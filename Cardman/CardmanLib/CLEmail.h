//
//  CLEmail.h
//  Cardman
//
//  Created by Jason Lee on 16/1/26.
//  Copyright © 2016年 Jason Lee. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CLEmail : NSObject

@property (nonatomic, strong) NSString *address;
@property (nonatomic, strong) NSString *originalLabel;
@property (nonatomic, strong) NSString *localizedLabel;

@end
