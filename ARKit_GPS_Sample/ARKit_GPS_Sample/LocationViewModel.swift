//
//  LocationViewModel.swift
//  ShowLocationSample
//
//  Created by スカラパートナーズ on 2021/12/23.
//
import CoreLocation

class LocationViewModel: NSObject, ObservableObject, CLLocationManagerDelegate {
    @Published var authorizationStatus: CLAuthorizationStatus
    @Published var lastSeenLocation: CLLocation?
    @Published var lastSeenHeading: CLHeading?

    private let locationManager: CLLocationManager
    
    override init() {
        locationManager = CLLocationManager()
        authorizationStatus = locationManager.authorizationStatus
        
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters //10m
        locationManager.distanceFilter = 5.0
        // バックグラウンド実行中も座標取得する場合、trueにする
//        locationManager.allowsBackgroundLocationUpdates = true
        locationManager.pausesLocationUpdatesAutomatically = false
        locationManager.startUpdatingLocation()
        
        locationManager.headingFilter = 20
        locationManager.headingOrientation = .portrait
        locationManager.startUpdatingHeading()

    }

    func requestPermission() {
        locationManager.requestWhenInUseAuthorization()
        // バックグラウンド実行中も座標取得する場合はこちら
//        locationManager.requestAlwaysAuthorization()
    }

    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        authorizationStatus = manager.authorizationStatus
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        lastSeenLocation = locations.first
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
        lastSeenHeading = newHeading
//            if angle == -1 { // コンパスの回転を初期化する
//                angle = newHeading.magneticHeading
//                compassNode?.rotation = SCNVector4(0, 1, 0, (angle / 180) * Double.pi)
//            }
        }
    
    var coordinate: CLLocationCoordinate2D? {
        lastSeenLocation?.coordinate
    }
    
    var direction: CLHeading?{
        lastSeenHeading
    }
}
