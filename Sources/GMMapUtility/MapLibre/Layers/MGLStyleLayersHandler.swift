import Foundation
import Mapbox

open class MGLStyleLayersHandler: MapLayerHandler {
    // MARK: Properties

    public private(set) var mapTheme: MapTheme

    public private(set) var mapLayerManager: MapboxMapLayerManager?

    // MARK: Computed Properties

    open var interactionLayerIdentifiers: Set<String> { Set<String>([]) }

    private var isVisible = true {
        didSet {
            guard isVisible != oldValue else {
                return
            }
            refreshLayerVisibility(isVisible: isVisible)
        }
    }

    private var tilt: Float = 0 {
        didSet {
            guard tilt != oldValue else {
                return
            }
            updateTilt(tilt: tilt)
        }
    }

    // MARK: Lifecycle

    open func setup() {}

    open func startLayerUpdates() {
        updateTilt(tilt: tilt)
        updateVisibility(isVisible: isVisible)
    }

    open func stopLayerUpdates() {}

    public init(mapLayerManager: MapboxMapLayerManager?, mapTheme: MapTheme) {
        self.mapLayerManager = mapLayerManager
        self.mapTheme = mapTheme
    }

    // MARK: Functions

    /// This method is called when layer should be updated due to visibility change.
    ///
    /// This method should be overwritten by subclasses.
    open func refreshLayerVisibility(isVisible _: Bool) {}

    /// This method is called when layer should be updated due to camera tilt change.
    ///
    /// This method should be overwritten by subclasses.
    open func refreshLayerTilt(tilt _: Float) {}

    open func didTapFeature(identifier _: Any?, attributes _: [String: Any]) {}

    /// This method should be called from outside to update the visibility of the layer.
    ///
    /// If the handler is currently inactive the value will be stored and applied when the handler is started.
    public func updateVisibility(isVisible: Bool) {
        self.isVisible = isVisible
    }

    /// This method should be called from subclasses to update the visibility of the layer if there is any special logic in addition to the default.
    public func refreshLayerVisibility() {
        refreshLayerVisibility(isVisible: isVisible)
    }

    /// This method should be called from outside to update the camera tilt of the layer.
    ///
    /// If the handler is currently inactive the value will be stored and applied when the handler is started.
    public func updateTilt(tilt: Float) {
        self.tilt = tilt
    }

    /// This method should be called from subclasses to update the camera tilt of the layer if there is any special logic in addition to the default.
    public func refreshLayerTilt() {
        refreshLayerTilt(tilt: tilt)
    }

    // MARK: - User Interaction

    func didTapLayer(at location: CGPoint, in mapView: MGLMapView) {
        let features = mapView.visibleFeatures(
            at: location,
            styleLayerIdentifiers: interactionLayerIdentifiers
        )
        features.first.map { didTapFeature(identifier: $0.identifier, attributes: $0.attributes) }
    }
}
