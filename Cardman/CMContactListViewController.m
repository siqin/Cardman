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

@interface CMContactListViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) NSArray<CLPerson *> *contactArray;

@property (nonatomic, strong) UITableView *tableView;

@end

@implementation CMContactListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"联系人";
    
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.contactArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString * cellIdentifier = @"cellIdentifier";
    CLContactsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[CLContactsTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
    }
    
    CLPerson *clPerson = self.contactArray[indexPath.row];
    [cell configWithCLPerson:clPerson];
    
    cell.rightButtons = @[[MGSwipeButton buttonWithTitle:@"发短信"
                                         backgroundColor:[UIColor greenColor]
                                                callback:^BOOL(MGSwipeTableCell *sender) {
                                                    return YES;
                                                }],
                          [MGSwipeButton buttonWithTitle:@"打电话"
                                         backgroundColor:[UIColor blueColor]
                                                callback:^BOOL(MGSwipeTableCell *sender) {
                                                    return YES;
                                                }]
                          ];
    cell.rightSwipeSettings.transition = MGSwipeTransition3D;
    
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    CLContactsTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
}

#pragma mark -

@end
