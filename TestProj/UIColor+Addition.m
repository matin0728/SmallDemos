//
//  UIColor+Addition.m
//  TestProj
//
//  Created by ma xiao on 11/4/15.
//  Copyright © 2015 ma xiao. All rights reserved.
//

#import "UIColor+Addition.h"

@implementation UIColor (Addition)

+ (UIColor *)colorWithHexString:(NSString *)stringToConvert {
  NSString *string = stringToConvert;
  if ([string hasPrefix:@"#"])
    string = [string substringFromIndex:1];

  if (string.length == 3) {
    string = [NSString stringWithFormat:@"%@%@", string, string];
  }

  NSScanner *scanner = [NSScanner scannerWithString:string];
  unsigned hexNum;
  if (![scanner scanHexInt:&hexNum]) return nil;
  return [self colorWithRGBHex:hexNum];
}

+ (UIColor *)colorWithRGBHex:(UInt32)hex {
  UInt32 r = (hex >> 16) & 0xFF;
  UInt32 g = (hex >> 8) & 0xFF;
  UInt32 b = (hex) & 0xFF;
  UIColor *result = [UIColor colorWithRed:r / 255.0f
                                    green:g / 255.0f
                                     blue:b / 255.0f
                                    alpha:1.0f];
  return result;
}

@end
