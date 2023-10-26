import Foundation
import Mapbox

extension MGLPolylineFeature {
    public static func geodesicPolyline(
        fromCoordinate src: CLLocationCoordinate2D,
        toCoordinate dst: CLLocationCoordinate2D
    ) -> MGLPolylineFeature {
        let coordinates = MGLPolylineFeature.createBezierCurve(src: src, dst: dst, offset: 0.4, numberOfSteps: 12)
        return MGLPolylineFeature(coordinates: coordinates, count: UInt(coordinates.count))
    }

    private static var earthRadiusMeter: Double { 6_371_008.8 }
    private static var metersNorthToLatitude: Double { 180.0 / Double.pi / earthRadiusMeter }

    private static func deg2rad(_ number: Double) -> Double { number * .pi / 180 }

    private static func metersEastToLongitude(latitude: Double) -> Double {
        metersNorthToLatitude / cos(deg2rad(latitude))
    }

    private static func shiftByCartesian(latitude: Double, longitude: Double, metersNorth: Double, metersEast: Double)
        -> CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latitude + metersNorth * metersNorthToLatitude,
                               longitude: longitude + metersEast * metersEastToLongitude(latitude: latitude))
    }

    private static func shiftByCartesian(src: CLLocationCoordinate2D, metersNorth: Double, metersEast: Double)
        -> CLLocationCoordinate2D {
        shiftByCartesian(latitude: src.latitude, longitude: src.longitude, metersNorth: metersNorth, metersEast: metersEast)
    }

    private static func distanceMetersNorth(src: CLLocationCoordinate2D, dst: CLLocationCoordinate2D) -> Double {
        return (dst.latitude - src.latitude) / metersNorthToLatitude
    }

    private static func distanceMetersEast(src: CLLocationCoordinate2D, dst: CLLocationCoordinate2D) -> Double {
        return (dst.longitude - src.longitude) / metersEastToLongitude(latitude: src.latitude)
    }

    private static func createBezierCurve(
        src: CLLocationCoordinate2D, dst: CLLocationCoordinate2D, offset: Double, numberOfSteps: Int
    ) -> [CLLocationCoordinate2D] {
        let northEnd = MGLPolylineFeature.distanceMetersNorth(src: src, dst: dst)
        let eastEnd = MGLPolylineFeature.distanceMetersEast(src: src, dst: dst)

        var normalisation = offset
        if eastEnd < 0.0 {
            normalisation = -offset
        }

        let northMid = 0.5 * northEnd + eastEnd * normalisation
        let eastMid = 0.5 * eastEnd - northEnd * normalisation

        var positions = [CLLocationCoordinate2D]()

        let step = 1.0 / (Double(numberOfSteps) - 1.0)
        for index in 0 ..< numberOfSteps {
            let weight = Double(index) * step
            let factorMid = 2.0 * (1.0 - weight) * weight
            let factorEnd = weight * weight
            let north = northMid * factorMid + northEnd * factorEnd
            let east = eastMid * factorMid + eastEnd * factorEnd
            positions.append(shiftByCartesian(src: src, metersNorth: north, metersEast: east))
        }

        return positions
    }
}
