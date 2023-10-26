import CoreLocation
import Foundation

extension Collection where Element == CLLocationCoordinate2D {
    public func geographicMidpoint() -> CLLocationCoordinate2D {
        guard count > 1 else {
            return first ?? CLLocationCoordinate2D(latitude: 0, longitude: 0)
        }

        var x = Double(0)
        var y = Double(0)
        var z = Double(0)

        for coordinate in self {
            let lat = deg2rad(coordinate.latitude)
            let lon = deg2rad(coordinate.longitude)
            x += cos(lat) * cos(lon)
            y += cos(lat) * sin(lon)
            z += sin(lat)
        }

        x /= Double(count)
        y /= Double(count)
        z /= Double(count)

        let lon = atan2(y, x)
        let hyp = sqrt(x * x + y * y)
        let lat = atan2(z, hyp)

        return CLLocationCoordinate2D(latitude: rad2deg(lat), longitude: rad2deg(lon))
    }

    private func deg2rad(_ number: Double) -> Double {
        return number * .pi / 180
    }

    private func rad2deg(_ number: Double) -> Double {
        return number * 180 / .pi
    }
}
