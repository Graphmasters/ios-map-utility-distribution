import Foundation
import Mapbox

public class MapboxMapLayerManager {
    public weak var mapView: MGLMapView?

    private var cachedShapes = [String: MGLShape?]()

    public init(mapView: MGLMapView) {
        self.mapView = mapView
    }
}

extension MapboxMapLayerManager {
    // MARK: - Source handling

    public func add(source: MGLSource) {
        guard !mapSourceExists(source: source) else {
            return
        }
        mapView?.style?.addSource(source)
    }

    public func add(shapeSource: MGLShapeSource, useFeatureCache: Bool = false) {
        add(source: shapeSource)

        guard useFeatureCache else {
            return
        }

        try? updateSourceFromCache(source: shapeSource)
    }

    private func updateSourceFromCache(source: MGLShapeSource) throws {
        guard let shape = cachedShapes[source.identifier] else {
            return
        }
        try set(shape: shape, on: source)
    }

    public func remove(source: MGLSource) {
        guard mapView?.style?.sources.contains(source) ?? false else {
            return
        }
        mapView?.style?.removeSource(source)
    }

    public func clear(source: MGLShapeSource) throws {
        try set(shape: nil, on: source)
    }

    public func set(shape: MGLShape?, on source: MGLShapeSource) throws {
        guard mapSourceIsAvailable(source: source) else {
            throw MapboxMapLayerManagerError.sourceUnavailable(source.identifier)
        }
        cachedShapes[source.identifier] = shape
        source.shape = shape
    }

    private func mapSourceIsAvailable(source: MGLSource) -> Bool {
        return mapView?.style?.source(withIdentifier: source.identifier) == source
    }

    private func mapSourceExists(source: MGLSource) -> Bool {
        return mapView?.style?.source(withIdentifier: source.identifier) != nil
    }
}

extension MapboxMapLayerManager {
    // MARK: - Image handling

    public func add(image: UIImage, for key: String) {
        mapView?.style?.setImage(image, forName: key)
    }

    public func remove(imageWithKey key: String) {
        mapView?.style?.removeImage(forName: key)
    }
}

extension MapboxMapLayerManager {
    // MARK: - Layer handling

    public func showLayers(withPrefix prefix: String) {
        let layers = mapView?.style?.layers.filter { $0.identifier.starts(with: prefix) } ?? []
        layers.forEach {
            $0.isVisible = true
        }
    }

    public func hideLayers(withPrefix prefix: String) {
        let layers = mapView?.style?.layers.filter { $0.identifier.starts(with: prefix) } ?? []
        layers.forEach {
            $0.isVisible = false
        }
    }

    public func showLayer(with identifier: String) {
        guard let layer = mapView?.style?.layers.first(where: { $0.identifier == identifier }) else {
            return
        }
        layer.isVisible = true
    }

    public func hideLayer(with identifier: String) {
        guard let layer = mapView?.style?.layers.first(where: { $0.identifier == identifier }) else {
            return
        }
        layer.isVisible = false
    }

    public func mapLayerAvailable(mapLayer: MGLStyleLayer) -> Bool {
        return mapView?.style?.layer(withIdentifier: mapLayer.identifier) == mapLayer
    }

    private func mapLayerExists(mapLayer: MGLStyleLayer) -> Bool {
        return mapView?.style?.layer(withIdentifier: mapLayer.identifier) != nil
    }

    public func addOnTop(layer: MGLStyleLayer) throws {
        guard !mapLayerExists(mapLayer: layer) else {
            throw MapboxMapLayerManagerError.layerAlreadyAdded(layer.identifier)
        }
        mapView?.style?.addLayer(layer)
    }

    public func add(layer: MGLStyleLayer, belowLayerWith layerId: String) throws {
        guard !mapLayerExists(mapLayer: layer) else {
            throw MapboxMapLayerManagerError.layerAlreadyAdded(layerId)
        }
        guard let layer2 = mapView?.style?.layer(withIdentifier: layerId) else {
            try addOnTop(layer: layer)
            return
        }
        mapView?.style?.insertLayer(layer, below: layer2)
    }

    public func add(layer: MGLStyleLayer, aboveLayerWith layerId: String) throws {
        guard !mapLayerExists(mapLayer: layer) else {
            throw MapboxMapLayerManagerError.layerAlreadyAdded(layerId)
        }
        guard let layer2 = mapView?.style?.layer(withIdentifier: layerId) else {
            try addOnTop(layer: layer)
            return
        }
        mapView?.style?.insertLayer(layer, above: layer2)
    }

    private func add(layer: MGLStyleLayer, at index: UInt) throws {
        guard !mapLayerExists(mapLayer: layer) else {
            return
        }
        guard (0 ... (mapView?.style?.layers.count ?? 0)).contains(Int(index)) else {
            try addOnTop(layer: layer)
            return
        }
        mapView?.style?.insertLayer(layer, at: index)
    }

    public func remove(layer: MGLStyleLayer) {
        guard mapView?.style?.layers.contains(layer) ?? false else {
            return
        }
        mapView?.style?.removeLayer(layer)
    }
}
