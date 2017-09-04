//
//  TKDataAnalysisCategory.m
//  TKDataAnalysis
//
//  Created by 云峰李 on 2017/8/31.
//  Copyright © 2017年 512869343@qq.com. All rights reserved.
//


#import "TKDataAnalysis.h"
#import <TKMiddleware/TKMiddleware.h>

static NSString* const kDataAnalysisTarget = @"DataAnalysis";

static NSString* const kUserIdentifier = @"Identifier";
static NSString* const kUserValue = @"userValue";
static NSString* const kUserKey = @"userKey";

static NSString* const kLogFlag = @"logFlag";
static NSString* const kLogMessage = @"logMessage";

@implementation TKDataAnalysis

+ (void)initializationReportManager:(NSDictionary *)params
{
    [TKMiddleWareMgr performTarget:kDataAnalysisTarget
                            action:@"initReportManager"
                            params:params
                 shouldCacheTarget:YES];
}

/**
 崩溃日志的用户标识，用来区分
 
 @param identifier 标识
 */
+ (void)setUserIdentifier:(NSString *)identifier
{
    NSParameterAssert(identifier);
    [TKMiddleWareMgr performTarget:kDataAnalysisTarget
                            action:@"setUserIdentifier"
                            params:@{kUserIdentifier:identifier}
                 shouldCacheTarget:YES];
}

/**
 当前崩溃时，一同传递到后台的信息
 
 @param value 数据
 @param key key
 */
+ (void)setCrashUserValue:(NSString *)value forKey:(NSString *)key
{
    NSParameterAssert(value);
    NSParameterAssert(key);
    [TKMiddleWareMgr performTarget:kDataAnalysisTarget
                            action:@"setUserValueWithKey"
                            params:@{kUserValue:value,
                                     kUserKey:key}
                 shouldCacheTarget:YES];
}

+ (void)initializationWithConfig:(NSDictionary *)config
{
    [TKMiddleWareMgr performTarget:kDataAnalysisTarget
                            action:@"initLogWithConfig"
                            params:config
                 shouldCacheTarget:YES];
}

+ (void)logWithFlag:(TKLOGFLAG) flag format:(NSString *)format,...
{
    va_list args;
    if (format) {
        va_start(args, format);
        NSString *message = [[NSString alloc] initWithFormat:format arguments:args];
        va_end(args);
        
        va_start(args, format);
        [TKMiddleWareMgr performTarget:kDataAnalysisTarget
                                action:@"logWithFlagAndMessage"
                                params:@{kLogFlag : @(flag),
                                         kLogMessage : message}
                     shouldCacheTarget:YES];
        va_end(args);
    }
}

@end
