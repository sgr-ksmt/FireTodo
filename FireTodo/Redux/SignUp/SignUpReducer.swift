//
// Copyright © Suguru Kishimoto. All rights reserved.
//

import Foundation
import ReSwift

enum SignUpReducer {
    static var reducer: Reducer<SignUpState> {
        return { action, state in
            var state = state ?? SignUpState()
            switch action {
            case let action as SignUpAction:
                switch action {
                case .signUpStarted:
                    state.requesting = true
                    state.error = nil
                    return state
                case .signUpFinished:
                    state.requesting = false
                    state.error = nil
                    return state
                case let .signUpFailed(error):
                    state.requesting = false
                    state.error = error
                    return state
                }
            default:
                return state
            }
        }
    }
}
