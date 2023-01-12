//
//  IPSliderDelegate.swift
//  Draw-And-Edit
//
//  Created by Ivan Pryhara on 12.01.23.
//

import Foundation

protocol IPSliderDelegate {
    func touchesBegan() -> Void
    func touchesEnded() -> Void
}
