//
//  CLContactsTableViewCell.h
//  Cardman
//
//  Created by Jason Lee on 16/1/29.
//  Copyright © 2016年 Jason Lee. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MGSwipeTableCell.h>

@class CLPerson;

@interface CLContactsTableViewCell : MGSwipeTableCell

- (void)configWithCLPerson:(CLPerson *)clPerson;

@end
