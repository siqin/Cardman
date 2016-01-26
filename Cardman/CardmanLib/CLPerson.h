//
//  CLPerson.h
//  Cardman
//
//  Created by Jason Lee on 16/1/25.
//  Copyright © 2016年 Jason Lee. All rights reserved.
//

#import <Foundation/Foundation.h>

@import AddressBook;
@import UIKit;

#import "CLName.h"
#import "CLPhone.h"
#import "CLAddress.h"
#import "CLEmail.h"
#import "CLJob.h"

// 部分属性可以延迟加载
@interface CLPerson : NSObject

@property (nonatomic, strong) NSNumber *recordId;

@property (nonatomic, strong) CLName *name;
@property (nonatomic, strong) UIImage *avatar;
@property (nonatomic, strong) NSArray <CLPhone *> *phones;

@property (nonatomic, strong) NSArray <CLAddress *> *addresses;
@property (nonatomic, strong) NSArray <CLEmail *> *emails;
@property (nonatomic, strong) NSArray <NSString *> *websites;

@property (nonatomic, strong) NSDate *birthday;
@property (nonatomic, strong) NSString *note;
@property (nonatomic, strong) CLJob *job;

+ (CLPerson *)personFromABRecordRef:(ABRecordRef)abRecordRef;

@end
