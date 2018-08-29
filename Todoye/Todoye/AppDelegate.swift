//
//  AppDelegate.swift
//  Todoye
//
//  Created by Denis Semerych on 25.05.2018.
//  Copyright © 2018 Denis Semerych. All rights reserved.
//

import UIKit
import RealmSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
    
        

        do {
            _ = try Realm()
        } catch {
            print("Error instaling Realm  \(error)")
        }
        
        return true
    }


}

