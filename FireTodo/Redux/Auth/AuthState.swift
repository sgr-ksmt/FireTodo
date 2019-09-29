//
// Copyright © Suguru Kishimoto. All rights reserved.
//

import Combine
import Firebase
import FireSnapshot
import Foundation
import ReSwift

struct AuthState: StateType {
    enum LoadingState {
        case initial
        case loaded
    }

    var loadingState: LoadingState = .initial
    var user: Snapshot<Model.User>?
    var listenerCancellable: AnyCancellable?
}
