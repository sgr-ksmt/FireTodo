//
// Copyright © Suguru Kishimoto. All rights reserved.
//

import Foundation
import ReSwift

func createLoggingMiddleware() -> Middleware<AppState> {
    return { dispatch, getState in
        { next in
            { action in
                print(">  \(action)")
                next(action)
            }
        }
    }
}
