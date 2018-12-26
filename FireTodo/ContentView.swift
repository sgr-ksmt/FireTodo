//
// Copyright © Suguru Kishimoto. All rights reserved.
//

import SwiftUI
import Combine

struct ContentView: View {
    @EnvironmentObject private var store: AppStore

    var body: some View {
        AnyView({ () -> AnyView in
            if store.state.authState.loadingState == .initial {
                return AnyView(Spacer())
            } else {
                if self.store.state.authState.user != nil {
                    return AnyView(TasksView())
                } else {
                    return AnyView(SignUpView())
                }
            }
        }())
        .onAppear { self.store.dispatch(AuthAction.subscribe()) }
        .onDisappear {
            self.store.dispatch(AuthAction.subscribe())
        }
    }
}

#if DEBUG
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environmentObject(AppMain().store)
    }
}
#endif
