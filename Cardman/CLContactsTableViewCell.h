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

@property (nonatomic, assign) BOOL contactSelected;

- (void)configWithCLPerson:(CLPerson *)clPerson
                 isEditing:(BOOL)isEditing
           contactSelected:(BOOL)contactSelected;

@end
