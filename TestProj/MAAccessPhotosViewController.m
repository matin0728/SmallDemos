  //
//  MAAccessPhotos.m
//  TestProj
//
//  Created by ma xiao on 11/11/15.
//  Copyright © 2015 ma xiao. All rights reserved.
//

#import "MAAccessPhotosViewController.h"

@interface MAAccessPhotosViewController()<UINavigationControllerDelegate, UIImagePickerControllerDelegate> 

@property(nonatomic, strong) UIImagePickerController *imagePickerController;

@end

@implementation MAAccessPhotosViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  if (nil == self.imagePickerController) {
    self.imagePickerController = [[UIImagePickerController alloc] init];
  }

  self.imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
  self.imagePickerController.delegate = self;
  self.imagePickerController.allowsEditing = NO;
  //  [self presentSemiViewController:self.imagePickerController
  //          withSuperViewController:self
  //                          aniType:ZHSemiModalMoveAniTpye];
  [self presentViewController:self.imagePickerController animated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(nullable NSDictionary<NSString *,id> *)editingInfo NS_DEPRECATED_IOS(2_0, 3_0){
  NSString *a = @"";
}
@end
