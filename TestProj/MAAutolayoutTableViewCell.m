//
//  MAAutolayoutTableViewCell.m
//  TestProj
//
//  Created by ma xiao on 11/7/15.
//  Copyright © 2015 ma xiao. All rights reserved.
//

#import "MAAutolayoutTableViewCell.h"
#import <Masonry/Masonry.h>

@interface MAAutolayoutTableViewCell()

@property (nonatomic) BOOL hasSetupConstraints;

@property (nonatomic , strong) UILabel *titleLable;
@property (nonatomic , strong) UIImageView *avatarImage;

@end


@implementation MAAutolayoutTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
  self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
  if (self) {
    self.titleLable = [[UILabel alloc] init];
    self.titleLable.text = @"我是一个 Label";
    [self.contentView addSubview:self.titleLable];

    self.avatarImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@""]];
    [self.contentView addSubview:self.avatarImage];
  }

  return self;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (void)updateConstraints {
  if (!self.hasSetupConstraints) {
    [self makeConstraints];
    self.hasSetupConstraints = YES;
  }
  [super updateConstraints];
}

- (void)makeConstraints {
  [self.avatarImage mas_makeConstraints:^(MASConstraintMaker *make) {
    make.top.equalTo(self.contentView).offset(10);
    make.right.equalTo(self.contentView);
    make.bottom.equalTo(self.contentView).offset(-10);
    make.width.mas_equalTo(100);
    make.height.mas_equalTo(100);
  }];

  [self.titleLable mas_makeConstraints:^(MASConstraintMaker *make) {
    make.left.equalTo(self.contentView);
    make.centerY.equalTo(self.avatarImage);
  }];
}
@end
