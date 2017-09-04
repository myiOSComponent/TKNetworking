//
//  TKDataAnalysisCategory.h
//  TKDataAnalysis
//
//  Created by 云峰李 on 2017/8/31.
//  Copyright © 2017年 512869343@qq.com. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_OPTIONS(NSUInteger, TKLOGFLAG) {
    TKLOGFLAG_ERROR     = (1 << 0),
    
    TKLOGFLAG_WARING    = (1 << 1),
    
    TKLOGFLAG_INFO      = (1 << 2),
    
    TKLOGFLAG_DEBUG     = (1 << 3),
    
    TKLOGFLAG_VERBOSE   = (1 << 4)
};

#define TKLogError(frmt, ...)   [TKDataAnalysis logWithFlag:TKLOGFLAG_ERROR format: frmt, ##__VA_ARGS__]
#define TKLogWarn(frmt, ...)   [TKDataAnalysis logWithFlag:TKLOGFLAG_WARING format: frmt, ##__VA_ARGS__]
#define TKLogInfo(frmt, ...)   [TKDataAnalysis logWithFlag:TKLOGFLAG_INFO format: frmt, ##__VA_ARGS__]
#define TKLogDebug(frmt, ...)   [TKDataAnalysis logWithFlag:TKLOGFLAG_DEBUG format: frmt, ##__VA_ARGS__]
#define TKLogVerbose(frmt, ...)   [TKDataAnalysis logWithFlag:TKLOGFLAG_VERBOSE format: frmt, ##__VA_ARGS__]

@interface TKDataAnalysis : NSObject

/**
 初始化报告管理对象
 
 @param params 管理对象配置
 */
+ (void)initializationReportManager:(NSDictionary *)params;

/**
 崩溃日志的用户标识，用来区分
 
 @param identifier 标识
 */
+ (void)setUserIdentifier:(NSString *)identifier;

/**
 当前崩溃时，一同传递到后台的信息
 
 @param value 数据
 @param key key
 */
+ (void)setCrashUserValue:(NSString *)value forKey:(NSString *)key;

+ (void)initializationWithConfig:(NSDictionary *)config;

+ (void)logWithFlag:(TKLOGFLAG) flag format:(NSString *)format,...;

@end
