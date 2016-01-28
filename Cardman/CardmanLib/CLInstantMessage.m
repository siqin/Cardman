//
//  CLInstantMessage.m
//  Cardman
//
//  Created by Jason Lee on 16/1/29.
//  Copyright © 2016年 Jason Lee. All rights reserved.
//

#import "CLInstantMessage.h"

@import AddressBook;

@implementation CLInstantMessage

+ (CLInstantMessageType)typeFromIMServiceKey:(NSString *)serviceKey {
    CLInstantMessageType type;
    
    if ([serviceKey isEqualToString:(__bridge NSString *)kABPersonInstantMessageServiceYahoo]) {
        type = kCLInstantMessageTypeYahoo;
    } else if ([serviceKey isEqualToString:(__bridge NSString *)kABPersonInstantMessageServiceJabber]) {
        type = kCLInstantMessageTypeJabber;
    } else if ([serviceKey isEqualToString:(__bridge NSString *)kABPersonInstantMessageServiceMSN]) {
        type = kCLInstantMessageTypeMSN;
    } else if ([serviceKey isEqualToString:(__bridge NSString *)kABPersonInstantMessageServiceICQ]) {
        type = kCLInstantMessageTypeICQ;
    } else if ([serviceKey isEqualToString:(__bridge NSString *)kABPersonInstantMessageServiceAIM]) {
        type = kCLInstantMessageTypeAIM;
    } else if ([serviceKey isEqualToString:(__bridge NSString *)kABPersonInstantMessageServiceQQ]) {
        type = kCLInstantMessageTypeQQ;
    } else if ([serviceKey isEqualToString:(__bridge NSString *)kABPersonInstantMessageServiceGoogleTalk]) {
        type = kCLInstantMessageTypeGoogleTalk;
    } else if ([serviceKey isEqualToString:(__bridge NSString *)kABPersonInstantMessageServiceSkype]) {
        type = kCLInstantMessageTypeSkype;
    } else if ([serviceKey isEqualToString:(__bridge NSString *)kABPersonInstantMessageServiceFacebook]) {
        type = kCLInstantMessageTypeFacebook;
    } else if ([serviceKey isEqualToString:(__bridge NSString *)kABPersonInstantMessageServiceGaduGadu]) {
        type = kCLInstantMessageTypeGaduGadu;
    } else {
        type = kCLInstantMessageTypeUnknown;
    }
    
    return type;
}

@end
