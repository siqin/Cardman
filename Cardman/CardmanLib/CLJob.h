//
//  CLJob.h
//  Cardman
//
//  Created by Jason Lee on 16/1/26.
//  Copyright © 2016年 Jason Lee. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CLObject.h"

@interface CLJob : NSObject <CLObject>

@property (nonatomic, strong) NSString *organization;
@property (nonatomic, strong) NSString *department;
@property (nonatomic, strong) NSString *title;

- (NSString *)fullJobTitle;

@end
