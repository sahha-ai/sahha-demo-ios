// Copyright © 2022 Sahha. All rights reserved.

import SwiftUI
import Sahha

struct DemographicView: View {
    
    @State var birthDate = Date()
    @State var countries: [String: String] = [:]
    @AppStorage("country") var country: String = ""
    let genders: [String] = ["Male", "Female", "Gender Diverse"]
    @AppStorage("gender") var gender: String = ""
    var isInvalid: Bool {
        return country.isEmpty || gender.isEmpty
    }
    
    var body: some View {
        Form {
            Section {
                HStack {
                    Spacer()
                    Image(systemName: "person.fill")
                    Text("Demographic")
                    Spacer()
                }.font(.title)
            }
            Section {
                DatePicker(selection: $birthDate, in: ...Date(), displayedComponents: .date) {
                     Text("Select")
                 }
            } header: {
                Text("Birthday")
            }
            Section {
                Picker("Select", selection: $gender) {
                    ForEach(genders, id: \.self) { value in
                        Text(value).tag(value)
                    }
                }
            } header: {
                Text("Gender")
            }
            Section {
                Picker("Select", selection: $country) {
                    ForEach(countries.sorted{$0.value < $1.value}, id: \.key) { key, value in
                        Text(value).tag(key)
                    }
                }
            } header: {
                Text("Country")
            }
            if isInvalid == false {
                Section {
                    Button {
                        hideKeyboard()
                        let demographic = SahhaDemographic(gender: gender, country: country, birthDate: birthDate.toYMDFormat)
                        print(demographic)
                        Sahha.postDemographic(demographic) { error, success in
                            if let error = error {
                                print(error)
                            }
                            print(success)
                        }
                    } label: {
                        HStack {
                            Spacer()
                            Text("Post")
                            Spacer()
                        }
                    }
                }
                Section {
                    Button {
                        hideKeyboard()
                        Sahha.getDemographic { error, value in
                            if let error = error {
                                print("woops")
                                print(error)
                            }
                            else if let value = value {
                                print(value)
                                if let stringValue = value.birthDate {
                                    birthDate = stringValue.dateFromYMDFormat
                                }
                                if let stringValue = value.gender {
                                    self.gender = stringValue
                                }
                                if let stringValue = value.country {
                                    self.country = stringValue
                                }
                            }
                        }
                    } label: {
                        HStack {
                            Spacer()
                            Text("Get")
                            Spacer()
                        }
                    }
                }
            }
        }.onAppear {
            if let date = UserDefaults.standard.object(forKey: "birthDate") as? Date {
                birthDate = date
            }
            if let jsonFile = Bundle.main.url(forResource: "country_codes", withExtension: "json"), let jsonData = try? Data(contentsOf: jsonFile), let jsonObject = try? JSONSerialization.jsonObject(with: jsonData, options: []), let jsonDictionary = jsonObject as? [String: String] {
                countries = jsonDictionary
            }
        }.onChange(of: birthDate) { newValue in
            UserDefaults.standard.set(newValue, forKey: "birthDate")
        }
    }
}

struct DemographicView_Previews: PreviewProvider {
    static var previews: some View {
        DemographicView()
    }
}

public extension Date {
    var toYMDFormat: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter.string(from: self)
    }
    var toString: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSZZZZZ"
        return dateFormatter.string(from: self)
    }
}

public extension String {
    var dateFromYMDFormat: Date {
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = "yyyy-MM-dd"
        if let date = dateFormatterGet.date(from: self) {
            return date
        } else {
            Sahha.postError(framework: .ios_swift, message: "String to date conversion failed", path: "Sahha+Extensions_String", method: "dateFromYMDFormat", body: self)
            return Date()
        }
    }
}
