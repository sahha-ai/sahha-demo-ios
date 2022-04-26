// Copyright © 2022 Sahha. All rights reserved.

import SwiftUI
import Sahha

struct AuthenticationView: View {
    @AppStorage("sahhaProfileToken") private var sahhaProfileToken: String = ""
    @AppStorage("sahhaRefreshToken") private var sahhaRefreshToken: String = ""
    
    var isSaveDisabled: Bool {
        sahhaProfileToken.isEmpty || sahhaRefreshToken.isEmpty
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
            Section(header: Text("Profile Token")) {
                TextField("ABC-123", text: $sahhaProfileToken).autocapitalization(.none)
            }
            Section(header: Text("Refresh Token")) {
                TextField("ABC-123", text: $sahhaRefreshToken).autocapitalization(.none)
            }
            Section {
                Button {
                    hideKeyboard()
                    Sahha.authenticate(profileToken: sahhaProfileToken, refreshToken: sahhaRefreshToken)
                } label: {
                    HStack {
                        Spacer()
                        Text("Save")
                        Spacer()
                    }
                }.disabled(isSaveDisabled)
            }
            if isSaveDisabled == false {
                Section {
                    Button {
                        hideKeyboard()
                        sahhaProfileToken = ""
                        sahhaRefreshToken = ""
                        Sahha.deauthenticate()
                    } label: {
                        HStack {
                            Spacer()
                            Text("Delete")
                            Spacer()
                        }
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
