//
//  IPTextFillState.swift
//  Draw-And-Edit
//
//  Created by Ivan Pryhara on 19.11.22.
//

import Foundation
import UIKit

enum IPTextFillState: Int, CaseIterable {
    case defaultFill = 0
    case filled = 1
    // it means that we're using the same fill color,
    // however it will be filled with fifth of 100% current color
    case semi = 2
    case stroke = 3
}
