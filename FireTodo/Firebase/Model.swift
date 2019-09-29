//
// Copyright © Suguru Kishimoto. All rights reserved.
//

import Foundation
import FireSnapshot

/// Name space for Cloud Firestore document models.
enum Model {
}

extension Model {
    enum Path {
        static var users: CollectionPath = .init("users")
        static func user(userID: String) -> DocumentPath {
            users.doc(userID)
        }

        static func tasks(userID: String) -> CollectionPath {
            user(userID: userID).collection("tasks")
        }

        static func task(userID: String, taskID: String) -> DocumentPath {
            tasks(userID: userID).doc(taskID)
        }
    }
}
