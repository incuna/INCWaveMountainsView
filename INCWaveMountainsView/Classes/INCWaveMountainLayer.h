//
//  INCWaveMountainLayer.h
//  eDetailing
//
//  Created by Carlos Pages on 06/02/2017.
//  Copyright © 2017 IncunaLTD. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import <UIKit/UIKit.h>

@interface INCWaveMountainLayer : CAShapeLayer

@property(nonatomic,strong,nonnull)CAShapeLayer *shapeLayerMountain;
@property(nonatomic,assign)float mountainPercent;
@property(atomic,strong,nullable)NSNumber *mountainPointId;
@property(nonatomic,strong,nonnull)CAShapeLayer *maskMountain;
@property(nonatomic,strong,nonnull)CAGradientLayer *gradientMountain;


- (void)removeMountainPosition;
- (void)animatePath:(nonnull UIBezierPath *)path;
- (void)resetWave;

- (BOOL)belongsToPointId:(NSInteger)idPoint;

@end
