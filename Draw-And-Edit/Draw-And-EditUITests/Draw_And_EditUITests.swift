//
//  Draw_And_EditUITests.swift
//  Draw-And-EditUITests
//
//  Created by Ivan Pryhara on 9.01.23.
//

import XCTest

final class Draw_And_EditUITests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    let app = XCUIApplication()
    
    func testCancelButton() throws {
        // UI tests must launch the application that they test.
        
        app.launch()

        let addButton = app.buttons["add"]
        XCTAssertTrue(addButton.exists, "add button was not found")

        addButton.tap()
        
        let cancelButton = app.buttons["Cancel"]
        XCTAssertTrue(cancelButton.exists, "Cancel button was not found")
        
        cancelButton.tap()

        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testDoneButton() throws {
        app.launch()
        
        let addButton = app.buttons["add"]
        XCTAssertTrue(addButton.exists, "add button was not found")
        
        addButton.tap()

        let doneButton = app.buttons["Done"]
        XCTAssertTrue(doneButton.exists, "Done button was not found")
        
        let textView = app.textViews["text"]
        XCTAssertTrue(textView.exists, "Text View was not found.")
    }
    
    func testTextViewUsability() throws {
        app.launch()
        
        let addButton = app.buttons["add"]
        XCTAssertTrue(addButton.exists, "add button was not found")
        
        addButton.tap()

        let textView = app.textViews.element
        
        textView.typeText("Hello World")

        let doneButton = app.buttons["Done"]
        XCTAssertTrue(doneButton.exists, "Done button was not found")
        
        XCTAssertTrue(textView.exists, "Text View was not found.")
    }

    func testLaunchPerformance() throws {
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 7.0, *) {
            // This measures how long it takes to launch your application.
            measure(metrics: [XCTApplicationLaunchMetric()]) {
                XCUIApplication().launch()
            }
        }
    }
}
