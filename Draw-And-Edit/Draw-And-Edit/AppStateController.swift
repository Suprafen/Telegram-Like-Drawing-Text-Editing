//
//  AppStateController.swift
//  Draw-And-Edit
//
//  Created by Ivan Pryhara on 19.11.22.
//

import Foundation

class AppStateController {
    
    var filledAs: IPTextFillState = .defaultFill
    
    var alignment: IPTextAlignmentState = .left
    
    // TODO: Make functions generic
    
    func changeFilledState() {
        
        let count = IPTextFillState.allCases.count
        let index = count > (filledAs.rawValue + 1) ? filledAs.rawValue + 1 : 0
        filledAs = IPTextFillState(rawValue: index) ?? .defaultFill
        
    }
    
    func changeAlignmentState() {
        
        let count = IPTextAlignmentState.allCases.count
        let index = count > (alignment.rawValue + 1) ? alignment.rawValue + 1 : 0
        alignment = IPTextAlignmentState(rawValue: index) ?? .left
        
    }
}
