//
//  ViewController.swift
//  Weather
//
//  Created by Zehra Öner on 5.08.2024.
//

import UIKit

class ViewController: UIViewController, UISearchBarDelegate, UITableViewDataSource, UITableViewDelegate {
    
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    var weatherData: [Weather] = [] // Hava durumu verilerini depolamak için
    let apiKey = "1e4bb4c552d25c014796a1635ddb91d9" // API anahtarınızı buraya ekleyin
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchBar.delegate = self
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        // Ekstra ayarlar
               searchBar.showsCancelButton = false
               searchBar.autocapitalizationType = .none
               searchBar.enablesReturnKeyAutomatically = true
    }
    
   
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
            guard let city = searchBar.text, !city.isEmpty else { return }
            fetchWeather(for: city)
            searchBar.resignFirstResponder()
        }

        func fetchWeather(for city: String) {
            let urlString = "https://api.openweathermap.org/data/2.5/weather?q=\(city)&appid=\(apiKey)&units=metric"
            guard let url = URL(string: urlString) else { return }

            let task = URLSession.shared.dataTask(with: url) { data, response, error in
                guard let data = data, error == nil else { return }

                do {
                    if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                       let weatherArray = json["weather"] as? [[String: Any]],
                       let weatherDescription = weatherArray.first?["description"] as? String,
                       let main = json["main"] as? [String: Any],
                       let temperature = main["temp"] as? Double,
                       let highTemperature = main["temp_max"] as? Double,
                       let lowTemperature = main["temp_min"] as? Double {
                        let weather = Weather(city: city, temperature: temperature, highTemperature: highTemperature, lowTemperature: lowTemperature, description: weatherDescription)
                        DispatchQueue.main.async {
                            self.weatherData.append(weather)
                            self.tableView.reloadData()
                        }
                    }
                } catch {
                    print("JSON error: \(error.localizedDescription)")
                }
            }
            task.resume()
        }

        func localizedDescription(for description: String) -> String {
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

        // UITableViewDataSource methods
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return weatherData.count
        }

        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "weatherCell", for: indexPath) as! WeatherTableViewCell
            let weather = weatherData[indexPath.row]
            cell.cityLabel.text = weather.city
            cell.temperatureLabel.text = "\(weather.temperature)°C"
            cell.descriptionLabel.text = localizedDescription(for: weather.description)

            return cell
        }

        // UITableViewDelegate method
        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            // Seçilen hava durumu bilgisini al
            let selectedWeather = weatherData[indexPath.row]

            // Detay view controller'ı storyboard'dan alın
            if let detailVC = storyboard?.instantiateViewController(withIdentifier: "WeatherDetailViewController") as? WeatherDetailViewController {
                // Detay view controller'a veri geçişi yap
                detailVC.weather = selectedWeather

                // Detay view controller'ı göster
                navigationController?.pushViewController(detailVC, animated: true)
            }
        }

        // Hücre silme işlemi için method
        func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
            if editingStyle == .delete {
                // Veriyi sil
                weatherData.remove(at: indexPath.row)
                // Tabloyu güncelle
                tableView.deleteRows(at: [indexPath], with: .automatic)
            }
        }
    }
