import Mapbox

open class DashedLineLayer: MGLLineStyleLayer {
    private enum Constants {
        static let defaultZoomLevel: Float = 11
    }

    public init(identifier: String, source: MGLSource, lineColor: UIColor) {
        super.init(identifier: identifier, source: source)

        applyDefaultStyle(to: self, lineColor: lineColor)
    }

    private func applyDefaultStyle(to layer: MGLLineStyleLayer, lineColor: UIColor) {
        layer.minimumZoomLevel = Constants.defaultZoomLevel
        layer.lineCap = NSExpression(forConstantValue: "round")
        layer.lineJoin = NSExpression(forConstantValue: "round")
        layer.lineColor = NSExpression(forConstantValue: lineColor)
        layer.lineDashPattern = NSExpression(forConstantValue: [0.5, 1.75])
        layer.lineWidth = NSExpression(
            forMGLInterpolating: .zoomLevelVariable,
            curveType: .linear,
            parameters: nil,
            stops: NSExpression(forConstantValue: [
                20: 4,
                1: 0.2
            ])
        )
    }
}
