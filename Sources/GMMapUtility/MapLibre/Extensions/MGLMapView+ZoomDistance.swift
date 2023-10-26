import Foundation
import Mapbox

extension MGLMapView {
    @available(*, deprecated, renamed: "convertToZoomDistance(zoom:pitch:latitude:)")
    public func convertToDistance(zoom: Double, pitch: CGFloat, latitude: CLLocationDegrees) -> CLLocationDistance {
        convertToZoomDistance(zoom: zoom, pitch: pitch, latitude: latitude)
    }

    public func convertToZoomDistance(zoom: Double, pitch: CGFloat, latitude: CLLocationDegrees) -> CLLocationDistance {
        return MGLAltitudeForZoomLevel(
            zoom,
            pitch,
            latitude,
            bounds.size
        )
    }
}
