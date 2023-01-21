//
//  IPTextViewDelegate.swift
//  Draw-And-Edit
//
//  Created by Ivan Pryhara on 21.01.23.
//

import Foundation

protocol IPTextViewDelegate {
    func presentControlPath(forTextView textView: IPTextView) -> Void
    func removeControlPath() -> Void
}
