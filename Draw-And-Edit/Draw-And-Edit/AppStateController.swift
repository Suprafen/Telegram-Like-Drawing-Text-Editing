//
//  AppStateController.swift
//  Draw-And-Edit
//
//  Created by Ivan Pryhara on 19.11.22.
//

import Foundation

class AppStateController {
    
    var filledAs: IPTextFillState = .normal
    
    var alignment: IPTextAlignmentState = .left
    
    // TODO: Make functions generic
    
    func changeFilledState() {
        print("Current index: \(filledAs)")
        let count = IPTextFillState.allCases.count
        let index = count / (filledAs.rawValue + 1) != 1 ? filledAs.rawValue + 1 : 0
        filledAs = IPTextFillState(rawValue: index) ?? .normal
        print("Current index(after click): \(filledAs)")
    }
    
    func changeAlignmentState() {
        print("Current index alignment: \(alignment)")
        let count = IPTextAlignmentState.allCases.count
        let index = count / (alignment.rawValue + 1) != 1 ? alignment.rawValue + 1 : 0
        alignment = IPTextAlignmentState(rawValue: index) ?? .left
        print("Current index alignment(after click): \(alignment)")
    }
}
