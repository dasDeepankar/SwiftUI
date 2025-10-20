//
//  String+Ext.swift
//  Bookworm
//
//  Created by Deepankar Das on 20/10/25.
//

import Foundation

extension String {
    var isBlank : Bool {
        return self.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
}
