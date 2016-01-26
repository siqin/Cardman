//
//  CLPhone.h
//  Cardman
//
//  Created by Jason Lee on 16/1/26.
//  Copyright © 2016年 Jason Lee. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CLPhone : NSObject

@property (nonatomic, strong) NSString *number;
@property (nonatomic, strong) NSString *originalLabel;
@property (nonatomic, strong) NSString *localizedLabel;

@end
