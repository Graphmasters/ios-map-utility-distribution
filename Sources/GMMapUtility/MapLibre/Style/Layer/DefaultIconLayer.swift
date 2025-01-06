import Foundation
import Mapbox

open class DefaultIconLayer: MGLSymbolStyleLayer {
    // MARK: Nested Types

    private enum Constants {
        static let defaultZoomLevel: Float = 11
    }

    // MARK: Static Properties

    @objc public static let iconNameKey: String = #keyPath(iconNameKey)
    @objc public static let textKey: String = #keyPath(textKey)

    // MARK: Lifecycle

    public init(identifier: String, source: MGLSource, minimumZoomLevel: Float? = nil) {
        super.init(identifier: identifier, source: source)

        self.minimumZoomLevel = minimumZoomLevel ?? Constants.defaultZoomLevel

        applyDefaultStyle(to: self)
    }

    // MARK: Functions

    // swiftlint:disable no_magic_numbers
    private func applyDefaultStyle(to layer: MGLSymbolStyleLayer) {
        layer.text = NSExpression(forKeyPath: Self.textKey)
        layer.iconImageName = NSExpression(forKeyPath: Self.iconNameKey)
        layer.iconAllowsOverlap = NSExpression(forConstantValue: false)
        layer.iconAnchor = NSExpression(forConstantValue: "bottom")
        layer.iconScale = NSExpression(
            forMGLInterpolating: NSExpression.zoomLevelVariable,
            curveType: .linear,
            parameters: nil,
            stops: NSExpression(forConstantValue: [
                5.0: 0.4,
                15.0: 1.0,
                20.0: 1.3
            ])
        )
        layer.iconOpacity = NSExpression(
            forMGLInterpolating: NSExpression.zoomLevelVariable,
            curveType: .linear,
            parameters: nil,
            stops: NSExpression(forConstantValue: [
                layer.minimumZoomLevel: 0.0,
                layer.minimumZoomLevel + 0.25: 1.0
            ])
        )
    }
    // swiftlint:enable no_magic_numbers
}
