//
//  ViewController.swift
//  yandexMapApp
//
//  Created by Илья Тимченко on 16.12.2022.
//

import UIKit
import YandexMapsMobile
import CoreLocation

class ViewController: UIViewController, YMKUserLocationObjectListener {
    var presenter: Presenter?
    var locationString: [String] = []
    @IBOutlet var mapView: YMKMapView!
    @IBOutlet var clearButtonView: UIButton!
    @IBOutlet var routeButtonView: UIButton!
    @IBOutlet var routeCells: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter = Presenter(delegate: self)
        let mapKit = YMKMapKit.sharedInstance()
        let userLocationLayer = mapKit.createUserLocationLayer(with: mapView.mapWindow)
        userLocationLayer.setVisibleWithOn(true)
        userLocationLayer.isHeadingEnabled = true
        userLocationLayer.setObjectListenerWith(self)
        routeCells.backgroundColor = UIColor.clear
    }
    
    @IBAction func addButtonTapped(_ sender: Any) {
        presenter?.addAdress()
    }
    
    @IBAction func myLocationTapped(_ sender: UIButton) {
        let geo = CLLocationManager()
        mapView.mapWindow.map.move(with:
                                    YMKCameraPosition(target: YMKPoint(latitude: geo.location?.coordinate.latitude ?? 0, longitude: geo.location?.coordinate.longitude ?? 0), zoom: 14, azimuth: 0, tilt: 0))
    }
    
    @IBAction func clearButtonTapped(_ sender: UIButton) {
        presenter?.clearAll()
    }
    
    @IBAction func routeButtonTapped(_ sender: Any) {
        presenter?.showOnMap()
    }
    
    func onObjectAdded(with view: YMKUserLocationView) {
        _ = view.pin.useCompositeIcon()
        view.accuracyCircle.fillColor = UIColor(named: "Color") ?? .blue
    }
    
    func onObjectRemoved(with view: YMKUserLocationView) {}
    
    func onObjectUpdated(with view: YMKUserLocationView, event: YMKObjectEvent) {}
}

extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

    }
}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch routeCells {
           case self.routeCells:
              return self.locationString.count
            default:
              return 0
           }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "routeListCell", for: indexPath)
        guard let routeListCell = cell as? routeListCell else {
            return UITableViewCell()
        }
        configCell(for: routeListCell)
        cell.textLabel?.text = self.locationString[indexPath.row]
        return routeListCell
    }
    
    func configCell(for cell: routeListCell) {
        
    }
}
