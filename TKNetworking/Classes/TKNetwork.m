//
//  TKNetwork.m
//  TKNetwork
//
//  Created by 云峰李 on 2017/9/1.
//  Copyright © 2017年 512869343@qq.com. All rights reserved.
//

#import "TKNetwork.h"
@import TKMiddleware;

static NSString* const kNetworkTarget = @"Network";

static NSString* const kNetworkRequestURL = @"requestURL";
static NSString* const kNetworkRequestParams = @"requestParams";
static NSString* const kNetworkRequestHander = @"requestCompletion";

static NSString* const kNetworkRequestProgress = @"requestProgress";
static NSString* const kNetworkRequestDestination = @"requestDestination";
static NSString* const kNetworkRequestUploadData = @"requestUploadData";

@interface TKNetwork ()

@property (nonatomic, strong) NSDictionary* netParams;
@property (nonatomic, copy) TKNetworkingHander hander;
@property (nonatomic, copy) TKNetworkingProgress netProgress;
@property (nonatomic, copy) TKNetworkingDestination netDesination;
@property (nonatomic, copy) NSArray* netUploadData;

@end

@implementation TKNetwork

- (instancetype)initWithUrlString:(NSString *)urlString networkType:(kNETWORKTYPE)type
{
    self = [super init];
    if (self) {
        _urlString = [urlString copy];
        _networkType = type;
    }
    return self;
}

- (TKNetwork *(^)(NSDictionary *))params
{
    return ^(NSDictionary *params){
        self.netParams = [params copy];
        return self;
    };
}

- (TKNetwork *(^)(TKNetworkingHander))completion
{
    return ^(TKNetworkingHander hander){
        self.hander = hander;
        return self;
    };
}

- (TKNetwork *(^)(TKNetworkingProgress))progress
{
    return ^(TKNetworkingProgress progress){
        self.netProgress = progress;
        return self;
    };
}

- (TKNetwork *(^)(TKNetworkingDestination))destination
{
    return ^(TKNetworkingDestination destination){
        self.netDesination = destination;
        return self;
    };
}

- (TKNetwork *(^)(NSArray*))uploadData
{
    return ^(NSArray* uploadData){
        self.netUploadData = uploadData;
        return self;
    };
}

- (TKNetwork *(^)())start
{
    return ^(){
        [self startRequest];
        return self;
    };
}

#pragma mark - 私有方法

- (void)startRequest
{
    switch (self.networkType) {
        case kNETWORKTYPE_GET:
            [self requestGET];
            break;
        case kNETWORKTYPE_POST:
            [self requestPOST];
            break;
        case kNETWORKTYPE_DOWNLOAD:
            [self requestDOWNLOAD];
            break;
        case kNETWORKTYPE_UPLOAD:
            [self requestUPLOAD];
            break;
    }
}

- (void)requestGET
{
    NSMutableDictionary* params = [NSMutableDictionary new];
    params[kNetworkRequestURL] = self.urlString ?: @"";
    params[kNetworkRequestParams] = self.netParams ?: @{};
    if (self.hander) {
        params[kNetworkRequestHander] = self.hander;
    }
    
    [TKMiddleWareMgr performTarget:kNetworkTarget
                            action:@"GET"
                            params:[params copy]];
}

- (void)requestPOST
{
    NSMutableDictionary* params = [NSMutableDictionary new];
    params[kNetworkRequestURL] = self.urlString ?: @"";
    params[kNetworkRequestParams] = self.netParams ?: @{};
    if (self.hander) {
        params[kNetworkRequestHander] = self.hander;
    }
    
    [TKMiddleWareMgr performTarget:kNetworkTarget
                            action:@"POST"
                            params:[params copy]];
}

- (void)requestUPLOAD
{
    NSMutableDictionary* params = [NSMutableDictionary new];
    params[kNetworkRequestURL] = self.urlString ?: @"";
    params[kNetworkRequestParams] = self.netParams ?: @{};
    if (self.hander) {
        params[kNetworkRequestHander] = self.hander;
    }
    
    if (self.netProgress) {
        params[kNetworkRequestProgress] = self.netProgress;
    }
    
    params[kNetworkRequestUploadData] = self.netUploadData?:@[];
    
    [TKMiddleWareMgr performTarget:kNetworkTarget
                            action:@"UPLOAD"
                            params:[params copy]];
}

- (void)requestDOWNLOAD
{
    NSMutableDictionary* params = [NSMutableDictionary new];
    params[kNetworkRequestURL] = self.urlString ?: @"";
    params[kNetworkRequestParams] = self.netParams ?: @{};
    if (self.hander) {
        params[kNetworkRequestHander] = self.hander;
    }
    
    if (self.netDesination) {
        params[kNetworkRequestDestination] = self.netDesination;
    }
    
    if (self.netProgress) {
        params[kNetworkRequestProgress] = self.netProgress;
    }
    
    [TKMiddleWareMgr performTarget:kNetworkTarget
                            action:@"DOWNLOAD"
                            params:[params copy]];
}

@end
