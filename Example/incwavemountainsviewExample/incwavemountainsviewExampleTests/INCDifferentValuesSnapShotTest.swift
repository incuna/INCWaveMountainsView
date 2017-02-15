//
//  INCDifferentValuesSnapShotTest.swift
//  incwavemountainsviewExample
//
//  Created by Carlos Pages on 15/02/2017.
//  Copyright © 2017 Incuna. All rights reserved.
//

import UIKit
import FBSnapshotTestCase

class INCDifferentValuesSnapShotTest: FBSnapshotTestCase {

    override func setUp() {
        super.setUp()
        self.recordMode = false;
    }
    
    let WIDTH = 350;
    let HEIGHT = 300;
    
    func testViewWithHalfPointPercentOneView () {
        
        let mountainView:INCWaveMountainsView = INCWaveMountainsView.init(frame: CGRect(x: 0, y: 0, width: WIDTH, height: HEIGHT))
        mountainView.backgroundColor = UIColor.white
        mountainView .drawPercent(0.5, forIdPoint: 1)
        
        FBSnapshotVerifyView(mountainView);
        FBSnapshotVerifyLayer(mountainView.layer);
        
    }
    
    func testViewWithHalfPointPercentTwoViews () {
        
        let mountainView:INCWaveMountainsView = INCWaveMountainsView.init(frame: CGRect(x: 0, y: 0, width: WIDTH, height: HEIGHT))
        mountainView.backgroundColor = UIColor.white
        mountainView .drawPercent(0.5, forIdPoint: 1)
        mountainView .drawPercent(0.5, forIdPoint: 2)
        
        FBSnapshotVerifyView(mountainView);
        FBSnapshotVerifyLayer(mountainView.layer);
        
    }
    
    
    func testViewWithHalfPointPercentThreeViews () {
        
        let mountainView:INCWaveMountainsView = INCWaveMountainsView.init(frame: CGRect(x: 0, y: 0, width: WIDTH, height: HEIGHT))
        mountainView.backgroundColor = UIColor.white
        mountainView .drawPercent(0.5, forIdPoint: 1)
        mountainView .drawPercent(0.5, forIdPoint: 2)
        mountainView .drawPercent(0.5, forIdPoint: 3)
        
        FBSnapshotVerifyView(mountainView);
        FBSnapshotVerifyLayer(mountainView.layer);
        
    }
}
