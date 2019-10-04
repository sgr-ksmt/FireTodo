//
// Copyright © Suguru Kishimoto. All rights reserved.
//

import Combine
import Firebase
import FireSnapshot
import Foundation
import ReSwift
import ReSwiftThunk

enum AuthAction: Action {
    case finishInitialLoad
    case updateAuthChangeListener(listener: AnyCancellable?)
    case updateUser(user: Snapshot<Model.User>?)

    static func subscribe() -> AppThunkAction {
        AppThunkAction { dispatch, getState in
            let finishInitialLoad = {
                if getState()?.authState.loadingState == .initial {
                    dispatch(AuthAction.finishInitialLoad)
                }
            }

            let cancellable = Auth.auth().combine.stateDidChange()
                .map { $1 }
                .map { user -> Action in
                    if let user = user {
                        return AuthAction.fetchUser(uid: user.uid) {
                            finishInitialLoad()
                        }
                    } else {
                        finishInitialLoad()
                        return AuthAction.updateUser(user: nil)
                    }
                }
                .sink(receiveValue: dispatch)

            dispatch(AuthAction.updateAuthChangeListener(listener: cancellable))
        }
    }

    static func unsubscribe() -> AppThunkAction {
        AppThunkAction { dispatch, getState in
            getState()?.authState.listenerCancellable?.cancel()
            dispatch(AuthAction.updateAuthChangeListener(listener: nil))
        }
    }

    static func fetchUser(uid: String, completion: @escaping () -> Void = {}) -> AppThunkAction {
        AppThunkAction { dispatch, getState in
            Snapshot.get(.user(userID: uid)) { result in
                switch result {
                case let .success(user):
                    dispatch(AuthAction.updateUser(user: user))
                case let .failure(error):
                    print(error)
                    if getState()?.signUpState.requesting == false {
                        dispatch(AuthAction.signOut())
                    }
                }
                completion()
            }
        }
    }

    static func signOut() -> AppThunkAction {
        AppThunkAction { _, _ in
            _ = try? Auth.auth().signOut()
        }
    }
}
