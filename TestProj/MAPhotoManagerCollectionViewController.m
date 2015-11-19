//
//  MAPhotoManagerCollectionViewController.m
//  TestProj
//
//  Created by ma xiao on 11/18/15.
//  Copyright © 2015 ma xiao. All rights reserved.
//

#import "MAPhotoManagerCollectionViewController.h"
#import "MAPhotoPlusCell.h"
#import "MAPhotoCell.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import "MASpringBoardLayout.h"

@interface MAPhotoManagerCollectionViewController ()<MASpringCollectionViewDataSource, MASpringCollectionViewDelegateFlowLayout> {
  BOOL isDeletionModeActive;
  NSArray *photos;
}

//一旦发生顺序修改，或者是添加删除相片，这个为真.
@property (nonatomic) BOOL deletionMode;
@property (nonatomic) BOOL editingMode; //当长按生效之后会进入 editing ，除非按下保存按钮。

@property (nonatomic) UIButton *editButton;

@end

@implementation MAPhotoManagerCollectionViewController

static NSString * const reuseIdentifier = @"Cell";

- (void)viewDidLoad {
  [super viewDidLoad];

  self->photos = @[@"01", @"02", @"03", @"04", @"05", @"06", @"07"];
    // Register cell classes
  [self.collectionView registerClass:[MAPhotoCell class] forCellWithReuseIdentifier:reuseIdentifier];
  [self.collectionView registerClass:MAPhotoPlusCell.class forCellWithReuseIdentifier:@"plus"];

  UIButton *edit = [UIButton buttonWithType:UIButtonTypeCustom];
  edit.frame = CGRectMake(0, 0, 60, 44);
  [edit setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
  [edit addTarget:self action:@selector(onTapEdit:) forControlEvents:UIControlEventTouchUpInside];
  self.editButton = edit;
  [edit setTitle:@"编辑" forState:UIControlStateNormal];
  UIBarButtonItem *right = [[UIBarButtonItem alloc] initWithCustomView:edit];
  self.navigationItem.rightBarButtonItem = right;

  @weakify(self)
  [[[RACObserve(self, deletionMode) combineLatestWith:RACObserve(self, editingMode)] map:^id(RACTuple *x) {
    RACTupleUnpack(NSNumber *deletion, NSNumber *editing) = x;
    return ([deletion boolValue] || [editing boolValue])?@"保存": @"编辑";
  }] subscribeNext:^(NSString *title) {
    @strongify(self);
    [self.editButton setTitle:title forState:UIControlStateNormal];
  }];
}

- (void)onTapEdit: (id)sender {
  [self toggleDeletionModel];
}

- (void)toggleDeletionModel {
  if (self.deletionMode || self.editingMode){
    self.deletionMode = NO;
    self.editingMode = NO;
    //TODO: save current data.
    [self.collectionViewLayout invalidateLayout];
    return;
  }
  self.deletionMode = YES;
  [self.collectionViewLayout invalidateLayout];
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
    MAPhotoCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];

    cell.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"pic_placeholder.png"]];
    cell.titleLabel.text = self->photos[index];
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

#pragma mark <MASpringCollectionViewDataSource>
- (void)collectionView:(UICollectionView *)collectionView itemAtIndexPath:(NSIndexPath *)fromIndexPath didMoveToIndexPath:(NSIndexPath *)toIndexPath {
  NSLog(@"Index: %ld DID MOVE TO : %ld", fromIndexPath.row, toIndexPath.row);

  NSMutableArray *arr = [self->photos mutableCopy];
  id obj = [arr objectAtIndex:fromIndexPath.row];
  [arr removeObjectAtIndex:fromIndexPath.row];
  [arr insertObject:obj atIndex:toIndexPath.row];
  self->photos = [arr copy];
  //这里不需要 reload Data 的
}

- (BOOL)collectionView:(UICollectionView *)collectionView canMoveItemAtIndexPath:(NSIndexPath *)indexPath {
  if (indexPath.row == self->photos.count) {
    //不能移动最后一项
    NSLog(@"CAN MOVE TO INDEX: %ld", indexPath.row);
    return NO;
  }
  return YES;
}

- (BOOL)collectionView:(UICollectionView *)collectionView itemAtIndexPath:(NSIndexPath *)fromIndexPath canMoveToIndexPath:(NSIndexPath *)toIndexPath {
  //不能移动到最后一项.
  if (toIndexPath.row == self->photos.count) {
    NSLog(@"Index CAN MOVE FROM: %ld TO: %ld", fromIndexPath.row, toIndexPath.row);
    return NO;
  }
  return YES;
}

#pragma mark <MASpringCollectionViewDelegateFlowLayout>
- (void)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout willBeginDraggingItemAtIndexPath:(NSIndexPath *)indexPath{
  if (!self.editingMode && !self.deletionMode) {
    self.editingMode = YES;
  }
}

- (void)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout didEndDraggingItemAtIndexPath:(NSIndexPath *)indexPath {
  NSLog(@"完成拖动~~~~~~");
}

- (BOOL)isDeletionModeActiveForCollectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout {
  return self.deletionMode;
}
@end
