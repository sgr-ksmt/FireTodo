//
// Copyright © Suguru Kishimoto. All rights reserved.
//

import Combine
import FirebaseAuth

// ref: https://gist.github.com/marty-suzuki/96f9d6cd0c4419555b5eac7c4b34cbd6

public struct CombineAuth {
    fileprivate let auth: Auth
}

extension CombineAuth {
    public final class Subscription<S: Subscriber>: Combine.Subscription where S.Input == (Auth, User?), S.Failure == Never {
        private var subscriber: S?
        private let auth: Auth
        private let _cancel: (Auth) -> Void

        fileprivate init(subscriber: S,
                         auth: Auth,
                         addListener: @escaping (Auth, @escaping (Auth, User?) -> Void) -> NSObjectProtocol,
                         removeListener: @escaping (Auth, NSObjectProtocol) -> Void) {
            self.subscriber = subscriber
            self.auth = auth
            let listener = addListener(auth) { auth, user in
                _ = subscriber.receive((auth, user))
            }
            _cancel = { removeListener($0, listener) }
        }

        public func request(_ demand: Subscribers.Demand) {}

        public func cancel() {
            _cancel(auth)
            subscriber = nil
        }
    }

    public struct Publisher: Combine.Publisher {
        public typealias Output = (Auth, User?)
        public typealias Failure = Never

        private let auth: Auth
        private let addListener: (Auth, @escaping (Auth, User?) -> Void) -> NSObjectProtocol
        private let removeListener: (Auth, NSObjectProtocol) -> Void

        init(auth: Auth,
             addListener: @escaping (Auth, @escaping (Auth, User?) -> Void) -> NSObjectProtocol,
             removeListener: @escaping (Auth, NSObjectProtocol) -> Void) {
            self.auth = auth
            self.addListener = addListener
            self.removeListener = removeListener
        }

        public func receive<S>(subscriber: S) where S: Subscriber, S.Failure == Failure, S.Input == Output {
            subscriber.receive(subscription: Subscription(
                subscriber: subscriber,
                auth: auth,
                addListener: addListener,
                removeListener: removeListener
            ))
        }
    }
}

extension Auth {
    public var combine: CombineAuth {
        return CombineAuth(auth: self)
    }
}

extension CombineAuth {
    public func stateDidChange() -> AnyPublisher<(Auth, User?), Never> {
        return Publisher(auth: auth,
                         addListener: { $0.addStateDidChangeListener($1) },
                         removeListener: { $0.removeStateDidChangeListener($1) })
            .eraseToAnyPublisher()
    }

    public func idTokenDidChange() -> AnyPublisher<(Auth, User?), Never> {
        return Publisher(auth: auth,
                         addListener: { $0.addIDTokenDidChangeListener($1) },
                         removeListener: { $0.removeIDTokenDidChangeListener($1) })
            .eraseToAnyPublisher()
    }
}
