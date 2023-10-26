import CoreLocation
import Foundation

extension Collection where Element == CLLocationCoordinate2D {
    public var boundingBox: (southWest: CLLocationCoordinate2D, northEast: CLLocationCoordinate2D)? {
        guard let first = first else {
            return nil
        }

        var maxLatitude: Double = first.latitude
        var maxLongitude: Double = first.longitude
        var minLatitude: Double = first.latitude
        var minLongitude: Double = first.longitude

        for coordinate in self {
            if coordinate.latitude > maxLatitude {
                maxLatitude = coordinate.latitude
            }

            if coordinate.latitude < minLatitude {
                minLatitude = coordinate.latitude
            }

            if coordinate.longitude > maxLongitude {
                maxLongitude = coordinate.longitude
            }

            if coordinate.longitude < minLongitude {
                minLongitude = coordinate.longitude
            }
        }

        return (southWest: CLLocationCoordinate2D(latitude: minLatitude, longitude: maxLongitude),
                northEast: CLLocationCoordinate2D(latitude: maxLatitude, longitude: minLongitude))
    }
}
