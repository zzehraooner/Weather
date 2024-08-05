//
//  WeatherDetailViewController.swift
//  Weather
//
//  Created by Zehra Öner on 5.08.2024.
//

import UIKit

class WeatherDetailViewController: UIViewController {
    
    
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var highTemperatureLabel: UILabel!
    @IBOutlet weak var lowTemperatureLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var weatherImageView: UIImageView!

    var weather: Weather?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let weather = weather {
            cityLabel.text = weather.city
            temperatureLabel.text = "\(weather.temperature)°C"
            highTemperatureLabel.text = "En Yüksek: \(weather.highTemperature)°C"
            lowTemperatureLabel.text = "En Düşük: \(weather.lowTemperature)°C"
            descriptionLabel.text = localizedDescription(for: weather.description)
            weatherImageView.image = image(for: weather.description)
        }
    }

    private func localizedDescription(for description: String) -> String {
        switch description.lowercased() {
        case let x where x.contains("clear"):
            return "Açık"
        case let x where x.contains("cloud"):
            return "Bulutlu"
        case let x where x.contains("rain"):
            return "Yağmurlu"
        case let x where x.contains("snow"):
            return "Karla Karışık"
        case let x where x.contains("storm"):
            return "Fırtına"
        default:
            return "Bilinmeyen"
        }
    }

    private func image(for description: String) -> UIImage? {
        switch description.lowercased() {
        case let x where x.contains("clear"):
            return UIImage(named: "clearSky")
        case let x where x.contains("cloud"):
            return UIImage(named: "cloudy")
        case let x where x.contains("rain"):
            return UIImage(named: "rainy")
        case let x where x.contains("snow"):
            return UIImage(named: "snowy")
        case let x where x.contains("storm"):
            return UIImage(named: "stormy")
        default:
            return UIImage(named: "defaultWeather")
        }
    }
}
