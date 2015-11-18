//
//  MAPhotoPlusCell.m
//  TestProj
//
//  Created by ma xiao on 11/18/15.
//  Copyright © 2015 ma xiao. All rights reserved.
//

#import "MAPhotoPlusCell.h"

@interface MAPhotoPlusCell()

@property (nonatomic, strong) UILabel *titleLabel;

@end

@implementation MAPhotoPlusCell

- (instancetype)initWithFrame:(CGRect)frame {
  self = [super initWithFrame:frame];
  if (self) {
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.textColor = [UIColor redColor];
    titleLabel.font = [UIFont systemFontOfSize:36.f];
    titleLabel.text = @"+";
    titleLabel.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.backgroundColor = [UIColor lightGrayColor];

    self.titleLabel = titleLabel;
    [self.contentView addSubview:titleLabel];
    NSLog(@"INit: %@", NSStringFromCGRect(titleLabel.frame));
  }
  return self;
}

- (void)applyLayoutAttributes:(UICollectionViewLayoutAttributes *)layoutAttributes {
  [super applyLayoutAttributes:layoutAttributes];
  NSLog(@"BEFORE APPLY: %@", NSStringFromCGRect(self.titleLabel.frame));
//  self.titleLabel.frame = self.contentView.frame;
  self.titleLabel.bounds = self.contentView.frame;
  self.titleLabel.center = self.contentView.center;
//  [self.titleLabel sizeToFit];
  NSLog(@"AFTER APPLY: %@", NSStringFromCGRect(self.titleLabel.frame));
}

@end
