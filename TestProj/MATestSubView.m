//
//  MATestSubView.m
//  TestProj
//
//  Created by ma xiao on 12/1/15.
//  Copyright © 2015 ma xiao. All rights reserved.
//

#import "MATestSubView.h"
#import <Masonry/Masonry.h>

@interface MATestSubView()



@property (nonatomic) BOOL hasSetupConstraints;

@end

@implementation MATestSubView

- (instancetype)init {
  self = [super init];
  if (self) {
    [self setupUI];
  }
  return self;
}

- (void)updateConstraints {
  if (!self.hasSetupConstraints) {
    [self setupConstraints];
    self.hasSetupConstraints = TRUE;
  }
  [super updateConstraints];

}

- (void)layoutSubviews {
  [super layoutSubviews];
  NSLog(@"my frame: %@", NSStringFromCGRect(self.frame));
  NSLog(@"BTN 1 frame: %@", NSStringFromCGRect(self.btn1.frame));
  NSLog(@"BTN 2 frame: %@", NSStringFromCGRect(self.btn2.frame));
}

- (void)setupUI {
  UIButton *btn1 = [UIButton buttonWithType:UIButtonTypeCustom];
  [btn1 setTitle:@"Click the fuck ME!!!!" forState:UIControlStateNormal];
  [self styleButton:btn1];

  self.btn1 = btn1;

  UIButton *btn2 = [UIButton buttonWithType:UIButtonTypeCustom];
  [self styleButton:btn2];

  self.btn2 = btn2;
  [btn2 setBackgroundColor:[UIColor redColor]];
}

- (void)styleButton :(UIButton *)btn {
  [btn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
  [btn setBackgroundColor:[UIColor greenColor]];
}

- (void)setupConstraints {
  [self.btn1 mas_makeConstraints:^(MASConstraintMaker *make) {
    make.left.equalTo(self);
    make.top.equalTo(self);
    make.height.mas_equalTo(self.buttonHeight);
    make.width.equalTo(self).multipliedBy((CGFloat)1/2).offset(-2);

  }];

  [self.btn2 mas_makeConstraints:^(MASConstraintMaker *make) {
    make.left.equalTo(self.btn1.mas_right).offset(2);
    make.top.equalTo(self);
    make.height.mas_equalTo(self.buttonHeight);
    make.width.equalTo(self.btn1);

  }];
}

- (void)setupViewHierarchy {
  [self addSubview:self.btn1];
  [self addSubview:self.btn2];
}

- (void)didMoveToSuperview {
  [super didMoveToSuperview];
  [self setupViewHierarchy];
}
@end
