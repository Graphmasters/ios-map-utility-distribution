import Foundation
import Mapbox

open class MGLStyleLayersHandler: MapLayerHandler {
    public private(set) var mapTheme: MapTheme

    public private(set) var mapLayerManager: MapboxMapLayerManager?

    open var interactionLayerIdentifiers: Set<String> { Set<String>([]) }

    public init(mapLayerManager: MapboxMapLayerManager?, mapTheme: MapTheme) {
        self.mapLayerManager = mapLayerManager
        self.mapTheme = mapTheme
    }

    // MARK: - User Interaction

    func didTapLayer(at location: CGPoint, in mapView: MGLMapView) {
        let features = mapView.visibleFeatures(
            at: location,
            styleLayerIdentifiers: interactionLayerIdentifiers
        )
        features.first.map { didTapFeature(identifier: $0.identifier, attributes: $0.attributes) }
    }

    open func setup() {}

    open func startLayerUpdates() {}

    open func stopLayerUpdates() {}

    open func updateVisibility(_: Bool) {}

    open func updateTilt(tilt _: Float) {}

    open func didTapFeature(identifier _: Any?, attributes _: [String: Any]) {}
}
