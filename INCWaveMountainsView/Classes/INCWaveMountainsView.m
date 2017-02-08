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

@interface INCWaveMountainsView ()<INCWavwMountainLayerDelegate>

//Left mountain
@property(nonatomic,strong)INCWaveMountainLayer *leftMountain;

//Central mountain
@property(nonatomic,strong)INCWaveMountainLayer *centerMountain;

//Right mountain
@property(nonatomic,strong)INCWaveMountainLayer *rightMountain;

@property(nonatomic,strong)NSMutableDictionary <NSNumber *,NSNumber *>*percentReachFull;
@property(nonatomic,strong)UIBezierPath *backgroundPath;
@property(nonatomic,strong)NSDictionary <NSNumber *,NSNumber *>*indexDict;

@end

@implementation INCWaveMountainsView

#pragma mark - Paint Methods

static NSInteger MAX_COLUMNS = 3;

-(void)commonInit{
    self.unblockMontainsForMissingPercents = YES;
    self.indexDict = @{@(INCMountainPositionLeft):@0,
                       @(INCMountainPositionCenter):@1,
                       @(INCMountainPositionRight):@2};
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

-(void)setUnblockMontainsForMissingPercents:(BOOL)unblockMontainsForMissingPercents
{
    if (_unblockMontainsForMissingPercents != unblockMontainsForMissingPercents) {
        _unblockMontainsForMissingPercents = unblockMontainsForMissingPercents;
        
        _leftMountain.unblockMontainsForMissingPercents = _unblockMontainsForMissingPercents;
        _centerMountain.unblockMontainsForMissingPercents = _unblockMontainsForMissingPercents;
        _rightMountain.unblockMontainsForMissingPercents = _unblockMontainsForMissingPercents;
    }
}

-(void)_initialSetUpMountain:(INCWaveMountainLayer *)mountain
{
    if (mountain) {
        [mountain setFillColor:[UIColor clearColor].CGColor];
        [mountain setDelegate:self];
        [mountain setUnblockMontainsForMissingPercents:self.unblockMontainsForMissingPercents];
    }

}

-(INCWaveMountainLayer *)leftMountain
{
    if (!_leftMountain) {
        _leftMountain = [[INCWaveMountainLayer alloc]init];
        [self _initialSetUpMountain:_leftMountain];
        [self.layer addSublayer:_leftMountain];
    }
    return _leftMountain;
}

-(INCWaveMountainLayer *)centerMountain
{
    if (!_centerMountain) {
        _centerMountain = [[INCWaveMountainLayer alloc]init];
        [self _initialSetUpMountain:_centerMountain];
        [self.layer addSublayer:_centerMountain];
    }
    return _centerMountain;
}

-(INCWaveMountainLayer *)rightMountain
{
    if (!_rightMountain) {
        _rightMountain = [[INCWaveMountainLayer alloc]init];
        [self _initialSetUpMountain:_rightMountain];
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

#pragma mark - Other Private methods

-(void)_resetByReachingMaximumMountainLayer:(INCWaveMountainLayer *)mountainLayer
{
    [mountainLayer resetMountainPosition];
    if (mountainLayer.mountainId) {
        [self.percentReachFull setObject:@YES forKey:mountainLayer.mountainId];
    }
}

-(void)_removeThePointWithIdPoint:(NSInteger)idPoint inMountainLayer:(INCWaveMountainLayer *)mountainLayer inMountainPosition:(INCMountainPosition)mountainPosition later:(NSTimeInterval)laterTime
{
    //In order to reset the values we need to reset the values to 0 and then remove the point.
    if (laterTime > 0) {
        __weak typeof(self) weakSelf = self;
        dispatch_group_t group = dispatch_group_create();
        
        dispatch_group_enter(group);
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [weakSelf _animateIdPoint:idPoint withPercent:0 inMountainLayer:mountainLayer andInPosition:mountainPosition];
            dispatch_group_leave(group);
        });
        
        dispatch_group_notify(group, dispatch_get_main_queue(), ^{
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [weakSelf _resetByReachingMaximumMountainLayer:mountainLayer];
            });
        });
    }
    else{
        [self _animateIdPoint:idPoint withPercent:0 inMountainLayer:mountainLayer andInPosition:mountainPosition];
        [self _resetByReachingMaximumMountainLayer:mountainLayer];
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

//For now this method remains in the view
- (UIBezierPath *)_pathWithIdPoint:(NSInteger)idPoint percent:(float)percent inMountainLayer:(INCWaveMountainLayer *)mountainLayer inMountainPosition:(INCMountainPosition)mountainPosition
{
    int index = [self.indexDict[@(mountainPosition)] intValue];
    
    mountainLayer.mountainPercent = percent;
    mountainLayer.mountainId = @(idPoint);
    
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
    
    switch (mountainPosition) {
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

-(void)_animateIdPoint:(NSInteger)idPoint withPercent:(float)percent inMountainLayer:(INCWaveMountainLayer *)mountainLayer andInPosition:(INCMountainPosition)mountainPosition
{
    UIBezierPath *path = [self _pathWithIdPoint:idPoint percent:percent inMountainLayer:mountainLayer inMountainPosition:mountainPosition];
    if (path) {
        [mountainLayer animatePath:path];
    }
}

-(void)_drawPercent:(float)percent forIdPoint:(NSInteger)idPoint inMountainLayer:(INCWaveMountainLayer *)mountainLayer inMountainPosition:(INCMountainPosition)mountainPosition{
    
    [self _animateIdPoint:idPoint withPercent:percent inMountainLayer:mountainLayer andInPosition:mountainPosition];
    
    if (percent == 1) {
        //We need to do it later because we just animated the point so the view need to have time to refresh.
        [self _removeThePointWithIdPoint:idPoint inMountainLayer:mountainLayer inMountainPosition:mountainPosition later:0.1];
    }
}

#pragma mark - Draw mountains

-(void)_drawMountainForPercent:(float)percent forIdPoint:(NSInteger)idPoint inMountainLayer:(INCWaveMountainLayer *)mountainLayer inMountainPosition:(INCMountainPosition)mountainPosition
{
    if (percent > mountainLayer.mountainPercent) {
        [mountainLayer setUpUnblockTimer];
        [self _drawPercent:percent forIdPoint:idPoint inMountainLayer:mountainLayer inMountainPosition:mountainPosition];
    }
}

#pragma mark - Public methods

-(void)resetWaves
{
    [self.leftMountain resetWave];
    [self.centerMountain resetWave];
    [self.rightMountain resetWave];
    
    [self.leftMountain removeFromSuperlayer];
    self.leftMountain = NULL;
    
    [self.centerMountain removeFromSuperlayer];
    self.centerMountain = NULL;
    
    [self.rightMountain removeFromSuperlayer];
    self.rightMountain = NULL;
    
    self.percentReachFull = [@{} mutableCopy];
}

-(void)drawPercent:(float)percent forIdPoint:(NSInteger)idPoint
{
    if (self.percentReachFull[@(idPoint)] || percent < 0) {
        //If the point was already shown as full or the percent is no positive we don't do anything
        return;
    }
    
    if (percent > 1) {
        percent = 1;
    }
    
    if ([self.leftMountain belongsToPointId:idPoint]) {
        [self _drawMountainForPercent:percent forIdPoint:idPoint inMountainLayer:self.leftMountain inMountainPosition:INCMountainPositionLeft];
        return;
    }
    
    if ([self.centerMountain belongsToPointId:idPoint]) {
        [self _drawMountainForPercent:percent forIdPoint:idPoint inMountainLayer:self.centerMountain inMountainPosition:INCMountainPositionCenter];
        return;
    }
    
    if ([self.rightMountain belongsToPointId:idPoint]) {
        [self _drawMountainForPercent:percent forIdPoint:idPoint inMountainLayer:self.rightMountain inMountainPosition:INCMountainPositionRight];
        return;
    }
    
    if (!self.leftMountain.mountainId) {
        [self _drawMountainForPercent:percent forIdPoint:idPoint inMountainLayer:self.leftMountain inMountainPosition:INCMountainPositionLeft];
        return;
    }
        
    if (!self.centerMountain.mountainId) {
        [self _drawMountainForPercent:percent forIdPoint:idPoint inMountainLayer:self.centerMountain inMountainPosition:INCMountainPositionCenter];
        return;
    }
    
    if (!self.rightMountain.mountainId) {
        [self _drawMountainForPercent:percent forIdPoint:idPoint inMountainLayer:self.rightMountain inMountainPosition:INCMountainPositionRight];
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

#pragma mark - INCWavwMountainLayerDelegate


-(void)layerResetByTimeOut:(nonnull INCWaveMountainLayer *)layer
{
    if (layer.mountainId) {
        [self.percentReachFull setObject:@YES forKey:layer.mountainId];
    }
}

@end
