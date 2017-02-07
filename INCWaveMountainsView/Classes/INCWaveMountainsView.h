//
//  INCWaveMountainsView.h
//  eDetailing
//
//  Created by Carlos Pages on 26/01/2017.
//  Copyright © 2017 IncunaLTD. All rights reserved.
//

/*
 We use this view to show the progress when some files are downloading.
 
 The view has three mountains and the
 
*/

#import <UIKit/UIKit.h>

@interface INCWaveMountainsView : UIView

//You can provide a gradient for each mountain. This gradients should be provided before the first call to drawPercent. To change the gradients after a drawPercent call you need to call resetWaves and then change the gradients before the call to drawPercent. If null a default gradients will be created.
@property(nonatomic,strong,nonnull)CAGradientLayer *gradientLeftMountain;
@property(nonatomic,strong,nonnull)CAGradientLayer *gradientCenterMountain;
@property(nonatomic,strong,nonnull)CAGradientLayer *gradientRightMountain;

/*!
 * @discussion This reset the waves to the initial value
 */
-(void)resetWaves;
/*!
 * @discussion This draws the percent for idPoint. The percent goes between 0 and 1. Negative values and values bigger than 1 are ignored.
 * @param percent The value percent to update. 
 * @param idPoint the id for the point to update. In terms of keep a tracking of which mountain was updated we need an id.
 */
-(void)drawPercent:(float)percent forIdPoint:(NSInteger)idPoint;

@property(nonatomic,assign)BOOL unblockMontainsForMissingPercents;///If this property is true, if the point is not updated in 2sec the mountain is released to accept a new point. Default YES
@end
