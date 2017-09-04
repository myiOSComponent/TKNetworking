//
//  TKNetworking.h
//  TKNetwork
//
//  Created by 云峰李 on 2017/9/1.
//  Copyright © 2017年 512869343@qq.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TKNetwork.h"


@interface TKNetworking : NSObject

@property (class, nonatomic, readonly) TKNetwork* (^GET)(NSString *urlString);
@property (class, nonatomic, readonly) TKNetwork* (^POST)(NSString *urlString);
@property (class, nonatomic, readonly) TKNetwork* (^UPLOAD)(NSString *urlString);
@property (class, nonatomic, readonly) TKNetwork* (^DOWNLOAD)(NSString *urlString);


/**
 使用网络框架前必须先初始化

 @param config 配置信息
 */
+ (void)initializeWithConfig:(NSDictionary *)config;
@end
