//
//  INCWaveMountainsView.m
//  eDetailing
//
//  Created by Carlos Pages on 26/01/2017.
//  Copyright © 2017 IncunaLTD. All rights reserved.
//

#import "INCWaveMountainsView.h"
#import "INCWaveMountainLayer.h"

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
@property(nonatomic,strong)INCWaveMountainLayer *leftMountain;


//Central mountain
@property(nonatomic,strong)INCWaveMountainLayer *centerMountain;

//Right mountain
@property(nonatomic,strong)INCWaveMountainLayer *rightMountain;


@property(nonatomic,strong)NSMutableDictionary *percentReachFull;
@property(nonatomic,strong)UIBezierPath *backgroundPath;

@end


@implementation INCWaveMountainsView

#pragma mark - Paint Methods

static NSInteger MAX_COLUMNS = 3;

-(void)commonInit{
    self.unblockMontainsForMissingPercents = YES;
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

-(INCWaveMountainLayer *)leftMountain
{
    if (!_leftMountain) {
        _leftMountain = [[INCWaveMountainLayer alloc]init];
        _leftMountain.fillColor = [UIColor clearColor].CGColor;

        [self.layer addSublayer:_leftMountain];
    }
    return _leftMountain;
}

-(INCWaveMountainLayer *)centerMountain
{
    if (!_centerMountain) {
        _centerMountain = [[INCWaveMountainLayer alloc]init];
        _centerMountain.fillColor = [UIColor clearColor].CGColor;
        
        [self.layer addSublayer:_centerMountain];
    }
    return _centerMountain;
}

-(INCWaveMountainLayer *)rightMountain
{
    if (!_rightMountain) {
        _rightMountain = [[INCWaveMountainLayer alloc]init];
        _rightMountain.fillColor = [UIColor clearColor].CGColor;
        
        [self.layer addSublayer:_rightMountain];
    }
    return _rightMountain;
}


-(CAGradientLayer *)gradientLeftMountain
{
    return self.leftMountain.gradientMountain;
}

-(void)setGradientLeftMountain:(CAGradientLayer *)gradientLeftMountain
{
    [self.leftMountain setGradientMountain:gradientLeftMountain];
}

-(CAGradientLayer *)gradientCenterMountain
{
    return self.centerMountain.gradientMountain;
}

-(void)setGradientCenterMountain:(CAGradientLayer *)gradientCenterMountain
{
    [self.centerMountain setGradientMountain:gradientCenterMountain];
}

-(CAGradientLayer *)gradientRightMountain
{
    return self.rightMountain.gradientMountain;
}

-(void)setGradientRightMountain:(CAGradientLayer *)gradientRightMountain
{
    [self.rightMountain setGradientMountain:gradientRightMountain];
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
    INCWaveMountainLayer *mountain;
    switch (mountainPosition) {
        case INCMountainPositionLeft:
            mountain = self.leftMountain;
            break;
        
        case INCMountainPositionCenter:
            mountain = self.centerMountain;
            break;
            
        case INCMountainPositionRight:
            mountain = self.rightMountain;
            break;
    }
    if (mountain.mountainPointId) {
        [self.percentReachFull setObject:@YES forKey:mountain.mountainPointId];
    }
    [mountain removeMountainPosition];
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

//For now this method remains in the view
- (UIBezierPath *)_pathWithIdPoint:(NSInteger)idPoint percent:(float)percent inMountain:(INCMountainPosition)mountain
{
    int index = -1;
    INCWaveMountainLayer *mountainLayer;

    CAShapeLayer *layer;
    switch (mountain) {
        case INCMountainPositionLeft:
            
            mountainLayer = self.leftMountain;
            index = 0;
            break;
            
        case INCMountainPositionCenter:
            
            mountainLayer = self.centerMountain;
            index = 1;
            break;
            
        case INCMountainPositionRight:
            
            mountainLayer = self.rightMountain;
            index = 2;
            break;
    }
    
    layer = mountainLayer.shapeLayerMountain;
    mountainLayer.mountainPercent = percent;
    mountainLayer.mountainPointId = @(idPoint);
    

    float height = self.bounds.size.height;

    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(0, height)];
        
    int widthForAPoint = self.bounds.size.width/MAX_COLUMNS;
    
    
    //First curve
    CGPoint finalPointCurve1 = CGPointMake(widthForAPoint * index + widthForAPoint/2, height - (height * percent));
    CGPoint controlPoint1Curve1 = CGPointZero;
    CGPoint controlPoint2Curve1 = CGPointZero;
    
    //Second curve
    CGPoint finalPointCurve2 = CGPointMake(self.bounds.size.width, height);
    CGPoint controlPoint1Curve2 = CGPointZero;
    CGPoint controlPoint2Curve2 = CGPointZero;
    
    switch (mountain) {
        case INCMountainPositionLeft:
            controlPoint1Curve1 = CGPointMake((finalPointCurve1.x + 0)/2, (height + finalPointCurve1.y)/2);//The control point 1 is x and y are the equidistance point between the origin point and the final point
            controlPoint2Curve1 = CGPointMake(controlPoint1Curve1.x, finalPointCurve1.y);
            
            controlPoint1Curve2 = CGPointMake(finalPointCurve1.x + (finalPointCurve1.x - controlPoint2Curve1.x), finalPointCurve1.y);
            controlPoint2Curve2 = CGPointMake(self.bounds.size.width/2,finalPointCurve2.y);
            break;
            
        case INCMountainPositionCenter:
            controlPoint1Curve1 = CGPointMake(widthForAPoint/2, height);//The control point 1 is x and y are the equidistance point between the origin point and the final point
            controlPoint2Curve1 = CGPointMake(finalPointCurve1.x - widthForAPoint/4, finalPointCurve1.y);
            
            controlPoint1Curve2 = CGPointMake(finalPointCurve1.x + widthForAPoint/4, finalPointCurve1.y);
            controlPoint2Curve2 = CGPointMake(self.bounds.size.width - widthForAPoint/2,finalPointCurve2.y);
            break;
            
        case INCMountainPositionRight:
        
            controlPoint1Curve1 = CGPointMake(self.bounds.size.width/2, height);//The control point 1 is x and y are the equidistance point between the origin point and the final point
            controlPoint2Curve1 = CGPointMake(finalPointCurve1.x - (self.bounds.size.width - finalPointCurve1.x) / 2, finalPointCurve1.y);
            
            controlPoint1Curve2 = CGPointMake(finalPointCurve1.x + (finalPointCurve1.x - controlPoint2Curve1.x), finalPointCurve1.y);//The control point 1 is x and y are the equidistance point between the origin point and the final point
            controlPoint2Curve2 = CGPointMake(controlPoint1Curve2.x, (height + finalPointCurve1.y)/2);
            break;
    }
    [path addCurveToPoint:finalPointCurve1 controlPoint1:controlPoint1Curve1 controlPoint2:controlPoint2Curve1];
    
    [path addCurveToPoint:finalPointCurve2 controlPoint1:controlPoint1Curve2 controlPoint2:controlPoint2Curve2];
    
    [path addLineToPoint:CGPointMake(0, height)];
        
    [path closePath];
    
    return path;
}

- (void)_animatePath:(UIBezierPath *)path inMountain:(INCMountainPosition)mountainPosition
{
    switch (mountainPosition) {
        case INCMountainPositionLeft:
            
            [self.leftMountain animatePath:path];
            break;
            
        case INCMountainPositionCenter:
            
            [self.centerMountain animatePath:path];
            break;
            
        case INCMountainPositionRight:
            
            [self.rightMountain animatePath:path];
            break;
    }
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
    if (percent > self.leftMountain.mountainPercent) {
        [self _setUpUnblockTimerForTimer:&unblockLeftMountainTimer];
        [self _drawPercent:percent forIdPoint:idPoint inMountain:INCMountainPositionLeft];
    }
}

-(void)_drawForCenterMountainPercent:(float)percent forIdPoint:(NSInteger)idPoint
{
    if (percent > self.centerMountain.mountainPercent) {
        [self _setUpUnblockTimerForTimer:&unblockCentralMountainTimer];
        [self _drawPercent:percent forIdPoint:idPoint inMountain:INCMountainPositionCenter];
    }
}

-(void)_drawForRightMountainPercent:(float)percent forIdPoint:(NSInteger)idPoint
{
    if (percent > self.rightMountain.mountainPercent) {
        [self _setUpUnblockTimerForTimer:&unblockRightMountainTimer];
        [self _drawPercent:percent forIdPoint:idPoint inMountain:INCMountainPositionRight];
    }
}


#pragma mark - Public methods

-(void)resetWaves
{
    [self.leftMountain resetWave];
    [self.centerMountain resetWave];
    [self.rightMountain resetWave];
    
    [unblockLeftMountainTimer invalidate];
    [unblockCentralMountainTimer invalidate];
    [unblockRightMountainTimer invalidate];
    
    [self _removeMountainPosition:INCMountainPositionLeft];
    [self _removeMountainPosition:INCMountainPositionCenter];
    [self _removeMountainPosition:INCMountainPositionRight];
    
    [self.leftMountain removeFromSuperlayer];
    self.leftMountain = NULL;
    
    [self.centerMountain removeFromSuperlayer];
    self.centerMountain = NULL;
    
    [self.rightMountain removeFromSuperlayer];
    self.rightMountain = NULL;
}

-(void)drawPercent:(float)percent forIdPoint:(NSInteger)idPoint
{
    if (self.percentReachFull[@(idPoint)] || percent < 0 || percent > 1) {
        //If the point was already shown as full or the percent is no positive we don't do anything
        return;
    }
    
    if ([self.leftMountain belongsToPointId:idPoint]) {
        [self _drawForLeftMountainPercent:percent forIdPoint:idPoint];
        return;
    }
    
    if ([self.centerMountain belongsToPointId:idPoint]) {
        [self _drawForCenterMountainPercent:percent forIdPoint:idPoint];
        return;
    }
    
    if ([self.rightMountain belongsToPointId:idPoint]) {
        [self _drawForRightMountainPercent:percent forIdPoint:idPoint];
        return;
    }
    
    
    if (!self.leftMountain.mountainPointId) {
        [self _drawForLeftMountainPercent:percent forIdPoint:idPoint];
        return;
    }
        
    if (!self.centerMountain.mountainPointId) {
        [self _drawForCenterMountainPercent:percent forIdPoint:idPoint];
        return;
    }
    
    if (!self.rightMountain.mountainPointId) {
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
