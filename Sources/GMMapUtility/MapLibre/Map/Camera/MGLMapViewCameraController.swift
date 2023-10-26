import Mapbox

public class MGLMapViewCameraController: MapViewCameraController {
    // MARK: - Attributes

    private weak var mapView: MGLMapView?

    private let defaultPitch: CGFloat

    private let defaultZoom: Double

    // MARK: - Life Cycle

    public init(
        mapView: MGLMapView,
        defaultPitch: CGFloat = .zero,
        defaultZoom: Double = 15
    ) {
        self.mapView = mapView
        self.defaultPitch = defaultPitch
        self.defaultZoom = defaultZoom
    }

    // MARK: - Actions

    public var isCenteredToCurrentLocation: Bool {
        guard let mapView = mapView, let location = mapView.userLocation else {
            return false
        }
        return abs(mapView.camera.heading) == 0
            && abs(location.coordinate.latitude - mapView.centerCoordinate.latitude) < 0.0001
    }

    public func set(to location: CLLocationCoordinate2D, heading: Double?, completion: (() -> Void)?) {
        move(to: location, heading: heading, duration: .zero, completion: completion)
    }

    public func move(
        to location: CLLocationCoordinate2D,
        heading: Double?,
        duration: TimeInterval,
        zoom: Double?,
        pitch: CGFloat?,
        edgeInsets: UIEdgeInsets = .zero,
        completion: (() -> Void)?
    ) {
        set(
            camera: camera(from: location, heading: heading, zoom: zoom, pitch: pitch),
            animationTimingFunction: CAMediaTimingFunction(name: .linear),
            duration: duration,
            edgeInsets: edgeInsets,
            completion: completion
        )
    }

    public func fly(
        to location: CLLocationCoordinate2D,
        heading: Double?,
        zoomLevel: Double?,
        completion: (() -> Void)?
    ) {
        mapView?.fly(to: camera(from: location, heading: heading, zoom: zoomLevel), withDuration: 1, completionHandler: completion)
    }

    public func showNorth(animated _: Bool, completion: (() -> Void)?) {
        guard let mapView = mapView else {
            completion?()
            return
        }
        let camera = mapView.camera
        camera.heading = .zero
        camera.pitch = .zero
        camera.altitude += 1000
        set(
            camera: camera,
            animationTimingFunction: CAMediaTimingFunction(name: .easeOut),
            duration: nil,
            completion: completion
        )
    }

    public func show(locations: [CLLocationCoordinate2D], animated: Bool, completion: (() -> Void)? = nil) {
        guard let bbox = locations.filter({ CLLocationCoordinate2DIsValid($0) }).boundingBox else {
            return
        }
        showBoundingBox(northEast: bbox.northEast, southWest: bbox.southWest, animated: animated, completion: completion)
    }

    public func cancelCameraUpdates() {
        mapView?.zoomLevel += 0.01
    }

    public func zoomIn(animated _: Bool, completion: (() -> Void)?) {
        guard let mapView = mapView else {
            completion?()
            return
        }
        set(
            camera: camera(
                from: mapView.camera.centerCoordinate,
                heading: mapView.camera.heading,
                zoom: mapView.zoomLevel + 1,
                pitch: mapView.camera.pitch
            ),
            animationTimingFunction: CAMediaTimingFunction(name: .easeOut),
            completion: completion
        )
    }

    public func zoomOut(animated _: Bool, completion: (() -> Void)?) {
        guard let mapView = mapView else {
            completion?()
            return
        }
        set(
            camera: camera(
                from: mapView.camera.centerCoordinate,
                heading: mapView.camera.heading,
                zoom: mapView.zoomLevel - 1,
                pitch: mapView.camera.pitch
            ),
            animationTimingFunction: CAMediaTimingFunction(name: .easeOut),
            completion: completion
        )
    }

    public func moveCamera(
        withTranslation translation: CGPoint,
        timingFunction: CAMediaTimingFunction,
        duration: TimeInterval?,
        completion: (() -> Void)?
    ) {
        guard let mapView = mapView else {
            completion?()
            return
        }
        let contentFrame = mapView.bounds.inset(by: mapView.safeAreaInsets)
        let centerPoint = CGPoint(x: contentFrame.midX, y: contentFrame.midY)
        let endCameraPoint = CGPoint(x: centerPoint.x - translation.x, y: centerPoint.y - translation.y)

        let destinationCoordinate = mapView.convert(
            endCameraPoint,
            toCoordinateFrom: nil
        )
        set(
            camera: MGLMapCamera(
                lookingAtCenter: destinationCoordinate,
                altitude: mapView.camera.altitude,
                pitch: mapView.camera.pitch,
                heading: mapView.camera.heading
            ),
            animationTimingFunction: timingFunction,
            duration: duration,
            edgeInsets: .zero,
            completion: completion
        )
    }

    public func moveCamera(
        inDirection direction: CGPoint,
        withFactor factor: CGFloat,
        timingFunction: CAMediaTimingFunction,
        duration: TimeInterval?,
        completion: (() -> Void)?
    ) {
        guard let mapView = mapView else {
            completion?()
            return
        }
        let baseSize = min(
            mapView.bounds.width - (mapView.safeAreaInsets.left + mapView.safeAreaInsets.right),
            mapView.bounds.height - (mapView.safeAreaInsets.top + mapView.safeAreaInsets.bottom)
        )
        let moveLegth = baseSize * factor
        moveCamera(
            withTranslation: CGPoint(x: direction.x * moveLegth, y: direction.y * moveLegth),
            timingFunction: timingFunction,
            duration: duration,
            completion: completion
        )
    }

    // MARK: - Helpers

    private func camera(
        from location: CLLocationCoordinate2D,
        heading: Double?,
        zoom: Double? = nil,
        pitch: CGFloat? = nil
    ) -> MGLMapCamera {
        return MGLMapCamera(
            lookingAtCenter: location,
            acrossDistance: mapView?.convertToZoomDistance(
                zoom: zoom ?? defaultZoom,
                pitch: pitch ?? defaultPitch,
                latitude: location.latitude
            ) ?? 500,
            pitch: pitch ?? defaultPitch,
            heading: heading ?? .zero
        )
    }

    private func set(
        camera: MGLMapCamera,
        animationTimingFunction: CAMediaTimingFunction,
        duration: TimeInterval? = nil,
        edgeInsets: UIEdgeInsets = .zero,
        completion: (() -> Void)?
    ) {
        mapView?.setCamera(
            camera,
            withDuration: calculateDuration(camera: camera, defaultDuration: duration),
            animationTimingFunction: animationTimingFunction,
            edgePadding: edgeInsets,
            completionHandler: completion
        )
    }

    private func calculateDuration(camera: MGLMapCamera, defaultDuration: TimeInterval?) -> TimeInterval {
        guard let mapView = mapView else {
            return .zero
        }
        let distance = CLLocation(
            latitude: mapView.centerCoordinate.latitude,
            longitude: mapView.centerCoordinate.longitude
        ).distance(from: CLLocation(
            latitude: camera.centerCoordinate.latitude,
            longitude: camera.centerCoordinate.longitude
        ))

        let altitude = (0.75 * camera.altitude + 0.25 * mapView.camera.altitude)

        guard distance < altitude * 2 else {
            return .zero
        }

        return defaultDuration ?? max(0.5, distance / altitude)
    }

    private func showBoundingBox(
        northEast: CLLocationCoordinate2D,
        southWest: CLLocationCoordinate2D,
        animated: Bool = true,
        completion: (() -> Void)? = nil
    ) {
        guard let mapView = mapView else {
            completion?()
            return
        }
        guard CLLocationCoordinate2DIsValid(northEast), CLLocationCoordinate2DIsValid(southWest) else {
            completion?()
            return
        }

        let bounds = MGLCoordinateBounds(
            sw: southWest,
            ne: northEast
        )
        let baseCamera = MGLMapCamera(
            lookingAtCenter: [northEast, southWest].geographicMidpoint(),
            acrossDistance: .zero, pitch: .zero, heading: .zero
        )
        let camera = mapView.camera(
            baseCamera,
            fitting: bounds,
            edgePadding: .zero
        )
        set(
            camera: camera,
            animationTimingFunction: CAMediaTimingFunction(name: .easeOut),
            duration: animated ? nil : 0,
            completion: completion
        )
    }
}
