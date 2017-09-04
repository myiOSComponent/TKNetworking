#ifdef __OBJC__
#import <UIKit/UIKit.h>
#else
#ifndef FOUNDATION_EXPORT
#if defined(__cplusplus)
#define FOUNDATION_EXPORT extern "C"
#else
#define FOUNDATION_EXPORT extern
#endif
#endif
#endif

#import "TKNetwork.h"
#import "TKNetworking.h"
#import "TKNetworkUpload.h"

FOUNDATION_EXPORT double TKNetworkingVersionNumber;
FOUNDATION_EXPORT const unsigned char TKNetworkingVersionString[];

