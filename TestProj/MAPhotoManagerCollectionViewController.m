//
//  MAPhotoManagerCollectionViewController.m
//  TestProj
//
//  Created by ma xiao on 11/18/15.
//  Copyright © 2015 ma xiao. All rights reserved.
//

#import "MAPhotoManagerCollectionViewController.h"
#import "MAPhotoPlusCell.h"
#import "MAPhotoCollectionViewCell.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import "MASpringBoardLayout.h"

@interface MAPhotoManagerCollectionViewController ()<MASpringCollectionViewDataSource, MASpringCollectionViewDelegateFlowLayout> {
  BOOL isDeletionModeActive;
  NSArray *photos;
}

//一旦发生顺序修改，或者是添加删除相片，这个为真.
@property (nonatomic) BOOL hasBeenChanged;
@property (nonatomic) BOOL deletionMode;

@property (nonatomic) UIButton *editButton;

@end

@implementation MAPhotoManagerCollectionViewController

static NSString * const reuseIdentifier = @"Cell";

- (void)viewDidLoad {
  [super viewDidLoad];

  self->photos = @[@"1", @"2", @"2", @"2", @"2", @"2", @"2"];
    // Register cell classes
  [self.collectionView registerClass:[MAPhotoCollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
  [self.collectionView registerClass:MAPhotoPlusCell.class forCellWithReuseIdentifier:@"plus"];

//  self.collectionView.delegate = self;

  UIButton *edit = [UIButton buttonWithType:UIButtonTypeCustom];
  edit.frame = CGRectMake(0, 0, 60, 44);
  [edit setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
  [edit addTarget:self action:@selector(onTapEdit:) forControlEvents:UIControlEventTouchUpInside];
  self.editButton = edit;
  [edit setTitle:@"编辑" forState:UIControlStateNormal];
  UIBarButtonItem *right = [[UIBarButtonItem alloc] initWithCustomView:edit];
  self.navigationItem.rightBarButtonItem = right;

  @weakify(self)
  [[RACObserve(self, hasBeenChanged) map:^id(id value) {
    return [value boolValue]?@"保存": @"编辑";
  }] subscribeNext:^(NSString *title) {
    @strongify(self);
    [self.editButton setTitle:@"编辑" forState:UIControlStateNormal];
  }];
}

- (void)onTapEdit: (id)sender {
  if (self.deletionMode){
    self.deletionMode = NO;
    [self.collectionViewLayout invalidateLayout];
//    [self.collectionView reloadData];
    return;
  }

  if (self.hasBeenChanged) {
    //点击应该是保存。
    //After saving
    self.deletionMode = NO;
    self.hasBeenChanged = NO;

    //下面这步应该是异步的。
   [self.collectionViewLayout invalidateLayout];
  } else {
//    self.hasBeenChanged = YES;
    self.deletionMode = YES;

    NSAssert(self.collectionViewLayout == self.collectionView.collectionViewLayout, @"NOT the layout!!!!!");
    MASpringBoardLayout *layout = (MASpringBoardLayout *)self.collectionView.collectionViewLayout;
    [layout invalidateLayout];

//    [self.collectionView reloadData];
     [self.collectionViewLayout invalidateLayout];
  }

}

- (BOOL)isDeletionModeActiveForCollectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout {
  return self.deletionMode;
}


#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
  return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
  return self->photos.count + 1; //最后一个是添加的 Cell.
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {

    
  NSInteger index = indexPath.row;
  if (index < self->photos.count) {
    MAPhotoCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    cell.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"pic_placeholder.png"]];
    return cell;
  }

  //最后一格 添加的 Cell.
  MAPhotoPlusCell *cel = [collectionView dequeueReusableCellWithReuseIdentifier:@"plus" forIndexPath:indexPath];
  return cel;
}

#pragma mark <UICollectionViewDelegate>

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
  NSInteger index = indexPath.row;
  if (index == self->photos.count) {
    //点击了最后一个添加相片的按钮
    NSLog(@"添加相片");
  }
}

- (void)collectionView:(UICollectionView *)collectionView itemAtIndexPath:(NSIndexPath *)fromIndexPath didMoveToIndexPath:(NSIndexPath *)toIndexPath {
  NSLog(@"确实编过了，这个时候需要显示保存按钮.");
  self.hasBeenChanged = YES;
}

/*
// Uncomment this method to specify if the specified item should be highlighted during tracking
- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
	return YES;
}
*/

/*
// Uncomment this method to specify if the specified item should be selected
- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}
*/

/*
// Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
- (BOOL)collectionView:(UICollectionView *)collectionView shouldShowMenuForItemAtIndexPath:(NSIndexPath *)indexPath {
	return NO;
}

- (BOOL)collectionView:(UICollectionView *)collectionView canPerformAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	return NO;
}

- (void)collectionView:(UICollectionView *)collectionView performAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	
}
*/


@end
