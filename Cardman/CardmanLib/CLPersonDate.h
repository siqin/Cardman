//
//  CLPersonDate.h
//  Cardman
//
//  Created by Jason Lee on 16/1/28.
//  Copyright © 2016年 Jason Lee. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CLPersonDate : NSObject

@property (nonatomic, strong) NSDate *date;
@property (nonatomic, strong) NSString *originalLabel;
@property (nonatomic, strong) NSString *localizedLabel;

@end
