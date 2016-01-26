//
//  CLCardman.h
//  Cardman
//
//  Created by Jason Lee on 16/1/25.
//  Copyright © 2016年 Jason Lee. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "CLPerson.h"

typedef enum : NSUInteger {
    kCLAccessStatusNotDetermined = 0,
    kCLAccessStatusDenied,
    kCLAccessStatusAuthorized,
} kCLStatus;

@interface CLCardman : NSObject

@property (nonatomic, readonly) ABAddressBookRef abRef;

+ (CLCardman *)sharedInstance;

+ (BOOL)hasAccessToAddressBook;

- (void)requestAccessToAddressBookWithCompletion:(void (^)(BOOL granted))completion;

#pragma mark - 

- (void)readAllContactsWithCompletion:(void (^)(NSArray<CLPerson *> *contacts, NSError *error))completion;

@end
