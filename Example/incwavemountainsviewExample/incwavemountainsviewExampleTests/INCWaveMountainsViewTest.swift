//
//  INCWaveMountainsViewTest.swift
//  incwavemountainsviewExample
//
//  Created by Carlos Pages on 08/02/2017.
//  Copyright © 2017 Incuna. All rights reserved.
//

import XCTest
//import INCWaveMountainsView

class INCWaveMountainsViewTest: XCTestCase {
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }

    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testPointPercent (){
        
        let mountainView:INCWaveMountainsView = INCWaveMountainsView.init()
        
        mountainView.drawPercent(0.1, forIdPoint: 1)
        
        if mountainView.leftMountain.mountainId == 1 {
            XCTAssertEqual(mountainView.leftMountain.mountainPercent, 0.1)
            return
        }
        
        if mountainView.centerMountain.mountainId == 1 {
            XCTAssertEqual(mountainView.centerMountain.mountainPercent, 0.1)
            return
        }
        
        if mountainView.rightMountain.mountainId == 1 {
            XCTAssertEqual(mountainView.rightMountain.mountainPercent, 0.1)
            return
        }
        
        XCTAssert(true,"No founded mountain")
    }
    
    private var expectationTestPointIsReset:XCTestExpectation?

    func testPointIsReset(){
        
        let mountainView:INCWaveMountainsView = INCWaveMountainsView.init()
        mountainView.unblockMontainsForMissingPercents = false; // We set this to false so we are not worried about the amount of time to check the right behaviour.
        
        
        //first we need to find the right layer
        
        mountainView.drawPercent(0.1, forIdPoint: 1)

        var mountainLayer:INCWaveMountainLayer?
        if mountainView.leftMountain.mountainId == 1 {
            mountainLayer = mountainView.leftMountain
        }
        
        if mountainView.centerMountain.mountainId == 1 {
            mountainLayer = mountainView.centerMountain
        }
        
        if mountainView.rightMountain.mountainId == 1 {
            mountainLayer = mountainView.rightMountain
        }
        
        guard let mountainLayerUnw = mountainLayer else {
            XCTAssert(true,"No founded mountain")
            return
        }
        
        
        mountainLayerUnw.addObserver(self, forKeyPath:NSStringFromSelector(#selector(getter: INCWaveMountainLayer.mountainPercent)), options: .new, context: &expectationTestPointIsReset)

        mountainView.drawPercent(1, forIdPoint: 1)

        expectationTestPointIsReset = self.expectation(description: "Test point isReset")
        self.waitForExpectations(timeout: 5) { (error:Error?) in
            guard error != nil else{
                XCTAssert(true,"The mountain was not reset: Error: \(error!)")
                return
            }
            XCTAssert(true,"The mountain was not reset: Time Out")
        }
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        
        guard let keyPathUwp = keyPath else {
            XCTAssert(true,"The keys path is nil")
            return
        }
        
        
        let stringForMountainPercentProperty = NSStringFromSelector(#selector(getter: INCWaveMountainLayer.mountainPercent))
        if keyPathUwp == stringForMountainPercentProperty && context == &expectationTestPointIsReset{
            guard let mountain = object as? INCWaveMountainLayer, mountain.mountainPercent == Float(NO_PERCENT_VALUE) else {
                return
            }
            expectationTestPointIsReset!.fulfill()
        }
    }
    
}

