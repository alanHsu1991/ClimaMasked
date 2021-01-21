//
//  ViewController.swift
//  Clima
//
//  Created by Alan Hsu on 2020/11/30.
//

import UIKit
import CoreLocation

class WeatherViewController: UIViewController {    // 1. Add UITextFieldDelegate as first step to access the "Go" button on the soft keyboard
    
    @IBOutlet weak var conditionImageView: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var searchTextField: UITextField!
    
    var weatherManager = WeatherManager()
    let locationManager = CLLocationManager()    // Manager the location
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.delegate = self    // Without this nothing's gonna happen even if we adopt the protocols and delegate methods
        locationManager.requestWhenInUseAuthorization()    // Request permission from the user for the location data
        locationManager.requestLocation()    // If we want continuous location update we will use "startUpdatingLocation()"
        
        weatherManager.delegate = self
        searchTextField.delegate = self    // 2. searchTextField will tell the viewController what's the user doing
        
    }
    
    @IBAction func locationPressed(_ sender: UIButton) {
        
        locationManager.requestLocation()
        
    }
    
    
}

//MARK: - UITextFieldDelegate

extension WeatherViewController: UITextFieldDelegate {
    
    @IBAction func searchPressed(_ sender: UIButton) {
        searchTextField.endEditing(true)    // To dismiss the keyboard
        print(searchTextField.text!)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchTextField.endEditing(true)
        print(searchTextField.text!)
        return true
    }    // 3. Add textFieldShouldReturn to tell the viewController what to do when the return key is pressed
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if textField.text != "" {
            return true
        } else {
            textField.text = "Type in a city name"
            return false
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        if let city = searchTextField.text {
            weatherManager.fetchWeather(cityName: city)
        }
        // Use the searchTextField.text before it ends
        searchTextField.text = ""    // To clear the text field after finish editing
    }
    
}

//MARK: - WeatherManagerDelegate

// Shown data on the interface of the App
extension WeatherViewController: WeatherManagerDelegate {
    
    func didUpdateWeather(_ weatherManager: WeatherManager, weather: WeatherModel){
        DispatchQueue.main.async{
            self.temperatureLabel.text = weather.temperatureString
            self.conditionImageView.image = UIImage(systemName: weather.conditionName)
            self.cityLabel.text = weather.cityName
        }
    }
    
    func didFailWithError(error: Error) {
        print(error)
    }
    
}

//MARK: - CLLocationManagerDelegate

extension WeatherViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            locationManager.stopUpdatingLocation()
            let lat = location.coordinate.latitude
            let lon = location.coordinate.longitude
            weatherManager.fetchWeather(latitude: lat, longitude: lon)
        }
    }
    
    // In addition to having didUpdateLocationDelegate method implemented, we also need to have "didFailWithErrorMethod" implemented
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
    
}

