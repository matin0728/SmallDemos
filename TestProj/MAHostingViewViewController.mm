//
//  MAHostingViewViewController.m
//  TestProj
//
//  Created by ma xiao on 1/25/16.
//  Copyright © 2016 ma xiao. All rights reserved.
//

#import "MAHostingViewViewController.h"
#import "ActionCardComponent.h"

static NSString *actionCard = @"action_card";
static NSString *test = @"test";

@interface MAHostingViewViewController ()

@property (nonatomic, strong) CKComponentHostingView *hostingView;
@property (nonatomic, strong) UIScrollView *wrap;

@end

@implementation MAHostingViewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
  [self.view setBackgroundColor:[UIColor whiteColor]];

  _wrap = [[UIScrollView alloc] initWithFrame:self.view.frame];
  [self.view addSubview:_wrap];

  _wrap.contentSize = CGSizeMake(self.view.frame.size.width, 1000);

  _hostingView = [[CKComponentHostingView alloc]
                  initWithComponentProvider:self.class sizeRangeProvider:[CKComponentFlexibleSizeRangeProvider providerWithFlexibility:CKComponentSizeRangeFlexibleHeight]];
  _hostingView.frame = CGRectMake(0, 0, self.view.frame.size.width, 1000);
  _hostingView.delegate = self;

  [_wrap addSubview:_hostingView];

  [self.hostingView updateContext:@"xx" mode:CKUpdateModeAsynchronous];
  [self.hostingView updateModel:@[test] mode:CKUpdateModeAsynchronous];

}

- (void)viewDidAppear:(BOOL)animated {
  [super viewDidAppear:animated];
  [self.hostingView updateModel:@[actionCard, test] mode:CKUpdateModeAsynchronous];
}

+ (CKComponent *)componentForModel:(id<NSObject>)model context:(id<NSObject>)context {

  std::vector<CKStackLayoutComponentChild> _children;

  NSArray *arrayModel = (NSArray *)model;
  for (NSString *row in arrayModel) {
    if ([row isEqualToString: actionCard]) {
      _children.push_back(CKStackLayoutComponentChild({

        .component = [ActionCardComponent createNew]

      }));
    } else if ([row isEqualToString: test]) {
      _children.push_back(CKStackLayoutComponentChild({

        .component = [CKLabelComponent
                      newWithLabelAttributes:{
                        .string = @"Hello world!",
                        .color = [UIColor blueColor],
                        .font = [UIFont systemFontOfSize:30.f]
                      }
                      viewAttributes:{
                        {@selector(setBackgroundColor:), [UIColor grayColor]}
                      }],
        .spacingBefore = 20.f

      }));
    }
  }

  return [CKStackLayoutComponent
          newWithView:{}
          size:{}
          style:{
            .alignItems = CKStackLayoutAlignItemsStretch
          }
          children:_children];
}


- (void)componentHostingViewDidInvalidateSize:(CKComponentHostingView *)hostingView {
  [hostingView sizeToFit];
  CGSize size = hostingView.frame.size;
  NSLog(@"HOSTING VIEW RESIZED TO SIZE: %@", NSStringFromCGSize(size));
  self.wrap.contentSize = size;
}


@end
