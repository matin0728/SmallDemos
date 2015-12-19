//
//  ZHSwipeActionRenderer.m
//  Mobile
//
//  Created by ma xiao on 12/8/14.
//  Copyright (c) 2014 Zhihu.inc. All rights reserved.
//

#import "ZHSwipeActionRenderer.h"

//static CGFloat const kZHStop1                       = 0.25; // Percentage limit to trigger the first action
//static CGFloat const kZHStop2                       = 0.75; // Percentage limit to trigger the second action
static CGFloat const kZHBounceAmplitude             = 20.0; // Maximum bounce amplitude when using the ZHSwipeActionModeSwitch mode
static CGFloat const kZHDamping                     = 0.6;  // Damping of the spring animation
static CGFloat const kZHVelocity                    = 0.9;  // Velocity of the spring animation
static CGFloat const kZHAnimationDuration           = 0.4;  // Duration of the animation
static NSTimeInterval const kZHBounceDuration1      = 0.2;  // Duration of the first part of the bounce animation
static NSTimeInterval const kZHBounceDuration2      = 0.1;  // Duration of the second part of the bounce animation
static NSTimeInterval const kZHDurationLowLimit     = 0.25; // Lowest duration when swiping the cell because we try to simulate velocity
static NSTimeInterval const kZHDurationHighLimit    = 0.1;  // Highest duration when swiping the cell because we try to simulate velocity

@interface ZHSwipeActionRenderer() <UIGestureRecognizerDelegate>

@property (nonatomic, assign) ZHSwipeActionDirection direction;
@property (nonatomic, assign) CGFloat currentPercentage;
@property (nonatomic, assign) ZHSwipeActionState currentState;
@property (nonatomic, assign) BOOL isExited;

@property (nonatomic, strong) UIPanGestureRecognizer *panGestureRecognizer;
@property (nonatomic, strong) UIImageView *contentScreenshotView;
@property (nonatomic, strong) UIView *colorIndicatorView;
@property (nonatomic, strong) UIView *slidingView;
@property (nonatomic, strong) UIView *activeView;

- (void)initializer;

@end

@implementation ZHSwipeActionRenderer

- (instancetype)initWithView: (UIView *)wrapperView {
  self = [super init];
  if (self) {
    _wrapperView = wrapperView;
    @weakify(self);
    [[[[RACObserve(self, currentState) skip:1] distinctUntilChanged] combinePreviousWithStart:@0 reduce:^id(id previous, id current) {
      return RACTuplePack(previous, current);
    }] subscribeNext:^(id x) {
      @strongify(self);
      RACTupleUnpack(NSNumber *pre,NSNumber *current) = x;
      if ([self.controller respondsToSelector:@selector(stateChangeFrom:to:activeView:)]) {
        [self.controller stateChangeFrom:(ZHSwipeActionState)(pre.integerValue) to:(ZHSwipeActionState)(current.integerValue) activeView:self->_activeView];
      }
    }];
  }
  return self;
}

- (void)initializer {
  [self initDefaults];
  
  // Setup Gesture Recognizer.
  _panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanGestureRecognizer:)];
  [_wrapperView addGestureRecognizer:_panGestureRecognizer];
  _panGestureRecognizer.delegate = self;
  _currentState = ZHSwipeActionStateNone;
}

- (void)initDefaults {
  _isExited = NO;
  _dragging = NO;
  _shouldDrag = YES;
  _shouldAnimateIcons = YES;
  
//  _firstTrigger = kZHStop1;
//  _secondTrigger = kZHStop2;
  
  _damping = kZHDamping;
  _velocity = kZHVelocity;
  _animationDuration = kZHAnimationDuration;
  _defaultColor = [UIColor whiteColor];
  _activeView = nil;
}

- (UIView *)contentView {
  if ([_wrapperView isKindOfClass:UITableViewCell.class]) {
    UITableViewCell *cell = (UITableViewCell *)_wrapperView;
    return cell.contentView;
  } else if ([_wrapperView respondsToSelector:@selector(contentView)]) {
    return [_wrapperView performSelector:@selector(contentView)];
  }
  
  return nil;
}

- (void)setupSwipingView {
  if (_contentScreenshotView) {
    return;
  }
  
  // If the content view background is transparent we get the background color.
  BOOL isContentViewBackgroundClear = !self.contentView.backgroundColor;
  if (isContentViewBackgroundClear) {
    BOOL isBackgroundClear = [_wrapperView.backgroundColor isEqual:[UIColor clearColor]];
    [self contentView].backgroundColor = isBackgroundClear ? [UIColor whiteColor] :_wrapperView.backgroundColor;
  }
  
  UIImage *contentViewScreenshotImage = [self imageWithView:_wrapperView];
  
  if (isContentViewBackgroundClear) {
    self.contentView.backgroundColor = nil;
  }
  
  _colorIndicatorView = [[UIView alloc] initWithFrame:_wrapperView.bounds];
  _colorIndicatorView.autoresizingMask = (UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth);
  _colorIndicatorView.backgroundColor = self.defaultColor ? self.defaultColor : [UIColor clearColor];
  [_wrapperView addSubview:_colorIndicatorView];
  
  _slidingView = [[UIView alloc] init];
  _slidingView.contentMode = UIViewContentModeCenter;
  [_colorIndicatorView addSubview:_slidingView];
  
  _contentScreenshotView = [[UIImageView alloc] initWithImage:contentViewScreenshotImage];
  [_wrapperView addSubview:_contentScreenshotView];
}

- (void)uninstallSwipingView {
  if (!_contentScreenshotView) {
    return;
  }
  
  [_slidingView removeFromSuperview];
  _slidingView = nil;
  
  [_colorIndicatorView removeFromSuperview];
  _colorIndicatorView = nil;
  
  [_contentScreenshotView removeFromSuperview];
  _contentScreenshotView = nil;
}

- (void)setViewOfSlidingView:(UIView *)slidingView {
  if (!_slidingView) {
    return;
  }
  
  NSArray *subviews = [_slidingView subviews];
  [subviews enumerateObjectsUsingBlock:^(UIView *view, NSUInteger idx, BOOL *stop) {
    [view removeFromSuperview];
  }];
  
  [_slidingView addSubview:slidingView];
}

#pragma mark - Handle Gestures

- (void)handlePanGestureRecognizer:(UIPanGestureRecognizer *)gesture {
  
  if (![self shouldDrag] || _isExited) {
    return;
  }
  
  UIGestureRecognizerState state      = [gesture state];
  CGPoint translation                 = [gesture translationInView:_wrapperView];
  CGPoint velocity                    = [gesture velocityInView:_wrapperView];
  CGFloat percentage                  = [self percentageWithOffset:CGRectGetMinX(_contentScreenshotView.frame) relativeToWidth:CGRectGetWidth(_wrapperView.bounds)];
  NSTimeInterval animationDuration    = [self animationDurationWithVelocity:velocity];
  _direction                          = [self directionWithPercentage:percentage];
  
  if (state == UIGestureRecognizerStateBegan || state == UIGestureRecognizerStateChanged) {
    _dragging = YES;
    
    [self setupSwipingView];
    
    CGPoint center = {_contentScreenshotView.center.x + translation.x, _contentScreenshotView.center.y};
    _contentScreenshotView.center = center;
    [self animateWithOffset:CGRectGetMinX(_contentScreenshotView.frame)];
    [gesture setTranslation:CGPointZero inView:_wrapperView];
    
    // Notifying the delegate that we are dragging with an offset percentage.
    if ([_delegate respondsToSelector:@selector(swipeActionRenderer:didSwipeWithPercentage:)]) {
      [_delegate swipeActionRenderer:self didSwipeWithPercentage:percentage];
    }
//    NSLog(@"Current active view: %@", _activeView);
  }
  
  else if (state == UIGestureRecognizerStateEnded || state == UIGestureRecognizerStateCancelled) {
    
    _dragging = NO;
    _activeView = [self.controller viewWithPercentage:percentage];
    _currentPercentage = percentage;
    
    ZHSwipeActionState cellState = [self.controller stateWithPercentage:percentage andDirection:_direction];
    ZHSwipeActionMode cellMode = [self.controller modeWithState:cellState andDirection:_direction];
    
    if (cellMode == ZHSwipeActionModeExit && _direction != ZHSwipeActionDirectionCenter) {
      [self moveWithDuration:animationDuration andDirection:_direction];
    } else {
      [self swipeToOriginWithCompletion:^{
        [self executeCompletionBlock];
      }];
    }
    
    // We notify the delegate that we just ended swiping.
    if ([_delegate respondsToSelector:@selector(swipeActionRendererDidEndSwiping:)]) {
      [_delegate swipeActionRendererDidEndSwiping:self];
    }
  }
}

- (void)swipeToOriginWithCompletion:(void(^)(void))completion {
  CGFloat bounceDistance = kZHBounceAmplitude * _currentPercentage;
//  NSLog(@"swipe to origin with comp.");
  if ([UIView.class respondsToSelector:@selector(animateWithDuration:delay:usingSpringWithDamping:initialSpringVelocity:options:animations:completion:)]) {
    
    [UIView animateWithDuration:_animationDuration delay:0.0 usingSpringWithDamping:_damping initialSpringVelocity:_velocity options:UIViewAnimationOptionCurveEaseInOut animations:^{
      
      CGRect frame = self.contentScreenshotView.frame;
      frame.origin.x = 0;
      self.contentScreenshotView.frame = frame;
      
      // Clearing the indicator view
      self.colorIndicatorView.backgroundColor = self.defaultColor;
      
//      self.slidingView.alpha = 0;
      [self slideViewWithPercentage:0 view:self.activeView isDragging:NO];
      
    } completion:^(BOOL finished) {
      
      self.isExited = NO;
      [self uninstallSwipingView];
      
      if (completion) {
        completion();
      }
    }];
  }
  
  else {
    [UIView animateWithDuration:kZHBounceDuration1 delay:0 options:(UIViewAnimationOptionCurveEaseOut) animations:^{
      
      CGRect frame = self.contentScreenshotView.frame;
      frame.origin.x = -bounceDistance;
      self.contentScreenshotView.frame = frame;
      
//      self.slidingView.alpha = 0;
      [self slideViewWithPercentage:0 view:self.activeView isDragging:NO];
      
      // Setting back the color to the default.
      self.colorIndicatorView.backgroundColor = self.defaultColor;
      
    } completion:^(BOOL finished1) {
      
      [UIView animateWithDuration:kZHBounceDuration2 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        
        CGRect frame = self.contentScreenshotView.frame;
        frame.origin.x = 0;
        self.contentScreenshotView.frame = frame;
        
        // Clearing the indicator view
        self.colorIndicatorView.backgroundColor = [UIColor clearColor];
        
      } completion:^(BOOL finished2) {
        
        self.isExited = NO;
        [self uninstallSwipingView];
        
        if (completion) {
          completion();
        }
      }];
    }];
  }
}

#pragma mark - UIGestureRecognizerDelegate

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
  
  if ([gestureRecognizer class] == [UIPanGestureRecognizer class]) {
    
    UIPanGestureRecognizer *g = (UIPanGestureRecognizer *)gestureRecognizer;
    CGPoint point = [g velocityInView:_wrapperView];
    
//    ZHSwipeActionDirection direction = ZHSwipeActionDirectionCenter;

    if (fabs(point.x) > fabs(point.y) ) {
      //From right to left.
      if (point.x < 0) {
        return [self.controller shouldStartWithDirection: ZHSwipeActionDirectionRight];
      }
      
      if (point.x > 0) {
        return [self.controller shouldStartWithDirection: ZHSwipeActionDirectionLeft];
      }
      
      // We notify the delegate that we just started dragging
      if ([_delegate respondsToSelector:@selector(swipeActionRendererDidStartSwiping:)]) {
        [_delegate swipeActionRendererDidStartSwiping:self];
      }
      
      return YES;
    }
  }
  
  return NO;
}

#pragma mark - Percentage

- (CGFloat)offsetWithPercentage:(CGFloat)percentage relativeToWidth:(CGFloat)width {
  CGFloat offset = percentage * width;
  
  if (offset < -width) offset = -width;
  else if (offset > width) offset = width;
  
  return offset;
}

- (CGFloat)percentageWithOffset:(CGFloat)offset relativeToWidth:(CGFloat)width {
  CGFloat percentage = offset / width;
  
  if (percentage < -1.0) percentage = -1.0;
  else if (percentage > 1.0) percentage = 1.0;
  
  return percentage;
}

- (NSTimeInterval)animationDurationWithVelocity:(CGPoint)velocity {
  CGFloat width                           = CGRectGetWidth(_wrapperView.bounds);
  NSTimeInterval animationDurationDiff    = kZHDurationHighLimit - kZHDurationLowLimit;
  CGFloat horizontalVelocity              = velocity.x;
  
  if (horizontalVelocity < -width) horizontalVelocity = -width;
  else if (horizontalVelocity > width) horizontalVelocity = width;
  
  return (kZHDurationHighLimit + kZHDurationLowLimit) - fabs(((horizontalVelocity / width) * animationDurationDiff));
}

- (ZHSwipeActionDirection)directionWithPercentage:(CGFloat)percentage {
  if (percentage < 0) {
    return ZHSwipeActionDirectionLeft;
  }
  
  else if (percentage > 0) {
    return ZHSwipeActionDirectionRight;
  }
  
  else {
    return ZHSwipeActionDirectionCenter;
  }
}

//- (UIColor *)colorWithPercentage:(CGFloat)percentage {
//  UIColor *color;
//  //TODO: SET this as default color.
//  return color;
//}


#pragma mark - Movement

- (void)animateWithOffset:(CGFloat)offset {
  CGFloat percentage = [self percentageWithOffset:offset relativeToWidth:CGRectGetWidth(_wrapperView.bounds)];
  
  UIView *view = [self.controller viewWithPercentage:percentage];
  //Should be assign active view here?
  _activeView = view;
  
  self.currentState = [self.controller stateWithPercentage:percentage andDirection:_direction];
  
  NSAssert(view != nil, @"animated view is nil.");
//  NSLog(@"viewWithPercetage: %@", NSStringFromCGRect(view.frame));
//  NSLog(@"animateWithOffset: %f", offset);
  
  // View Position.
  if (view) {
    [self setViewOfSlidingView:view];
    _slidingView.alpha = [self.controller alphaWithPercentage:percentage];
    [self slideViewWithPercentage:percentage view:view isDragging:self.shouldAnimateIcons];
  }
  
  // Color
  UIColor *color = [self.controller colorWithPercentage:percentage];
  if (color != nil) {
    _colorIndicatorView.backgroundColor = color;
  }
}

- (void)slideViewWithPercentage:(CGFloat)percentage view:(UIView *)view isDragging:(BOOL)isDragging {
  if (!view) {
    return;
  }
  
  CGFloat firstTrigger = [self.controller percentageWithState:ZHSwipeActionStateStage1 andDirection:_direction];
//  CGFloat secondTrigger = [self.controller percentageWithState:ZHSwipeActionStateStage2 andDirection:_direction];
  
  CGPoint position = CGPointZero;
  position.y = CGRectGetHeight(_wrapperView.bounds) / 2.0;
  
  if (isDragging) {
    if (percentage >= 0 && percentage < firstTrigger) {
      position.x = [self offsetWithPercentage:(firstTrigger / 2) relativeToWidth:CGRectGetWidth(_wrapperView.bounds)];
    } else if (percentage >= firstTrigger) {
      position.x = [self offsetWithPercentage:percentage/2 relativeToWidth:CGRectGetWidth(_wrapperView.bounds)];
    } else if (percentage < 0 && percentage >= -firstTrigger) {
      position.x = CGRectGetWidth(_wrapperView.bounds) - [self offsetWithPercentage:(firstTrigger / 2) relativeToWidth:CGRectGetWidth(_wrapperView.bounds)];
    } else if (percentage < -firstTrigger) {
      position.x = CGRectGetWidth(_wrapperView.bounds) + [self offsetWithPercentage:percentage/2 relativeToWidth:CGRectGetWidth(_wrapperView.bounds)];
    }
    
  } else {
    if (_direction == ZHSwipeActionDirectionRight) {
      position.x = [self offsetWithPercentage:(firstTrigger / 2) relativeToWidth:CGRectGetWidth(_wrapperView.bounds)];
    }
    
    else if (_direction == ZHSwipeActionDirectionLeft) {
      position.x = CGRectGetWidth(_wrapperView.bounds) - [self offsetWithPercentage:(firstTrigger / 2) relativeToWidth:CGRectGetWidth(_wrapperView.bounds)];
    }
    
    else {
      return;
    }
  }
  
  CGSize activeViewSize = view.bounds.size;
  CGRect activeViewFrame = CGRectMake(position.x - activeViewSize.width / 2.0,
                                      position.y - activeViewSize.height / 2.0,
                                      activeViewSize.width,
                                      activeViewSize.height);
  
  activeViewFrame = CGRectIntegral(activeViewFrame);
  _slidingView.frame = activeViewFrame;
//  NSLog(@"set sliding view 's frame: %@", NSStringFromCGRect(activeViewFrame));
}

- (void)moveWithDuration:(NSTimeInterval)duration andDirection:(ZHSwipeActionDirection)direction {
  
  _isExited = YES;
  CGFloat origin;
  
  if (direction == ZHSwipeActionDirectionLeft) {
    origin = -CGRectGetWidth(_wrapperView.bounds);
  }
  
  else if (direction == ZHSwipeActionDirectionRight) {
    origin = CGRectGetWidth(_wrapperView.bounds);
  }
  
  else {
    origin = 0;
  }
  
  CGFloat percentage = [self percentageWithOffset:origin relativeToWidth:CGRectGetWidth(_wrapperView.bounds)];
  CGRect frame = _contentScreenshotView.frame;
  frame.origin.x = origin;
  
  // Color
  UIColor *color = [self.controller colorWithPercentage:_currentPercentage];
  if (color) {
    [_colorIndicatorView setBackgroundColor:color];
  }
  
  [UIView animateWithDuration:duration delay:0 options:(UIViewAnimationOptionCurveEaseOut | UIViewAnimationOptionAllowUserInteraction) animations:^{
    self.contentScreenshotView.frame = frame;
//    self.slidingView.alpha = 0;
    [self slideViewWithPercentage:percentage view: self.activeView isDragging:self.shouldAnimateIcons];
  } completion:^(BOOL finished) {
    [self executeCompletionBlock];
  }];
}


#pragma mark - Utilities

- (UIImage *)imageWithView:(UIView *)view {
  CGFloat scale = [[UIScreen mainScreen] scale];
  UIGraphicsBeginImageContextWithOptions(view.bounds.size, NO, scale);
  [view.layer renderInContext:UIGraphicsGetCurrentContext()];
  UIImage * image = UIGraphicsGetImageFromCurrentImageContext();
  UIGraphicsEndImageContext();
  return image;
}

#pragma mark - Completion block

- (void)executeCompletionBlock {
  ZHSwipeActionState state = [self.controller stateWithPercentage:_currentPercentage andDirection:_direction];
  ZHSwipeActionMode mode = [self.controller modeWithState:state andDirection:_direction];

  [self.delegate swipeActionRenderer:self didActionWithState:state mode:mode];
  
}

@end
