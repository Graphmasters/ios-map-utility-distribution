import CoreLocation
import Foundation

extension Collection where Element == CLLocationCoordinate2D {
    public func geographicMidpoint() -> CLLocationCoordinate2D {
        guard count > 1 else {
            return first ?? CLLocationCoordinate2D(latitude: 0, longitude: 0)
        }

        var xCoordinate = Double(0)
        var yCoordinate = Double(0)
        var zCoordinate = Double(0)

        for coordinate in self {
            let lat = deg2rad(coordinate.latitude)
            let lon = deg2rad(coordinate.longitude)
            xCoordinate += cos(lat) * cos(lon)
            yCoordinate += cos(lat) * sin(lon)
            zCoordinate += sin(lat)
        }

        xCoordinate /= Double(count)
        yCoordinate /= Double(count)
        zCoordinate /= Double(count)

        let lon = atan2(yCoordinate, xCoordinate)
        let hyp = sqrt(xCoordinate * xCoordinate + yCoordinate * yCoordinate)
        let lat = atan2(zCoordinate, hyp)

        return CLLocationCoordinate2D(latitude: rad2deg(lat), longitude: rad2deg(lon))
    }

    private func deg2rad(_ number: Double) -> Double {
        return number * .pi / 180 // swiftlint:disable:this no_magic_numbers
    }

    private func rad2deg(_ number: Double) -> Double {
        return number * 180 / .pi // swiftlint:disable:this no_magic_numbers
    }
}
