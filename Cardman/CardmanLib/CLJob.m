//
//  CLJob.m
//  Cardman
//
//  Created by Jason Lee on 16/1/26.
//  Copyright © 2016年 Jason Lee. All rights reserved.
//

#import "CLJob.h"

@implementation CLJob

- (BOOL)hasInfo {
    return self.organization.length > 0 || self.department.length > 0 || self.title.length > 0;
}

- (NSString *)fullJobTitle {
    if (![self hasInfo]) return nil;
    
    NSMutableString *fullTitle = [NSMutableString new];
    
    if (self.title.length > 0) [fullTitle appendString:self.title];
    if (self.department.length > 0) [fullTitle appendFormat:@", %@", self.department];
    if (self.organization.length > 0) [fullTitle appendFormat:@", %@", self.organization];
    
    return fullTitle;
}

@end
