//
//  INCWaveMountainLayer.m
//  eDetailing
//
//  Created by Carlos Pages on 06/02/2017.
//  Copyright © 2017 IncunaLTD. All rights reserved.
//

#import "INCWaveMountainLayer.h"

@implementation INCWaveMountainLayer


-(instancetype)init
{
    self = [super init];
    if (self) {
        self.mountainPercent = -1;
    }
    return self;
}

-(CAGradientLayer *)gradientMountain
{
    if (!_gradientMountain) {
        _gradientMountain = [CAGradientLayer layer];
        
        _gradientMountain.startPoint = CGPointMake(0, 0);
        _gradientMountain.endPoint = CGPointMake(1, 0);
        NSArray *colors = @[(id)[UIColor colorWithRed:48.0/255.0 green:35.0/255.0 blue:174.0/255.0 alpha:0.4].CGColor, (id)[UIColor colorWithRed:180.0/255.0 green:236.0/255.0 blue:81.0/255.0 alpha:0.4].CGColor];
        _gradientMountain.colors = colors;
    }
    return _gradientMountain;
}

-(CAShapeLayer *)maskMountain
{
    if (!_maskMountain) {
        _maskMountain = [CAShapeLayer layer];
        _maskMountain.fillColor = [UIColor whiteColor].CGColor;
    }
    return _maskMountain;
}

-(CAShapeLayer *)shapeLayerMountain
{
    if (!_shapeLayerMountain) {
        _shapeLayerMountain = [[CAShapeLayer alloc]init];
        
        [_shapeLayerMountain setFillColor:[UIColor clearColor].CGColor];
        [_shapeLayerMountain addSublayer:self.gradientMountain];
        
        [self addSublayer:_shapeLayerMountain];
    }
    return _shapeLayerMountain;
}

#pragma mark - Public methods

-(void)removeMountainPosition
{
    self.mountainPercent = -1;
    self.mountainPointId = NULL;
}

- (void)animatePath:(UIBezierPath *)path
{
    CAShapeLayer *layer = self.shapeLayerMountain;
    self.maskMountain.path = path.CGPath;
    self.gradientMountain.frame = path.bounds;
    
    CAShapeLayer *maskLayer = self.maskMountain;
    
    layer.mask = maskLayer;
    
    CGPathRef oldPath = layer.path;
    CGPathRef newPath = path.CGPath;
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"path"];
    [animation setFromValue:(__bridge id)oldPath];
    [animation setToValue:(__bridge id)newPath];
    [animation setDuration:0.1];
    [animation setBeginTime:CACurrentMediaTime()];
    [animation setFillMode:kCAFillModeBackwards];
    [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear]];
    
    animation.removedOnCompletion = false; // don't remove after finishing
    
    [maskLayer addAnimation:animation forKey:@"path"];
    layer.path = newPath;
    
}

-(void)resetWave
{
    [self.shapeLayerMountain removeFromSuperlayer];
    _shapeLayerMountain = NULL;
    
    [self.gradientMountain removeFromSuperlayer];
    _gradientMountain = NULL;
    
    [self.maskMountain removeFromSuperlayer];
    _maskMountain = NULL;
    
    [self removeMountainPosition];
}

- (BOOL)belongsToPointId:(NSInteger)idPoint
{
    return self.mountainPointId && self.mountainPointId.integerValue == idPoint;
}


@end
