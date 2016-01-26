//
//  CLAddress.h
//  Cardman
//
//  Created by Jason Lee on 16/1/25.
//  Copyright © 2016年 Jason Lee. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CLAddress : NSObject

@property (nullable, nonatomic, strong) NSString *street;
@property (nullable, nonatomic, strong) NSString *city;
@property (nullable, nonatomic, strong) NSString *state;
@property (nullable, nonatomic, strong) NSString *zip;
@property (nullable, nonatomic, strong) NSString *country;
@property (nullable, nonatomic, strong) NSString *countryCode;
@property (nullable, nonatomic, strong) NSString *originalLabel;
@property (nullable, nonatomic, strong) NSString *localizedLabel;

@end
