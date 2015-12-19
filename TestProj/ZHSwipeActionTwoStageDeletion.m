//
//  ZHSwipeActionTwoStageDeletion.m
//  Mobile
//
//  Created by ma xiao on 12/8/14.
//  Copyright (c) 2014 Zhihu.inc. All rights reserved.
//

#import "ZHSwipeActionTwoStageDeletion.h"

@implementation ZHSwipeActionTwoStageDeletion

- (UIView *)viewWithPercentage:(CGFloat)percentage {
  //Override this func in subclass, here just for demo.
  static UIImageView *iv = nil;
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    iv = [[UIImageView alloc] initWithImage: ZHImageWithName(@"Find_Highlight.png")];
  });
  
  return iv;
}

- (CGFloat)alphaWithPercentage:(CGFloat)percentage {
  return 1.0;
}

- (UIColor *)colorWithPercentage:(CGFloat)percentage {
  return [UIColor grayColor];
}

- (ZHSwipeActionState)stateWithPercentage:(CGFloat)percentage andDirection: (ZHSwipeActionDirection)direction {
  CGFloat per = fabs(percentage);
  if (per < .31f) {
    return ZHSwipeActionStateNone;
  } if (per < .50f) {
    return ZHSwipeActionStateStage1;
  } else {
    return ZHSwipeActionStateStage2;
  }
}

- (CGFloat)percentageWithState: (ZHSwipeActionState)state andDirection:(ZHSwipeActionDirection)direction{
  if (state == ZHSwipeActionStateStage1) {
    return .31f;
  } else if (state == ZHSwipeActionStateStage2) {
    return .50f;
  }
  return 0.f;
}

- (ZHSwipeActionMode)modeWithState: (ZHSwipeActionState)state andDirection: (ZHSwipeActionDirection)direction {
  if (state == ZHSwipeActionStateStage2) {
    return ZHSwipeActionModeExit;
  }
  return ZHSwipeActionSwitch;
}

- (BOOL)shouldStartWithDirection: (ZHSwipeActionDirection)direction {
  //Only support right to left.
  return direction == ZHSwipeActionDirectionRight;
}

- (void)stateChangeFrom: (ZHSwipeActionState)current to: (ZHSwipeActionState)next activeView: (UIView *)activeView {
  //Nothing to do.
}

@end
