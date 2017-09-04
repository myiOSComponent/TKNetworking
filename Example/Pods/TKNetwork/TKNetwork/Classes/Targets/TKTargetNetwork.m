//
//  TKTargetNetwork.m
//  Pods
//
//  Created by 云峰李 on 2017/9/1.
//
//

#import "TKTargetNetwork.h"
#import "TKNetworkManager.h"

static NSString* const kNetworkRequestURL = @"requestURL";
static NSString* const kNetworkRequestParams = @"requestParams";
static NSString* const kNetworkRequestHander = @"requestCompletion";

static NSString* const kNetworkRequestProgress = @"requestProgress";
static NSString* const kNetworkRequestDestination = @"requestDestination";
static NSString* const kNetworkRequestUploadData = @"requestUploadData";


@implementation TKTargetNetwork

- (void) tkAction_initNetworking:(NSDictionary *)config
{
    [TKNetworkManager.manager initializationWithConfig:config];
}

- (void) tkAction_GET:(NSDictionary *)getParams
{
    NSString* method = getParams[kNetworkRequestURL];
    NSDictionary* params = getParams[kNetworkRequestParams];
    TKNetworkingHander hander = getParams[kNetworkRequestHander];
    NSParameterAssert(method);
    
    [TKNetworkManager.manager GET:method
                           params:params
                       completion:hander];
}

- (void) tkAction_POST:(NSDictionary *)postParams
{
    NSString* method = postParams[kNetworkRequestURL];
    NSDictionary* params = postParams[kNetworkRequestParams];
    TKNetworkingHander hander = postParams[kNetworkRequestHander];
    NSParameterAssert(method);
    
    [TKNetworkManager.manager POST:method
                           params:params
                       completion:hander];
}

- (void) tkAction_DOWNLOAD:(NSDictionary *)downloadParams
{
    NSString* method = downloadParams[kNetworkRequestURL];
    NSDictionary* params = downloadParams[kNetworkRequestParams];
    TKNetworkingHander hander = downloadParams[kNetworkRequestHander];
    TKNetworkingProgress progress = downloadParams[kNetworkRequestProgress];
    TKNetworkingDestination destination = downloadParams[kNetworkRequestDestination];
    NSParameterAssert(method);
    
    [TKNetworkManager.manager DOWNLOAD:method
                                params:params
                              progress:progress
                           destination:destination
                            completion:hander];
}

- (void) tkAction_UPLOAD:(NSDictionary *)uploadParams
{
    NSString* method = uploadParams[kNetworkRequestURL];
    NSDictionary* params = uploadParams[kNetworkRequestParams];
    TKNetworkingHander hander = uploadParams[kNetworkRequestHander];
    TKNetworkingProgress progress = uploadParams[kNetworkRequestProgress];
    NSArray* dataList = uploadParams[kNetworkRequestUploadData];
    NSParameterAssert(dataList);
    NSParameterAssert(method);
    
    [TKNetworkManager.manager UPLOAD:method
                              params:params
                            dataList:dataList
                            progress:progress
                          completion:hander];
}

@end
