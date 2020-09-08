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
import Combine

public class RecordCreationMapRootView: NiblessView, MKMapViewDelegate, CLLocationManagerDelegate {

    // MARK: - Properties
    // View Model
    let viewModel: RecordCreationViewModel

    // Subviews
    private var mapView: MKMapView!
    private var closeButton: UIButton!

    private var hierarchyNotReady: Bool = true

    // Location
    private let locationManager = CLLocationManager()
    private let geoCoder = CLGeocoder()
    private let regionInMeters = 2e3

    // Combine
    private var subscriptions = Set<AnyCancellable>()

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
    }

    private func addAnnotation(_ annotation: MKPointAnnotation) {
        mapView.removeAnnotations(mapView.annotations)
        mapView.addAnnotation(annotation)
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

        viewModel.locationSubject.compactMap { $0 }
            .combineLatest(viewModel.addressSubject.compactMap { $0 })
            .sink { [weak self] location, address in
                let annotation = MKPointAnnotation()
                annotation.coordinate = CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude)
                annotation.title = address
                self?.addAnnotation(annotation) }
            .store(in: &subscriptions)
    }

    private func setupSubviews() {
        mapView = MKMapView()
        mapView.delegate = self
        mapView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleMapTap)))
        mapView.layoutMargins = UIEdgeInsets(top: 64, left: 0, bottom: 0, right: 12)

        let configuration = UIImage.SymbolConfiguration(font: UIFont.systemFont(ofSize: 22, weight: .medium))
        let image = UIImage(systemName: "xmark.circle.fill", withConfiguration: configuration)

        closeButton = UIButton(type: .system)
        closeButton.setImage(image, for: .normal)
        closeButton.tintColor = .label
        closeButton.addTarget(self, action: #selector(handleClose), for: .touchUpInside)
    }

    private func constructHierarchy() {
        addSubview(mapView)
        addSubview(closeButton)
    }

    private func activateConstraints() {
        activateConstraintsTableView()
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

    private func activateConstraintsCloseButton() {
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        let top = closeButton.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 0)
        let trailing = closeButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -12)
        let width = closeButton.widthAnchor.constraint(equalToConstant: 50)
        let height = closeButton.heightAnchor.constraint(equalTo: closeButton.widthAnchor)
        NSLayoutConstraint.activate([top, trailing, width, height])
    }

    @objc private func handleClose() {
        viewModel.dismissCreation()
    }

    @objc private func handleMapTap(_ sender: UITapGestureRecognizer) {
        let location = sender.location(in: mapView)
        let coordinate = mapView.convert(location, toCoordinateFrom: mapView)
        let clLocation = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)

        geoCoder.reverseGeocodeLocation(clLocation, preferredLocale: Locale.current) { [weak self] placemarks, error in
            guard let self = self else { return }
            if let error = error { print(error); return }
            guard let placemark = placemarks?.first else { return }
            let streetNumber = placemark.subThoroughfare ?? ""
            let streetName = placemark.thoroughfare ?? ""

            var address: String = streetNumber.isEmpty ? streetName : (streetNumber + " " + streetName)
            address = address.isEmpty ? "Undefined" : address

            self.viewModel.addressSubject.send(address)
            self.viewModel.locationSubject.send(Location(latitude: coordinate.latitude, longitude: coordinate.longitude))
        }
    }

    // MARK: - Core Location Delegate
    public func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        checkLocationAuthorization()
    }
}
