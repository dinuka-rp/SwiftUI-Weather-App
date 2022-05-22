//
//  SearchView.swift
//  Weather
//
//  Created by Dinuka Piyadigama on 2022-05-22.
//

import SwiftUI

struct SearchView: View {
    
    @State private var cityText = ""
    @State private var unitToggle = false
    
    @StateObject var manager = WeatherManager()
    
    var body: some View {
        NavigationView {
            VStack {
                if manager.weather?.detailedData == nil {
                    Spacer()
                }
                HStack {
                    TextField("Enter a city", text: $cityText)
                        .font(.system(size: 22, weight: .light, design: .rounded))
                        .textFieldStyle(.roundedBorder).multilineTextAlignment(.center)
                    Button {
                        Task {
                            print("fetch details")
                            await manager.fetchForCity(string: self.cityText, unit: unitToggle ? .imperial : .metric)
                        }
                    } label: {
                        Image(systemName: "magnifyingglass")
                            .padding()
                    }
                    //                .alert("Important message", isPresented: true) {
                    //                    Button("OK", role: .cancel) { }
                    //                }
                }
                if let data = manager.weather?.detailedData {
                    Toggle(isOn: $unitToggle) {
                        Text("Display Imperial Units")
                    }
                    List(data) { item in
                        HStack {
                            Image(systemName: item.icon)
                                .foregroundColor(item.color)
                            Text(item.title)
                                .font(.system(size: 16, weight: .regular, design: .rounded))
                            Spacer()
                            Text("\(item.value)")
                                .font(.system(size: 20, weight: .bold, design: .rounded)) + Text(item.unit)
                                .font(.system(size: 16, weight: .light, design: .rounded))
                        }
                    }
                    .listStyle(PlainListStyle())
                    
                    VStack (spacing: 28){
                        NavigationLink{
                            DailyForecastView()
                        } label: {
                            Text("View Daily Weather Forecast")
                        }
                        NavigationLink{
                            IntervalForecastView()
                        } label: {
                            Text("View Interval Weather Forecast")
                        }
                    }
                } else {
                    Spacer()
                    Spacer()
                }
            }
            .onChange(of: unitToggle, perform: { _ in
                Task {
                    print("unit toggled")
                    await manager.fetchForCity(string: self.cityText, unit: unitToggle ? .imperial : .metric)
                }
            })
            .padding()
            .navigationBarTitle("Current Weather")
        }
    }
}

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView()
    }
}
