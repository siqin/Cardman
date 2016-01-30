//
//  CMContactListViewController.m
//  Cardman
//
//  Created by Jason Lee on 16/1/26.
//  Copyright © 2016年 Jason Lee. All rights reserved.
//

#import "CMContactListViewController.h"
#import "CardmanLib.h"
#import "CLContactsTableViewCell.h"
#import <UIActionSheet+Blocks.h>

@interface CMContactListViewController () <UITableViewDataSource, UITableViewDelegate, MGSwipeTableCellDelegate>

@property (nonatomic, strong) NSArray<CLPerson *> *contactArray;

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, assign) BOOL isEditing; // 是否进入编辑状态，允许多选联系人

@end

@implementation CMContactListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self layoutNavBar];
    
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];
    
    [[CLCardman sharedInstance] readAllContactsWithCompletion:^(NSArray *contacts, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            self.contactArray = contacts;
            [self.tableView reloadData];
        });
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - layout ui

- (void)layoutNavBar {
    self.title = @"联系人";
    
    // http://www.appcoda.com/customize-navigation-status-bar-ios-7/
    // http://stackoverflow.com/questions/17678881/how-to-change-status-bar-text-color-in-ios-7
    // http://stackoverflow.com/questions/19022210/preferredstatusbarstyle-isnt-called/19513714#19513714
    [[UINavigationBar appearance] setBarTintColor:[UIColor colorWithRed:41/255.0f green:137/255.0f blue:220/255.0f alpha:1]];
    [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor whiteColor]}];
    [[UINavigationBar appearance] setBarStyle:UIBarStyleBlack];
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    
    self.isEditing = NO;
}

#pragma mark - setter

- (void)setIsEditing:(BOOL)isEditing {
    _isEditing = isEditing;
    
    if (_isEditing) {
        UIBarButtonItem *cancelItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"CLNavCloseIcon"] style:UIBarButtonItemStylePlain target:self action:@selector(onNavBarCancelAction:)];
        self.navigationItem.leftBarButtonItems = @[cancelItem];
        
        UIBarButtonItem *selectItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"CLNavCircleTickIcon"] style:UIBarButtonItemStylePlain target:self action:@selector(onNavBarSelectAction:)];
        self.navigationItem.rightBarButtonItems = @[selectItem];
    } else {
        UIBarButtonItem *editItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"CLNavPencilIcon"] style:UIBarButtonItemStylePlain target:self action:@selector(onNavBarEditAction:)];
        self.navigationItem.leftBarButtonItems = @[editItem];
        
        UIBarButtonItem *addItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"CLNavAddContactIcon"] style:UIBarButtonItemStylePlain target:self action:@selector(onNavBarAddAction:)];
        self.navigationItem.rightBarButtonItems = @[addItem];
    }
    
    [self.tableView reloadData];
}

#pragma mark - nav bar action

- (void)onNavBarEditAction:(id)sender {
    self.isEditing = YES;
}

- (void)onNavBarAddAction:(id)sender {
    ;
}

- (void)onNavBarCancelAction:(id)sender {
    self.isEditing = NO;
}

- (void)onNavBarSelectAction:(id)sender {
    ;
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.contactArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString * cellIdentifier = @"cellIdentifier";
    CLContactsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[CLContactsTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
        cell.delegate = self;
        
        cell.rightSwipeSettings.transition = MGSwipeTransitionDrag;
        cell.rightButtons = @[[MGSwipeButton buttonWithTitle:@"发短信"
                                                        icon:[UIImage imageNamed:@"CLCellSMSIcon"]
                                             backgroundColor:[UIColor colorWithRed:58/255.0f green:255/255.0f blue:0 alpha:1]],
                              [MGSwipeButton buttonWithTitle:@"打电话"
                                                        icon:[UIImage imageNamed:@"CLCellDialIcon"]
                                             backgroundColor:[UIColor colorWithRed:14/255.0f green:152/255.0f blue:210/255.0f alpha:1]]
                              ];
        
        cell.leftSwipeSettings.transition = MGSwipeTransitionDrag;
        cell.leftButtons = @[[MGSwipeButton buttonWithTitle:@"收藏"
                                                        icon:[UIImage imageNamed:@"CLCellWhiteStarIcon"]
                                             backgroundColor:[UIColor colorWithRed:254/255.0f green:198/255.0f blue:3/255.0f alpha:1]]
                             ];
    }
    
    [self configCell:cell atIndexPath:indexPath];
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (self.isEditing) {
        CLPerson *clPerson = self.contactArray[indexPath.row];
        BOOL selected = [clPerson.extendedInfo[@"selected"] boolValue];
        clPerson.extendedInfo[@"selected"] = @(!selected);
        [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
}

#pragma mark - Config Cell

- (void)configCell:(CLContactsTableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    CLPerson *clPerson = self.contactArray[indexPath.row];
    BOOL selected = [clPerson.extendedInfo[@"selected"] boolValue];
    [cell configWithCLPerson:clPerson isEditing:self.isEditing contactSelected:selected];
}

#pragma mark - MGSwipeTableCellDelegate

-(BOOL) swipeTableCell:(MGSwipeTableCell*) cell canSwipe:(MGSwipeDirection) direction fromPoint:(CGPoint) point {
    return !self.isEditing;
}

-(BOOL) swipeTableCell:(MGSwipeTableCell*) cell tappedButtonAtIndex:(NSInteger) index direction:(MGSwipeDirection)direction fromExpansion:(BOOL) fromExpansion {
    
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    
    if (direction == MGSwipeDirectionRightToLeft) {
        if (index == 0) {
            [self smsAtIndexPath:indexPath];
        } else if (index == 1) {
            [self dialAtIndexPath:indexPath];
        }
    } else {
        ;
    }
    
    return YES;
}

- (void)dialAtIndexPath:(NSIndexPath *)indexPath {
    CLPerson *clPerson = self.contactArray[indexPath.row];
    NSArray *phoneArray = [self phoneArrayFromCLPerson:clPerson];
    
    if (phoneArray.count == 1) {
        NSString *phoneNumber = phoneArray.firstObject;
        NSString *phoneScheme = [NSString stringWithFormat:@"tel://%@", phoneNumber];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:phoneScheme]];
    } else if (phoneArray.count > 1) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [UIActionSheet showInView:self.view
                            withTitle:@"打电话"
                    cancelButtonTitle:@"取消"
               destructiveButtonTitle:nil
                    otherButtonTitles:phoneArray
                             tapBlock:^(UIActionSheet * _Nonnull actionSheet, NSInteger buttonIndex) {
                                 if (buttonIndex < phoneArray.count) {
                                     NSString *phoneNumber = phoneArray[buttonIndex];
                                     NSString *phoneScheme = [NSString stringWithFormat:@"tel://%@", phoneNumber];
                                     [[UIApplication sharedApplication] openURL:[NSURL URLWithString:phoneScheme]];
                                 }
                             }
             ];
        });
    }
}

- (void)smsAtIndexPath:(NSIndexPath *)indexPath {
    CLPerson *clPerson = self.contactArray[indexPath.row];
    NSArray *phoneArray = [self phoneArrayFromCLPerson:clPerson];
    
    if (phoneArray.count == 1) {
        NSString *phoneNumber = phoneArray.firstObject;
        NSString *phoneScheme = [NSString stringWithFormat:@"sms:%@", phoneNumber];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:phoneScheme]];
    } else if (phoneArray.count > 1) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [UIActionSheet showInView:self.view
                            withTitle:@"发短信"
                    cancelButtonTitle:@"取消"
               destructiveButtonTitle:nil
                    otherButtonTitles:phoneArray
                             tapBlock:^(UIActionSheet * _Nonnull actionSheet, NSInteger buttonIndex) {
                                 if (buttonIndex < phoneArray.count) {
                                     NSString *phoneNumber = phoneArray[buttonIndex];
                                     NSString *phoneScheme = [NSString stringWithFormat:@"sms:%@", phoneNumber];
                                     [[UIApplication sharedApplication] openURL:[NSURL URLWithString:phoneScheme]];
                                 }
                             }
             ];
        });
    }
}

- (NSArray *)phoneArrayFromCLPerson:(CLPerson *)clPerson {
    NSMutableArray *phoneArray = [[NSMutableArray alloc] initWithCapacity:clPerson.phones.count];
    for (CLPhone *clPhone in clPerson.phones) {
        if (clPhone.number.length > 0) {
            [phoneArray addObject:clPhone.number];
        }
    }
    return phoneArray;
}

#pragma mark -

@end
