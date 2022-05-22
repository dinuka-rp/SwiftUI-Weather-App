//
//  OCWeatherManager.swift
//  Weather
//
//  Created by Dinuka Piyadigama on 2022-05-22.
//

import Foundation

class OCWeatherManager: ObservableObject {
    
    let oneCallBaseURL: String = "https://api.openweathermap.org/data/2.5/onecall?exclude=minutely&appid=\(API.key)"
     
    // Lat and lon of Pitakotte
//    private let lat = 6.884074
//    private let lon = 79.902046
    
    @Published var weather: OCWeatherModel?
    private var unit: WeatherUnit = .metric
    
    func getFiveDayForecast(unit: WeatherUnit, lat: Double?, lon: Double?) async {
        //        TODO:  get current location lat long from device here
        self.unit = unit
        let url = "\(oneCallBaseURL)&lat=\(lat ?? 6.884074)&lon=\(lon ?? 79.902046)&units=\(unit.rawValue)"
        await requestForecast(url: url)
    }
    
    func requestForecast(url: String) async {
        guard let url = URL(string: url) else { return }
        do {
            let (data, _) = try await URLSession.shared.data(from: url) // Defining a session using a URL for requests
            let weather =  try JSONDecoder().decode(OneCallWeather.self, from: data) // Converting a JSON response into Swift Objects
            DispatchQueue.main.async {
                let forecasts = weather.daily.map { daily in
                    OCWeatherDisplay(dt: daily.dt.unixToDate(date: .complete, time: .omitted)!,
                                     temp: self.unit == .metric ? "\(daily.temp.day)°C" : "\(daily.temp.day)°F",
                                     pressure: daily.pressure,
                                     humidity: daily.humidity,
                                     clouds: daily.clouds,
                                     wind_speed: self.unit == .metric ? "\(daily.wind_speed) m/s" : "\(daily.wind_speed) mi/h",
                                     weather: daily.weather.first!,
                                     icon: self.getIcon(id: daily.weather.first!.id))
                }
                
                let first = weather.hourly.first!
                let current = OCWeatherDisplayHourly(dt: first.dt.unixToDate(date: .complete, time: .shortened)!,
                                                     temp: self.unit == .metric ? "\(first.temp)°C" : "\(first.temp)°F",
                                                     weather: first.weather.first!,
                                                     icon: self.getIcon(id: first.weather.first!.id),
                                                     hour: first.dt.unixToDate()!.get(.hour))
                var hourly = weather.hourly.map { hourly in
                    OCWeatherDisplayHourly(dt: hourly.dt.unixToDate(date: .long, time: .shortened)!,
                                           temp: self.unit == .metric ? "\(hourly.temp)°C" : "\(hourly.temp)°F",
                                           weather: hourly.weather.first!,
                                           icon: self.getIcon(id: hourly.weather.first!.id),
                                           hour: hourly.dt.unixToDate()!.get(.hour))
                }
                
                hourly = hourly.filter({ item in
                    return item.hour % 3 == 0
                })
                
                self.weather = OCWeatherModel(forecast: forecasts,
                                              hourlyForecasts: hourly,
                                              current: current)
            }
            print("OCWeather: ",weather)
        } catch {
            print("OCError: ",error.localizedDescription)
        }
    }
    
    func getIcon(id: Int) -> String {
        switch id {
        case 200...232:
            return "cloud.bolt"
        case 300...321:
            return "cloud.drizzle"
        case 500...531:
            return "cloud.rain"
        case 600...622:
            return "cloud.snow"
        case 701...781:
            return "cloud.fog"
        case 800:
            return "sun.max"
        case 801...804:
            return "cloud.bolt"
        default:
            return "cloud"
        }
    }
}
