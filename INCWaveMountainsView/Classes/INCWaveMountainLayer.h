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

@property(nonatomic,strong,nonnull)CAShapeLayer *shapeLayerMountain;//This property define the shape of the mountain
@property(nonatomic,assign)float mountainPercent;//This define the hight of the mountain, the value has to be between 0 to 1 or NO_PERCENT_VALUE. A lower value will be considered 0 and higher value will be considered 1.
@property(atomic,strong,nullable)NSNumber *mountainPointId;
@property(nonatomic,strong,nonnull)CAShapeLayer *maskMountain;
@property(nonatomic,strong,nonnull)CAGradientLayer *gradientMountain;

@property(nonatomic,assign)BOOL unblockMontainsForMissingPercents;
@property(weak,nullable)id<INCWavwMountainLayerDelegate> delegate;

- (void)resetMountainPosition;
- (void)animatePath:(nonnull UIBezierPath *)path;
- (void)resetWave;

- (BOOL)belongsToPointId:(NSInteger)idPoint;
- (void)setUpUnblockTimer;
@end
