//
//  INCWaveMountainLayer.h
//  eDetailing
//
//  Created by Carlos Pages on 06/02/2017.
//  Copyright © 2017 IncunaLTD. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import <UIKit/UIKit.h>

extern const NSInteger NO_PERCENT_VALUE;

@class INCWaveMountainLayer;

@protocol INCWavwMountainLayerDelegate <CALayerDelegate>

@optional
-(void)layerResetByTimeOut:(nonnull INCWaveMountainLayer *)layer;

@end


@interface INCWaveMountainLayer : CAShapeLayer


@property(nonatomic,strong,nonnull)CAShapeLayer *shapeLayerMountain;///This property define the shape of the mountain
@property(nonatomic,assign)float mountainPercent;///This define the hight of the mountain, the value has to be between 0 to 1 or NO_PERCENT_VALUE. A lower value will be considered 0 and higher value will be considered 1.
@property(atomic,strong,nullable)NSNumber *mountainId;///This is the id of the mountain
@property(nonatomic,strong,nonnull)CAShapeLayer *maskMountain;///Mask layer
@property(nonatomic,strong,nonnull)CAGradientLayer *gradientMountain;///Gradient colour

@property(nonatomic,assign)BOOL unblockMontainsForMissingPercents;///If yes the time can be set up to unblock a mountain automatically. If after unblockTimeInterval time the layer doesn't new values the mountain is reset to 0.
@property(weak,nullable)id<INCWavwMountainLayerDelegate> delegate;

/*!
 * @dicussion Reset the values for this mountain.
 */
- (void)resetMountainPosition;
/*!
 * @discussion Animate the mountain with the path provided
 * @param path An UIBezierPath to paint in the shapeLayerMountain
 */
- (void)animatePath:(nonnull UIBezierPath *)path;
/*!
 * @discussion Reset the mountain removing all layers from their super layer
 */
- (void)resetWave;
/*!
 * @discussion Checks if the idMountain is the idMountain for the class
 @ @param idMountain id to check
 @ return boolean values after the check
 */
- (BOOL)belongsToPointId:(NSInteger)idMountain;
/*!
 * @discussion Set up the timer. See more unblockMontainsForMissingPercents
 */
- (void)setUpUnblockTimer;
@end
