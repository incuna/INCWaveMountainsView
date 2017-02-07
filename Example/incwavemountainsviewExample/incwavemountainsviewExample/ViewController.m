//
//  ViewController.m
//  incwavemountainsviewExample
//
//  Created by Carlos Pages on 07/02/2017.
//  Copyright © 2017 Incuna. All rights reserved.
//

#import "ViewController.h"
#import "INCWaveMountainsView.h"

@interface ViewController ()
{
    NSInteger idPoint1;
    NSInteger idPoint2;
    NSInteger idPoint3;
    
    float percentIdPoint1;
    float percentIdPoint2;
    float percentIdPoint3;
}

@property (strong, nonatomic) IBOutlet INCWaveMountainsView *waveMountainsView;

@property (strong, nonatomic)NSTimer *timer;



@property (nonatomic,assign)NSInteger timerCounter;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    idPoint1 = 1;
    idPoint2 = 2;
    idPoint3 = 3;
    
    percentIdPoint1 = 0;
    percentIdPoint2 = 0;
    percentIdPoint3 = 0;
    
    self.timerCounter = 0;
    
    __weak typeof(self) weakSelf = self;
    self.timer = [NSTimer scheduledTimerWithTimeInterval:0.1 repeats:YES block:^(NSTimer * _Nonnull timer) {
       
        percentIdPoint1 += 0.1;
        percentIdPoint2 += 0.2;
        percentIdPoint3 += 0.5;
        
        [weakSelf.waveMountainsView drawPercent:percentIdPoint1 forIdPoint:idPoint1];
        [weakSelf.waveMountainsView drawPercent:percentIdPoint2 forIdPoint:idPoint2];
        [weakSelf.waveMountainsView drawPercent:percentIdPoint3 forIdPoint:idPoint3];
        
        [self checkPoint:&idPoint1 withPercent:&percentIdPoint1];

        [self checkPoint:&idPoint2 withPercent:&percentIdPoint2];
        
        [self checkPoint:&idPoint3 withPercent:&percentIdPoint3];

        weakSelf.timerCounter++;
        if (weakSelf.timerCounter == 30) {
            [timer invalidate];
            NSLog(@"End of timer");
        }
        
    }];
    
}

-(void)checkPoint:(NSInteger *)idPoint withPercent:(float *)percent
{
    if (*percent >= 1) {
        *idPoint += 3;
        *percent = 0;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
