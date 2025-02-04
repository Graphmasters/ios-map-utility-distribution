import Mapbox

public protocol MGLMapViewLifeCycleHandlerDelegate: AnyObject {
    func mapView(
        _ mapView: MGLMapView,
        didFinishLoading style: MGLStyle,
        handledBy handler: MGLMapViewLifeCycleHandler
    )

    func mapView(
        _ mapView: MGLMapView,
        regionWillChangeWith reason: MGLCameraChangeReason,
        animated: Bool,
        handledBy handler: MGLMapViewLifeCycleHandler
    )

    func mapView(
        _ mapView: MGLMapView,
        regionIsChangingWith _: MGLCameraChangeReason,
        handledBy handler: MGLMapViewLifeCycleHandler
    )

    func mapView(
        _ mapView: MGLMapView,
        regionDidChangeWith reason: MGLCameraChangeReason,
        animated: Bool,
        handledBy handler: MGLMapViewLifeCycleHandler
    )
}

extension MGLMapViewLifeCycleHandlerDelegate {
    public func mapView(
        _: MGLMapView,
        didFinishLoading _: MGLStyle,
        handledBy _: MGLMapViewLifeCycleHandler
    ) {}

    public func mapView(
        _: MGLMapView,
        regionWillChangeWith _: MGLCameraChangeReason,
        animated _: Bool,
        handledBy _: MGLMapViewLifeCycleHandler
    ) {}

    public func mapView(
        _: MGLMapView,
        regionIsChangingWith _: MGLCameraChangeReason,
        handledBy _: MGLMapViewLifeCycleHandler
    ) {}

    public func mapView(
        _: MGLMapView,
        regionDidChangeWith _: MGLCameraChangeReason,
        animated _: Bool,
        handledBy _: MGLMapViewLifeCycleHandler
    ) {}
}
