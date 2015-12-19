//
//  ZHSwipeActionTwoStageDeletion.h
//  Mobile
//
//  Created by ma xiao on 12/8/14.
//  Copyright (c) 2014 Zhihu.inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZHSwipeActionProtocol.h"

//@class ZHSwipeActionTwoStageDeletion;
//
//@protocol ZHSwipeActionTwoStageDeletionDelegate <NSObject>
//
//- (void)didPerformDeletion: (ZHSwipeActionTwoStageDeletion *)swipeAction;
//
//@end

@interface ZHSwipeActionTwoStageDeletion : NSObject<ZHSwipeActionController>

- (UIView *)viewWithPercentage:(CGFloat)percentage;
- (CGFloat)alphaWithPercentage:(CGFloat)percentage;
- (UIColor *)colorWithPercentage:(CGFloat)percentage;

- (ZHSwipeActionState)stateWithPercentage:(CGFloat)percentage andDirection: (ZHSwipeActionDirection)direction;
- (CGFloat)percentageWithState: (ZHSwipeActionState)state andDirection:(ZHSwipeActionDirection)direction;
- (ZHSwipeActionMode)modeWithState: (ZHSwipeActionState)state andDirection: (ZHSwipeActionDirection)direction;

//Allow the delegate to perform animation.
- (void)stateChangeFrom: (ZHSwipeActionState)current to: (ZHSwipeActionState)next activeView: (UIView *)activeView;

- (BOOL)shouldStartWithDirection: (ZHSwipeActionDirection)direction;

@end
