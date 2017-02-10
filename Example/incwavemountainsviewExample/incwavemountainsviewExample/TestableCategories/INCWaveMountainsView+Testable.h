//
//  INCWaveMountainsView+Testable.h
//  incwavemountainsviewExample
//
//  Created by Carlos Pages on 08/02/2017.
//  Copyright © 2017 Incuna. All rights reserved.
//

#import "INCWaveMountainsView.h"
#import "INCWaveMountainLayer.h"

@interface INCWaveMountainsView (Testable)

@property(nonatomic,strong)INCWaveMountainLayer *leftMountain;
@property(nonatomic,strong)INCWaveMountainLayer *centerMountain;
@property(nonatomic,strong)INCWaveMountainLayer *rightMountain;

@end
