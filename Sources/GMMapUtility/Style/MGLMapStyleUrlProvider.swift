import Foundation

public protocol MGLMapStyleUrlProvider {
    func mapStyle(forMapTheme: MapTheme) -> URL
}
