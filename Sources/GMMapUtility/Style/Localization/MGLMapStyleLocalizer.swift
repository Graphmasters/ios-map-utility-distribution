import Foundation
import Mapbox

public protocol MGLMapStyleLocalizer {
    func localize(_ style: MGLStyle, locale: Locale)
}
