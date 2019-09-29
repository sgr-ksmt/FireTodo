//
// Copyright © Suguru Kishimoto. All rights reserved.
//

import Foundation
import ReSwift

func createLoggingMiddleware() -> Middleware<AppState> {
    return { _, _ in
        { next in
            { action in
                print("[dispatch]: \(action)")
                next(action)
            }
        }
    }
}
