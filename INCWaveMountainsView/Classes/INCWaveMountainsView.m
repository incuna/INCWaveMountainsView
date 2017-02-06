//
//  INCWaveMountainsView.m
//  eDetailing
//
//  Created by Carlos Pages on 26/01/2017.
//  Copyright © 2017 IncunaLTD. All rights reserved.
//

#import "INCWaveMountainsView.h"

typedef NS_ENUM(NSInteger, INCMountainPosition){
    INCMountainPositionLeft,
    INCMountainPositionCenter,
    INCMountainPositionRight
};

@interface INCWaveMountainsView ()
{
    NSTimer *unblockLeftMountainTimer;
    NSTimer *unblockCentralMountainTimer;
    NSTimer *unblockRightMountainTimer;
}

//Left mountain
@property(nonatomic,strong)CAShapeLayer *shapeLayerLeftMountain;
@property(nonatomic,assign)float leftMountainPercent;
@property(atomic,strong)NSNumber *leftMountainPointId;
@property(nonatomic,strong)CAShapeLayer *maskLeftMountain;

//Central mountain
@property(nonatomic,strong)CAShapeLayer *shapeLayerCenterMountain;
@property(nonatomic,assign)float centerMountainPercent;
@property(atomic,strong)NSNumber *centerMountainPointId;
@property(nonatomic,strong)CAShapeLayer *maskCenterMountain;

//Right mountain
@property(nonatomic,strong)CAShapeLayer *shapeLayerRightMountain;
@property(nonatomic,assign)float rightMountainPercent;
@property(atomic,strong)NSNumber *rightMountainPointId;
@property(nonatomic,strong)CAShapeLayer *maskRightMountain;


@property(nonatomic,strong)NSMutableDictionary *percentReachFull;
@property(nonatomic,strong)UIBezierPath *backgroundPath;

@end


@implementation INCWaveMountainsView

#pragma mark - Paint Methods

static NSInteger MAX_COLUMNS = 3;

-(void)commonInit{
    self.unblockMontainsForMissingPercents = YES;
    
    self.leftMountainPercent = -1;
    self.centerMountainPercent = -1;
    self.rightMountainPercent = -1;
}

-(instancetype)init
{
    self = [super init];
    if (self) {
        [self commonInit];
    }
    return self;
}

-(instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder: aDecoder];
    if (self) {
        [self commonInit];
    }
    return self;
}

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self commonInit];
    }
    return self;
}

-(CAGradientLayer *)gradientLeftMountain
{
    if (!_gradientLeftMountain) {
        _gradientLeftMountain = [CAGradientLayer layer];
        
        _gradientLeftMountain.startPoint = CGPointMake(0, 0);
        _gradientLeftMountain.endPoint = CGPointMake(1, 0);
        NSArray *colors = @[(id)[UIColor colorWithRed:48.0/255.0 green:35.0/255.0 blue:174.0/255.0 alpha:0.4].CGColor, (id)[UIColor colorWithRed:180.0/255.0 green:236.0/255.0 blue:81.0/255.0 alpha:0.4].CGColor];
        _gradientLeftMountain.colors = colors;
    }
    return _gradientLeftMountain;
}

-(CAGradientLayer *)gradientCenterMountain
{
    if (!_gradientCenterMountain) {
        _gradientCenterMountain = [CAGradientLayer layer];
        
        _gradientCenterMountain.startPoint = CGPointMake(0, 0);
        _gradientCenterMountain.endPoint = CGPointMake(1, 0);
        NSArray *colors = @[(id)[UIColor colorWithRed:48.0/255.0 green:35.0/255.0 blue:174.0/255.0 alpha:0.4].CGColor, (id)[UIColor colorWithRed:180.0/255.0 green:236.0/255.0 blue:81.0/255.0 alpha:0.4].CGColor];
        _gradientCenterMountain.colors = colors;
    }
    return _gradientCenterMountain;
}

-(CAGradientLayer *)gradientRightMountain
{
    if (!_gradientRightMountain) {
        _gradientRightMountain = [CAGradientLayer layer];
        
        _gradientRightMountain.startPoint = CGPointMake(0, 0);
        _gradientRightMountain.endPoint = CGPointMake(1, 0);
        NSArray *colors = @[(id)[UIColor colorWithRed:48.0/255.0 green:35.0/255.0 blue:174.0/255.0 alpha:0.4].CGColor, (id)[UIColor colorWithRed:180.0/255.0 green:236.0/255.0 blue:81.0/255.0 alpha:0.4].CGColor];
        _gradientRightMountain.colors = colors;
    }
    return _gradientRightMountain;
}

-(CAShapeLayer *)maskLeftMountain
{
    if (!_maskLeftMountain) {
        _maskLeftMountain = [CAShapeLayer layer];
        _maskLeftMountain.fillColor = [UIColor whiteColor].CGColor;
    }
    return _maskLeftMountain;
}

-(CAShapeLayer *)maskCenterMountain
{
    if (!_maskCenterMountain) {
        _maskCenterMountain = [CAShapeLayer layer];
        _maskCenterMountain.fillColor = [UIColor whiteColor].CGColor;
    }
    return _maskCenterMountain;
}

-(CAShapeLayer *)maskRightMountain
{
    if (!_maskRightMountain) {
        _maskRightMountain = [CAShapeLayer layer];
        _maskRightMountain.fillColor = [UIColor whiteColor].CGColor;
    }
    return _maskRightMountain;
}

-(CAShapeLayer *)shapeLayerLeftMountain
{
    if (!_shapeLayerLeftMountain) {
        _shapeLayerLeftMountain = [[CAShapeLayer alloc]init];
#pragma mark pending to create external colours for change the mountains
        [_shapeLayerLeftMountain setFillColor:[UIColor clearColor].CGColor];
        [_shapeLayerLeftMountain addSublayer:self.gradientLeftMountain];

        [self.layer addSublayer:_shapeLayerLeftMountain];
    }
    return _shapeLayerLeftMountain;
}

-(CAShapeLayer *)shapeLayerCenterMountain
{
    if (!_shapeLayerCenterMountain) {
        _shapeLayerCenterMountain = [[CAShapeLayer alloc]init];
        
        [_shapeLayerCenterMountain setFillColor:[UIColor clearColor].CGColor];
        [_shapeLayerCenterMountain addSublayer:self.gradientCenterMountain];

        [self.layer addSublayer:_shapeLayerCenterMountain];
    }
    return _shapeLayerCenterMountain;
}

-(CAShapeLayer *)shapeLayerRightMountain
{
    if (!_shapeLayerRightMountain) {
        _shapeLayerRightMountain = [[CAShapeLayer alloc]init];
        
        [_shapeLayerRightMountain setFillColor:[UIColor clearColor].CGColor];
        [_shapeLayerRightMountain addSublayer:self.gradientRightMountain];

        [self.layer addSublayer:_shapeLayerRightMountain];
    }
    return _shapeLayerRightMountain;
}

-(NSMutableDictionary *)percentReachFull
{
    if (!_percentReachFull) {
        _percentReachFull = [[NSMutableDictionary alloc]init];
    }
    return _percentReachFull;
}

-(void)_removeThePointWithIdPoint:(NSInteger)idPoint inMountain:(INCMountainPosition)mountain
{
    //In order to reset the values we need to reset the values to 0 and then remove the point.
    
    __weak typeof(self) weakSelf = self;
    dispatch_group_t group = dispatch_group_create();
    
    dispatch_group_enter(group);
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        UIBezierPath *path = [self _pathWithIdPoint:idPoint percent:0 inMountain:mountain];
        if (path) {
            [self _animatePath:path inMountain:mountain];
        }
        dispatch_group_leave(group);
    });
    
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{

            [weakSelf _removeMountainPosition:mountain];
        });
    });
}

-(void)_removeMountainPosition:(INCMountainPosition)mountainPosition
{
    switch (mountainPosition) {
        case INCMountainPositionLeft:
            if (self.leftMountainPointId) {
                [self.percentReachFull setObject:@YES forKey:self.leftMountainPointId];
            }
            self.leftMountainPercent = -1;
            self.leftMountainPointId = NULL;
            break;
        
        case INCMountainPositionCenter:
            if (self.centerMountainPointId) {
                [self.percentReachFull setObject:@YES forKey:@(self.centerMountainPercent)];
            }
            self.centerMountainPercent = -1;
            self.centerMountainPointId = NULL;
            break;
            
        case INCMountainPositionRight:
            if (self.rightMountainPointId) {
                [self.percentReachFull setObject:@YES forKey:@(self.rightMountainPercent)];
            }
            self.rightMountainPercent = -1;
            self.rightMountainPointId = NULL;
            
            break;
    }
}

#pragma mark - Drawing functions

static float distanceBeetweenBackgroundLines = 10;
-(void)_drawBackgroundLinesInRect:(CGRect)rect withContext:(CGContextRef)context
{
    int numberOfLines = (rect.size.width / 10) - 1;//We substract one line because we don't want the line at the end
    
    CGContextSetStrokeColorWithColor(context, [UIColor colorWithRed:151.0/255.0 green:151.0/255.0 blue:151.0/255.0 alpha:0.11].CGColor);
    CGContextSetLineWidth(context, 1.0f);
    
    for (int i = 0; i < numberOfLines; i++) {
        
        float yPosLine = (float)(i + 1) * distanceBeetweenBackgroundLines;
        
        CGContextMoveToPoint(context, 0.0f, yPosLine); //start at this point
        
        CGContextAddLineToPoint(context, rect.size.width, yPosLine); //draw to this point
        
        // and now draw the Path!
    }
    CGContextStrokePath(context);

}

- (UIBezierPath *)_pathWithIdPoint:(NSInteger)idPoint percent:(float)percent inMountain:(INCMountainPosition)mountain
{
    int index = -1;
    
    CAShapeLayer *layer;
    switch (mountain) {
        case INCMountainPositionLeft:
            
            layer = self.shapeLayerLeftMountain;
            self.leftMountainPercent = percent;
            self.leftMountainPointId = @(idPoint);
            
            index = 0;
            break;
            
        case INCMountainPositionCenter:
            
            layer = self.shapeLayerCenterMountain;
            self.centerMountainPercent = percent;
            self.centerMountainPointId = @(idPoint);
            
            index = 1;
            break;
            
        case INCMountainPositionRight:
            
            layer = self.shapeLayerRightMountain;
            self.rightMountainPercent = percent;
            self.rightMountainPointId = @(idPoint);
            index = 2;
            
            break;
    }

    float height = self.bounds.size.height;

    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(0, height)];
        
    int widthForAPoint = self.bounds.size.width/MAX_COLUMNS;
    
    
    //First curve
    CGPoint finalPointCurve1 = CGPointMake(widthForAPoint * index + widthForAPoint/2, height - (height * percent));
    CGPoint controlPoint1Curve1 = CGPointZero;
    CGPoint controlPoint2Curve1 = CGPointZero;
    
    if (layer == self.shapeLayerLeftMountain) {
        controlPoint1Curve1 = CGPointMake((finalPointCurve1.x + 0)/2, (height + finalPointCurve1.y)/2);//The control point 1 is x and y are the equidistance point between the origin point and the final point
        controlPoint2Curve1 = CGPointMake(controlPoint1Curve1.x, finalPointCurve1.y);
    }
    if (layer == self.shapeLayerCenterMountain) {
        controlPoint1Curve1 = CGPointMake(widthForAPoint/2, height);//The control point 1 is x and y are the equidistance point between the origin point and the final point
        controlPoint2Curve1 = CGPointMake(finalPointCurve1.x - widthForAPoint/4, finalPointCurve1.y);
    }
    if (layer == self.shapeLayerRightMountain) {
        controlPoint1Curve1 = CGPointMake(self.bounds.size.width/2, height);//The control point 1 is x and y are the equidistance point between the origin point and the final point
        controlPoint2Curve1 = CGPointMake(finalPointCurve1.x - (self.bounds.size.width - finalPointCurve1.x) / 2, finalPointCurve1.y);
    }
    [path addCurveToPoint:finalPointCurve1 controlPoint1:controlPoint1Curve1 controlPoint2:controlPoint2Curve1];
    
    
    //Second curve
    CGPoint finalPointCurve2 = CGPointMake(self.bounds.size.width, height);
    CGPoint controlPoint1Curve2 = CGPointZero;
    CGPoint controlPoint2Curve2 = CGPointZero;
    if (layer == self.shapeLayerLeftMountain) {
        controlPoint1Curve2 = CGPointMake(finalPointCurve1.x + (finalPointCurve1.x - controlPoint2Curve1.x), finalPointCurve1.y);
        controlPoint2Curve2 = CGPointMake(self.bounds.size.width/2,finalPointCurve2.y);
    }
    if (layer == self.shapeLayerCenterMountain) {
        controlPoint1Curve2 = CGPointMake(finalPointCurve1.x + widthForAPoint/4, finalPointCurve1.y);
        controlPoint2Curve2 = CGPointMake(self.bounds.size.width - widthForAPoint/2,finalPointCurve2.y);
    }
    if (layer == self.shapeLayerRightMountain) {
        controlPoint1Curve2 = CGPointMake(finalPointCurve1.x + (finalPointCurve1.x - controlPoint2Curve1.x), finalPointCurve1.y);//The control point 1 is x and y are the equidistance point between the origin point and the final point
        controlPoint2Curve2 = CGPointMake(controlPoint1Curve2.x, (height + finalPointCurve1.y)/2);
    }
    [path addCurveToPoint:finalPointCurve2 controlPoint1:controlPoint1Curve2 controlPoint2:controlPoint2Curve2];
    
    [path addLineToPoint:CGPointMake(0, height)];
        
    [path closePath];
    
    return path;
}

- (void)_animatePath:(UIBezierPath *)path inMountain:(INCMountainPosition)mountainPosition
{
    CAShapeLayer *maskLayer;
    CAShapeLayer *layer;
    switch (mountainPosition) {
        case INCMountainPositionLeft:
            
            layer = self.shapeLayerLeftMountain;
            self.maskLeftMountain.path = path.CGPath;
            self.gradientLeftMountain.frame = path.bounds;
            
            maskLayer = self.maskLeftMountain;
            break;
            
        case INCMountainPositionCenter:
            
            layer = self.shapeLayerCenterMountain;
            self.maskCenterMountain.path = path.CGPath;
            self.gradientCenterMountain.frame = path.bounds;
            
            maskLayer = self.maskCenterMountain;
            
            break;
            
        case INCMountainPositionRight:
            
            layer = self.shapeLayerRightMountain;
            self.maskRightMountain.path = path.CGPath;
            self.gradientRightMountain.frame = path.bounds;
            
            maskLayer = self.maskRightMountain;
            
            break;
    }
    
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


-(void)_drawPercent:(float)percent forIdPoint:(NSInteger)idPoint inMountain:(INCMountainPosition)mountain{
    
    UIBezierPath *path = [self _pathWithIdPoint:idPoint percent:percent inMountain:mountain];
    if (!path) {
        return;
    }
    [self _animatePath:path inMountain:mountain];
    
    if (percent == 1) {
        [self _removeThePointWithIdPoint:idPoint inMountain:mountain];
    }
}

#pragma mark - unblock timers

- (void)timerFireMethod:(NSTimer *)timer
{
    if (timer == unblockLeftMountainTimer) {
        [self _removeMountainPosition:INCMountainPositionLeft];
    }
    
    if (timer == unblockCentralMountainTimer) {
        [self _removeMountainPosition:INCMountainPositionCenter];
    }
    
    if (timer == unblockRightMountainTimer) {
        [self _removeMountainPosition:INCMountainPositionRight];
    }
    
    [timer invalidate];
}

static NSTimeInterval unblockTimeInterval = 5;
-(void)_setUpUnblockTimerForTimer:(NSTimer *__strong *)timer
{
    if (!timer || !self.unblockMontainsForMissingPercents) {
        return;
    }
    
    if(*timer)
    {
        [*timer invalidate];
        *timer = NULL;
    }
    
    *timer = [NSTimer scheduledTimerWithTimeInterval:unblockTimeInterval target:self selector:@selector(timerFireMethod:) userInfo:NULL repeats:NO];
}

#pragma mark - Draw mountains

-(void)_drawForLeftMountainPercent:(float)percent forIdPoint:(NSInteger)idPoint
{
    if (percent > self.leftMountainPercent) {
        [self _setUpUnblockTimerForTimer:&unblockLeftMountainTimer];
        [self _drawPercent:percent forIdPoint:idPoint inMountain:INCMountainPositionLeft];
    }
}

-(void)_drawForCenterMountainPercent:(float)percent forIdPoint:(NSInteger)idPoint
{
    if (percent > self.centerMountainPercent) {
        [self _setUpUnblockTimerForTimer:&unblockCentralMountainTimer];
        [self _drawPercent:percent forIdPoint:idPoint inMountain:INCMountainPositionCenter];
    }
}

-(void)_drawForRightMountainPercent:(float)percent forIdPoint:(NSInteger)idPoint
{
    if (percent > self.rightMountainPercent) {
        [self _setUpUnblockTimerForTimer:&unblockRightMountainTimer];
        [self _drawPercent:percent forIdPoint:idPoint inMountain:INCMountainPositionRight];
    }
}


#pragma mark - Public methods

-(void)resetWaves
{
    [self.shapeLayerLeftMountain removeFromSuperlayer];
    self.shapeLayerLeftMountain = NULL;
    
    [self.gradientLeftMountain removeFromSuperlayer];
    _gradientLeftMountain = NULL;
    
    [self.maskLeftMountain removeFromSuperlayer];
    self.maskLeftMountain = NULL;
    
    [self.shapeLayerCenterMountain removeFromSuperlayer];
    self.shapeLayerCenterMountain = NULL;

    [self.maskCenterMountain removeFromSuperlayer];
    self.maskCenterMountain = NULL;
    
    [self.gradientCenterMountain removeFromSuperlayer];
    _gradientCenterMountain = NULL;
    
    [self.shapeLayerRightMountain removeFromSuperlayer];
    self.shapeLayerRightMountain = NULL;
    
    [self.maskRightMountain removeFromSuperlayer];
    self.maskRightMountain = NULL;
    
    [self.gradientRightMountain removeFromSuperlayer];
    _gradientRightMountain = NULL;
    
    [unblockLeftMountainTimer invalidate];
    [unblockCentralMountainTimer invalidate];
    [unblockRightMountainTimer invalidate];
    
    [self _removeMountainPosition:INCMountainPositionLeft];
    [self _removeMountainPosition:INCMountainPositionCenter];
    [self _removeMountainPosition:INCMountainPositionRight];
    
    
}

-(void)drawPercent:(float)percent forIdPoint:(NSInteger)idPoint
{
    if (self.percentReachFull[@(idPoint)] || percent < 0 || percent > 1) {
        //If the point was already shown as full or the percent is no positive we don't do anything
        return;
    }
    
    if (self.leftMountainPointId && self.leftMountainPointId.integerValue == idPoint) {
        [self _drawForLeftMountainPercent:percent forIdPoint:idPoint];
        return;
    }
    
    if (self.centerMountainPointId && self.centerMountainPointId.integerValue == idPoint) {
        [self _drawForCenterMountainPercent:percent forIdPoint:idPoint];
        return;
    }
    
    if (self.rightMountainPointId && self.rightMountainPointId.integerValue == idPoint) {
        [self _drawForRightMountainPercent:percent forIdPoint:idPoint];
        return;
    }
    
    
    if (!self.leftMountainPointId) {
        [self _drawForLeftMountainPercent:percent forIdPoint:idPoint];
        return;
    }
        
    if (!self.centerMountainPointId) {
        [self _drawForCenterMountainPercent:percent forIdPoint:idPoint];
        return;
    }
    
    if (!self.rightMountainPointId) {
        [self _drawForRightMountainPercent:percent forIdPoint:idPoint];
        return;
    }
}

#pragma mark - View Draw Method

-(void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    [self _drawBackgroundLinesInRect:rect withContext:context];
}



@end
