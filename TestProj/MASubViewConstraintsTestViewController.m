//
//  MASubViewConstraintsTestViewController.m
//  TestProj
//
//  Created by ma xiao on 12/1/15.
//  Copyright © 2015 ma xiao. All rights reserved.
//

#import "MASubViewConstraintsTestViewController.h"
#import "MATestSubView.h"
#import <Masonry/Masonry.h>

@interface MASubViewConstraintsTestViewController ()

@property (nonatomic,strong) MATestSubView *testView;
@end

@implementation MASubViewConstraintsTestViewController

- (void)viewDidLoad {
  [super viewDidLoad];

  self.view.backgroundColor = [UIColor whiteColor];

  MATestSubView *test = [[MATestSubView alloc] init];
  [self.view addSubview:test];
  self.testView = test;

  test.buttonHeight = 44;
  test.backgroundColor = [UIColor grayColor];

  [test mas_makeConstraints:^(MASConstraintMaker *make) {
    make.width.equalTo(self.view);
    make.top.equalTo(self.view).offset(100);
    make.left.equalTo(self.view);
    make.height.mas_equalTo(45);
  }];

  [self.view layoutIfNeeded];

  [self.testView.btn1 addTarget:self action:@selector(onTapButton:) forControlEvents:UIControlEventTouchUpInside];
  [self.testView.btn2 addTarget:self action:@selector(onTapButton:) forControlEvents:UIControlEventTouchUpInside];


  UIButton *btn3 = [UIButton buttonWithType:UIButtonTypeSystem];
  [self.view addSubview:btn3];
  [btn3 mas_makeConstraints:^(MASConstraintMaker *make) {
    make.top.mas_equalTo(64);
    make.left.mas_equalTo(20);
    make.width.mas_equalTo(100);
    make.height.mas_equalTo(44);
  }];
  [btn3 setTitle:@"hahahahahah" forState:UIControlStateNormal];
  [btn3 addTarget:self action:@selector(onTapButton:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)onTapButton: (id)sender {
//  UIViewController *self; // code assumes you're in a view controller
//  UIButton *button; // the button you want to show the popup sheet from
  UIButton *button = (UIButton *)sender;

  UIAlertController *alertController;
  UIAlertAction *destroyAction;
  UIAlertAction *otherAction;

  alertController = [UIAlertController alertControllerWithTitle:nil
                                                        message:nil
                                                 preferredStyle:UIAlertControllerStyleActionSheet];
  destroyAction = [UIAlertAction actionWithTitle:@"Remove All Data"
                                           style:UIAlertActionStyleDestructive
                                         handler:^(UIAlertAction *action) {
                                           // do destructive stuff here
                                         }];
  otherAction = [UIAlertAction actionWithTitle:@"Blah"
                                         style:UIAlertActionStyleDefault
                                       handler:^(UIAlertAction *action) {
                                         // do something here
                                       }];
  // note: you can control the order buttons are shown, unlike UIActionSheet
  [alertController addAction:destroyAction];
  [alertController addAction:otherAction];
  [alertController setModalPresentationStyle:UIModalPresentationPopover];

  //IMPORTANT: 这个对于 iPad 是必要的吗？
  UIPopoverPresentationController *popPresenter = [alertController
                                                   popoverPresentationController];
  popPresenter.sourceView = button;
  popPresenter.sourceRect = button.bounds;
  //End for ipad.

  [self presentViewController:alertController animated:YES completion:nil];
}

@end
