//
//  IPAvailableFontsStorage.swift
//  Draw-And-Edit
//
//  Created by Ivan Pryhara on 20.11.22.
//

import Foundation
import UIKit

class IPAvailableFontsStorage {
    
    static let standardFontSize: CGFloat = 20
    
    var availableFonts: [IPFont] = [
        IPFont(font: UIFont(name: fontName.Helvetica.rawValue,
                            size: standardFontSize)),
        IPFont(font: UIFont(name: fontName.AmericanTypewriter.rawValue,
                            size: standardFontSize)),
        IPFont(font: UIFont(name: fontName.Baskerville.rawValue,
                            size: standardFontSize)),
        IPFont(font: UIFont(name: fontName.GillSans.rawValue,
                            size: standardFontSize)),
        IPFont(font: UIFont(name: fontName.Georgia.rawValue,
                            size: standardFontSize)),
        IPFont(font: UIFont(name: fontName.AppleSDGothicNeo_Regular.rawValue,
                            size: standardFontSize)),
        IPFont(font: UIFont(name: fontName.Cochin.rawValue,
                            size: standardFontSize)),
    ]
}
