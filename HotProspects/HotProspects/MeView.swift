//
//  MeView.swift
//  HotProspects
//
//  Created by Deepankar Das on 02/12/25.
//
import CoreImage
import CoreImage.CIFilterBuiltins
import SwiftUI

struct MeView: View {
    @AppStorage("name") private var name = "Anonymous"
    @AppStorage("emailAddress") private var email = "Anonymous@gmail.com"
    
    let context = CIContext()
    let filter = CIFilter.qrCodeGenerator()
    @State private var qrCodeImage = UIImage()
    
    var body: some View {
        NavigationStack{
            Form{
                TextField("Name", text: $name)
                    .textContentType(.name)
                TextField("Email", text: $email)
                    .textContentType(.emailAddress)
                Image(uiImage:qrCodeImage)
                    .interpolation(.none)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 200,height: 200)
                    .contextMenu {
                        ShareLink(item: Image(uiImage: qrCodeImage), preview: SharePreview("QR Code", image: Image(uiImage: qrCodeImage)))
                    }
            }.navigationTitle("Your code")
        }.onAppear(perform: updateCode)
            .onChange(of: name, updateCode)
            .onChange(of: email, updateCode)
    }
    func updateCode(){
        qrCodeImage = generateQRcode(from: "\(name)\n\(email)")
    }
    func generateQRcode(from string : String) -> UIImage {
        filter.message = Data(string.utf8)
        if let outputImage = filter.outputImage {
            if let cgImage = context.createCGImage(outputImage, from: outputImage.extent){
                return UIImage(cgImage: cgImage)
            }
        }
        
        return UIImage(systemName: "xmark.circle") ?? UIImage()
    }
    
    
}

#Preview {
    MeView()
}
