//
//  CLAlternateBirthday.h
//  Cardman
//
//  Created by Jason Lee on 16/1/29.
//  Copyright © 2016年 Jason Lee. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CLAlternateBirthday : NSObject

@property (nonatomic, strong) NSString *calendarIdentifier;

@property (nonatomic, assign) NSInteger era;
@property (nonatomic, assign) NSInteger year;
@property (nonatomic, assign) NSInteger month;
@property (nonatomic, assign) NSInteger day;

@property (nonatomic, assign) BOOL isLeapMonth;

@end
