//
//  MAPhotoCell.m
//  TestProj
//
//  Created by ma xiao on 11/18/15.
//  Copyright © 2015 ma xiao. All rights reserved.
//

#import "MAPhotoCell.h"

@implementation MAPhotoCell

- (instancetype)initWithFrame:(CGRect)frame {
  self = [super initWithFrame:frame];
  if (self){
    UILabel *lb = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 80, 80)];
    lb.font = [UIFont systemFontOfSize:60.f];
    lb.textColor = [UIColor greenColor];
    self.titleLabel = lb;
    [self.contentView addSubview:lb];
  }
  return self;
}

- (void)applyLayoutAttributes:(UICollectionViewLayoutAttributes *)layoutAttributes {
  [super applyLayoutAttributes:layoutAttributes];
  self.titleLabel.center = self.contentView.center;
}

@end
