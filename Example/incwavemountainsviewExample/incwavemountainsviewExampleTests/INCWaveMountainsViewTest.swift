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
}
