//
// Copyright © Suguru Kishimoto. All rights reserved.
//

import Foundation
import ReSwift

struct SignUpState: StateType {
    var requesting: Bool = false
    var error: Error?
}
