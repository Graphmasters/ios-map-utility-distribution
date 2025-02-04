import Foundation
import Mapbox
import UIKit

public final class MGLMapViewLifeCycleHandler: NSObject {
    // MARK: Properties

    private weak var mapView: MGLMapView?
    private weak var delegate: MGLMapViewLifeCycleHandlerDelegate?

    private var mapThemeRepository: MapThemeRepository
    private let mapStyleUrlProvider: MGLMapStyleUrlProvider
    private let mapStyleLocalizer: MGLMapStyleLocalizer
    private let mapLayerHandlerBuilder: MapLayerHandlerBuilder

    private var currentLayersController: MGLStyleLayersHandler?
    private lazy var mapTapGestureRecognizer: UITapGestureRecognizer = {
        let recognizer = UITapGestureRecognizer(target: self, action: #selector(didTapMapView(sender:)))
        recognizer.delegate = self
        return recognizer
    }()

    // MARK: Computed Properties

    private var layerUpdatesPaused = true {
        didSet {
            if layerUpdatesPaused {
                currentLayersController?.stopLayerUpdates()
            } else {
                currentLayersController?.startLayerUpdates()
            }
        }
    }

    // MARK: Lifecycle

    public init(
        mapThemeRepository: MapThemeRepository,
        mapStyleUrlProvider: MGLMapStyleUrlProvider,
        mapStyleLocalizer: MGLMapStyleLocalizer,
        mapLayerHandlerBuilder: MapLayerHandlerBuilder
    ) {
        self.mapThemeRepository = mapThemeRepository
        self.mapStyleUrlProvider = mapStyleUrlProvider
        self.mapStyleLocalizer = mapStyleLocalizer
        self.mapLayerHandlerBuilder = mapLayerHandlerBuilder

        super.init()
    }

    /// This methods setups the `MGLMapViewLifeCycleHandler` with the given `MGLMapView`.
    ///
    /// - warning: This methods sets itself as delegate of the mapView and the mapThemeRepository. It expects that the delegates are not set from
    ///     somewhere else.
    public func setup(mapView: MGLMapView, delegate: MGLMapViewLifeCycleHandlerDelegate?) {
        self.mapView = mapView
        self.mapView?.delegate = self
        self.mapView?.addGestureRecognizer(mapTapGestureRecognizer)
        self.delegate = delegate

        mapThemeRepository.delegate = self
    }
}

// MARK: - Public methods

extension MGLMapViewLifeCycleHandler {
    /// This methods pauses all layer updates.
    ///
    /// - note: This shoud be called if the map is not visible to not update the map layers if the view is not visible.
    public func pauseLayerUpdates() {
        layerUpdatesPaused = true
    }

    /// This methods resumes all layer updates.
    ///
    /// - note: This should be called if the map becomes visible.
    public func resumeLayerUpdates() {
        layerUpdatesPaused = false
    }
}

// MARK: - Layer handler controlling

extension MGLMapViewLifeCycleHandler {
    private func initNewMapLayersController(_ mapView: MGLMapView) {
        currentLayersController?.stopLayerUpdates()

        currentLayersController = mapLayerHandlerBuilder.mapLayerHandler(
            for: mapView,
            withMapTheme: mapThemeRepository.mapTheme
        )

        currentLayersController?.setup()

        if !layerUpdatesPaused {
            currentLayersController?.startLayerUpdates()
        }
    }

    private func localize(style: MGLStyle) {
        mapStyleLocalizer.localize(style, locale: Locale.current)
    }

    @objc
    private func didTapMapView(sender: UITapGestureRecognizer) {
        guard let mapView = mapView else {
            return
        }
        if mapView.attributionButton.bounds.contains(sender.location(in: mapView.attributionButton)) {
            mapView.attributionButton.sendActions(for: .touchUpInside)
        } else {
            currentLayersController?.didTapLayer(at: sender.location(in: mapView), in: mapView)
        }
    }
}

// MARK: - Implementations

extension MGLMapViewLifeCycleHandler: MGLMapViewDelegate {
    public func mapView(_ mapView: MGLMapView, didFinishLoading style: MGLStyle) {
        initNewMapLayersController(mapView)
        localize(style: style)

        delegate?.mapView(mapView, didFinishLoading: style, handledBy: self)
    }

    public func mapView(_ mapView: MGLMapView, regionIsChangingWith reason: MGLCameraChangeReason) {
        delegate?.mapView(mapView, regionIsChangingWith: reason, handledBy: self)
    }

    public func mapView(_ mapView: MGLMapView, regionDidChangeWith reason: MGLCameraChangeReason, animated: Bool) {
        if reason == .gestureTilt {
            currentLayersController?.updateTilt(tilt: Float(mapView.camera.pitch))
        }

        delegate?.mapView(mapView, regionDidChangeWith: reason, animated: animated, handledBy: self)
    }
}

extension MGLMapViewLifeCycleHandler: UIGestureRecognizerDelegate {
    public func gestureRecognizer(
        _: UIGestureRecognizer,
        shouldRecognizeSimultaneouslyWith _: UIGestureRecognizer
    ) -> Bool {
        return true
    }
}

extension MGLMapViewLifeCycleHandler: MapThemeRepositoryDelegate {
    public func mapThemeRepository(_: MapThemeRepository, didChangeMapTheme mapTheme: MapTheme) {
        mapView?.styleURL = mapStyleUrlProvider.mapStyle(forMapTheme: mapTheme)
    }
}
