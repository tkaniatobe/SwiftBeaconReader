//
//  ViewController.swift
//  SwiftBeaconReader
//
//  Created by Tali on 8/29/19.
//  Copyright © 2019 Tali. All rights reserved.
//

import UIKit
import CoreLocation

class ViewController: UIViewController, CLLocationManagerDelegate {

    var locationManager: CLLocationManager!
    
    @IBOutlet weak var AccuracyLabel: UILabel!
    @IBOutlet weak var DistanceLabel: UILabel!
    @IBOutlet weak var UuidLabel: UILabel!
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()
        
        AccuracyLabel.textColor = UIColor.white
        DistanceLabel.textColor = UIColor.white
        UuidLabel.textColor = UIColor.white
    }

    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedAlways {
            if CLLocationManager.isMonitoringAvailable(for: CLBeaconRegion.self) {
                if CLLocationManager.isRangingAvailable() {
                    startScanning()
                }
            }
        }
    }
    
    func startScanning() {
        let uuid = UUID(uuidString: "dc241f60-0a21-4324-b5e8-d7c0c6c03f90")!
        let beaconRegion = CLBeaconRegion(proximityUUID: uuid, major: 123, minor: 123, identifier: "MyBeacon")
        
        locationManager.startMonitoring(for: beaconRegion)
        locationManager.startRangingBeacons(in: beaconRegion)
    }

    func locationManager(_ manager: CLLocationManager, didRangeBeacons beacons: [CLBeacon], in region: CLBeaconRegion) {
        
        AccuracyLabel.text = String(beacons[0].accuracy)
        UuidLabel.text = beacons[0].proximityUUID.uuidString
        
        //Update bg colors
        if beacons.count > 0 {
            updateDistance(beacons[0].proximity)
        } else {
            updateDistance(.unknown)
        }
    }
    
    func updateDistance(_ distance: CLProximity) {
        UIView.animate(withDuration: 0.8) {
            switch distance {
            case .unknown:
                self.view.backgroundColor = UIColor.gray
                self.DistanceLabel.text = "UNKOWN"
            case .far:
                self.view.backgroundColor = UIColor.blue
                self.DistanceLabel.text = "FAR"
            case .near:
                self.view.backgroundColor = UIColor.orange
                self.DistanceLabel.text = "NEAR"
            case .immediate:
                self.view.backgroundColor = UIColor.red
                self.DistanceLabel.text = "IMMEDIATE"
            }
        }
    }
}

