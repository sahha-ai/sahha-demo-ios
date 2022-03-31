// Copyright © 2022 Sahha. All rights reserved.

import SwiftUI
import Sahha

struct AuthenticationView: View {
    @AppStorage("customerId") private var customerId: String = ""
    @AppStorage("profileId") private var profileId: String = ""
    @State private var authStatus: String = ""
    
    var isLoginDisabled: Bool {
        customerId.isEmpty || profileId.isEmpty
    }
    
    var body: some View {
        List {
            Section {
                HStack {
                    Spacer()
                    Image(systemName: "lock.fill")
                    Text("Authentication")
                    Spacer()
                }.font(.title)
            }
            Section(header: Text("Account")) {
                TextField("Customer ID", text: $customerId).autocapitalization(.none)
                TextField("Profile ID", text: $profileId).autocapitalization(.none)
            }
            if authStatus.isEmpty == false {
                Section(header: Text("Status")) {
                    Text(authStatus)
                }
                Section {
                    Button {
                        hideKeyboard()
                        authStatus = ""
                    } label: {
                        HStack {
                            Spacer()
                            Text("Logout")
                            Spacer()
                        }
                    }
                }
            } else {
                Section {
                    Button {
                        hideKeyboard()
                        Sahha.authenticate(customerId: customerId, profileId: profileId) { error, value in
                            if let value = value {
                                authStatus = value
                            }
                        }
                    } label: {
                        HStack {
                            Spacer()
                            Text("Login")
                            Spacer()
                        }
                    }.disabled(isLoginDisabled)
                }
            }
        }
    }
}

struct AuthorizationView_Previews: PreviewProvider {
    static var previews: some View {
        AuthenticationView()
    }
}
