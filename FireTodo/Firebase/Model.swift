//
// Copyright © Suguru Kishimoto. All rights reserved.
//

import FireSnapshot
import Foundation

/// Name space for Cloud Firestore document models.
enum Model {
}

extension CollectionPaths {
    static let users = CollectionPath<Model.User>("users")
    static func tasks(userID: String) -> CollectionPath<Model.Task> {
        DocumentPaths.user(userID: userID).collection("tasks")
    }
}

extension DocumentPaths {
    static func user(userID: String) -> DocumentPath<Model.User> {
        CollectionPaths.users.document(userID)
    }

    static func task(userID: String, taskID: String) -> DocumentPath<Model.Task> {
        CollectionPaths.tasks(userID: userID).document(taskID)
    }
}
