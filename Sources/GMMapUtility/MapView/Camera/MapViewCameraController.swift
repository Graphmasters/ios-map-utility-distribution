import CoreLocation
import Foundation
import UIKit

public protocol MapViewCameraController {
    var isCenteredToCurrentLocation: Bool { get }

    /// Moves the map camera directly to the given coordinate without any animation.
    func set(to location: CLLocationCoordinate2D, heading: Double?, completion: (() -> Void)?)

    /// Moves the map camera to the given location with the given duration
    func move(
        to location: CLLocationCoordinate2D,
        heading: Double?,
        duration: TimeInterval,
        zoom: Double?,
        pitch: CGFloat?,
        edgeInsets: UIEdgeInsets,
        completion: (() -> Void)?
    )

    /// Moves the map camera to the given location. The method automatically decides on the used animation.
    ///
    /// - warning: The camera may move without any animation.
    func fly(
        to location: CLLocationCoordinate2D,
        heading: Double?,
        zoomLevel: Double?,
        completion: (() -> Void)?
    )

    /// Rotates the camera to the north.
    ///
    /// - note: The camera additionally adjusts the pitch to `0` and zooms out one zoom level.
    func showNorth(animated: Bool, completion: (() -> Void)?)

    /// Adjusts the map camera for all locations being visible on the map.
    func show(locations: [CLLocationCoordinate2D], animated: Bool, completion: (() -> Void)?)

    /// Adjusts the map's zoom level
    func zoomIn(animated: Bool, completion: (() -> Void)?)

    /// Adjusts the map's zoom level
    func zoomOut(animated: Bool, completion: (() -> Void)?)

    /// Cancels any ongoing camera animations.
    func cancelCameraUpdates()

    /// Moves camera in the given direction
    func moveCamera(
        withTranslation translation: CGPoint,
        timingFunction: CAMediaTimingFunction,
        duration: TimeInterval?,
        completion: (() -> Void)?
    )

    /// Moves camera in the given direction
    func moveCamera(
        inDirection direction: CGPoint,
        withFactor factor: CGFloat,
        timingFunction: CAMediaTimingFunction,
        duration: TimeInterval?,
        completion: (() -> Void)?
    )
}

extension MapViewCameraController {
    public func move(to location: CLLocationCoordinate2D, heading: Double?, duration: TimeInterval) {
        move(to: location, heading: heading, duration: duration, completion: nil)
    }

    public func move(
        to location: CLLocationCoordinate2D,
        heading: Double?,
        duration: TimeInterval,
        completion: (() -> Void)?
    ) {
        move(
            to: location,
            heading: heading,
            duration: duration,
            zoom: nil,
            pitch: nil,
            edgeInsets: .zero,
            completion: completion
        )
    }

    public func moveCamera(
        withTranslation translation: CGPoint,
        timingFunction: CAMediaTimingFunction = .init(name: .linear),
        duration: TimeInterval? = nil
    ) {
        moveCamera(withTranslation: translation, timingFunction: timingFunction, duration: duration, completion: nil)
    }
}
