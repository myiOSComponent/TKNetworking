//
//  TKTargetNetwork.h
//  Pods
//
//  Created by 云峰李 on 2017/9/1.
//
//

#import <Foundation/Foundation.h>

/**
 网络模块对外接口
 */
@interface TKTargetNetwork : NSObject

- (void) tkAction_initNetworking:(NSDictionary *)config;
- (void) tkAction_GET:(NSDictionary *)getParams;
- (void) tkAction_POST:(NSDictionary *)postParams;
- (void) tkAction_DOWNLOAD:(NSDictionary *)downloadParams;
- (void) tkAction_UPLOAD:(NSDictionary *)uploadParams;

@end
