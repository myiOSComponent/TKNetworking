//
//  TKNetworkUpload.h
//  TKNetwork
//
//  Created by 云峰李 on 2017/9/1.
//  Copyright © 2017年 512869343@qq.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TKNetworkUpload : NSObject

@property (nonatomic, copy) NSData* imgData;
@property (nonatomic, copy) NSString* imgName;
@property (nonatomic, copy) NSString* fileName;
@property (nonatomic, copy) NSString* mimeType;

@end
