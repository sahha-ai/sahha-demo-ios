// Copyright © 2022 Sahha. All rights reserved.

import SwiftUI
import Sahha

struct DemographicView: View {
    
    @AppStorage("age") var age: Int = 0
    @State var countries: [String: String] = [:]
    @AppStorage("country") var country: String = ""
    let genders: [String] = ["Male", "Female", "Gender Diverse"]
    @AppStorage("gender") var gender: String = ""
    var isInvalid: Bool {
        return age == 0 || country.isEmpty || gender.isEmpty
    }
    
    var body: some View {
        Form {
            Section {
                HStack {
                    Spacer()
                    Image(systemName: "person.fill")
                    Text("Profile")
                    Spacer()
                }.font(.title)
            }
            Section {
                TextField("Enter Your Age", value: $age, formatter: NumberFormatter()).keyboardType(.numbersAndPunctuation)
            } header: {
                Text("Age")
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
                        let demographic = SahhaDemographic(age: age, gender: gender, country: country)
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
                                if let age = value.age {
                                    self.age = age
                                }
                                if let gender = value.gender {
                                    self.gender = gender
                                }
                                if let country = value.country {
                                    self.country = country
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
            if let jsonFile = Bundle.main.url(forResource: "country_codes", withExtension: "json"), let jsonData = try? Data(contentsOf: jsonFile), let jsonObject = try? JSONSerialization.jsonObject(with: jsonData, options: []), let jsonDictionary = jsonObject as? [String: String] {
                countries = jsonDictionary
            }
        }
    }
}

struct DemographicView_Previews: PreviewProvider {
    static var previews: some View {
        DemographicView()
    }
}
