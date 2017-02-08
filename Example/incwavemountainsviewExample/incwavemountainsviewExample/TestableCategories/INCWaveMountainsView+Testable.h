//
//  INCWaveMountainsView+Testable.h
//  incwavemountainsviewExample
//
//  Created by Carlos Pages on 08/02/2017.
//  Copyright © 2017 Incuna. All rights reserved.
//

#import "INCWaveMountainsView.h"
#import "INCWaveMountainLayer.h"
#import "INCWaveMountainTypes.h"

@interface INCWaveMountainsView (Testable)


-(void)_removeThePointWithIdPoint:(NSInteger)idPoint inMountainLayer:(INCWaveMountainLayer *)mountainLayer inMountainPosition:(INCMountainPosition)mountainPosition later:(NSTimeInterval)laterTime;


@end
