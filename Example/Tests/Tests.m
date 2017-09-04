//
//  TKNetworkTests.m
//  TKNetworkTests
//
//  Created by 512869343@qq.com on 08/31/2017.
//  Copyright (c) 2017 512869343@qq.com. All rights reserved.
//

// https://github.com/kiwi-bdd/Kiwi
#import <Kiwi/Kiwi.h>
@import TKNetworking;


SPEC_BEGIN(InitialTests)

describe(@"My initial tests", ^{
    context(@"will pass", ^{
        
        beforeEach(^{
            [TKNetworking initializeWithConfig:@{}];
        });
        
        it(@"can do maths", ^{
            NSString* testUrl = @"http://www.baidu.com";
            NSString* baseUrl = @"http://www.163.com";
            NSURL* url = [NSURL URLWithString:testUrl relativeToURL:[NSURL URLWithString:baseUrl]];
            NSLog(@"%@",url.absoluteString);
        });
        
        it(@"can read", ^{
            __block id retObj = nil;
            TKNetworking.GET(@"https://www.baidu.com")
            .completion(^(id  _Nonnull ret, NSError * _Nonnull error) {
                retObj = ret;
                NSLog(@"错误信息%@",error);
                NSLog(@"处理结果为%@",ret);
            })
            .start();
            
            [[expectFutureValue(retObj) shouldEventually] beNonNil];
        });  
    });
    
});

SPEC_END

