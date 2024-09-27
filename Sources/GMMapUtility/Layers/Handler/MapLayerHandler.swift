import Foundation

/// Handles the updates and styling of objects shown on a map which belong together.
///
/// - note: A `MapLayerHandler` may be self updating to model changes or receive udpates from outside. 
/// Often these two purposes are split up.
public protocol MapLayerHandler {
    var mapTheme: MapTheme { get }

    /// One time setup for all needed resources for handling the layer, e.g. images, sources.
    func setup()

    /// In case of the layer being a self updating layer `startLayerUpdates` will start the updates.
    func startLayerUpdates()

    /// In case of the layer being a self updating layer `stopLayerUpdates` will stop the updates.
    func stopLayerUpdates()

    /// Handles Layer visibility.
    ///
    /// - warning: This controls the visibility from outside, but it is not guranteed that the layer is displayed if `isVisible` is set tu `true`.
    ///  The `MapLayerHandler` may have inner logic whether the layer should be shown.
    func updateVisibility(_ visible: Bool)

    /// This method should be called if the camera tilt of the `MapView` changes in order to update the layer.
    func updateTilt(tilt: Float)

    func didTapFeature(identifier: Any?, attributes: [String: Any])
}

extension MapLayerHandler {
    public func setup() {}

    public func startLayerUpdates() {}

    public func stopLayerUpdates() {}

    public func updateVisibility(_: Bool) {}

    public func updateTilt(tilt _: Float) {}

    public func didTapFeature(identifier _: Any?, attributes _: [String: Any]) {}
}
