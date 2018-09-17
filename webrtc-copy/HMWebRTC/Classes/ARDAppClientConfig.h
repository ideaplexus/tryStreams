//
//  ARDAppClientConfig.h
//  HMWebRTC
//
//  Created by TRAN DIEP Hue Man on 5/23/18.
//

#import <Foundation/Foundation.h>

@interface ARDAppClientConfig : NSObject
+(void)setServerHostUrl: (NSString*)newValue;
+(void)setServerHostParams: (NSString*)newValue;
+(void)setServerJoinFormat: (NSString*)newValue;
+(void)setServerJoinFormatLoopback: (NSString*)newValue;
+(void)setServerMessageFormat: (NSString*)newValue;
+(void)setServerLeaveFormat: (NSString*)newValue;
+(void)setTURNRefererURLString: (NSString*)newValue;

+(NSString*)getServerHostUrl;
+(NSString*)getServerHostParams;
+(NSString*)getServerJoinFormat;
+(NSString*)getServerJoinFormatLoopback;
+(NSString*)getServerMessageFormat;
+(NSString*)getServerLeaveFormat;
+(NSString*)getTURNRefererURLString;
@end
