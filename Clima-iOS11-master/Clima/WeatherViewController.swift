//
//  ViewController.swift
//  WeatherApp
//
//  Created by Angela Yu on 23/08/2015.
//  Copyright (c) 2015 London App Brewery. All rights reserved.
//

import UIKit
import CoreLocation
import Alamofire
import SwiftyJSON

class WeatherViewController: UIViewController, CLLocationManagerDelegate, ChangeCityDelegate {
    
    //Constants
    let WEATHER_URL = "http://api.openweathermap.org/data/2.5/weather"
    let APP_ID = "ddb556f53b4e52fd41ea820874b77a2f"
    

    //TODO: Declare instance variables here
    
    var locationManager = CLLocationManager()
    var weatherDataModel = WeatherDataModel()

    
    //Pre-linked IBOutlets
    @IBOutlet weak var weatherIcon: UIImageView!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        //TODO:Set up the location manager here.
    
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
        
    }
    
    
    
    //MARK: - Networking
    /***************************************************************/
    
    //Write the getWeatherData method here:
    
    func getWeatherData (url: String, parameters: [String:String]) {
        Alamofire.request(url, method: .get, parameters: parameters).responseJSON {
            response in
            if response.result.isSuccess {
                print("Sucsses. Got the data")
                let weatherJSON: JSON = JSON(response.result.value!)
                print(weatherJSON)

                self.updateWeatherData(imput: weatherJSON)
                
            } else {
                print("error \(String(describing: response.result.error))")
                self.cityLabel.text = "Connection failure"
            }
        }
    }

    
    
    
    
    
    //MARK: - JSON Parsing
    /***************************************************************/
   
    func updateWeatherData (imput: JSON) {
        if let tempResults = imput["main"]["temp"].double {
        weatherDataModel.temperatureInCelcius = Int(tempResults - 273.15)
        weatherDataModel.temperatureInFarengeit = Int(Double(weatherDataModel.temperatureInCelcius) * 1.8 + 32.0)
        weatherDataModel.city = imput["name"].stringValue
        weatherDataModel.condition = imput["weather"][0]["id"].intValue
        weatherDataModel.wheatherIconName = weatherDataModel.updateWeatherIcon(condition: weatherDataModel.condition)
        updateUIWithWeatherData()
        
        } else {
            cityLabel.text = "Weather unavailiable"
        }
        }

    
    
    
    //MARK: - UI Updates
    /***************************************************************/
    func updateUIWithWeatherData() {
        cityLabel.text = weatherDataModel.city
        temperatureLabel.text = "\(weatherDataModel.temperatureInCelcius)°"
        weatherIcon.image = UIImage(named: weatherDataModel.wheatherIconName)
    }
    
    
    
    
    
    //MARK: - Location Manager Delegate Methods
    /***************************************************************/
    
    
    //Write the didUpdateLocations method here:
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations[locations.count-1]
        if location.horizontalAccuracy > 0 {
            locationManager.stopUpdatingLocation()
            locationManager.delegate = nil
            
            let latitude = location.coordinate.latitude
            let longitude = location.coordinate.longitude
            
            let params: [String:String] = ["lat": String(latitude), "lon": String(longitude), "appid": APP_ID]
            
            getWeatherData(url: WEATHER_URL, parameters: params)
        }
    }
    
    
    //Write the didFailWithError method here:
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
        cityLabel.text = "Location unavaliable"
    }
    
    

    
    //MARK: - Change City Delegate methods
    /***************************************************************/
    
    
    //Write the userEnteredANewCityName Delegate method here:
    func userEnteredANewCityName(city: String) {
        let params = ["q": city, "appid": APP_ID]
        
        getWeatherData(url: WEATHER_URL, parameters: params)
        
    }

    
    //Write the PrepareForSegue Method here
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "changeCityName" {
            let destanationVC = segue.destination as! ChangeCityViewController
            
            destanationVC.delegate = self
            
            
        }
    }
    
    
    @IBAction func switchToFarengeit(_ sender: UISwitch) {
        if sender.isOn {
            updateUIWithWeatherData()
        }
        if !sender.isOn {
            temperatureLabel.text = "\(weatherDataModel.temperatureInFarengeit)°"
        }
    }
    
    
}


