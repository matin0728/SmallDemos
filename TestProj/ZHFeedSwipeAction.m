//
//  ZHFeedSwipeAction.m
//  Mobile
//
//  Created by ma xiao on 12/8/14.
//  Copyright (c) 2014 Zhihu.inc. All rights reserved.
//

// .31 ~= 100PT on iPhone 5s

#import "ZHFeedSwipeAction.h"


@implementation ZHFeedSwipeAction

- (UIView *)viewWithPercentage:(CGFloat)percentage {
  //Override this func in subclass, here just for demo.
  CGFloat p = fabs(percentage);
  if (p < .31f) {
//    UITextView *tv = nil;
    
    static UILabel *lb = nil;
    static dispatch_once_t onceTokenLabel;
    dispatch_once(&onceTokenLabel, ^{
      lb = [[UILabel alloc] init];
      lb.font = [UIFont systemFontOfSize: 14.f];
      lb.text = @"不再显示";
      lb.textColor = [UIColor whiteColor];
      lb.frame = CGRectMake(0, 0, 58.f, 20.f);
    });
    return lb;
  } else {
    static UIImageView *smallImage = nil;
    static dispatch_once_t onceTokenSmallImage;
    dispatch_once(&onceTokenSmallImage, ^{
      smallImage = [[UIImageView alloc] initWithImage: ZHImageWithName(@"Not-interested.png")];
    });
    return smallImage;
  }
}

//if percentage > 0, swipt to right, or swipe to left.
- (UIColor *)colorWithPercentage:(CGFloat)percentage {
  if (percentage > 0) {
    //TODO: 这里需要返回当前 ThemeManager Table cell 的默认底色.
    return [UIColor colorWithRGBHex:0xFFFFFF];
  } else {
    return [UIColor colorWithRGBHex:0xFE6270];
  }
  
}

- (void)stateChangeFrom:(ZHSwipeActionState)current to:(ZHSwipeActionState)next activeView:(UIView *)activeView {
//  NSLog(@"State chaange from: %ld to %ld , with view: %@", (long)current, (long)next, activeView);
  if ((current == ZHSwipeActionStateStage1 && next == ZHSwipeActionStateStage2) || (current == ZHSwipeActionStateStage2 && next == ZHSwipeActionStateStage1)) {
    UIView *img = activeView;
    [UIView animateWithDuration:.25
                     animations:^{
                       img.transform = CGAffineTransformMakeScale(1.25, 1.25);
                     }
                     completion:^(BOOL finished) {
                       [UIView animateWithDuration:0.1
                                        animations:^{
                                          img.transform = CGAffineTransformMakeScale(0.75, 0.75);
                                        }
                                        completion:^(BOOL finished1) {
                                          [UIView animateWithDuration:0.1
                                                           animations:^{
                                                             img.transform = CGAffineTransformMakeScale(1.0, 1.0);
                                                           } completion:^(BOOL finished2) {
                                                             img.transform = CGAffineTransformMakeScale(1, 1);
                                                           }];
                                        }];
                     }];
  }
}

@end
