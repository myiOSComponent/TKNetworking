//
//  TKNetworkManager.m
//  Pods
//
//  Created by 云峰李 on 2017/9/1.
//
//

#import "TKNetworkManager.h"
#import <AFNetworking/AFNetworking.h>
#import <TKDataAnalysisCategory/TKDataAnalysis.h>
#import <TKModelCategory/TKModel.h>

static NSString* const kNetworkRequestTimeOut = @"requestTimeOut";
static NSString* const kNetworkRequestBaseURL = @"requestBaseURL";

@interface TKNetworkManager ()

@property(nonatomic, strong) AFHTTPSessionManager *sessionManager;
@property(nonatomic, assign) NSTimeInterval requestTimeout;

@end

@implementation TKNetworkManager

+ (instancetype)manager
{
    static TKNetworkManager* instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [TKNetworkManager new];
    });
    return instance;
}

- (void)initializationWithConfig:(NSDictionary *)config
{
    NSAssert(config != nil, @"网络配置信息不能为nil，请检测您的配置信息");
    TKLogInfo(@"网络配置开始初始化%@",config);
    NSURLSessionConfiguration* sessionConfig = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSString* baseUrl = config[kNetworkRequestBaseURL];
    
    self.requestTimeout = [config[kNetworkRequestTimeOut] doubleValue];
    if (self.requestTimeout >= 1) {
        sessionConfig.timeoutIntervalForRequest = self.requestTimeout;
    }
    
    _sessionManager = [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:baseUrl]
                                               sessionConfiguration:sessionConfig];
    _sessionManager.requestSerializer = [AFHTTPRequestSerializer serializer];
    _sessionManager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [_sessionManager.requestSerializer setValue:@"application/x-www-form-urlencoded; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    
    NSURLCache *URLCache = [[NSURLCache alloc] initWithMemoryCapacity:4 * 1024 * 1024
                                                         diskCapacity:20 * 1024 * 1024
                                                             diskPath:nil];
    [NSURLCache setSharedURLCache:URLCache];
    TKLogInfo(@"网络配置完成初始化");
}

#pragma mark - GET

- (void)GET:(NSString *)method
     params:(NSDictionary *)params
 completion:(TKNetworkingHander)completion
{
    __weak typeof(self) ws = self;
    NSURLSessionDataTask* curTask = [_sessionManager GET:method
              parameters:params
                progress:nil
                 success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                     id retObject = responseObject;
                     NSHTTPURLResponse* httpResponse = (NSHTTPURLResponse*)task.response;
                     if (httpResponse.statusCode == 200) {
                         NSCachedURLResponse* cachedResponse = [[NSCachedURLResponse alloc] initWithResponse:httpResponse
                                                                                                        data:[responseObject tkModelToJsonData]
                                                                                                    userInfo:@{@"dataClass" : NSStringFromClass([responseObject class])} storagePolicy:NSURLCacheStorageAllowed];
                         [[NSURLCache sharedURLCache] storeCachedResponse:cachedResponse
                                                               forRequest:task.currentRequest];
                     } else {
                         NSCachedURLResponse* cacheResponse = [[NSURLCache sharedURLCache] cachedResponseForRequest:task.currentRequest];
                         Class cacheCalss = NSClassFromString(cacheResponse.userInfo[@"dataClass"]);
                         retObject = [cacheCalss tkModelWithJson:cacheResponse.data];
                     }
                     
                     [ws logResponse:httpResponse
                         responseObj:retObject
                             request:task.currentRequest
                               error:nil];
                     
                     if (completion) {
                         completion(retObject, nil);
                     }
                     
                 } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                     NSCachedURLResponse* cacheResponse = [[NSURLCache sharedURLCache] cachedResponseForRequest:task.currentRequest];
                     Class cacheCalss = NSClassFromString(cacheResponse.userInfo[@"dataClass"]);
                     id retObject = [cacheCalss tkModelWithJson:cacheResponse.data];
                     if (completion) {
                         completion(retObject, error);
                     }
                     [ws logResponse:task.response
                         responseObj:retObject
                             request:task.currentRequest
                               error:nil];
                 }];
    [self logRequest:curTask.currentRequest
             mthName:method
       requestParams:[params copy]
          httpMethod:@"GET"];
}

#pragma mark - POST
- (void)POST:(NSString *)method
      params:(NSDictionary *)prams
  completion:(TKNetworkingHander)completion
{
    __weak typeof(self) ws = self;
    NSURLSessionDataTask* dataTask = [_sessionManager POST:method
               parameters:prams
                 progress:nil
                  success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                      
                      [ws logResponse:task.response
                            responseObj:responseObject
                                request:task.currentRequest
                                  error:nil];
                      
                      if (completion) {
                          completion(responseObject, nil);
                      }
                      
                  } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                      
                      [self logResponse:task.response
                            responseObj:nil
                                request:task.currentRequest
                                  error:error];
                      
                      if (completion) {
                          completion(nil, error);
                      }
                  }];
    
    [self logRequest:dataTask.currentRequest
             mthName:method
       requestParams:[prams copy]
          httpMethod:@"POST"];
}

- (void)UPLOAD:(NSString *)method
        params:(NSDictionary *)params
      dataList:(NSArray *)dataList
      progress:(TKNetworkingProgress)progress
    completion:(TKNetworkingHander)completion
{
    method = [[NSURL URLWithString:method relativeToURL:_sessionManager.baseURL] absoluteString];
    NSMutableURLRequest* request = [_sessionManager.requestSerializer multipartFormRequestWithMethod:@"POST"
                                                                                           URLString:method
                                                                                          parameters:params
                                                                           constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
                                                                               for (NSDictionary* dic in dataList) {
                                                                                   [formData appendPartWithFileData:dic[@"imgData"]
                                                                                                               name:dic[@"imgName"]
                                                                                                           fileName:dic[@"fileName"]
                                                                                                           mimeType:dic[@"mimeType"]];
                                                                               }
                                                                           } error:nil];
    __weak typeof(self) ws = self;
    NSURLSessionUploadTask* uploadTask = [_sessionManager uploadTaskWithStreamedRequest:request
                                                                               progress:progress
                                                                      completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
                                                                          if (completion) {
                                                                              completion(responseObject, error);
                                                                          }
                                                                          
                                                                          [ws logResponse:response
                                                                              responseObj:responseObject
                                                                                  request:request
                                                                                    error:error];
                                                                      }];
    
    [self logRequest:uploadTask.currentRequest
             mthName:method
       requestParams:params
          httpMethod:@"UPLOAD"];
}

- (void)DOWNLOAD:(NSString *)method
          params:(NSDictionary *)params
        progress:(TKNetworkingProgress)progress
     destination:(NSURL *(^)(NSURL * _Nonnull, NSURLResponse * _Nonnull))destination
      completion:(TKNetworkingHander)completion
{
    __weak typeof(self) ws = self;
    method = [NSURL URLWithString:method relativeToURL:_sessionManager.baseURL];
    NSURLRequest* request = [_sessionManager.requestSerializer requestWithMethod:@"GET"
                                                                       URLString:method
                                                                      parameters:params
                                                                           error:nil];
    NSURLSessionDownloadTask* task = [_sessionManager downloadTaskWithRequest:request
                                    progress:progress
                                 destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
                                     if (destination) {
                                         return destination(targetPath, response);
                                     } else {
                                         return nil;
                                     }
                                 } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
                                     [ws logResponse:response
                                         responseObj:filePath
                                             request:request
                                               error:error];
                                     
                                     if (completion) {
                                         completion(filePath,error);
                                     }
                                 }];
    
    [self logRequest:task.currentRequest
             mthName:method
       requestParams:params
          httpMethod:@"DOWNLOAD"];
}


#pragma mark - 记录日志
- (void)logRequest:(NSURLRequest *)request
           mthName:(NSString *)mthName
     requestParams:(id)requestParams
        httpMethod:(NSString *)method
{
    NSMutableString *logString = [NSMutableString stringWithString:@"\n\n**************************************************************\n*                       Request Start                        *\n**************************************************************\n\n"];
    [logString appendFormat:@"API Name:\t\t%@\n", mthName];
    [logString appendFormat:@"Method:\t\t\t%@\n", method];
    [logString appendFormat:@"Params:\n%@", requestParams];
    
    [logString appendString:[self appendURLRequest:request]];
    
    
    [logString appendFormat:@"\n\n**************************************************************\n*                         Request End                        *\n**************************************************************\n\n\n\n"];
    
    TKLogDebug(@"%@",logString);
}

- (void)logResponse:(NSHTTPURLResponse *)response
        responseObj:(id)responseObj
            request:(NSURLRequest *)request
              error:(NSError *)error
{
    BOOL shouldLogError = error ? YES : NO;
    
    NSMutableString *logString = [NSMutableString stringWithString:@"\n\n==============================================================\n=                        API Response                        =\n==============================================================\n\n"];
    
    
    [logString appendFormat:@"Status:\t%ld\t(%@)\n\n", (long)response.statusCode,
     [NSHTTPURLResponse localizedStringForStatusCode:response.statusCode]];
    NSString* responseString = @"";
    if ([responseObj isKindOfClass:[NSString class]]) {
        responseString = responseObj;
    }else{
        responseString = [responseObj tkModelToJsonString];
    }
    [logString appendFormat:@"Content Json:\n\t%@\n\n", responseString];
    if (shouldLogError) {
        [logString appendFormat:@"Error Domain:\t\t\t\t\t\t\t%@\n", error.domain];
        [logString appendFormat:@"Error Domain Code:\t\t\t\t\t\t%ld\n", (long)error.code];
        [logString appendFormat:@"Error Localized Description:\t\t\t%@\n", error.localizedDescription];
        [logString appendFormat:@"Error Localized Failure Reason:\t\t\t%@\n", error.localizedFailureReason];
        [logString appendFormat:@"Error Localized Recovery Suggestion:\t%@\n\n", error.localizedRecoverySuggestion];
    }
    
    [logString appendString:@"\n---------------  Related Request Content  --------------\n"];
    
    [logString appendString:[self appendURLRequest:request]];
    
    [logString appendFormat:@"\n\n==============================================================\n=                        Response End                        =\n==============================================================\n\n\n\n"];
    
    if (shouldLogError) {
        TKLogDebug(@"%@",logString);
    }else{
        TKLogDebug(@"%@",logString);
    }
}

- (void)logCachedResponse:(NSData *)responseData
                   params:(NSDictionary *)params
               methodName:(NSString *)mthName
               HTTPMethod:(NSString *)methodName
{
    NSMutableString *logString = [NSMutableString stringWithString:@"\n\n==============================================================\n=                      Cached Response                       =\n==============================================================\n\n"];
    [logString appendFormat:@"API Name:\t\t%@\n", mthName];
    [logString appendFormat:@"Method Name:\t%@\n", methodName];
    [logString appendFormat:@"Params:\n%@\n\n", params];
    
    [logString appendFormat:@"Content:\n\t%@\n\n", [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding]];
    
    [logString appendFormat:@"\n\n==============================================================\n=                        Response End                        =\n==============================================================\n\n\n\n"];
    TKLogDebug(logString);
}

- (NSString *)appendURLRequest:(NSURLRequest *)request
{
    NSMutableString* requestString = [NSMutableString new];
    [requestString appendFormat:@"\n\nHTTP URL:\n\t%@", request.URL];
    [requestString appendFormat:@"\n\nHTTP Header:\n%@", request.allHTTPHeaderFields ?: @"\t\t\t\t\tN/A"];
    [requestString appendFormat:@"\n\nHTTP Body:\n\t%@", [[NSString alloc] initWithData:request.HTTPBody encoding:NSUTF8StringEncoding]];
    
    return [requestString copy];
}

@end
