//
// Copyright © Suguru Kishimoto. All rights reserved.
//

import Firebase
import FirebaseFirestoreSwift
import SwiftUI

extension Model {
    final class Task: Codable, DocumentTimestamp, Equatable {
        var title: String = ""
        var desc: String = ""
        var completed: Bool = false
        private(set) var color: String = ""
        var taskColor: TaskColor {
            get {
                TaskColor(rawValue: color) ?? .red
            }
            set {
                color = newValue.rawValue
            }
        }
        let createTime: Timestamp = Timestamp()
        let updateTime: Timestamp = Timestamp()

        static func == (lhs: Model.Task, rhs: Model.Task) -> Bool {
            return lhs.title == rhs.title
                && lhs.desc == rhs.desc
                && lhs.completed == rhs.completed
                && lhs.color == rhs.color
                && lhs.createTime.dateValue() == rhs.updateTime.dateValue()
                && lhs.updateTime.dateValue() == rhs.updateTime.dateValue()
        }
    }
}

enum TaskColor: String, CaseIterable, Identifiable, Decodable {
    public var id: String { rawValue }

    case red
    case blue
    case green
    case gray

    var color: Color {
        switch self {
        case .red: return .red
        case .blue: return .blue
        case .green: return .green
        case .gray: return .gray
        }
    }
}
