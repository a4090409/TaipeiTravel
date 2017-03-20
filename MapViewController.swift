//
//  MapViewController.swift
//  TaipeiTravel
//
//  Created by ChinBuck on 2017/2/13.
//  Copyright © 2017年 ChinBuck. All rights reserved.
//

import UIKit
import MapKit
import SDWebImage

class MapViewController: UIViewController, MKMapViewDelegate,CLLocationManagerDelegate {
    
    @IBOutlet var mapView: MKMapView!
    
    var  travelInfo:TravalInfo!
    var  cLLocationManager:CLLocationManager!//控管授權
    var  dest:CLLocationCoordinate2D!
    var  drawing:Bool = false
    var  overlay:MKPolyline!//圖層
    
    //var restaurant:Restaurant!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        cLLocationManager = CLLocationManager()
        cLLocationManager.delegate = self
        cLLocationManager.desiredAccuracy =  kCLLocationAccuracyBest
        //修改info.plist
        cLLocationManager.requestAlwaysAuthorization()
        cLLocationManager.startUpdatingLocation()
        mapView.delegate = self
        mapView.showsCompass = true
        mapView.showsScale = true
        mapView.showsTraffic = true
        mapView.showsUserLocation = true
        
        
        // Convert address to coordinate and annotate it on map
        let geoCoder = CLGeocoder()
        geoCoder.geocodeAddressString(travelInfo.address, completionHandler: { placemarks, error in
            if error != nil {
                print(error!)
                return
            }
            
            if let placemarks = placemarks {
                // Get the first placemark
                let placemark = placemarks[0]
                // Add annotation
                let annotation = MKPointAnnotation()
                annotation.title = self.travelInfo.stitle
                annotation.subtitle = self.travelInfo.cate
                if let location = placemark.location {
                    
                    self.dest = placemark.location?.coordinate
                    self.drow()
                    // Display the annotation
                    annotation.coordinate = location.coordinate
                    self.mapView.showAnnotations([annotation], animated: true)
                    //self.mapView.selectAnnotation(annotation, animated: true)
                }
            }
            
        })
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func drow()
    {
        if drawing
        {
            return
        }
        guard (self.dest) != nil else
        {
            return
        }
        //取得路線
        let req = MKDirectionsRequest()
        req.transportType = .automobile
        req.source = MKMapItem(placemark: MKPlacemark(coordinate: mapView.userLocation.coordinate, addressDictionary: nil))
        req.destination = MKMapItem(placemark: MKPlacemark(coordinate: self.dest, addressDictionary: nil))
        req.requestsAlternateRoutes = false
        let deriction = MKDirections(request: req)
        drawing = true
        //計算完將線圖蓋上
        deriction.calculate { (res, error) in
            if let rout = res?.routes.first
            {
                if let ol = self.overlay
                {
                    self.mapView.remove(ol)
                }
                self.overlay = rout.polyline
                self.mapView.add(self.overlay)
                //看見整條
                self.mapView.setVisibleMapRect(rout.polyline.boundingMapRect, animated: true)
            }
            self.drawing = false
        }
    }
    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
        print(userLocation.coordinate)
        //更新位置地圖中心
        // mapView.setCenter(userLocation.coordinate, animated: true)
        //設定可視範圍  單位公尺
        //        let viewRegion = MKCoordinateRegionMakeWithDistance(userLocation.coordinate, 500, 500)
        //        mapView.setRegion(viewRegion, animated: true)
        drow()        
    }
    //有新圖層會進入這
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let render = MKPolylineRenderer(polyline: self.overlay)
        render.strokeColor = #colorLiteral(red: 0.3647058904, green: 0.06666667014, blue: 0.9686274529, alpha: 1)
        render.lineWidth = 5.0
        return render
    }
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let identifier = "MyPin"
        
        if annotation.isKind(of: MKUserLocation.self) {
            return nil
        }
        
        // Reuse the annotation if possible
        var annotationView:MKPinAnnotationView? = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKPinAnnotationView
        
        if annotationView == nil {
            annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            annotationView?.canShowCallout = true
        }
        
        let leftIconView = UIImageView(frame: CGRect.init(x: 0, y: 0, width: 53, height: 53))
        
        leftIconView.sd_setImage(with: URL(string: "https://" + travelInfo.imgfile[1])!)
        
        annotationView?.leftCalloutAccessoryView = leftIconView
        annotationView?.pinTintColor = UIColor.orange
        
        return annotationView
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
