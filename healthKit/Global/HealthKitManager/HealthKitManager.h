//
//  HealthKitManager.h
//  healthKit
//
//  Created by 张涛 on 16/7/7.
//  Copyright © 2016年 张涛. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HealthKitManager : NSObject

+ (instancetype)shareHealthKit;

- (BOOL)isAvailable;

- (void)requestAutherizationReturnBack:(void(^)(BOOL autherStatus))hanler;

//获取步数
- (void)requestHealthStepCountReturnBack:(void(^)(NSMutableArray *))stepsCountHandler;

@end
