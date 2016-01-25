//
//  MAHostingViewViewController.m
//  TestProj
//
//  Created by ma xiao on 1/25/16.
//  Copyright © 2016 ma xiao. All rights reserved.
//

#import "MAHostingViewViewController.h"

static NSString *actionCard = @"action_card";

@interface MAHostingViewViewController ()

@property (nonatomic, strong) CKComponentHostingView *hostingView;

@end

@implementation MAHostingViewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

  [self.hostingView updateContext:nil mode:CKUpdateModeAsynchronous];
  [self.hostingView updateModel:@[actionCard] mode:CKUpdateModeAsynchronous];
}

+ (CKComponent *)componentForModel:(id<NSObject>)model context:(id<NSObject>)context {

  NSString *stringModel = (NSString *)model;
  if ([stringModel isEqualToString: actionCard]) {
    return [CKLabelComponent newWithLabelAttributes:{.string = @"hahahaha "} viewAttributes:{}];
  }
  return nil;
}


- (void)componentHostingViewDidInvalidateSize:(CKComponentHostingView *)hostingView {
  //DOES nothing.
}


@end
