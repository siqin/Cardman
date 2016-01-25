//
//  CLCardman.h
//  Cardman
//
//  Created by Jason Lee on 16/1/25.
//  Copyright © 2016年 Jason Lee. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum : NSUInteger {
    kCLAccessStatusNotDetermined = 0,
    kCLAccessStatusDenied,
    kCLAccessStatusAuthorized,
} kCLStatus;

@interface CLCardman : NSObject

+ (BOOL)hasAccessToAddressBook;

+ (void)requestAccessToAddressBookWithCompletion:(void (^)(BOOL granted))completion;

+ (void)readAllContactsWithCompletion:(void (^)(NSArray *contacts, NSError *error))completion;

@end
