//
//  MAAutoLayoutCellTableViewController.m
//  TestProj
//
//  Created by ma xiao on 11/7/15.
//  Copyright © 2015 ma xiao. All rights reserved.
//

#import "MAAutoLayoutCellTableViewController.h"
#import "MAAutolayoutTableViewCell.h"

@interface MAAutoLayoutCellTableViewController ()

@end

@implementation MAAutoLayoutCellTableViewController

- (void)viewDidLoad {
  [super viewDidLoad];
    
  [self.tableView registerClass:MAAutolayoutTableViewCell.class forCellReuseIdentifier:@"CELL"];
  self.tableView.estimatedRowHeight = 50.f;
  self.tableView.rowHeight = UITableViewAutomaticDimension;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return 10;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  MAAutolayoutTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CELL" forIndexPath:indexPath];

  [cell setNeedsUpdateConstraints];
  [cell updateConstraintsIfNeeded];
//  [cell setNeedsLayout];
//  [cell layoutIfNeeded];
  return cell;
}

@end
