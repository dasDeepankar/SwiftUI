//
//  ContentView.swift
//  BucketList
//
//  Created by Deepankar Das on 12/11/25.
//

import MapKit
import SwiftUI

struct ContentView: View {
    
    
    private let startingPosition = MapCameraPosition.region(
        MKCoordinateRegion(
            center:CLLocationCoordinate2D(latitude: 17.4, longitude: 78.4),
            span: MKCoordinateSpan(latitudeDelta: 10, longitudeDelta: 10)
        )
    )
    
    @State var viewModel = ViewModel()
    
    var body: some View {
        if viewModel.isUnLocked {
            ZStack(alignment: .bottomTrailing) {
                MapReader { proxy in
                    Map(initialPosition: startingPosition){
                        ForEach(viewModel.locations){ location in
                            Annotation(location.name, coordinate: location.coordinate) {
                                Button {
                                    viewModel.selectedLocation = location
                                } label: {
                                    Image(systemName: "pin.circle")
                                        .resizable()
                                        .foregroundStyle(.red)
                                        .frame(width: 44, height: 44)
                                        .background(.white)
                                        .clipShape(.circle)
                                }
                                
                            }
                        }
                    }
                    .mapStyle(viewModel.mapStyle)
                    .onTapGesture { position in
                        if let coordinate = proxy.convert(position, from: .local){
                            viewModel.addLocation(at: coordinate)
                        }
                    }.sheet(item: $viewModel.selectedLocation) { place in
                        EditView(location: place) {
                            viewModel.updateLocation(location: $0)
                        }
                    }
                }
                
                Button{
                    viewModel.isHybridMap.toggle()
                }label: {
                    Image(systemName: viewModel.icon)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 40, height: 40)
                        .padding(8)
                        .background(.secondary)
                        .foregroundStyle(.white)
                        .clipShape(.circle)
                        .animation(.bouncy, value: viewModel.isHybridMap)
                }
                .padding()
            }
        } else {
            VStack{
                Spacer()
                Label("Locked", systemImage: "lock").font(.title)
                Spacer()
                Button{
                    viewModel.authenticate()
                }label: {
                    VStack{
                        Image(systemName: "faceid")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 100, height: 100)
                        
                    }
                }.buttonStyle(.plain)
                Spacer()
                Spacer()
                Spacer()
            }.alert(viewModel.errorTitle, isPresented: $viewModel.isAuthenticationFailed) {
                Button("OK"){}
            } message: {
                Text(viewModel.errorDescription)
            }
        }
        
    }
}

#Preview {
    ContentView()
}
