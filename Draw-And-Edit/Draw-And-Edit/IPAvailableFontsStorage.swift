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
        IPFont(font: UIFont(name: fontName.Helvetica_Bold.rawValue,
                            size: standardFontSize)),
        IPFont(font: UIFont(name: fontName.AmericanTypewriter.rawValue,
                            size: standardFontSize)),
        IPFont(font: UIFont(name: fontName.Baskerville.rawValue,
                            size: standardFontSize)),
        IPFont(font: UIFont(name: fontName.GillSans.rawValue,
                            size: standardFontSize)),
        IPFont(font: UIFont(name: fontName.Georgia.rawValue,
                            size: standardFontSize)),
        IPFont(font: UIFont(name: fontName.Verdana_Bold.rawValue,
                            size: standardFontSize)),
        IPFont(font: UIFont(name: fontName.DamascusSemiBold.rawValue,
                            size: standardFontSize)),
    ]
}
