//
//  WeatherMAnager.swift
//  Weather
//
//  Created by Dinuka Piyadigama on 2022-05-22.
//

import Foundation

enum WeatherUnit: String, Equatable {
    case metric = "metric"
    case imperial = "imperial"
}

class WeatherManager: ObservableObject {
    
    let currentWeatherBaseURL: String = "https://api.openweathermap.org/data/2.5/weather?appid=\(API.key)"
    let oneCallBaseURL: String = "https://api.openweathermap.org/data/2.5/onecall?exclude=hourly,minutely&appid=\(API.key)"
    
    // Lat and lon of Pitakotte
    //    private let lat = 6.884074
    //    private let lon = 79.902046
    
    @Published var weather: WeatherModel?
    private var unit: WeatherUnit = .metric
    
    func fetchForCurrentLocation(lat: Double?, lon: Double?) async {
        // get current location lat long from device and pass to this function
        let url = "\(currentWeatherBaseURL)&lat=\(lat ?? 6.884074)&lon=\(lon ?? 79.902046)&units=metric"
        print(url)
        
        await requestWeather(url: url)
    }
    
    func fetchForCity(string: String, unit: WeatherUnit) async {
        self.unit = unit
        let url = "\(currentWeatherBaseURL)&q=\(string)&units=\(unit.rawValue)"
        print(url)
        
        await requestWeather(url: url)
    }
    
    func requestWeather(url: String) async {
        guard let url = URL(string: url) else { return }
        do {
            let (data, _) = try await URLSession.shared.data(from: url) // Defining a session using a URL for requests
            let weather =  try JSONDecoder().decode(WeatherData.self, from: data) // Converting a JSON response into Swift Objects
            DispatchQueue.main.async {
                self.weather = WeatherModel(id: weather.weather.first?.id ?? 0,
                                            name: weather.name,
                                            temperature: weather.main.temp,
                                            description: weather.weather.first?.description ?? "",
                                            humidity: weather.main.humidity,
                                            pressure: weather.main.pressure,
                                            windSpeed: weather.wind.speed,
                                            direction: weather.wind.deg,
                                            cloudPercentage: weather.clouds.all,
                                            unit: self.unit)
            }
            print(weather)
        } catch {
            print(error.localizedDescription)
            self.weather = nil
        }
    }
}
