import Foundation

public final class StaticCameraConfigurationProvider: CameraConfigurationProvider {
    // MARK: Lifecycle

    public init(cameraConfiguration: CameraConfiguration = CameraConfiguration()) {
        self.cameraConfiguration = cameraConfiguration
    }

    // MARK: Public

    public let cameraConfiguration: CameraConfiguration
}
