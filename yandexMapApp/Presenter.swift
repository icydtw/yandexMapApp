//
//  Presenter.swift
//  yandexMapApp
//
//  Created by Илья Тимченко on 16.12.2022.
//

import Foundation
import UIKit
import YandexMapsMobile
import MapKit

class Presenter {
    var delegate: ViewController
    var drivingSession: YMKDrivingSession?
    var coordinates: [YMKRequestPoint] = []
    
    init(delegate: ViewController) {
        self.delegate = delegate
    }
    
    func myLocationFinder() {
        
    }
    
    //Ф-ция, вызываемая контроллером после нажатия кнопки "+"
    func addAdress() {
        delegate.showNotification { [self] text in
            addCoordinates(adress: text)
        }
    }
    
    //Проверка кол-ва адресов для открытия доступа к кнопкам
    func checkLocationStringArray() {
        if coordinates.count == 1{
            delegate.clearButtonView.isEnabled = true
        }
        if coordinates.count == 2 {
            delegate.routeButtonView.isEnabled = true
        }
    }
    
    //Ф-ция, вызываемая нотификатором в хэндлере (передаётся полученный адрес)
    func addCoordinates(adress: String) {
        let geoCoder = CLGeocoder()
        geoCoder.geocodeAddressString(adress) { placemark, error in
            
            if error != nil {
                print("ERROR")
                return
            }
            
            guard let placemark = placemark else {
                print("ERROR")
                return
            }
            
            let latitude = placemark.first?.location?.coordinate.latitude
            let longitude = placemark.first?.location?.coordinate.longitude
            let coordinate = YMKPoint(latitude: latitude ?? 0, longitude: longitude ?? 0)
            self.coordinates.append(YMKRequestPoint(point: coordinate, type: .waypoint, pointContext: nil))
            self.checkLocationStringArray()
            self.delegate.locationString.append(placemark.first?.name ?? "")
            self.delegate.routeCells.reloadData()
        }
    }
    
    func searchRight(adress: String) {
        
    }
    
    //Ф-ция, вызываемая контроллером при нажатии на кнопку "В путь!"
    func showOnMap() {
        let responseHandler = {(routesResponse: [YMKDrivingRoute]?, error: Error?) -> Void in
            if let routes = routesResponse {
                self.onRoutesReceived(routes)
            } else {
                self.onRoutesError(error!)
            }
        }
        
        let drivingRouter = YMKDirections.sharedInstance().createDrivingRouter()
        drivingSession = drivingRouter.requestRoutes(
            with: coordinates,
            drivingOptions: YMKDrivingDrivingOptions(),
            vehicleOptions: YMKDrivingVehicleOptions(),
            routeHandler: responseHandler)
    }
    
    //Рисуем дорогу
    func onRoutesReceived(_ routes: [YMKDrivingRoute]) {
        let mapObjects = delegate.mapView.mapWindow.map.mapObjects
        mapObjects.addPolyline(with: routes.first?.geometry ?? YMKPolyline())
    }
    
    func onRoutesError(_ error: Error) {
        let routingError = (error as NSError).userInfo[YRTUnderlyingErrorKey] as! YRTError
        var errorMessage = "Unknown error"
        if routingError.isKind(of: YRTNetworkError.self) {
            errorMessage = "Network error"
        } else if routingError.isKind(of: YRTRemoteError.self) {
            errorMessage = "Remote server error"
        }
        
        let alert = UIAlertController(title: "Error", message: errorMessage, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        
        delegate.present(alert, animated: true, completion: nil)
    }
    
    func clearAll() {
        delegate.mapView.mapWindow.map.mapObjects.clear()
        coordinates.removeAll()
        delegate.clearButtonView.isEnabled = false
        delegate.routeButtonView.isEnabled = false
        delegate.locationString.removeAll()
        delegate.routeCells.reloadData()
    }
}


