//
//  Car.swift
//  Classes and Objects
//
//  Created by Denis Semerych on 21.04.2018.
//  Copyright © 2018 Denis Semerych. All rights reserved.
//

import Foundation

enum CarType {
    case Sedan
    case Coupe
    case Hatchback
}

class Car {
    var color = "Black"
    var numberOfSeats = 5
    var typeOfCar: CarType = .Coupe
    
    init () {
    }
    convenience init (color: String) {
        self.init()
        self.color = color
    }
    
    func drive () {
        print("Car is moving")
    }
}
