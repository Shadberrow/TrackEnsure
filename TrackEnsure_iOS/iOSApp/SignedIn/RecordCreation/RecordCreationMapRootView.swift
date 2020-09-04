//
//  RecordCreationMapRootView.swift
//  TrackEnsure_iOS
//
//  Created by Yevhenii on 03.09.2020.
//  Copyright © 2020 Yevhenii. All rights reserved.
//

import TrackEnsureKit
import TrackEnsureUIKit
import UIKit
import MapKit
import CoreLocation

public class RecordCreationMapRootView: NiblessView, MKMapViewDelegate, CLLocationManagerDelegate {

    // MARK: - Properties
    // View Model
    let viewModel: RecordCreationViewModel

    // Subviews
    private var mapView: MKMapView!
    private var pinImage: UIImageView!
    private var closeButton: UIButton!

    private var hierarchyNotReady: Bool = true

    // Location
    private let locationManager = CLLocationManager()
    private let geoCoder = CLGeocoder()
    private let regionInMeters = 2e3
    private var previousLocation: CLLocation?

    // MARK: - Methods
    init(viewModel: RecordCreationViewModel) {
        self.viewModel = viewModel
        super.init(frame: .zero)
        backgroundColor = .secondarySystemBackground
    }

    private func checkLocationServices() {
        if CLLocationManager.locationServicesEnabled() {
            setupLocationManager()
            checkLocationAuthorization()
        } else {
            // Show alert to turn locatin services
        }
    }

    private func checkLocationAuthorization() {
        switch CLLocationManager.authorizationStatus() {
        case .authorizedWhenInUse:
            startTrackingUserLocation()
        case .denied:
            // Show alert how to turn on permissions
            break
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .restricted:
            // Show alert that permission is restricted
            break
        case .authorizedAlways:
            break
        @unknown default: return
        }
    }

    private func startTrackingUserLocation() {
        mapView.showsUserLocation = true
        centerViewOnUserLocation()
        previousLocation = getCenterLocation(for: mapView)
    }

    private func centerViewOnUserLocation() {
        guard let location = locationManager.location?.coordinate else { return }
        let region = MKCoordinateRegion(center: location, latitudinalMeters: regionInMeters, longitudinalMeters: regionInMeters)
        mapView.setRegion(region, animated: true)
    }

    private func setupLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }

    public override func didMoveToSuperview() {
        super.didMoveToSuperview()
        guard hierarchyNotReady else { return }
        setupSubviews()
        constructHierarchy()
        activateConstraints()
        hierarchyNotReady = false

        checkLocationServices()
    }

    private func setupSubviews() {
        mapView = MKMapView()
        mapView.delegate = self

        pinImage = UIImageView(image: UIImage(systemName: "pin.fill"))
        pinImage.tintColor = .label

        let configuration = UIImage.SymbolConfiguration(font: UIFont.systemFont(ofSize: 22, weight: .medium))
        let image = UIImage(systemName: "xmark.circle.fill", withConfiguration: configuration)

        closeButton = UIButton(type: .system)
        closeButton.setImage(image, for: .normal)
        closeButton.tintColor = .label
        closeButton.addTarget(self, action: #selector(handleClose), for: .touchUpInside)
    }

    private func constructHierarchy() {
        addSubview(mapView)
        addSubview(pinImage)
        addSubview(closeButton)
    }

    private func activateConstraints() {
        activateConstraintsTableView()
        activateConstraintsPinImage()
        activateConstraintsCloseButton()
    }

    private func activateConstraintsTableView() {
        mapView.translatesAutoresizingMaskIntoConstraints = false
        let top = mapView.topAnchor.constraint(equalTo: self.topAnchor)
        let bottom = mapView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        let leading = mapView.leadingAnchor.constraint(equalTo: self.leadingAnchor)
        let trailing = mapView.trailingAnchor.constraint(equalTo: self.trailingAnchor)
        NSLayoutConstraint.activate([top, bottom, leading, trailing])
    }

    private func activateConstraintsPinImage() {
        pinImage.translatesAutoresizingMaskIntoConstraints = false
        let centerY = pinImage.centerYAnchor.constraint(equalTo: mapView.centerYAnchor, constant: -25)
        let centerX = pinImage.centerXAnchor.constraint(equalTo: mapView.centerXAnchor)
        let width = pinImage.widthAnchor.constraint(equalToConstant: 50)
        let height = pinImage.heightAnchor.constraint(equalTo: pinImage.widthAnchor)
        NSLayoutConstraint.activate([centerY, centerX, width, height])
    }

    private func activateConstraintsCloseButton() {
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        let top = closeButton.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 0)
        let trailing = closeButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -12)
        let width = closeButton.widthAnchor.constraint(equalToConstant: 50)
        let height = closeButton.heightAnchor.constraint(equalTo: closeButton.widthAnchor)
        NSLayoutConstraint.activate([top, trailing, width, height])
    }

    private func getCenterLocation(for mapView: MKMapView) -> CLLocation {
        let latitude = mapView.centerCoordinate.latitude
        let longitude = mapView.centerCoordinate.longitude

        return CLLocation(latitude: latitude, longitude: longitude)
    }

    @objc private func handleClose() {
        viewModel.dismissCreation()
    }

    // MARK: - Core Location Delegate
    public func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        checkLocationAuthorization()
    }

    // MARK: - MKMapView Delegate
    public func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        let center = getCenterLocation(for: mapView)

        guard let previousLocation = previousLocation,
            center.distance(from: previousLocation) > 20 else { return }
        self.previousLocation = center

        geoCoder.reverseGeocodeLocation(center) { [weak self] placemarks, error in
            guard let self = self else { return }
            if let error = error { print(error); return
                // Handle error
            }
            guard let placemark = placemarks?.first else { return }
            let streetNumber = placemark.subThoroughfare ?? ""
            let streetName = placemark.thoroughfare ?? ""

            var address: String
            address = streetNumber.isEmpty ? streetName : (streetNumber + " " + streetName)
            address = address.isEmpty ? "Move Pin" : address

            self.viewModel.addressSubject.send(address)
            self.viewModel.locationSubject.send(Location(latitude: center.coordinate.latitude, longitude: center.coordinate.longitude))
        }
    }
}
