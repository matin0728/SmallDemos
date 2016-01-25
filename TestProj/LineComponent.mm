//
//  LineComponent.m
//  TestProj
//
//  Created by ma xiao on 1/25/16.
//  Copyright © 2016 ma xiao. All rights reserved.
//

#import "LineComponent.h"


@implementation LineComponent

+ (instancetype)newShortLine {
  return [super
          newWithComponent:[CKInsetComponent
                            newWithInsets:UIEdgeInsetsMake(0, 10, 0, 0)
                            component:[CKComponent
                                       newWithView:{
                                         UIView.class,
                                         {{@selector(setBackgroundColor:), [UIColor grayColor]}}
                                       }
                                       size:{
                                         .height = (CGFloat)1/[UIScreen mainScreen].scale
                                       }]]];
}

+ (instancetype)newLine {
  return [super newWithComponent:[CKComponent
                                  newWithView:{
                                    UIView.class,
                                    {{@selector(setBackgroundColor:), [UIColor grayColor]}}
                                  }
                                  size:{
                                    .height = (CGFloat)1/[UIScreen mainScreen].scale
                                  }]];
}

+ (instancetype)newPointLineWithColor:(UIColor *)color {
  return [super newWithComponent:[CKComponent
                                  newWithView:{
                                    UIView.class,
                                    {{@selector(setBackgroundColor:), color}}
                                  }
                                  size:{
                                    .height = 1.f
                                  }]];
}

+ (instancetype)newPointLine {
  return [self newPointLineWithColor:[UIColor grayColor]];
}

+ (instancetype)newSectionDevider {
  return [super newWithComponent:[CKComponent
                                  newWithView:{
                                    UIView.class,
                                    {{@selector(setBackgroundColor:), [UIColor grayColor]}}
                                  }
                                  size:{
                                    .height = 8.f
                                  }]];
}

+ (instancetype)newSectionDeviderWide {
  return [super newWithComponent:[CKComponent
                                  newWithView:{
                                    UIView.class,
                                    {{@selector(setBackgroundColor:), [UIColor grayColor]}}
                                  }
                                  size:{
                                    .height = 10.f
                                  }]];
}

+ (instancetype)newPlaceholderSection {
  return [super newWithComponent:[CKComponent
                                  newWithView:{
                                    UIView.class,
                                    {{@selector(setBackgroundColor:), [UIColor grayColor]}}
                                  }
                                  size:{
                                    .height = 98 / 2.f
                                  }]];
}

@end
