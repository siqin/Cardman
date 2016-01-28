//
//  CLSocialProfile.h
//  Cardman
//
//  Created by Jason Lee on 16/1/28.
//  Copyright © 2016年 Jason Lee. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum : NSUInteger {
    kCLSocialNetworkTypeTwitter,
    kCLSocialNetworkTypeSinaWeibo,
    kCLSocialNetworkTypeGameCenter,
    kCLSocialNetworkTypeFacebook,
    kCLSocialNetworkTypeMyspace,
    kCLSocialNetworkTypeLinkedIn,
    kCLSocialNetworkTypeFlickr,
    
    kCLSocialNetworkTypeUnknown
} CLSocialNetworkType;

@interface CLSocialProfile : NSObject

@property (nonatomic, assign) CLSocialNetworkType type;
@property (nonatomic, strong) NSURL *url;
@property (nonatomic, strong) NSString *username;
@property (nonatomic, strong) NSString *userIdentifier;

+ (CLSocialNetworkType)typeFromSocialServiceKey:(NSString *)serviceKey;

@end
