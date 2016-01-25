//
//  CLPerson.h
//  Cardman
//
//  Created by Jason Lee on 16/1/25.
//  Copyright © 2016年 Jason Lee. All rights reserved.
//

#import <Foundation/Foundation.h>

@import AddressBook;

#import "CLAddress.h"

@interface CLPerson : NSObject

@property (nonatomic, copy) NSString *firstName;
@property (nonatomic, copy) NSString *lastName;
@property (nonatomic, copy) NSString *middleName;
@property (nonatomic, copy) NSString *compositeName;

+ (CLPerson *)personFromABRecordRef:(ABRecordRef)abRecordRef;

@end
