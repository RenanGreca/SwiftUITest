//
//  UITests.swift
//  solanumTests
//
//  Created by Cinq Technologies on 09/03/18.
//  Copyright © 2018 renangreca. All rights reserved.
//

import UIKit
import KIF

class UITests: KIFTestCase {

    func test00ClearHistory() {
        
        tester().tapView(withAccessibilityLabel: "Settings")
//        viewTester().usingLabel("Settings").tap()
        
        tester().setOn(true, forSwitchWithAccessibilityLabel: "Debug Mode")
        
        print("hello there")
        tester().tapView(withAccessibilityLabel: "Clear History")
        tester().tapView(withAccessibilityLabel: "No")
        
//        tester().setOn(false, forSwitchWithAccessibilityLabel: "Debug Mode")
    }
    
    func test01TabBarButtons() {
        // 1
        tester().tapView(withAccessibilityLabel: "History")
        tester().waitForView(withAccessibilityLabel: "History List")
        
        // 2
        tester().tapView(withAccessibilityLabel: "Timer")
        tester().waitForView(withAccessibilityLabel: "Task Name")

        // 3
        tester().tapView(withAccessibilityLabel: "Settings")
        tester().waitForView(withAccessibilityLabel: "Debug Mode")
    }
    
    func test10PresetTimer() {
        // 1
        tester().tapView(withAccessibilityLabel: "Timer")
        
        // 2
        tester().enterText("Set up a test\n",
                           intoViewWithAccessibilityLabel: "Task Name")
//        tester().tapView(withAccessibilityLabel: "done")
       
//        XCUIApplication().keyboards.firstMatch.buttons["Done"].tap()

        let presets = [
            [
                "name": "Classic",
                "workTime": 25,
                "breakTime": 5,
                "reps": 4
            ],
            [
                "name": "Express",
                "workTime": 15,
                "breakTime": 2,
                "reps": 3
            ],
            [
                "name": "Focused",
                "workTime": 40,
                "breakTime": 5,
                "reps": 2
            ],
            [
                "name": "Slacker",
                "workTime": 10,
                "breakTime": 20,
                "reps": 6
            ],
            [
                "name": "Slacker Pro+",
                "workTime": 5,
                "breakTime": 40,
                "reps": 1
            ]
        ]
        
        for i in 0...1 {
            // 3
            self.selectPresetAt(index: i)
            
            // 4
            let slider = tester().waitForView(withAccessibilityLabel: "Work Time Slider") as! UISlider
            XCTAssertEqual(slider.value, Float(presets[i]["workTime"] as! Int), accuracy: 0.1, "Work time slider was not set!")
        }
    }
    
    func test20StartTimerAndWaitForFinish() {
        // 1
        tester().tapView(withAccessibilityLabel: "Timer")
        
        // 2
        tester().clearText(fromAndThenEnterText: "Test the timer\n", intoViewWithAccessibilityLabel: "Task Name")
        
        // 3
        tester().setValue(1, forSliderWithAccessibilityLabel: "Work Time Slider")
        tester().setValue(50, forSliderWithAccessibilityLabel: "Work Time Slider")
        tester().setValue(1, forSliderWithAccessibilityLabel: "Work Time Slider")
        tester().setValue(8, forSliderWithAccessibilityLabel: "Work Time Slider")
        
        // 4
        tester().setValue(1, forSliderWithAccessibilityLabel: "Break Time Slider")
        tester().setValue(25, forSliderWithAccessibilityLabel: "Break Time Slider")
        tester().setValue(2, forSliderWithAccessibilityLabel: "Break Time Slider")
        
        // 5
        for _ in 0...5 {
            tester().tapStepper(withAccessibilityLabel: "Reps Stepper", increment: .decrement)
        }
        
        tester().wait(forTimeInterval: 1)
        tester().tapStepper(withAccessibilityLabel: "Reps Stepper", increment: .increment)
        tester().wait(forTimeInterval: 1)
        tester().tapStepper(withAccessibilityLabel: "Reps Stepper", increment: .increment)
        tester().wait(forTimeInterval: 1)
        
        // 6
        KIFUITestActor.setDefaultTimeout(60)
        tester().tapView(withAccessibilityLabel: "Start Working!")
        tester().waitForView(withAccessibilityLabel: "Start Working!")
        KIFUITestActor.setDefaultTimeout(10)

    }
    
    func test30StarTimerAndGiveUp() {
        tester().tapView(withAccessibilityLabel: "Timer")
        
        tester().clearText(fromAndThenEnterText: "Give Up\n", intoViewWithAccessibilityLabel: "Task Name")
        self.selectPresetAt(index: 2)
        
        tester().tapView(withAccessibilityLabel: "Start Working!")
        tester().wait(forTimeInterval: 3)
        
        tester().tapView(withAccessibilityLabel: "Give Up")
        (tester().usingTimeout(1)).waitForView(withAccessibilityLabel: "Start Working!")
    
    }
    
    func test40SwipeToDeleteHistoryItem() {
        tester().tapView(withAccessibilityLabel: "History")
        
        let tableView = tester().waitForView(withAccessibilityLabel: "History List") as! UITableView
        let originalHistoryCount = tableView.numberOfRows(inSection: 0)
        XCTAssertTrue(originalHistoryCount > 0)

        tester().swipeView(withAccessibilityLabel: "Section 0 Row 0", in: .left)
        tester().tapView(withAccessibilityLabel: "Delete")
        
        tester().wait(forTimeInterval: 1)
        let currentHistoryCount = tableView.numberOfRows(inSection: 0)
        XCTAssertTrue(currentHistoryCount == originalHistoryCount-1, "The history item was not deleted!")
        
        if currentHistoryCount > 0 {
            tester().tapRow(at: IndexPath(row: 0, section: 0), in: tableView)
        }

    }
    
    func test99DisableDebugmode() {
        tester().tapView(withAccessibilityLabel: "Settings")
        tester().waitForView(withAccessibilityLabel: "Debug Mode")
        tester().setOn(false, forSwitchWithAccessibilityLabel: "Debug Mode")
    }
    
    
    // Helpers
    
    func selectPresetAt(index: Int) {
        // tap Timer tab
        tester().tapView(withAccessibilityLabel: "Timer")
        
        // tap preset
        tester().tapView(withAccessibilityLabel: "Presets")
        tester().tapRow(at: IndexPath(row: index, section: 0), inTableViewWithAccessibilityIdentifier: "Presets List")
        
        // wait for preset to be selected
        tester().waitForAbsenceOfView(withAccessibilityLabel: "Presets List")
    }
}
