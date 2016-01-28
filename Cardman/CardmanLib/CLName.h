//
//  CLName.h
//  Cardman
//
//  Created by Jason Lee on 16/1/26.
//  Copyright © 2016年 Jason Lee. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CLName : NSObject

@property (nonatomic, strong) NSString *firstName;
@property (nonatomic, strong) NSString *lastName;
@property (nonatomic, strong) NSString *middleName;

@property (nonatomic, strong) NSString *compositeName;
@property (nonatomic, strong) NSString *nickname;

@property (nonatomic, strong) NSString *prefix;
@property (nonatomic, strong) NSString *suffix;

@property (nonatomic, strong) NSString *firstNamePhonetic;
@property (nonatomic, strong) NSString *lastNamePhonetic;
@property (nonatomic, strong) NSString *middleNamePhonetic;

@end
