import Foundation

public protocol MapThemeRepositoryDelegate: AnyObject {
    func mapThemeRepository(_ repository: MapThemeRepository, didChangeMapTheme mapTheme: MapTheme)
}
