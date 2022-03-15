
import UIKit
import GoogleMaps
import CoreLocation

class ViewController: UIViewController {

    // MARK: Properties

    private var coordinates = [CLLocationCoordinate2D]()
    private var locationManager: CLLocationManager?

    // MARK: IBOutlets

    @IBOutlet weak var mapView: GMSMapView!

    // MARK: Methods

    private func configureMapView() {
        mapView.isMyLocationEnabled = true
    }

    private func configureLocationManager() {
    locationManager = CLLocationManager()
    locationManager?.requestWhenInUseAuthorization()
    locationManager?.delegate = self
    }

    private func getAddress(from location: CLLocation) {
        CLGeocoder().reverseGeocodeLocation(location) { places, error in
            if let name = places?.first?.name {
                self.addCurrentPositionMarker(to: location.coordinate, with: name)
            }
        }
    }

    private func addCurrentPositionMarker(to position: CLLocationCoordinate2D, with name: String?) {
        let marker = GMSMarker(position: position)
        marker.icon = GMSMarker.markerImage(with: .cyan)
        marker.map = mapView
        marker.title = name
    }

    private func drawRoute() {
        let path = GMSMutablePath()
        coordinates.forEach { coordinate in
            path.add(coordinate)
        }
        let polyline = GMSPolyline(path: path)
        polyline.strokeWidth = 2
        polyline.strokeColor = .blue
        polyline.map = mapView

    }

    override func viewDidLoad() {
        super.viewDidLoad()

        configureMapView()
        configureLocationManager()
    }

    // MARK: IBActions
    @IBAction func didTapCurrentLocation(_ sender: UIBarButtonItem) {
        locationManager?.requestLocation()
        guard let location = locationManager?.location else {return}
        // получить адрес и поставить маркер в текущей локации
        getAddress(from:  location)
    }

    @IBAction func buildRoute(_ sender: UIBarButtonItem) {
        locationManager?.startUpdatingLocation()
        // отследить движение и нарисовать путь
        drawRoute()
    }
}

extension ViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {

        mapView.settings.myLocationButton = true
        guard let myLocation = locations.first else {return}
        self.coordinates.append(myLocation.coordinate)
        let camera = GMSCameraPosition.camera(withTarget: myLocation.coordinate , zoom: 18)
        mapView.camera = camera
        mapView.animate(to: camera)
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
}

