//
//  MAUITableViewCell.m
//  TestProj
//
//  Created by ma xiao on 11/4/15.
//  Copyright © 2015 ma xiao. All rights reserved.
//

#import "MAUITableViewCell.h"
#import "UIColor+Addition.h"

@implementation MAUITableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
  self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
  if (self) {
//    self.contentView.backgroundColor = [UIColor colorWithRed:45 green:0.3 blue:0.4 alpha:1];
    self.textLabel.frame = CGRectMake(10, 10, 600, 40);
    self.textLabel.backgroundColor = [UIColor clearColor];
  }
  return self;
}

- (void)drawRect:(CGRect)rect {
  [super drawRect:rect];

  CGPoint point = CGPointMake(rect.origin.x + 10, rect.origin.y + rect.size.height -1);

  CGContextRef context = UIGraphicsGetCurrentContext();
  CGContextSetStrokeColorWithColor(context, self.separatorColor.CGColor);

  // Draw them with a 2.0 stroke width so they are a bit more visible.
  CGContextSetLineWidth(context, 1/[UIScreen mainScreen].scale);
  CGContextMoveToPoint(context, point.x, point.y); //start at this point

  CGContextAddLineToPoint(context, point.x + rect.size.width - 10, point.y); //draw to this point

  // and now draw the Path!
  CGContextStrokePath(context);

  NSLog(@"Scale: %.f", [UIScreen mainScreen].scale);

}

- (UIColor *)getSeparatorColor {
  if (!_separatorColor) {
    return [UIColor colorWithHexString:@"#F7F7F7"];
  }
  return _separatorColor;
}
@end
