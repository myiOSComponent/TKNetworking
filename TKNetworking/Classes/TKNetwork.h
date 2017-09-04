//
//  TKNetwork.h
//  TKNetwork
//
//  Created by 云峰李 on 2017/9/1.
//  Copyright © 2017年 512869343@qq.com. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^TKNetworkingHander)(id ret, NSError* error);
typedef void(^TKNetworkingProgress)(NSProgress* progress);
typedef NSURL* _Nullable (^TKNetworkingDestination)(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response);

typedef NS_ENUM(NSUInteger, kNETWORKTYPE)
{
    kNETWORKTYPE_GET,
    kNETWORKTYPE_POST,
    kNETWORKTYPE_UPLOAD,
    kNETWORKTYPE_DOWNLOAD,
};

@interface TKNetwork : NSObject

@property (nonatomic, readonly, copy) TKNetwork* (^params)(NSDictionary *params);

@property (nonatomic, readonly, copy) TKNetwork* (^completion)(TKNetworkingHander completion);

@property (nonatomic, readonly, copy) TKNetwork* (^progress)(TKNetworkingProgress progress);

@property (nonatomic, readonly, copy) TKNetwork* (^destination)(TKNetworkingDestination destination);

@property (nonatomic, readonly, copy) TKNetwork* (^uploadData)(NSArray *uploadData);

@property (nonatomic, readonly, copy) TKNetwork* (^start)();

@property (nonatomic, copy, readonly) NSString* urlString;
@property (nonatomic, assign, readonly) kNETWORKTYPE networkType;


- (instancetype)initWithUrlString:(NSString *)urlString networkType:(kNETWORKTYPE)type;

@end

NS_ASSUME_NONNULL_END
