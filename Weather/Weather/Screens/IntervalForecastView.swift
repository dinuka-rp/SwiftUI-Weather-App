//
//  IntervalForecastView.swift
//  Weather
//
//  Created by Dinuka Piyadigama on 2022-05-22.
//

import SwiftUI

struct IntervalForecastView: View {
    
    @State private var unit: WeatherUnit = .metric
    @StateObject private var manager = OCWeatherManager()
    
    @ObservedObject var locationManager =  LocationManager()

    var body: some View {
        VStack {
            if let data = manager.weather {
                if let current = data.current {
                    Text("\(current.dt)")
                    HStack {
                        Image(systemName: current.icon)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 80, height: 80)
                        Text(current.temp)
                            .font(.system(size: 45, weight: .light, design: .rounded))
                    }
                    Text(current.weather.description)
                }
                List (data.hourlyForecasts) { item in
                    //                    let item = data[index]
                    HStack(spacing: 20) {
                        Image(systemName: item.icon)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 50, height: 50)
                            .foregroundColor(.cyan)
                        VStack (alignment: .leading) {
                            Text(item.weather.description)
                            Text(item.dt).font(.system(size: 14, weight:.light))
                        }
                        Spacer()
                        Text("\(item.temp)")
                    }
                }
                .listStyle(InsetListStyle())
            } else {
                Spacer()
            }
        }
        .onReceive(locationManager.$location) { loc in
            Task {
                await manager.getFiveDayForecast(unit: self.unit, lat: loc?.latitude, lon: loc?.longitude)
            }
            
        }
//        .onAppear {
//            Task {
//                await manager.getFiveDayForecast(unit: self.unit)
//            }
//        }
    }
}

struct IntervalForecastView_Previews: PreviewProvider {
    static var previews: some View {
        IntervalForecastView()
    }
}
