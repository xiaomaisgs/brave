//
//  ViewController.m
//  healthKit
//
//  Created by 张涛 on 16/7/7.
//  Copyright © 2016年 张涛. All rights reserved.
//

#import "ViewController.h"
#import "HealthKitManager.h"

@interface ViewController ()

@property (nonatomic, strong) NSMutableArray *stepsArray;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
     BOOL isAvailable = [[HealthKitManager shareHealthKit] isAvailable];
    __weak typeof(self) weakSelf = self;
    if (isAvailable) {
        [[HealthKitManager shareHealthKit] requestAutherizationReturnBack:^(BOOL autherStatus) {
            if (autherStatus) {
                [[HealthKitManager shareHealthKit] requestHealthStepCountReturnBack:^(NSMutableArray *steps) {
                    weakSelf.stepsArray = steps;
                    if (steps.count > 0 && steps != nil) {
                        NSLog(@"------%@",[steps firstObject]);
                    }
    
                }];
            }
        }];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSMutableArray *)stepsArray
{
    if (nil == _stepsArray) {
        _stepsArray = [NSMutableArray array];
    }
    return _stepsArray;
}

@end
