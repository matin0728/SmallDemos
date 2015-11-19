//
//  MASpringBoardLayoutAttributes.m
//  TestProj
//
//  Created by ma xiao on 11/18/15.
//  Copyright © 2015 ma xiao. All rights reserved.
//

#import "MASpringBoardLayoutAttributes.h"

@implementation MASpringBoardLayoutAttributes

- (instancetype)copyWithZone:(NSZone *)zone {
  MASpringBoardLayoutAttributes *attributes = [super copyWithZone:zone];
  attributes.deletionMode = self.deletionMode;
  return attributes;
}

- (BOOL)isEqual:(id)object {
  MASpringBoardLayoutAttributes *attr = (MASpringBoardLayoutAttributes *)object;
  return (attr.deletionMode == self.deletionMode) &&[super isEqual:object];
}
@end
