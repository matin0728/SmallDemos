//
//  LineComponent.h
//  TestProj
//
//  Created by ma xiao on 1/25/16.
//  Copyright © 2016 ma xiao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ComponentKit/ComponentKit.h>

@interface LineComponent : CKCompositeComponent

+ (instancetype)newShortLine; //有缩进的线
+ (instancetype)newLine; //无缩进的线, 1 pixer 宽度.
+ (instancetype)newPointLine; //无缩进的线，1 Point 宽度.
+ (instancetype)newPointLineWithColor:(UIColor *)color;
+ (instancetype)newSectionDevider; //无缩进略，宽度 8
+ (instancetype)newSectionDeviderWide; //无缩进略，宽度 10
+ (instancetype)newPlaceholderSection; //无缩进略，宽度 60，放在最后面以便最后一格的内容可以超过下面的 bar

@end
