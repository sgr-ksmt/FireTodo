//
// Copyright © Suguru Kishimoto. All rights reserved.
//

import SwiftUI

struct SignUpView: View {
    @EnvironmentObject private var store: AppStore
    @State private var name: String = ""
    private var canRegister: Bool {
        name.count >= 3 && name.count <= 16
    }

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                VStack(alignment: .center) {
                    Text("Fire Todo")
                        .font(.title)
                        .padding(.top, geometry.size.height / 4)
                        .padding(.bottom, 44.0)

                    VStack {
                        TextField("Enter your name...", text: self.$name.animation())
                        Color.primary.frame(height: 1.0)
                    }
                    .padding()

                    Button(action: {
                        self.store.dispatch(SignUpAction.signUp(with: self.name))
                    }) {
                        Text("Sign Up")
                            .foregroundColor(.primary)
                            .fontWeight(.bold)
                            .padding(.init(top: 8.0, leading: 32.0, bottom: 8.0, trailing: 32.0))
                            .overlay(
                                Capsule(style: .continuous)
                                    .stroke(self.canRegister ? Color.primary : Color.gray, lineWidth: 2.0)
                            )
                    }
                    .opacity(self.canRegister ? 1.0 : 0.5)
                    .disabled(!self.canRegister)

                    Spacer()
                }
                LoadingView(isLoading: self.store.state.signUpState.requesting)
            }
        }
    }
}

#if DEBUG
    struct SignUpView_Previews: PreviewProvider {
        static var previews: some View {
            SignUpView().environmentObject(AppMain().store)
        }
    }
#endif
