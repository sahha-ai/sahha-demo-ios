// Copyright © 2022 Sahha. All rights reserved.

import SwiftUI
import Sahha

struct AuthenticationView: View {
    @State var customerId: String = ""
    @State var profileId: String = ""
    @State var token: String = ""
    
    var isDisabled: Bool {
        customerId.isEmpty || profileId.isEmpty
    }
    
    var body: some View {
        List {
            Section(header: Text("Credentials")) {
                TextField("Customer ID", text: $customerId)
                TextField("Profile ID", text: $profileId)
                Button("Authenticate") {
                    hideKeyboard()
                    Sahha.shared.authenticate(customerId: customerId, profileId: profileId) { value in
                        token = value
                    }
                }.disabled(isDisabled)
            }
            if token.isEmpty == false {
                Section(header: Text("Token")) {
                    Text(token).contextMenu {
                        Button(action: {
                            UIPasteboard.general.string = token
                        }) {
                            Text("Copy")
                        }
                    }
                }
            }
        }.navigationTitle("Authentication")
    }
}

struct AuthorizationView_Previews: PreviewProvider {
    static var previews: some View {
        AuthenticationView(customerId: "ABC", profileId: "123")
    }
}
