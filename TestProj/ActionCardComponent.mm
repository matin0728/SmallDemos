//
//  ActionCardComponent.m
//  TestProj
//
//  Created by ma xiao on 1/25/16.
//  Copyright © 2016 ma xiao. All rights reserved.
//

#import "ActionCardComponent.h"
#import "LineComponent.h"

@implementation ActionCardComponent

+ (instancetype)createNew {

  CKComponent *inner = [CKInsetComponent
                        newWithInsets:{.left = 20}
                        component:[CKStackLayoutComponent
                                   newWithView:{}
                                   size:{}
                                   style:{
                                     .alignItems = CKStackLayoutAlignItemsStretch
                                   }
                                   children:{
                                     {
                                       titleRow(),
                                       .spacingBefore = 10.f,
                                     },
                                     {
                                       [LineComponent newLine],
                                       .spacingBefore = 10.f
                                     },
                                     {
                                       contentRow()
                                     }

                                   }]];

  CKStackLayoutComponent *main = [CKStackLayoutComponent
                                  newWithView:{}
                                  size:{}
                                  style:{
                                    .alignItems = CKStackLayoutAlignItemsStretch
                                  }
                                  children:{
                                    {
                                      [LineComponent newLine]
                                    },
                                    { inner },
                                    {
                                      [LineComponent newLine]
                                    }

                                  }];

  return [super newWithComponent:[CKInsetComponent newWithInsets:{.top = 5, .bottom = 5} component:main]];
}

CKComponent *titleRow() {
  return [CKStackLayoutComponent
          newWithView:{}
          size:{}
          style:{
            .direction = CKStackLayoutDirectionHorizontal
          }
          children:{
            {
              [CKLabelComponent
               newWithLabelAttributes:{
                 .string = @"完善你的个人资料",
                 .font = [UIFont systemFontOfSize:20.f],
                 .color = [UIColor grayColor]
               }
               viewAttributes:{}],
              .flexGrow = YES
            },
            {
              [CKImageComponent newWithImage:[UIImage imageNamed:@"close"] size: {.width = 20.f, .height = 20.f}]
            }
          }];
}

CKComponent *contentRow() {
  return [CKLabelComponent
          newWithLabelAttributes:{
            .string = @"为自己添加头象",
            .font = [UIFont systemFontOfSize:30.f]
          }
          viewAttributes:{}];
}


@end
