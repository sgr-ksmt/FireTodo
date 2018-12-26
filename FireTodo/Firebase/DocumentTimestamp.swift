//
// Copyright © Suguru Kishimoto. All rights reserved.
//

import Firebase
import Foundation

protocol DocumentTimestamp {
    /// 作成日
    var createTime: Timestamp { get }
    /// 更新日
    var updateTime: Timestamp { get }
}
