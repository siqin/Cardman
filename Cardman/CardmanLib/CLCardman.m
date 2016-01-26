//
//  CLCardman.m
//  Cardman
//
//  Created by Jason Lee on 16/1/25.
//  Copyright © 2016年 Jason Lee. All rights reserved.
//

#import "CLCardman.h"

@import AddressBook;
@import UIKit;

@interface CLCardman () {
    ABAddressBookRef _abRef;
}

@end

@implementation CLCardman

+ (CLCardman *)sharedInstance {
    static CLCardman *_sCardman = nil;
    if (_sCardman == nil) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            _sCardman = [CLCardman new];
        });
    }
    return _sCardman;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _abRef = ABAddressBookCreateWithOptions(NULL, NULL);
    }
    return self;
}

#pragma mark - Address book access

+ (BOOL)hasAccessToAddressBook {
    ABAuthorizationStatus status = ABAddressBookGetAuthorizationStatus();
    return status == kABAuthorizationStatusAuthorized;
}

- (void)requestAccessToAddressBookWithCompletion:(void (^)(BOOL granted))completion {
    ABAuthorizationStatus status = ABAddressBookGetAuthorizationStatus();
    if (status == kABAuthorizationStatusDenied || status == kABAuthorizationStatusRestricted) {
        dispatch_async(dispatch_get_main_queue(), ^{
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"通讯录授权"
                                                            message:@"请前往设置-隐私-通讯录进行授权"
                                                           delegate:nil
                                                  cancelButtonTitle:@"知道了"
                                                  otherButtonTitles:nil];
            [alert show];
        });
    } else if (status == kABAuthorizationStatusNotDetermined) {
        ABAddressBookRequestAccessWithCompletion(_abRef, ^(bool granted, CFErrorRef error) {
            if (completion) completion(granted);
        });
    } else {
        if (completion) completion(YES);
    }
}

- (ABAddressBookRef)abRef {
    return _abRef;
}

#pragma mark -

- (void)readAllContactsWithCompletion:(void (^)(NSArray<CLPerson *> *contacts, NSError *error))completion {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        if ([CLCardman hasAccessToAddressBook]) {
            if (completion) completion([self CL_ReadAllContacts], nil);
        } else {
            [self requestAccessToAddressBookWithCompletion:^(BOOL granted) {
                if (granted) {
                    if (completion) completion([self CL_ReadAllContacts], nil);
                } else {
                    if (completion) completion(nil, [NSError errorWithDomain:@"Access not granted!" code:-1 userInfo:nil]);
                }
            }];
        }
    });
}

- (NSArray *)CL_ReadAllContacts {
    CFArrayRef allPeople = ABAddressBookCopyArrayOfAllPeople(_abRef);
    CFIndex nPeople = ABAddressBookGetPersonCount(_abRef);
    
    NSMutableArray *contacts = [[NSMutableArray alloc] initWithCapacity:nPeople];
    
    for (int i = 0; i < nPeople; i++) {
        ABRecordRef ref = CFArrayGetValueAtIndex(allPeople, i);
        CLPerson *person = [CLPerson personFromABRecordRef:ref];
        if (person) [contacts addObject:person];
    }
    
    CFRelease(allPeople);
    
    return contacts;
}

#pragma mark -

@end
