//
//  MAPhotoCollectionViewCell.h
//  TestProj
//
//  Created by ma xiao on 11/18/15.
//  Copyright © 2015 ma xiao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MAPhotoCollectionViewCell : UICollectionViewCell

@property (nonatomic, strong) UIImage *deleteButtonImage;
@property (nonatomic, strong) UIButton *deleteButton;

- (void)startQuivering;
- (void)stopQuivering;

@end
