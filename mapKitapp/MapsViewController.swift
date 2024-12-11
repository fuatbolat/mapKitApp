//
//  ViewController.swift
//  mapKitapp
//
//  Created by Fuat Bolat on 3.12.2024.
//

import UIKit
import MapKit
import CoreLocation
import CoreData

class MapsViewController: UIViewController ,MKMapViewDelegate ,CLLocationManagerDelegate{

    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var notesTextField: UITextField!
    
    var selectedLatitude = Double()
    var selectedLongitude = Double()
    var locationManager = CLLocationManager()
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        mapView.delegate = self
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
        
        let gestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(selectLocation(gestureRecognizer:)))
        gestureRecognizer.minimumPressDuration = 3
        mapView.addGestureRecognizer(gestureRecognizer)
    }
    
    @objc func selectLocation(gestureRecognizer : UILongPressGestureRecognizer){
        if gestureRecognizer.state == .began {
            let touchingPoint = gestureRecognizer.location(in: mapView)
            let touchingCoordinate = mapView.convert(touchingPoint, toCoordinateFrom: mapView)
            
            selectedLatitude = touchingCoordinate.latitude
            selectedLongitude = touchingCoordinate.longitude
            
            let annotation = MKPointAnnotation()
            annotation.coordinate = touchingCoordinate
            annotation.title = nameTextField.text
            annotation.subtitle = notesTextField.text
            mapView.addAnnotation(annotation)
            
        }
        
    }
    
   
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        //print(locations[0].coordinate.latitude)
        //print(locations[0].coordinate.longitude)
        let location = CLLocationCoordinate2D(latitude: locations[0].coordinate.latitude, longitude: locations[0].coordinate.longitude)
        let span = MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
        
        let region = MKCoordinateRegion(center: location, span: span)
        mapView.setRegion(region, animated: true)
        
    }
    
    @IBAction func savePressed(_ sender: Any) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let area = NSEntityDescription.insertNewObject(forEntityName: "Area", into: context)
        
        area.setValue(UUID(), forKey: "id")
        area.setValue(nameTextField.text, forKey: "name")
        area.setValue(notesTextField.text, forKey: "comment")
        area.setValue(selectedLatitude, forKey: "latitude")
        area.setValue(selectedLongitude, forKey: "longitude")
        
        do {
            try context.save()
            print("saved")
            
        }catch{
            print("error")
        }
        
        NotificationCenter.default.post(name: NSNotification.Name("alertforrealoaddata"), object: nil)
        
        
    }
    

    


}

