//
//  MAAsyncViewAnimationViewController.m
//  TestProj
//
//  Created by ma xiao on 11/4/15.
//  Copyright © 2015 ma xiao. All rights reserved.
//

#import "MAAsyncViewAnimationViewController.h"
#import "UIColor+Addition.h"
#import "MAUITableViewCell.h"

@interface MAAsyncViewAnimationViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *table;
@property (nonatomic, strong) CKComponentHostingView *hostingView;

@end

@implementation MAAsyncViewAnimationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
  _hostingView = [[CKComponentHostingView alloc]
                  initWithComponentProvider:self.class sizeRangeProvider:[CKComponentFlexibleSizeRangeProvider providerWithFlexibility:CKComponentSizeRangeFlexibleHeight]];
  _hostingView.frame = CGRectMake(0, 64, self.view.frame.size.width, 200);
  [self.view addSubview:_hostingView];
  [self.view setBackgroundColor:[UIColor whiteColor]];

  self.view.backgroundColor = [UIColor whiteColor];
  self.table = [[UITableView alloc] init];
  self.table.backgroundColor = [UIColor clearColor];
  [self.view addSubview:self.table];
  self.table.frame = self.view.frame;
  self.table.frame.origin = CGPointMake(self.table.frame.origin.x, 64);
  self.table.delegate  = self;
  self.table.dataSource = self;
  self.table.separatorStyle = UITableViewCellSeparatorStyleNone;

 [self.table registerClass:MAUITableViewCell.class forCellReuseIdentifier:@"CELL"];

  UIView *header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 200)];
  self.table.tableHeaderView = header;
}

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  [self.hostingView updateContext:nil mode:CKUpdateModeAsynchronous];
  [self.hostingView updateModel:@"" mode:CKUpdateModeAsynchronous];
}

+ (CKComponent *)componentForModel:(id<NSObject>)model context:(id<NSObject>)context {
  return [CKCompositeComponent
          newWithComponent:[CKBackgroundLayoutComponent
                            newWithComponent:[CKInsetComponent
                                              newWithInsets:UIEdgeInsetsMake(30, 10, 30, 10)
                                              component:[CKLabelComponent
                                                         newWithLabelAttributes:{
                                                           .string = @"知乎大法就是好",
                                                           .color = [UIColor greenColor],
                                                           .font = [UIFont systemFontOfSize:20.f]
                                                         }
                                                         viewAttributes:{
                                                           {{@selector(setBackgroundColor:), [UIColor clearColor]},{@selector(setTag:), @(10086)}}
                                                         }]]
                            background:[CKImageComponent
                                        newWithImage:[UIImage imageNamed:@"test.png"]]]];
}

- (void)componentHostingViewDidInvalidateSize:(CKComponentHostingView *)hostingView {
  
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  MAUITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CELL" forIndexPath:indexPath];
  cell.textLabel.textColor = [UIColor blackColor];
  cell.textLabel.text = @"这里是一些表格数据。";
  [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
  return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  return 60.f;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  if (section == 0) {
    return 10;
  }
  return 0;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
  NSLog(@"Conent offset: %.f", scrollView.contentOffset.y);
  UIView *lb = [self.hostingView viewWithTag:10086];
  CGFloat trans = scrollView.contentOffset.y < 0?-scrollView.contentOffset.y:0;
  if (trans > 0) {
    lb.transform = CGAffineTransformMakeTranslation(0, trans/2);
  } else {
    lb.transform = CGAffineTransformIdentity;
  }

}

@end



















