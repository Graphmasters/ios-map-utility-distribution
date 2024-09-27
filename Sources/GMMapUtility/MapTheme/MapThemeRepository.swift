import Foundation

public protocol MapThemeRepository {
    var delegate: MapThemeRepositoryDelegate? { get set }

    var mapTheme: MapTheme { get }
}
