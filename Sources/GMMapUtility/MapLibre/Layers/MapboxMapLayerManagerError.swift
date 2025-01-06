import Foundation

public enum MapboxMapLayerManagerError: LocalizedError {
    case layerAlreadyAdded(String)
    case sourceUnavailable(String)

    // MARK: Computed Properties

    public var errorDescription: String? {
        switch self {
        case let .layerAlreadyAdded(layerId): return "Already added layer with id `\(layerId)`."
        case let .sourceUnavailable(sourceId): return "Source with id `\(sourceId)` is not added to the style."
        }
    }
}
