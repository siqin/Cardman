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
#import "CLRecordDate.h"
#import "CLPersonDate.h"
#import "CLSocialProfile.h"
#import "CLInstantMessage.h"
#import "CLRelatedName.h"
#import "CLRecordSource.h"
#import "CLAlternateBirthday.h"

@interface CLPerson : NSObject

@property (nonatomic, strong) NSNumber *recordId;

@property (nonatomic, strong) CLName *name;
@property (nonatomic, strong) UIImage *avatar;
@property (nonatomic, strong) NSArray <CLPhone *> *phones;

@property (nonatomic, strong) CLRecordDate *recordDate;

// 以下属性可以延迟加载

@property (nonatomic, strong) NSDate *birthday;
@property (nonatomic, strong) NSString *note;
@property (nonatomic, strong) CLJob *job;

@property (nonatomic, strong) NSArray <CLAddress *> *addresses;
@property (nonatomic, strong) NSArray <CLEmail *> *emails;
@property (nonatomic, strong) NSArray <NSString *> *websites;
@property (nonatomic, strong) NSArray <CLPersonDate *> *dates;
@property (nonatomic, strong) NSArray <CLSocialProfile *> *socialProfiles;
@property (nonatomic, strong) NSArray <CLInstantMessage *> *IMAccounts;

@property (nonatomic, strong) NSArray <CLRelatedName *> *relatedNames;
@property (nonatomic, strong) NSArray <NSNumber *> *linkedRecordIDs;
@property (nonatomic, strong) CLRecordSource *source;

@property (nonatomic, strong) CLAlternateBirthday *alternateBirthday;

/// @brief 只存在于内存中的临时信息
@property (nonatomic, strong) NSMutableDictionary *extendedInfo;

+ (CLPerson *)personFromABRecordRef:(ABRecordRef)abRecordRef;

@end
