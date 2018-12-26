//
// Copyright © Suguru Kishimoto. All rights reserved.
//

import Firebase
import FirebaseFirestoreSwift
import Foundation

protocol SnapshotType {
    associatedtype Data: Codable & AnyObject & DocumentTimestamp
    func set(encoder: Firestore.Encoder, merge: Bool, completion: @escaping (Result<Void, Error>) -> Void)
    static func get(_ path: DocumentPath, decoder: Firestore.Decoder, completion: @escaping (Result<Snapshot<Data>, Error>) -> Void)
}

final class Snapshot<D>: SnapshotType where D: Codable, D: AnyObject, D: DocumentTimestamp {
    typealias Data = D
    let data: D
    let reference: DocumentReference
    init(data: D, reference: DocumentReference) {
        self.reference = reference
        self.data = data
    }

    init(data: D, path: DocumentPath) {
        reference = Firestore.firestore().document(path.path)
        self.data = data
    }

    init(dataFactory: (DocumentReference) -> D, path: DocumentPath) {
        let ref = Firestore.firestore().document(path.path)
        reference = ref
        data = dataFactory(ref)
    }

    init(data: D, path: CollectionPath, id: String? = nil) {
        if let id = id, !id.isEmpty {
            reference = Firestore.firestore().collection(path.path).document(id)
        } else {
            reference = Firestore.firestore().collection(path.path).document()
        }
        self.data = data
    }

    init(dataFactory: (DocumentReference) -> D, path: CollectionPath, id: String? = nil) {
        let ref: DocumentReference
        if let id = id, !id.isEmpty {
            ref = Firestore.firestore().collection(path.path).document(id)
        } else {
            ref = Firestore.firestore().collection(path.path).document()
        }
        reference = ref
        data = dataFactory(ref)
    }

    init?(snapshot: DocumentSnapshot, decoder: Firestore.Decoder = .init()) throws {
        guard let snapshotData = snapshot.data() else {
            return nil
        }
        data = try decoder.decode(D.self, from: snapshotData)
        reference = snapshot.reference
    }

    func set(encoder: Firestore.Encoder = .init(),
             merge: Bool = false,
             completion: @escaping (Result<Void, Error>) -> Void = { _ in }) {
        do {
            reference.setData(try encoder.encode(data), merge: merge) { error in
                completion(error.map { .failure($0) } ?? .success(()))
            }
        } catch {
            completion(.failure(error))
        }
    }

    func update(encoder: Firestore.Encoder = .init(),
             completion: @escaping (Result<Void, Error>) -> Void = { _ in }) {
        do {
            var fields = try encoder.encode(data)
            fields["updateTime"] = Timestamp()
            reference.updateData(fields) { error in
                completion(error.map { .failure($0) } ?? .success(()))
            }
        } catch {
            completion(.failure(error))
        }
    }

    func remove(completion: @escaping (Result<Void, Error>) -> Void = { _ in }) {
        reference.delete { error in
            completion(error.map { .failure($0) } ?? .success(()))
        }
    }

    static func get(_ path: DocumentPath,
                    decoder: Firestore.Decoder = .init(),
                    completion: @escaping (Result<Snapshot<D>, Error>) -> Void) {
        Firestore.firestore().document(path.path).getDocument { snapshot, error in
            if let snapshot = snapshot, let data = snapshot.data() {
                do {
                    completion(.success(.init(data: try decoder.decode(D.self, from: data), reference: snapshot.reference)))
                } catch {
                    completion(.failure(error))
                }
            } else if let error = error {
                completion(.failure(error))
            }
        }
    }

    static func listen(_ path: CollectionPath,
                     queryBuilder: (Query) -> Query = { $0 },
                     decoder: Firestore.Decoder = .init(),
                     includeMetadataChanges: Bool = false,
                     completion: @escaping (Result<[Snapshot<D>], Error>) -> Void) -> ListenerRegistration {
        return queryBuilder(Firestore.firestore().collection(path.path))
            .addSnapshotListener(includeMetadataChanges: includeMetadataChanges) { snapshot, error in
                if let snapshot = snapshot {
                    do {
                        completion(.success(
                            try snapshot.documents.compactMap { try Snapshot<D>(snapshot: $0) }
                        ))
                    } catch {
                        completion(.failure(error))
                    }
                } else if let error = error {
                    completion(.failure(error))
                }
        }
    }
}

extension Snapshot: Equatable where D: Equatable {
    static func == (lhs: Snapshot<D>, rhs: Snapshot<D>) -> Bool {
        return lhs.reference.path == rhs.reference.path
            && lhs.data == rhs.data
    }
}

extension Snapshot: Identifiable {
    var id: String { reference.documentID }
}
