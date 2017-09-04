//
//  TKNetworking.m
//  TKNetwork
//
//  Created by 云峰李 on 2017/9/1.
//  Copyright © 2017年 512869343@qq.com. All rights reserved.
//

#import "TKNetworking.h"

@import TKMiddleware;

static NSString* const kNetworkTarget = @"Network";

@implementation TKNetworking

+ (TKNetwork* (^)(NSString *))GET
{
    return ^(NSString *urlString){
        TKNetwork* network = [[TKNetwork alloc] initWithUrlString:urlString
                                                      networkType:kNETWORKTYPE_GET];
        return network;
    };
}

+ (TKNetwork* (^)(NSString *))POST
{
    return ^(NSString *urlString){
        TKNetwork* network = [[TKNetwork alloc] initWithUrlString:urlString
                                                      networkType:kNETWORKTYPE_POST];
        return network;
    };
}

+ (TKNetwork* (^)(NSString *))UPLOAD
{
    return ^(NSString *urlString){
        TKNetwork* network = [[TKNetwork alloc] initWithUrlString:urlString
                                                      networkType:kNETWORKTYPE_UPLOAD];
        return network;
    };
}

+ (TKNetwork* (^)(NSString *))DOWNLOAD
{
    return ^(NSString *urlString){
        TKNetwork* network = [[TKNetwork alloc] initWithUrlString:urlString
                                                      networkType:kNETWORKTYPE_DOWNLOAD];
        return network;
    };
}

+ (void)initializeWithConfig:(NSDictionary *)config
{
    [TKMiddleWareMgr performTarget:kNetworkTarget
                            action:@"initNetworking"
                            params:config];
}

@end
