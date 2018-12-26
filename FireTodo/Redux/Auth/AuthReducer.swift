//
// Copyright © Suguru Kishimoto. All rights reserved.
//

import Foundation
import ReSwift

enum AuthReducer {
    static var reduce: Reducer<AuthState> {
        return { action, state in
            var state = state ?? AuthState()
            switch action {
            case let action as AuthAction:
                switch action {
                case .finishInitialLoad:
                    state.loadingState = .loaded
                    return state
                case let .registerAuthChangeHandle(listenerHandle):
                    state.listenerHandle = listenerHandle
                    return state
                case .removeAuthChangeHandle:
                    state.listenerHandle = nil
                    return state
                case let .subscribeAuthChange(cancellable):
                    state.listenerCancellable = cancellable
                    return state
                case .unsubscribeAuthChange:
                    state.listenerCancellable = nil
                    return state
                case let .updateUser(user):
                    state.user = user
                    return state
                }
            default:
                break
            }
            return state
        }
    }
}
