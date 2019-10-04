//
// Copyright © Suguru Kishimoto. All rights reserved.
//

import Firebase
import FireSnapshot
import SwiftUI

extension Model {
    struct Task: HasTimestamps, Codable, Equatable, FieldNameReferable {
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

        static var fieldNames: [PartialKeyPath<Model.Task> : String] {
            [
                \Task.title: "title",
                \Task.desc: "desc",
                \Task.completed: "completed",
            ]
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
