//
//  ARDAppClientConfig.m
//  HMWebRTC
//
//  Created by TRAN DIEP Hue Man on 5/23/18.
//

#import "ARDAppClientConfig.h"

@implementation ARDAppClientConfig

static NSString * kARDRoomServerHostUrl = @"https://appr.tc";
static NSString * kARDIceServerRequestUrl = @"https://appr.tc/params";
static NSString * kARDRoomServerJoinFormat = @"https://appr.tc/join/%@";
static NSString * kARDRoomServerJoinFormatLoopback = @"https://appr.tc/join/%@?debug=loopback";
static NSString * kARDRoomServerMessageFormat = @"https://appr.tc/message/%@/%@";
static NSString * kARDRoomServerLeaveFormat = @"https://appr.tc/leave/%@/%@";
static NSString * kTURNRefererURLString = @"https://appr.tc";

+(void)setServerHostUrl: (NSString*)newValue {
    kARDRoomServerHostUrl = newValue;
}
+(void)setServerHostParams: (NSString*)newValue {
    kARDIceServerRequestUrl = newValue;
}
+(void)setServerJoinFormat: (NSString*)newValue {
    kARDRoomServerJoinFormat = newValue;
}
+(void)setServerJoinFormatLoopback: (NSString*)newValue {
    kARDRoomServerJoinFormatLoopback = newValue;
}
+(void)setServerMessageFormat: (NSString*)newValue {
    kARDRoomServerMessageFormat = newValue;
}
+(void)setServerLeaveFormat: (NSString*)newValue {
    kARDRoomServerLeaveFormat = newValue;
}
+(void)setTURNRefererURLString: (NSString*)newValue {
    kTURNRefererURLString = newValue;
}

+(NSString*)getServerHostUrl {
    return kARDRoomServerHostUrl;
}
+(NSString*)getServerHostParams {
    return kARDIceServerRequestUrl;
}
+(NSString*)getServerJoinFormat {
    return kARDRoomServerJoinFormat;
}
+(NSString*)getServerJoinFormatLoopback {
    return kARDRoomServerJoinFormatLoopback;
}
+(NSString*)getServerMessageFormat {
    return kARDRoomServerMessageFormat;
}
+(NSString*)getServerLeaveFormat {
    return kARDRoomServerLeaveFormat;
}
+(NSString*)getTURNRefererURLString {
    return kTURNRefererURLString;
}

+ (id)alloc {
    [NSException raise:@"Cannot be instantiated!" format:@"Static class 'ARDAppClientConfig.h' cannot be instantiated!"];
    return nil;
}

@end
