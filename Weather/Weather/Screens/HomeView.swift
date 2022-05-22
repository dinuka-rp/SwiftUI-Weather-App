//
//  HomeView.swift
//  Weather
//
//  Created by Dinuka Piyadigama on 2022-05-22.
//

import SwiftUI

struct HomeView: View {
    
    @StateObject var manager = WeatherManager()
    //    StateObject listens to updates to observable objects
    
    @ObservedObject var locationManager =  LocationManager()
    
    var body: some View {
        ZStack {
            Color.blue
            .ignoresSafeArea()
            VStack {
                Spacer()
                Text (manager.weather?.name ?? "--")
                    .font(.system(size: 30, weight: .medium, design: .rounded))
                Text(manager.weather?.description ?? "--")
                    .font(.system(size: 20, weight: .ultraLight, design: .rounded))
                
                HStack{
                    Text("\(manager.weather?.tempString ?? "--")").font(.system(size: 90, weight: .light))
                        .foregroundStyle(.white)
                    Text("°C")
                        .font(.system(size: 45, weight: .ultraLight, design: .rounded))
                        .foregroundStyle(.white)
                }
                Spacer()
                Image(systemName: manager.weather?.conditionIcon ?? "")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 150, height: 150)
                
                Spacer()
            }
            .foregroundColor(.white)
        }
        .navigationBarHidden(true)
        .onReceive(locationManager.$location) { loc in
            Task {
                await manager.fetchForCurrentLocation(lat: loc?.latitude, lon: loc?.longitude)
            }
            
        }
//        .onAppear {
//            Task {
//                await manager.fetchForCurrentLocation()
//            }
//        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
