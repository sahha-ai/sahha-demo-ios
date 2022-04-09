// Copyright © 2022 Sahha. All rights reserved.

import SwiftUI
import Sahha

struct AuthenticationView: View {
    @AppStorage("sahhaToken") private var sahhaToken: String = ""
    @AppStorage("sahhaRefreshToken") private var sahhaRefreshToken: String = ""
    
    var isSaveDisabled: Bool {
        sahhaToken.isEmpty || sahhaRefreshToken.isEmpty
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
            Section(header: Text("Token")) {
                TextField("ABC-123", text: $sahhaToken).autocapitalization(.none)
            }
            Section(header: Text("Refresh Token")) {
                TextField("ABC-123", text: $sahhaRefreshToken).autocapitalization(.none)
            }
            Section {
                Button {
                    hideKeyboard()
                    Sahha.authenticate(token: sahhaToken, refreshToken: sahhaRefreshToken)
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
                        sahhaToken = ""
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
