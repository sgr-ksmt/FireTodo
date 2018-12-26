//
// Copyright © Suguru Kishimoto. All rights reserved.
//

import Foundation
import ReSwift
import Firebase
import Combine

struct AuthState: StateType {
    enum LoadingState {
        case initial
        case loaded
    }
    var loadingState: LoadingState = .initial
    var user: Snapshot<Model.User>?
    var listenerHandle: AuthStateDidChangeListenerHandle?
    var listenerCancellable: AnyCancellable?
}
