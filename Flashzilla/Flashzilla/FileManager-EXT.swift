//
//  FileManager-EXT.swift
//  Flashzilla
//
//  Created by Deepankar Das on 11/12/25.
//

import Foundation

extension FileManager {
    
    func getDocumentsDirectory() -> URL {
        return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    }
    
    func encode<T: Codable>(data: T, file: String) {
        let url = getDocumentsDirectory().appendingPathComponent(file)
        guard let encodedData = try? JSONEncoder().encode(data) else { return }
        do{
            try encodedData.write(to: url)
        }catch{
            print("error: \(error.localizedDescription)")
        }
    }
    
    func decode<T: Codable>(file: String) -> T? {
        let url = getDocumentsDirectory().appendingPathComponent(file)
        guard let data = try? Data(contentsOf: url) else {  return nil  }
        
        guard let decodeData = try? JSONDecoder().decode(T.self, from: data) else {  return nil }
        return decodeData
    }
}

