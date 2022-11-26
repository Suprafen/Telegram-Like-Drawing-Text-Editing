//
//  IPFont.swift
//  Draw-And-Edit
//
//  Created by Ivan Pryhara on 20.11.22.
//

import Foundation
import UIKit

class IPFont: Identifiable, Hashable {
    
    var id = UUID()
    var font: UIFont?
    
    init(font: UIFont?) {
        self.font = font
    }

    static func == (lhs: IPFont, rhs: IPFont) -> Bool {
        lhs.id == rhs.id
    }

    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
}
