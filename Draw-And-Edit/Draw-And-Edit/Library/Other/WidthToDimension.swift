//
//  WidthToDimension.swift
//  Draw-And-Edit
//
//  Created by Ivan Pryhara on 10.12.22.
//

import Foundation

func widthToDimensions(_ width: CGFloat) -> (width: CGFloat, height: CGFloat) {
    (width * 7 / 1, width)
}
