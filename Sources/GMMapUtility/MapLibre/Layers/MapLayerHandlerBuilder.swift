import Foundation
import Mapbox

public protocol MapLayerHandlerBuilder {
    func mapLayerHandler(
        for mapView: MGLMapView,
        withMapTheme mapTheme: MapTheme
    ) -> MGLStyleLayersHandler
}
