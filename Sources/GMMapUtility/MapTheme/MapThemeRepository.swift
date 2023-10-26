import Foundation

public protocol MapThemeRepositoryDelegate: AnyObject {
    func mapThemeRepository(_ repository: MapThemeRepository, didChangeMapTheme mapTheme: MapTheme)
}

public protocol MapThemeRepository {
    var delegate: MapThemeRepositoryDelegate? { get set }

    var mapTheme: MapTheme { get }
}
