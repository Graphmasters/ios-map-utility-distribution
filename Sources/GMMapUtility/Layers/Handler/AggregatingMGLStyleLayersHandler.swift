import Foundation
import Mapbox

open class AggregatingMGLStyleLayersHandler: MGLStyleLayersHandler {
    public var layerHandlers: [MGLStyleLayersHandler]

    public init(
        mapLayerManager: MapboxMapLayerManager?,
        layerHandlers: [MGLStyleLayersHandler]
    ) {
        self.layerHandlers = layerHandlers
        super.init(mapLayerManager: mapLayerManager)
    }

    override open func setup() {
        layerHandlers.forEach { $0.setup() }
    }

    override open func startLayerUpdates() {
        layerHandlers.forEach { $0.startLayerUpdates() }
    }

    override open func stopLayerUpdates() {
        layerHandlers.forEach { $0.stopLayerUpdates() }
    }

    override public func updateVisibility(_ visible: Bool) {
        layerHandlers.forEach { $0.updateVisibility(visible) }
    }

    override public func updateTilt(tilt: Float) {
        layerHandlers.forEach { $0.updateTilt(tilt: tilt) }
    }

    override public func didTapLayer(at location: CGPoint, in mapView: MGLMapView) {
        layerHandlers.forEach { $0.didTapLayer(at: location, in: mapView) }
    }
}
