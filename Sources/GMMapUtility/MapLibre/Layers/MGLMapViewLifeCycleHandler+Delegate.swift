import Mapbox

public protocol MGLMapViewLifeCycleHandlerDelegate: AnyObject {
    func mapView(_ mapView: MGLMapView, didFinishLoading style: MGLStyle, handledBy handler: MGLMapViewLifeCycleHandler)

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
