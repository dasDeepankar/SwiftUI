//
//  String+EXT.swift
//  CupcakeStore
//
//  Created by Deepankar Das on 13/10/25.
//

import Foundation

extension String {
   var isBlank: Bool {
       return self.isEmpty || self.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
}
