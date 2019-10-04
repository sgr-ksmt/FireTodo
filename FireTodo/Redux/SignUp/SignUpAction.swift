//
// Copyright © Suguru Kishimoto. All rights reserved.
//

import Firebase
import FireSnapshot
import Foundation
import ReSwift
import ReSwiftThunk

enum SignUpAction: Action {
    case signUpStarted
    case signUpFinished
    case signUpFailed(error: Error)

    static func signUp(with name: String, auth: Auth = .auth()) -> AppThunkAction {
        AppThunkAction { dispatch, getState in
            if getState()?.signUpState.requesting == true {
                return
            }

            dispatch(SignUpAction.signUpStarted)
            auth.signInAnonymously { result, error in
                if let error = error {
                    dispatch(SignUpAction.signUpFailed(error: error))
                } else if let result = result {
                    dispatch(SignUpAction.createUser(with: result.user.uid, name: name))
                }
            }
        }
    }

    private static func createUser(with uid: String, name: String, db: Firestore = .firestore()) -> AppThunkAction {
        AppThunkAction { dispatch, _ in
            let user = Model.User(username: name)
            Snapshot(data: user, path: .user(userID: uid)).create { result in
                switch result {
                case .success:
                    dispatch(AuthAction.fetchUser(uid: uid) {
                        dispatch(SignUpAction.signUpFinished)
                    })
                case let .failure(error):
                    dispatch(SignUpAction.signUpFailed(error: error))
                }
            }
        }
    }
}
