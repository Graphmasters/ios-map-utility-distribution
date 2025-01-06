import Foundation

public final class StaticCameraConfigurationProvider: CameraConfigurationProvider {
    // MARK: Properties

    public let cameraConfiguration: CameraConfiguration

    // MARK: Lifecycle

    public init(cameraConfiguration: CameraConfiguration = CameraConfiguration()) {
        self.cameraConfiguration = cameraConfiguration
    }
}
