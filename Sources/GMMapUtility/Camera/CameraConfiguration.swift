import Foundation

public struct CameraConfiguration {
    public enum Perspective: Int, CaseIterable, Codable {
        case threeDimensional
        case twoDimensional
        case twoDimensionalNorth
    }

    // MARK: Lifecycle

    public init(zoomLevelOffset: Double = 0, perspective: Perspective = .threeDimensional) {
        self.zoomLevelOffset = zoomLevelOffset
        self.perspective = perspective
    }

    // MARK: Public

    public let zoomLevelOffset: Double
    public let perspective: Perspective
}
