//
//  LocationView.swift
//  Weather_APP
//
//  Created by Ge Ding on 6/18/23.
//
import SwiftUI

struct LocationView: View {
    @ObservedObject var viewModel: WeatherViewModel
    @State var cityName: String = ""

    var body: some View {
        ZStack {
            RadialGradient(stops: [
                .init(color: Color(red: Double(255)/255.0, green: Double(255)/255.0, blue: Double(224)/255.0), location: 0.3),
                .init(color: Color(red: Double(143)/255.0, green: Double(188)/255.0, blue: Double(143)/255.0), location: 0.3),
            ], center: .top, startRadius: 200, endRadius: 250).ignoresSafeArea()
            
            VStack {
                HStack {
                    Spacer()
                    TextField("Enter Your City", text: $cityName)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    Spacer()
                    Button {
                        viewModel.fetchWeatherData(from: EndPoint(city: cityName))
                    } label: {
                        Image(systemName: "magnifyingglass")
                            .cornerRadius(10)
                            .foregroundColor(.init(Color(red: Double(143)/255.0, green: Double(188)/255.0, blue: Double(143)/255.0) ))
                    }
                    Spacer()
                }.padding()
                
                Spacer()

                HStack {
                    Image(systemName: "location")
                    Text(viewModel.weatherData?.name ?? "Loading")
                    Spacer()
                }
                .padding(.top, 50)
                .padding()
                .font(.title)
                .fontWeight(.bold)
                
                HStack {
                    Text("lon: \(viewModel.weatherData?.coord?.lon ?? 0.0, specifier:"%.2f")   |   lat: \(viewModel.weatherData?.coord?.lat ?? 0.0, specifier:"%.2f")")
                    Spacer()
                }
                .font(.title)
                .fontWeight(.bold)
                .padding()
                .padding(.top, -25)

                HStack {
                    Spacer()
                    if let temp = viewModel.weatherData?.main?.temp {
                        Text("\(temp - 273.15, specifier:"%.2f") C°")
                    } else {
                        Text("N/A")
                    }
                    if let weatherImage = viewModel.weatherImage {
                        Image(uiImage: weatherImage)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 50, height: 50)
                    } else {
                        Image(systemName: "arrow.down.circle")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 50, height: 50)
                    }
                }
                .padding()
                .font(.title)
                .fontWeight(.bold)
                
                HStack {
                    Spacer()
                    Text("Weather:  \(viewModel.weatherData?.weather?[0].main ?? "N/A")")
                }
                .padding(.top,-25)
                .padding()
                .font(.title)
                .fontWeight(.bold)
                Spacer()
                
                Divider()

                Text("Temperture Infomation")
                Group {
                    HStack(alignment: .top) {
                        Spacer()
                        VStack {
                            Text("Feel like")
                            if let feelLike = viewModel.weatherData?.main?.feels_like {
                                Text("\(feelLike - 273.15, specifier: "%.2f") C°")
                            } else {
                                Text("N/A")
                            }
                        }.stardardFont()
                        Spacer()
                        VStack {
                            Text("Max Temperture")
                            if let max = viewModel.weatherData?.main?.temp_max {
                                Text("\(max - 273.15, specifier:"%.2f") C°")
                            } else {
                                Text("N/A")
                            }
                        }.stardardFont()
                        Spacer()
                        VStack {
                            Text("Min Temperture")
                            if let min = viewModel.weatherData?.main?.temp_min {
                                Text("\(min - 273.15, specifier:"%.2f") C°")
                            } else {
                                Text("N/A")
                            }
                        }.stardardFont()
                        Spacer()
                    }.padding()
                    
                    Text("Wind Information")
                    HStack {
                        Spacer()
                        VStack {
                            Text("Speed")
                            Text("\(viewModel.weatherData?.wind?.speed ?? 0.0, specifier:"%.2f")")
                        }
                        .stardardFont()
                        VStack {
                            Text("Gust")
                            Text("\(viewModel.weatherData?.wind?.gust ?? 0.0, specifier:"%.2f")")
                        }.stardardFont()
                        VStack {
                            Text("Deg")
                            Text("\(viewModel.weatherData?.wind?.deg ?? 0)")
                        }.stardardFont()
                        Spacer()
                    }.padding()
                }
            }
        }
    }
}

struct LocationView_Previews: PreviewProvider {
    static var previews: some View {
        LocationView(viewModel: WeatherViewModel(client: WeatherAPIClient(), imageLoader: ImageLoader()))
    }
}
