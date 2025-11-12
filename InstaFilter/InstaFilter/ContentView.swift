//
//  ContentView.swift
//  InstaFilter
//
//  Created by Deepankar Das on 08/11/25.
//
import CoreImage
import CoreImage.CIFilterBuiltins
import PhotosUI
import StoreKit
import SwiftUI


struct ContentView: View {
    @State private var processedImage: Image?
    @State private var filterIntensity = 0.5
    @State private var filterBlur = 0.5
    @State private var selectedItem: PhotosPickerItem?
    @State private var currentFilter:CIFilter = CIFilter.sepiaTone()
    @State private var showDialog = false
    @AppStorage("filterCount") var filterCount = 0
    @Environment(\.requestReview) var requestReview
    
    let context = CIContext()
    
    var body: some View {
        NavigationStack{
            VStack{
                HStack{
                    Spacer()
                    Button(action: changeFilter) {
                        Image(systemName: "slider.horizontal.3")
                            .font(.system(size: 20, weight: .bold))
                    }.buttonStyle(.plain)
                        .disabled((processedImage == nil))
                }
                Spacer()
                PhotosPicker(selection: $selectedItem) {
                    if let processedImage = processedImage {
                        processedImage
                            .resizable()
                            .scaledToFit()
                    } else{
                        ContentUnavailableView("No Picture", systemImage: "photo.badge.plus", description: Text("Tap to import a photo"))
                    }
                }.buttonStyle(.plain)
                    .onChange(of: selectedItem, loadImage)
                Spacer()
                Group {
                    HStack{
                        Text("Intensity")
                        Slider(value: $filterIntensity)
                            .onChange(of: filterIntensity, applyProcessing)
                    }
                    HStack{
                        Text("Radius")
                        Slider(value: $filterBlur)
                            .onChange(of: filterBlur, applyProcessing)
                    }
                }.disabled((processedImage == nil))
             
            }.navigationTitle("Instafilter")
                .padding([.horizontal, .bottom])
                .confirmationDialog("Selcet a filter", isPresented: $showDialog, titleVisibility: .automatic) {
                    Button("Sepia Tone") { setFilter(CIFilter.sepiaTone()) }
                    Button("Vignette") { setFilter(CIFilter.vignette()) }
                    Button("Blur") { setFilter(CIFilter.zoomBlur()) }
                    Button("Cancel", role: .cancel) { }
                }
                .toolbar {
                    if let processedImage{
                        ShareLink(item: processedImage, preview: SharePreview("Instafilter image", image: processedImage))
                        Button("Clear", systemImage: "xmark") {
                            self.processedImage = nil
                        }
                    }
                }
        }
    }
    
    func changeFilter() {
        showDialog.toggle()
    }
    func setFilter(_ filter: CIFilter) {
        currentFilter = filter
        loadImage()
        filterCount += 1
        if filterCount > 20{
            requestReview()
        }
        
    }
    func loadImage()  {
        Task{
            guard let imageData = try await selectedItem?.loadTransferable(type: Data.self) else { return }
            guard let inputImage = UIImage(data: imageData) else { return }
            let beginImage = CIImage(image: inputImage)
            currentFilter.setValue(beginImage, forKey: kCIInputImageKey)
            applyProcessing()
            
        }
    }
    
    func applyProcessing() {
        let inputKey = currentFilter.inputKeys
        if inputKey.contains(kCIInputIntensityKey)  { currentFilter.setValue(filterIntensity + filterBlur, forKey: kCIInputIntensityKey) }
        if inputKey.contains(kCIInputRadiusKey)  { currentFilter.setValue(filterBlur + filterIntensity * 100, forKey: kCIInputRadiusKey) }
        if inputKey.contains(kCIInputScaleKey)  { currentFilter.setValue(filterIntensity + filterBlur * 10, forKey: kCIInputScaleKey) }
        guard let outputImage = currentFilter.outputImage else { return }
        guard let cgImage = context.createCGImage(outputImage, from: outputImage.extent) else { return }
        let uiImage = UIImage(cgImage: cgImage)
        processedImage = Image(uiImage: uiImage)
    }
}

#Preview {
    ContentView()
}
