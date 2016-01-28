//
//  CLInstantMessage.h
//  Cardman
//
//  Created by Jason Lee on 16/1/29.
//  Copyright © 2016年 Jason Lee. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum : NSUInteger {
    kCLInstantMessageTypeYahoo,
    kCLInstantMessageTypeJabber,
    kCLInstantMessageTypeMSN,
    kCLInstantMessageTypeICQ,
    kCLInstantMessageTypeAIM,
    kCLInstantMessageTypeQQ,
    kCLInstantMessageTypeGoogleTalk,
    kCLInstantMessageTypeSkype,
    kCLInstantMessageTypeFacebook,
    kCLInstantMessageTypeGaduGadu,
    
    kCLInstantMessageTypeUnknown
} CLInstantMessageType;

@interface CLInstantMessage : NSObject

@property (nonatomic, assign) CLInstantMessageType type;
@property (nonatomic, strong) NSString *username;

+ (CLInstantMessageType)typeFromIMServiceKey:(NSString *)serviceKey;

@end
