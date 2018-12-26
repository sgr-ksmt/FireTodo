//
// Copyright © Suguru Kishimoto. All rights reserved.
//

import SwiftUI

struct ProfileView: View {
    @EnvironmentObject private var store: AppStore
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @State private var showActionSheet: Bool = false

    var body: some View {
        VStack(alignment: .center) {
            Image(systemName: "person.crop.circle.fill")
                .resizable()
                .frame(width: 120, height: 120)
                .foregroundColor(.primary)
                .padding([.top], 64.0)
                .padding([.bottom], 16.0)

            Text(store.state.authState.user?.data.username ?? "Unknown name")
                .font(.title)
                .padding([.bottom], 64.0)

            Button(action: {
                self.showActionSheet = true
            }) {
                Text("Sign Out")
                    .foregroundColor(.primary)
                    .fontWeight(.bold)
                    .padding(.init(top: 8.0, leading: 32.0, bottom: 8.0, trailing: 32.0))
                    .overlay(
                        Capsule(style: .continuous)
                            .stroke(Color.primary, lineWidth: 2.0)
                )
            }
            .disabled(self.store.state.authState.user == nil)

            Spacer()
        }
        .navigationBarItems(trailing: Button(action: {
            self.presentationMode.wrappedValue.dismiss()
        }) {
            Image(systemName: "xmark")
                .imageScale(.large)
        })
        .actionSheet(isPresented: $showActionSheet) {
            ActionSheet(
                title: Text(""),
                message: Text("Would you want to sign out?"),
                buttons: [
                    ActionSheet.Button.destructive(Text("Sign Out")) {
                        self.store.dispatch(AuthAction.signOut())
                    },
                    ActionSheet.Button.cancel()])
        }
    }
}

//struct ProfileView_Previews: PreviewProvider {
//    static var previews: some View {
//        ProfileView()
//    }
//}
