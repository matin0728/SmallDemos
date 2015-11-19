//
//  MAPhotoCollectionViewCell.m
//  TestProj
//
//  Created by ma xiao on 11/18/15.
//  Copyright © 2015 ma xiao. All rights reserved.
//

#define MARGIN 10.f

#import "MAPhotoCollectionViewCell.h"
#import "MASpringBoardLayoutAttributes.h"

@implementation MAPhotoCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
  self = [super initWithFrame:frame];
  if (self) {
    self.deleteButton = [[UIButton alloc] initWithFrame:CGRectMake(frame.size.width/16, frame.size.width/16, frame.size.width/4, frame.size.width/4)];

    CGRect buttonFrame = self.deleteButton.frame;
    UIGraphicsBeginImageContext(buttonFrame.size);
    CGFloat sz = MIN(buttonFrame.size.width, buttonFrame.size.height);
    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(buttonFrame.size.width/2, buttonFrame.size.height/2) radius:sz/2-MARGIN startAngle:0 endAngle:M_PI * 2 clockwise:YES];
    [path moveToPoint:CGPointMake(MARGIN, MARGIN)];
    [path addLineToPoint:CGPointMake(sz-MARGIN, sz-MARGIN)];
    [path moveToPoint:CGPointMake(MARGIN, sz-MARGIN)];
    [path addLineToPoint:CGPointMake(sz-MARGIN, MARGIN)];
    [[UIColor redColor] setFill];
    [[UIColor whiteColor] setStroke];
    [path setLineWidth:3.0];
    [path fill];
    [path stroke];
    self.deleteButtonImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    [self.deleteButton setImage:self.deleteButtonImage forState:UIControlStateNormal];
    [self.contentView addSubview:self.deleteButton];
  }
  return self;
}

- (void)startQuivering {
  CABasicAnimation *quiverAnim = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
  float startAngle = (-2) * M_PI/180.0;
  float stopAngle = -startAngle;
  quiverAnim.fromValue = [NSNumber numberWithFloat:startAngle];
  quiverAnim.toValue = [NSNumber numberWithFloat:3 * stopAngle];
  quiverAnim.autoreverses = YES;
  quiverAnim.duration = 0.2;
  quiverAnim.repeatCount = HUGE_VALF;
  float timeOffset = (float)(arc4random() % 100)/100 - 0.50;
  quiverAnim.timeOffset = timeOffset;
  CALayer *layer = self.layer;
  [layer addAnimation:quiverAnim forKey:@"quivering"];
}

- (void)stopQuivering {
  CALayer *layer = self.layer;
  [layer removeAnimationForKey:@"quivering"];
}

- (void)applyLayoutAttributes:(UICollectionViewLayoutAttributes *)layoutAttributes {
  [super applyLayoutAttributes:layoutAttributes];
  MASpringBoardLayoutAttributes *attr = (MASpringBoardLayoutAttributes *)layoutAttributes;
  self.deleteButton.hidden = !attr.deletionMode;
  if (attr.deletionMode) {
    [self startQuivering];
  } else {
    [self stopQuivering];
  }
}

@end
