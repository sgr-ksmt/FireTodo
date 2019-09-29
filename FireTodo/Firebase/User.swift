//
// Copyright © Suguru Kishimoto. All rights reserved.
//

import Firebase
import FireSnapshot
import Foundation

extension Model {
    struct User: Codable, HasTimestamps {
        var username: String = ""
    }
}
