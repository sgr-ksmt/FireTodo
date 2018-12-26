//
// Copyright © Suguru Kishimoto. All rights reserved.
//

import Firebase
import FirebaseFirestoreSwift
import Foundation

extension Model {
    struct Path {
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

protocol FirestorePath: Equatable {
    var path: String { get }
    init(_ path: String)
    func verify() -> Bool
}

struct DocumentPath: FirestorePath {
    let path: String

    init(_ collectionPath: CollectionPath, _ documentID: String) {
        self.init([collectionPath.path, documentID].joined(separator: "/"))
    }

    init(_ path: String) {
        self.path = path
    }

    func collection(_ collectionName: String) -> CollectionPath {
        return .init(self, collectionName)
    }

    func verify() -> Bool {
        let components = path.components(separatedBy: "/")
        let isValid = components.count % 2 == 0 && !components.last!.isEmpty
        return isValid
    }
}

struct CollectionPath: FirestorePath {
    let path: String

    init(_ documentPath: DocumentPath, _ collectionName: String) {
        self.init([documentPath.path, collectionName].joined(separator: "/"))
    }

    init(_ path: String) {
        self.path = path
    }

    func doc(_ documentID: String) -> DocumentPath {
        return .init(self, documentID)
    }

    func verify() -> Bool {
        let components = path.components(separatedBy: "/")
        let isValid = components.count % 2 == 1 && !components.last!.isEmpty
        return isValid
    }
}
