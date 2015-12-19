//
//  ZHSwipeActionProtocol.h
//  Mobile
//
//  Created by ma xiao on 12/9/14.
//  Copyright (c) 2014 Zhihu.inc. All rights reserved.
//

@class ZHSwipeActionRenderer;

/** Describes the mode used during a swipe */
typedef NS_ENUM(NSUInteger, ZHSwipeActionMode) {
  /** Disabled swipe.  */
  ZHSwipeActionModeNone = 0,
  
  /** Upon swipe the view if exited from the view. Useful for destructive actions. */
  ZHSwipeActionModeExit,
  
  /** Upon swipe the view if automatically swiped back to it's initial position. */
  ZHSwipeActionSwitch
};

/** Describes the state that has been triggered by the user. */
typedef NS_OPTIONS(NSUInteger, ZHSwipeActionState) {
  
  /** No state has been triggered. */
  ZHSwipeActionStateNone = 0,
  
  /** 1st state triggered during a swipe. */
  ZHSwipeActionStateStage1 = (1 << 0),
  
  /** 2nd state triggered during a swipe. */
  ZHSwipeActionStateStage2 = (1 << 1),
};

typedef NS_ENUM(NSUInteger, ZHSwipeActionDirection) {
  ZHSwipeActionDirectionLeft = 0,
  ZHSwipeActionDirectionCenter,
  ZHSwipeActionDirectionRight
};

@protocol ZHSwipeActionController <NSObject>

- (UIView *)viewWithPercentage:(CGFloat)percentage;
- (CGFloat)alphaWithPercentage:(CGFloat)percentage;
- (UIColor *)colorWithPercentage:(CGFloat)percentage;

- (ZHSwipeActionState)stateWithPercentage:(CGFloat)percentage andDirection: (ZHSwipeActionDirection)direction;
- (CGFloat)percentageWithState: (ZHSwipeActionState)state andDirection:(ZHSwipeActionDirection)direction;
- (ZHSwipeActionMode)modeWithState: (ZHSwipeActionState)state andDirection: (ZHSwipeActionDirection)direction;

- (BOOL)shouldStartWithDirection: (ZHSwipeActionDirection)direction;

//Allow the delegate to perform animation.
@optional
- (void)stateChangeFrom: (ZHSwipeActionState)current to: (ZHSwipeActionState)next activeView: (UIView *)activeView;

@end

@protocol ZHSwipeActionCellDelegate <NSObject>

@optional

/**
 *  Called when the user starts swiping the cell.
 *
 *  @param cell `MCSwipeTableViewCell` currently swiped.
 */
- (void)swipeActionRendererDidStartSwiping:(ZHSwipeActionRenderer *)renderer;

/**
 *  Called when the user ends swiping the cell.
 *
 *  @param cell `MCSwipeTableViewCell` currently swiped.
 */
- (void)swipeActionRendererDidEndSwiping:(ZHSwipeActionRenderer *)renderer;

/**
 *  Called during a swipe.
 *
 *  @param cell         Cell that is currently swiped.
 *  @param percentage   Current percentage of the swipe movement. Percentage is calculated from the
 *                      left of the table view.
 */
- (void)swipeActionRenderer:(ZHSwipeActionRenderer *)renderer didSwipeWithPercentage:(CGFloat)percentage;

- (void)swipeActionRenderer:(ZHSwipeActionRenderer *)renderer didActionWithState: (ZHSwipeActionState)state mode: (ZHSwipeActionMode)mode;

@end