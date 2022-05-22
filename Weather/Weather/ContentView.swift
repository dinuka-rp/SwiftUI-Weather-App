//
//  ContentView.swift
//  Weather
//
//  Created by Dinuka Piyadigama on 2022-05-21.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            HomeView()
                .tabItem {
                    Label("Home", systemImage: "house")
                }
            SearchView()
                .tabItem {
                    Label("Current", systemImage: "magnifyingglass")
                }
            DailyForecastView()
                .tabItem {
                    Label("Forecast", systemImage: "goforward")
                }
            IntervalForecastView()
                .tabItem {
                    Label("Intervals", systemImage: "deskclock")
                }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
