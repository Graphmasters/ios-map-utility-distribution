import Foundation

public struct CameraConfiguration {
    // MARK: Nested Types

    public enum Perspective: Int, CaseIterable, Codable {
        case threeDimensional
        case twoDimensional
        case twoDimensionalNorth
    }

    // MARK: Properties

    public let zoomLevelOffset: Double
    public let perspective: Perspective

    // MARK: Lifecycle

    public init(zoomLevelOffset: Double = 0, perspective: Perspective = .threeDimensional) {
        self.zoomLevelOffset = zoomLevelOffset
        self.perspective = perspective
    }
}
