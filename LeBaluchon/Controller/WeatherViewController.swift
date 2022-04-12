//
//  WeatherViewController.swift
//  Le Baluchon
//
//  Created by Yves Charpentier on 09/03/2022.
//

import UIKit

class WeatherViewController: UIViewController {
    @IBOutlet weak var myCityLabel: UILabel!
    @IBOutlet weak var remoteCityLabel: UILabel!
    @IBOutlet weak var weatherConditionTextField: UITextField!
    @IBOutlet weak var temperatureTextField: UITextField!
    @IBOutlet weak var givenWeatherButton: UIButton!
    
    @IBOutlet weak var topFrameView: UIView!
    @IBOutlet weak var bottomFrameView: UIView!
    
    @IBOutlet weak var remoteWeatherConditionsLabel: UITextField!
    @IBOutlet weak var remoteTemperatureLabel: UITextField!
    
    @IBOutlet weak var searchCityTextField: UITextField!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var dateOfTheDay: UITextField!
    
    let myCity = "Montpellier"
    var remoteCity = "New York"
    
    var numberFormatter = NumberFormatter()
    
    override func viewWillAppear(_ animated: Bool) {
        AppDelegate.AppUtility.lockOrientation(UIInterfaceOrientationMask.portrait, andRotateTo: UIInterfaceOrientation.portrait)
        refresh(cityName: myCity)
        tappedDoneWeather()
        searchCityTextField.text = ""
        showDateOfTheDay()
        toggleActivityIndicator(shown: false)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView(view: topFrameView)
        setupView(view: bottomFrameView)
        temperatureTextField.borderStyle = .roundedRect
        remoteTemperatureLabel.borderStyle = .roundedRect
        
    }
    
    @IBAction func dismissKeyboard(_ sender: UITapGestureRecognizer) {
        searchCityTextField.resignFirstResponder()
    }
    
    @IBAction func tappedDoneWeather() {
        guard searchCityTextField.text?.isEmpty == true else {
            remoteCity = searchCityTextField.text!
            refresh(cityName: remoteCity)
            searchCityTextField.resignFirstResponder()
            return
        }
        refresh(cityName: remoteCity)
    }
    
    private func refresh(cityName: String) {
        toggleActivityIndicator(shown: true)
        WeatherService.shared.getValue(city: cityName) { success, data in
            self.toggleActivityIndicator(shown: false)
            guard success, let values = data else {
                self.presentAlert()
                return
            }
            self.showCity(weather: values)
        }
    }
    
    private func showCity(weather: Weather) {
        let cityLabel = weather.name == myCity ? myCityLabel! : remoteCityLabel!
        let temperatureLabel = weather.name == myCity ? temperatureTextField! : remoteTemperatureLabel!
        let weatherConditionLabel = weather.name == myCity ? weatherConditionTextField! : remoteWeatherConditionsLabel!
        cityLabel.text = "\(weather.name!)," + " \(weather.sys.country)"
        let formatTemperature = NSNumber(value: Float(weather.main.temp))
        let resultFormat = numberFormatter.string(from: formatTemperature) ?? ""
        temperatureLabel.text = "\(resultFormat)°"
        guard let situation = weather.weather.first?.description else {
            presentAlert()
            return
        }
        weatherConditionLabel.text = situation
    }
    
    private func toggleActivityIndicator(shown: Bool) {
        givenWeatherButton.isHidden = shown
        activityIndicator.isHidden = !shown
    }
    
    private func presentAlert() {
        let alertVC = UIAlertController(title: "Erreur", message: "Le téléchargement des données a échoué.", preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        present(alertVC, animated: true, completion: nil)
    }
}

extension WeatherViewController {
    private func setupView(view: UIView) {
        view.layer.cornerRadius = 10
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOffset = CGSize(width: 0, height: 15)
        view.layer.shadowOpacity = 0.2
        view.layer.shadowRadius = 10
    }
    
    private func decimalNumber() {
        numberFormatter.minimumFractionDigits = 0
        numberFormatter.maximumFractionDigits = 0
        numberFormatter.usesSignificantDigits = true
        numberFormatter.alwaysShowsDecimalSeparator = false
        numberFormatter.allowsFloats = true
        numberFormatter.numberStyle = .decimal
        numberFormatter.usesGroupingSeparator = false
    }
    
    private func showDateOfTheDay() {
        let now = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .full
        dateFormatter.timeStyle = .none
        dateFormatter.locale = Locale(identifier: "FR-fr")
        dateOfTheDay.text = "\(dateFormatter.string(from: now))"
    }
}
