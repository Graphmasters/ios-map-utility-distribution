import Foundation
import Mapbox

open class AggregatingMGLStyleLayersHandler: MGLStyleLayersHandler {
    // MARK: Properties

    public var layerHandlers: [MGLStyleLayersHandler]

    // MARK: Lifecycle

    override open func setup() {
        layerHandlers.forEach { $0.setup() }
    }

    override open func startLayerUpdates() {
        layerHandlers.forEach { $0.startLayerUpdates() }
    }

    override open func stopLayerUpdates() {
        layerHandlers.forEach { $0.stopLayerUpdates() }
    }

    public init(
        mapLayerManager: MapboxMapLayerManager?,
        mapTheme: MapTheme,
        layerHandlers: [MGLStyleLayersHandler]
    ) {
        self.layerHandlers = layerHandlers
        super.init(mapLayerManager: mapLayerManager, mapTheme: mapTheme)
    }

    // MARK: Overridden Functions

    override public func updateVisibility(isVisible visible: Bool) {
        layerHandlers.forEach { $0.updateVisibility(visible) }
    }

    override public func updateTilt(tilt: Float) {
        layerHandlers.forEach { $0.updateTilt(tilt: tilt) }
    }

    override public func didTapLayer(at location: CGPoint, in mapView: MGLMapView) {
        layerHandlers.forEach { $0.didTapLayer(at: location, in: mapView) }
    }
}
