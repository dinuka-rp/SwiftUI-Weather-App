//
//  ForecastView.swift
//  Weather
//
//  Created by Dinuka Piyadigama on 2022-05-22.
//

import SwiftUI
import CoreLocation

struct DailyForecastView: View {
    
    @State private var unit: WeatherUnit = .metric
    @StateObject private var manager = OCWeatherManager()
    
    @ObservedObject var locationManager =  LocationManager()
    @State private var loc:CLLocationCoordinate2D?
    
    var body: some View {
        NavigationView {
            VStack {
                Picker("", selection: $unit) {
                    Text("°C")
                        .tag(WeatherUnit.metric)
                    Text("°F")
                        .tag(WeatherUnit.imperial)
                }
                .pickerStyle(.segmented)
                .padding()
                if let data = manager.weather?.forecast {
                    List (0..<6) { index in
                        let item = data[index]
                        Section("\(item.dt)") {
                            HStack(spacing: 25) {
                                Image(systemName: item.icon)
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 50, height: 50)
                                    .foregroundColor(.cyan)
                                //                                        TODO: Make a network call and display an appropriate image
                                HStack {
                                    VStack(alignment: .leading){
                                        Text(item.weather.description)
                                        Text("\(item.temp)")
                                            .font(.system(size: 18, weight: .light, design: .rounded))
                                    }
                                    Spacer()
                                    VStack(alignment: .trailing){
                                        HStack{
                                            Image(systemName: "cloud")
                                                .foregroundColor(.gray)
                                            Text("\(item.clouds)%")
                                                .font(.system(size: 14, weight: .light, design: .rounded))
                                            Image(systemName: "drop")
                                                .foregroundColor(.blue)
                                            Text("\(item.wind_speed)")
                                                .font(.system(size: 14, weight: .light, design: .rounded))
                                        }
                                        Text("Humidity: \(item.humidity)%")
                                            .font(.system(size: 14, weight: .light, design: .rounded))
                                    }
                                }
                            }
                        }
                    }
                    .listStyle(PlainListStyle())
                    .onChange(of: unit) { _ in
                        Task {
                            await manager.getFiveDayForecast(unit: self.unit, lat: self.loc?.latitude, lon: self.loc?.longitude)
                        }
                    }
                } else{
                    Spacer()
                }
            }
            .navigationTitle("Daily Weather Forecast")
            .onReceive(locationManager.$location) { loc in
                self.loc = loc
                Task {
                    await manager.getFiveDayForecast(unit: self.unit, lat: loc?.latitude, lon: loc?.longitude)
                }
                
            }
            //            .onAppear {
            //                Task {
            //                    await manager.getFiveDayForecast(unit: self.unit)
            //                }
            //            }
        }
    }
}

struct DailyForecastView_Previews: PreviewProvider {
    static var previews: some View {
        DailyForecastView()
    }
}
