//
//  Location.swift
//  SuperGina
//
//  Created by ai966669 on 15/10/19.
//  Copyright © 2015年 anve. All rights reserved.
//

import UIKit


class Location: NSObject {
    var locationServe:BMKLocationService!
    var doLater:((lat:String,lng:String) -> Void)?
    static var timeSendBefore=0
    static var distanceToSend=300
    func sendLocation(aDoLater:((lat:String,lng:String) -> Void)){
        let timeSendNow=Int(NSDate().timeIntervalSince1970)
        if (timeSendNow-Location.timeSendBefore)>Location.distanceToSend{
            if (locationServe == nil){
                locationServe=BMKLocationService()
                locationServe.delegate = self
            }
            Location.timeSendBefore=timeSendNow
            doLater=aDoLater
            locationServe.startUserLocationService()
        }
    }
}
extension Location:BMKLocationServiceDelegate{
    func didUpdateBMKUserLocation(userLocation: BMKUserLocation!) {
        if (doLater != nil){
            doLater!(lat: "\(userLocation.location.coordinate.latitude)",lng: "\(userLocation.location.coordinate.longitude)")
        }
        locationServe.stopUserLocationService()
    }
}
