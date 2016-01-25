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

#import "CLPerson.h"

@implementation CLCardman

+ (BOOL)hasAccessToAddressBook {
    ABAuthorizationStatus status = ABAddressBookGetAuthorizationStatus();
    return status == kABAuthorizationStatusAuthorized;
}

+ (void)requestAccessToAddressBookWithCompletion:(void (^)(BOOL granted))completion {
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
        ABAddressBookRef abRef = ABAddressBookCreateWithOptions(NULL, nil);
        ABAddressBookRequestAccessWithCompletion(abRef, ^(bool granted, CFErrorRef error) {
            if (completion) completion(granted);
        });
    } else {
        if (completion) completion(YES);
    }
}

+ (void)readAllContactsWithCompletion:(void (^)(NSArray *contacts, NSError *error))completion {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        if ([CLCardman hasAccessToAddressBook]) {
            if (completion) completion([self CL_ReadAllContacts], nil);
        } else {
            [CLCardman requestAccessToAddressBookWithCompletion:^(BOOL granted) {
                if (granted) {
                    if (completion) completion([self CL_ReadAllContacts], nil);
                } else {
                    if (completion) completion(nil, [NSError errorWithDomain:@"" code:-1 userInfo:nil]);
                }
            }];
        }
    });
}

#pragma mark - 

+ (NSArray *)CL_ReadAllContacts {
    ABAddressBookRef abRef = ABAddressBookCreateWithOptions(NULL, nil);
    CFArrayRef allPeople = ABAddressBookCopyArrayOfAllPeople(abRef);
    CFIndex nPeople = ABAddressBookGetPersonCount(abRef);
    
    NSMutableArray *contacts = [[NSMutableArray alloc] initWithCapacity:nPeople];
    
    for (int i = 0; i < nPeople; i++) {
        ABRecordRef ref = CFArrayGetValueAtIndex(allPeople, i);
        CLPerson *person = [CLPerson personFromABRecordRef:ref];
        if (person) [contacts addObject:person];
    }
    
    CFRelease(allPeople);
    CFRelease(abRef);
    
    return contacts;
}

@end
