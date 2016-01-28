//
//  CLSocialProfile.m
//  Cardman
//
//  Created by Jason Lee on 16/1/28.
//  Copyright © 2016年 Jason Lee. All rights reserved.
//

#import "CLSocialProfile.h"
@import AddressBook;

@implementation CLSocialProfile

+ (CLSocialNetworkType)typeFromSocialServiceKey:(NSString *)serviceKey {
    CLSocialNetworkType type;
    
    if ([serviceKey isEqualToString:(__bridge NSString *)kABPersonSocialProfileServiceTwitter]) {
        type = kCLSocialNetworkTypeTwitter;
    } else if ([serviceKey isEqualToString:(__bridge NSString *)kABPersonSocialProfileServiceSinaWeibo]) {
        type = kCLSocialNetworkTypeSinaWeibo;
    } else if ([serviceKey isEqualToString:(__bridge NSString *)kABPersonSocialProfileServiceGameCenter]) {
        type = kCLSocialNetworkTypeGameCenter;
    } else if ([serviceKey isEqualToString:(__bridge NSString *)kABPersonSocialProfileServiceFacebook]) {
        type = kCLSocialNetworkTypeFacebook;
    } else if ([serviceKey isEqualToString:(__bridge NSString *)kABPersonSocialProfileServiceMyspace]) {
        type = kCLSocialNetworkTypeMyspace;
    } else if ([serviceKey isEqualToString:(__bridge NSString *)kABPersonSocialProfileServiceLinkedIn]) {
        type = kCLSocialNetworkTypeLinkedIn;
    } else if ([serviceKey isEqualToString:(__bridge NSString *)kABPersonSocialProfileServiceFlickr]) {
        type = kCLSocialNetworkTypeFlickr;
    } else {
        type = kCLSocialNetworkTypeUnknown;
    }
    
    return type;
}

@end
