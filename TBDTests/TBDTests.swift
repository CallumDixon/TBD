//
//  TBDTests.swift
//  TBDTests
//
//  Created by Callum Dixon on 20/06/2022.
//

import XCTest
@testable import TBD

class TBDTests: XCTestCase {
    
    var viewController : ViewController!
    
    override func setUpWithError() throws {
        
        let storyboard = NSStoryboard(name: "Main", bundle: nil)
        self.viewController = storyboard.instantiateController(identifier: "ViewController")
        self.viewController.loadView()
        
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testInit() throws {
        XCTAssert(viewController?.breakDuration == viewController.breakDurationInMin * 60)
        XCTAssert(viewController?.workDuration == viewController.workDurationInMin * 60)
        
        XCTAssert(viewController?.timer != nil)
        
        XCTAssert(viewController?.countdown == viewController.breakDuration)
        
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        // Any test you write for XCTest can be annotated as throws and async.
        // Mark your test throws to produce an unexpected failure when your test encounters an uncaught error.
        // Mark your test async to allow awaiting for asynchronous code to complete. Check the results with assertions afterwards.
    }
    
//    func testTogglePressed(){
//
//        //viewController.putInFullScreen()
//       // viewController.togglePressed(self)
//
//        let actualTimeInterval = viewController.timer?.value(forKey: "timeInterval") as? Double
//
//        XCTAssert(actualTimeInterval == viewController.workDuration)
//
//    }
    
    func testBuildCountdownLabelMessage_successful_600seconds(){
        
        let message = viewController.buildCountdownLabelMessage(countdown: 600.0)
        
        XCTAssert(message == "10:00")
        
    }
    
    func testBuildCountdownLabelMessage_successful_10678seconds(){
        
        let message = viewController.buildCountdownLabelMessage(countdown: 10678.0)
        
        XCTAssert(message == "177:58")
        
    }
    
    func testBuildCountdownLabelMessage_failure_negativeValue(){
        
        let message = viewController.buildCountdownLabelMessage(countdown: -1.0)
        
        XCTAssert(message == "Invalid value")
        
    }
    

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
