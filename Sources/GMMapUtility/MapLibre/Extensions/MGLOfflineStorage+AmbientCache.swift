import Foundation
import Mapbox

extension MGLOfflineStorage {
    public func invalidateAndClearAmbientCache() async throws {
        try await invalidateAmbientCache()
        try await clearAmbientCache()
    }

    public func invalidateAmbientCache() async throws {
        try await withCheckedThrowingContinuation { (continuation: CheckedContinuation<Void, Error>) in
            MGLOfflineStorage.shared.invalidateAmbientCache { error in
                guard let error = error else {
                    return continuation.resume(with: .success({}()))
                }
                continuation.resume(throwing: error)
            }
        }
    }

    public func clearAmbientCache() async throws {
        try await withCheckedThrowingContinuation { (continuation: CheckedContinuation<Void, Error>) in
            MGLOfflineStorage.shared.clearAmbientCache { error in
                guard let error = error else {
                    return continuation.resume(with: .success({}()))
                }
                continuation.resume(throwing: error)
            }
        }
    }
}
