//
//  HealthKitManager.m
//  healthKit
//
//  Created by 张涛 on 16/7/7.
//  Copyright © 2016年 张涛. All rights reserved.
//

#import "HealthKitManager.h"
#import <HealthKit/HealthKit.h>

@interface HealthKitManager ()

@property (nonatomic, strong) HKHealthStore *hkHealthStore;

@end

static HealthKitManager *_healthKitManager = nil;
@implementation HealthKitManager


+ (instancetype)shareHealthKit
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (nil == _healthKitManager) {
            _healthKitManager = [[HealthKitManager alloc] init];
        }
    });
    return _healthKitManager;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (BOOL)isAvailable
{
    return [HKHealthStore isHealthDataAvailable];
}

- (void)requestAutherizationReturnBack:(void(^)(BOOL autherStatus))hanler
{
    NSSet *readObjectTypes = [NSSet setWithObjects:[HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierStepCount], nil];
    [self.hkHealthStore requestAuthorizationToShareTypes:nil readTypes:readObjectTypes completion:^(BOOL success, NSError * _Nullable error) {
        if (success) {
            //授权成功
            
        }else{
            //授权失败
        }
        hanler(success);
    }];
}

//获取步数
- (void)requestHealthStepCountReturnBack:(void(^)(NSMutableArray *))stepsCountHandler
{
    HKSampleType *sampleType = [HKSampleType quantityTypeForIdentifier:HKQuantityTypeIdentifierStepCount];
    NSPredicate *predicate = [HKQuery predicateForSamplesWithStartDate:nil endDate:nil options:HKQueryOptionStrictStartDate];
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:HKSampleSortIdentifierStartDate ascending:YES];
    HKSampleQuery *sampleQuery = [[HKSampleQuery alloc] initWithSampleType:sampleType predicate:predicate limit:HKObjectQueryNoLimit sortDescriptors:@[sortDescriptor] resultsHandler:^(HKSampleQuery * _Nonnull query, NSArray<__kindof HKSample *> * _Nullable results, NSError * _Nullable error) {
        if (!error && results) {
            NSMutableArray *stepTempArray = [NSMutableArray array];
            for (HKQuantitySample *samples in results) {
                [stepTempArray addObject:samples.quantity];
             NSLog(@"%@ 至 %@ ：%@",samples.startDate,samples.endDate,samples.quantity);
            }
            stepsCountHandler(stepTempArray);
        }else{
            
        }
    }];
    [self.hkHealthStore executeQuery:sampleQuery];
    
}

//lazy load
- (HKHealthStore *)hkHealthStore
{
    if (nil == _hkHealthStore) {
        _hkHealthStore = [[HKHealthStore alloc] init];
    }
    return _hkHealthStore;
}

@end
