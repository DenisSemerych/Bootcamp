//
//  Self Driving car.swift
//  Classes and Objects
//
//  Created by Denis Semerych on 21.04.2018.
//  Copyright © 2018 Denis Semerych. All rights reserved.
//

import Foundation

class SelfDrivingCar: Car {
    
    var destination: String?
    
    override func drive() {
        super.drive()
        
        print("driving towards" + (destination ?? ""))
    }
}

