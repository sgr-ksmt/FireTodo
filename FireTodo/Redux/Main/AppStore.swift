//
// Copyright © Suguru Kishimoto. All rights reserved.
//

import Foundation
import ReSwift
import Combine

final class AppStore: StoreSubscriber, DispatchingStoreType, ObservableObject {
    private let store: Store<AppState>
    var state: AppState { store.state }
    private let stateChange = ObservableObjectPublisher()
    var objectWillChange: ObservableObjectPublisher {
        stateChange
    }

    init(_ store: Store<AppState>) {
        self.store = store
        store.subscribe(self)
    }

    func newState(state: AppState) {
        stateChange.send()
    }

    func dispatch(_ action: Action) {
        if Thread.isMainThread {
            store.dispatch(action)
        } else {
            DispatchQueue.main.async { [store] in
                store.dispatch(action)
            }
        }
    }

    deinit {
        store.unsubscribe(self)
    }
}
