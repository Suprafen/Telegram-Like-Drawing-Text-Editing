//
//  IPTextFillState.swift
//  Draw-And-Edit
//
//  Created by Ivan Pryhara on 19.11.22.
//

import Foundation
import UIKit

enum IPTextFillState: Int, CaseIterable {
    case normal = 0
    case fill = 1
    // it means that we're using the same fill color,
    // however it will be filled with fifth of 100% current color
    case fifthFill = 2
    case stroke = 3
}
