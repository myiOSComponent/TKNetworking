//
//  TKNetworkManager.h
//  Pods
//
//  Created by 云峰李 on 2017/9/1.
//
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^TKNetworkingHander)(id ret, NSError* error);
typedef void(^TKNetworkingProgress)(NSProgress* progress);
typedef NSURL* _Nullable (^TKNetworkingDestination)(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response);

@interface TKNetworkManager : NSObject

@property (class, nonatomic, readonly) TKNetworkManager* manager;

/**
 根据配置信息初始化网络连接

 @param config 配置信息
 */
- (void)initializationWithConfig:(NSDictionary *)config;

/**
 HTTP 网络GET请求

 @param method 请求方法
 @param params 请求参数
 @param completion 完成后回调
 */
- (void)GET:(NSString *)method
     params:(NSDictionary *)params
 completion:(TKNetworkingHander)completion;

/**
 HTTP 网络POST请求

 @param method 请求方法
 @param prams 请求参数
 @param completion 完成后回调
 */
- (void)POST:(NSString *)method
      params:(NSDictionary *)prams
  completion:(TKNetworkingHander)completion;

/**
 HTTP 下载数据

 @param method 请求方法
 @param params 参数
 @param progress 请求参数
 @param completion 完成后回调
 */
- (void)DOWNLOAD:(NSString *)method
          params:(NSDictionary *)params
        progress:(TKNetworkingProgress)progress
     destination:(NSURL* _Nullable (^_Nullable)(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response))destination
      completion:(TKNetworkingHander _Nullable )completion;

/**
 HTTP 上传文件

 @param method 请求方法
 @param params 参数
 @param dataList 数据列表
 @param progress 上传进度
 @param completion 完成后回调
 */
- (void)UPLOAD:(NSString *)method
        params:(NSDictionary *)params
      dataList:(NSArray *)dataList
      progress:(TKNetworkingProgress)progress
    completion:(TKNetworkingHander)completion;

@end

NS_ASSUME_NONNULL_END
