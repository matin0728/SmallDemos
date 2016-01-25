//
//  ViewController.m
//  TestProj
//
//  Created by ma xiao on 5/23/15.
//  Copyright (c) 2015 ma xiao. All rights reserved.
//

#import "ViewController.h"
#import "UIColor+Addition.h"
#import "MAUITableViewCell.h"
#import "MAAsyncViewAnimationViewController.h"
#import "MAAutoLayoutCellTableViewController.h"
#import "MAAccessPhotosViewController.h"
#import "MAPhotoManagerCollectionViewController.h"
#import "MASpringBoardLayout.h"
#import "MASubViewConstraintsTestViewController.h"
#import "MAHostingViewViewController.h"

static NSString *const kComponentHostingView = @"异步视图的动画支持";
static NSString *const kAutoLayoutTableViewCell = @"使用自动布局的 TableViewCell";
static NSString *const kAccessAlbum = @"访问相机和相册";
static NSString *const kPhotoManager = @"相片管理";
static NSString *const kSubViewConstraints = @"子视图约束";
static NSString *const kHostingView = @"ComponentHostingView";

@interface ViewController ()<UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) UITableView *table;
@end

@implementation ViewController

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
  self = [super initWithCoder:aDecoder];
  if (self) {

  }
  return self;
}

- (void)viewDidLoad {
  [super viewDidLoad];

  self.title = @"Demo 列表";

  self.view.backgroundColor = [UIColor whiteColor];
  self.table = [[UITableView alloc] init];
  self.table.backgroundColor = [UIColor colorWithHexString:@"#F7F7F7"];
  [self.view addSubview:self.table];
  self.table.frame = self.view.frame;
  self.table.delegate  = self;
  self.table.dataSource = self;
  self.table.separatorStyle = UITableViewCellSeparatorStyleNone;

  [self.table registerClass:MAUITableViewCell.class forCellReuseIdentifier:@"CELL"];
}

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  if (section == 0) {
    NSArray *model = [self createModel];
    return model.count;
  }
  return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  MAUITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CELL" forIndexPath:indexPath];
  cell.textLabel.textColor = [UIColor blackColor];
  NSArray *model = [self createModel];
  cell.textLabel.text = model[indexPath.row];
  [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
  return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  return 60.f;
}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  NSArray *model = [self createModel];
  NSString *row = model[indexPath.row];
  UIViewController *controller;
  if ([row isEqualToString:kComponentHostingView]) {
    controller = [[MAAsyncViewAnimationViewController alloc] init];
  } else if ([row isEqualToString:kAutoLayoutTableViewCell]) {
    controller = [[MAAutoLayoutCellTableViewController alloc] init];
  } else if ([row isEqualToString:kAccessAlbum]) {
    controller = [[MAAccessPhotosViewController alloc] init];
  } else if ([row isEqualToString:kPhotoManager]) {

//    @property (nonatomic) CGFloat minimumLineSpacing;
//    @property (nonatomic) CGFloat minimumInteritemSpacing;
//    @property (nonatomic) CGSize itemSize;

    MASpringBoardLayout *springLayout = [[MASpringBoardLayout alloc] init];
    springLayout.minimumInteritemSpacing = 5;
    springLayout.minimumInteritemSpacing = 5;
    CGFloat WIDTH = [UIScreen mainScreen].bounds.size.width;
    springLayout.itemSize = CGSizeMake((WIDTH - 5)/2, (WIDTH - 5)/2);
    controller = [[MAPhotoManagerCollectionViewController alloc] initWithCollectionViewLayout:springLayout];
  } else if ([row isEqualToString:kSubViewConstraints]) {
    controller = [[MASubViewConstraintsTestViewController alloc] init];

  } else if ([row isEqualToString:kHostingView]) {
    controller = [[MAHostingViewViewController alloc] init];
  }

  [self.navigationController pushViewController:controller animated:YES];
  return nil;
}

- (NSArray *)createModel {
  static NSArray *model;
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    model = @[kComponentHostingView, kAutoLayoutTableViewCell, kAccessAlbum, kPhotoManager, kSubViewConstraints, kHostingView];
  });
  return model;
}

@end












