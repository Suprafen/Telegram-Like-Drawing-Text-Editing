//
//  IPAvailableFontsCollectionViewControllerDelegate.swift
//  Draw-And-Edit
//
//  Created by Ivan Pryhara on 30.11.22.
//

import Foundation
import UIKit

protocol IPAvailableFontsCollectionViewControllerDelegate {
    func availableFontsCollectionViewController(chooseFont chosenFont: IPFont) -> Void
}
