//
//  IPAvailableFontsStorage.swift
//  Draw-And-Edit
//
//  Created by Ivan Pryhara on 20.11.22.
//

import Foundation
import UIKit

class IPAvailableFontsStorage {
    
    static let standardFontSize: CGFloat = 15
    
    var availableFonts: [IPFont] = [
        IPFont(font: UIFont(name: fontName.HelveticaNeue_Bold.rawValue,
                            size: standardFontSize)),
        IPFont(font: UIFont(name: fontName.AmericanTypewriter_Bold.rawValue,
                            size: standardFontSize)),
        IPFont(font: UIFont(name: fontName.Arial_Rounded_MT_Bold.rawValue,
                            size: standardFontSize)),
        IPFont(font: UIFont(name: fontName.Verdana_Bold.rawValue,
                            size: standardFontSize)),
    ]
}
