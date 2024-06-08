// Copyright © 2022 Sahha. All rights reserved.

import SwiftUI
import Sahha

struct AuthenticationView: View {
    @AppStorage("sahhaAppId") private var sahhaAppId: String = ""
    @AppStorage("sahhaAppSecret") private var sahhaAppSecret: String = ""
    @AppStorage("sahhaExternalId") private var sahhaExternalId: String = ""
    
    var isSaveDisabled: Bool {
        sahhaAppId.isEmpty || sahhaAppSecret.isEmpty || sahhaExternalId.isEmpty
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
            Section {
                Toggle("AUTHENTICATED", isOn: .constant(Sahha.isAuthenticated)).disabled(true)
            }
            Section(header: Text("App ID")) {
                TextField("ABC-123", text: $sahhaAppId).autocapitalization(.none)
            }
            Section(header: Text("App Secret")) {
                TextField("ABC-123", text: $sahhaAppSecret).autocapitalization(.none)
            }
            Section(header: Text("External ID")) {
                TextField("ABC-123", text: $sahhaExternalId).autocapitalization(.none)
            }
            Section {
                Button {
                    hideKeyboard()
                    Sahha.authenticate(appId: sahhaAppId, appSecret: sahhaAppSecret, externalId: sahhaExternalId) { error, success in
                        if let error = error {
                            print(error)
                        } else if success {
                            print("You are now authenticated")
                            print(Sahha.profileToken ?? "")
                        }
                    }
                } label: {
                    HStack {
                        Spacer()
                        Text("Save")
                        Spacer()
                    }
                }.disabled(isSaveDisabled)
            }
            Section {
                Button {
                    hideKeyboard()
                    Sahha.deauthenticate { error, success in
                        if success {
                            sahhaExternalId = ""
                        }
                    }
                } label: {
                    HStack {
                        Spacer()
                        Text("Reset")
                        Spacer()
                    }
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
