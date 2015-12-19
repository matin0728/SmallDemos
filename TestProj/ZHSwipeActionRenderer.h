//
//  ZHSwipeActionRenderer.h
//  Mobile
//
//  Created by ma xiao on 12/8/14.
//  Copyright (c) 2014 Zhihu.inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZHSwipeActionProtocol.h"


@interface ZHSwipeActionRenderer : NSObject

@property (nonatomic, weak) UIView *wrapperView;
@property (nonatomic, strong) id<ZHSwipeActionController> controller;
@property (nonatomic, weak) id<ZHSwipeActionCellDelegate> delegate;

/**
 * Damping of the physical spring animation. Expressed in percent.
 *
 * @discussion Only applied for version of iOS > 7.
 */
@property (nonatomic, assign, readwrite) CGFloat damping;

/**
 * Velocity of the spring animation. Expressed in points per second (pts/s).
 *
 * @discussion Only applied for version of iOS > 7.
 */
@property (nonatomic, assign, readwrite) CGFloat velocity;

/** Duration of the animations. */
@property (nonatomic, assign, readwrite) NSTimeInterval animationDuration;

/** Color for background, when no state has been triggered. */
@property (nonatomic, strong, readwrite) UIColor *defaultColor;

/** Boolean indicator to know if the cell is currently dragged. */
@property (nonatomic, assign, readonly, getter=isDragging) BOOL dragging;

/** Boolean to enable/disable the dragging ability of a cell. */
@property (nonatomic, assign, readwrite) BOOL shouldDrag;

/** Boolean to enable/disable the animation of the view during the swipe.  */
@property (nonatomic, assign, readwrite) BOOL shouldAnimateIcons;


- (instancetype)initWithView: (UIView *)wrapperView;

- (UIView *)contentView;

- (void)initializer;
- (void)initDefaults;

// View Manipulation.
- (void)setupSwipingView;
- (void)uninstallSwipingView;
- (void)setViewOfSlidingView:(UIView *)slidingView;

// Percentage
- (CGFloat)offsetWithPercentage:(CGFloat)percentage relativeToWidth:(CGFloat)width;
- (CGFloat)percentageWithOffset:(CGFloat)offset relativeToWidth:(CGFloat)width;
- (NSTimeInterval)animationDurationWithVelocity:(CGPoint)velocity;
- (ZHSwipeActionDirection)directionWithPercentage:(CGFloat)percentage;

// Movement
- (void)animateWithOffset:(CGFloat)offset;
- (void)slideViewWithPercentage:(CGFloat)percentage view:(UIView *)view isDragging:(BOOL)isDragging;
- (void)moveWithDuration:(NSTimeInterval)duration andDirection:(ZHSwipeActionDirection)direction;

// Utilities
- (UIImage *)imageWithView:(UIView *)view;

@end
