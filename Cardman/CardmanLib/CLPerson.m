//
//  CLPerson.m
//  Cardman
//
//  Created by Jason Lee on 16/1/25.
//  Copyright © 2016年 Jason Lee. All rights reserved.
//

#import "CLPerson.h"

@implementation CLPerson

+ (CLPerson *)personFromABRecordRef:(ABRecordRef)abRecordRef {
    CLPerson *clPerson = [CLPerson new];
    
    clPerson.firstName = [CLPerson readStringProperty:kABPersonFirstNameProperty fromABRecordRef:abRecordRef];
    clPerson.lastName = [CLPerson readStringProperty:kABPersonLastNameProperty fromABRecordRef:abRecordRef];
    clPerson.middleName = [CLPerson readStringProperty:kABPersonMiddleNameProperty fromABRecordRef:abRecordRef];
    
    CFStringRef compositeNameRef = ABRecordCopyCompositeName(abRecordRef);
    clPerson.compositeName =  (__bridge_transfer NSString *)compositeNameRef;
    
    return clPerson;
}

+ (NSString *)readStringProperty:(ABPropertyID)propertyId fromABRecordRef:(ABRecordRef)abRecordRef {
    CFTypeRef valueRef = (ABRecordCopyValue(abRecordRef, propertyId));
    return (__bridge_transfer NSString *)valueRef;
}

@end
