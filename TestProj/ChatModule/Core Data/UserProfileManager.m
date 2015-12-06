/************************************************************
 *  * EaseMob CONFIDENTIAL
 * __________________
 * Copyright (C) 2013-2014 EaseMob Technologies. All rights reserved.
 *
 * NOTICE: All information contained herein is, and remains
 * the property of EaseMob Technologies.
 * Dissemination of this information or reproduction of this material
 * is strictly forbidden unless prior written permission is obtained
 * from EaseMob Technologies.
 */

#import "UserProfileManager.h"
//#import <Parse/Parse.h>

//#import "MessageModel.h"

#define kCURRENT_USERNAME [[[EaseMob sharedInstance].chatManager loginInfo] objectForKey:kSDKUsername]

@implementation UIImage (UIImageExt)

- (UIImage*)imageByScalingAndCroppingForSize:(CGSize)targetSize
{
    UIImage *sourceImage = self;
    UIImage *newImage = nil;
    CGSize imageSize = sourceImage.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    CGFloat targetWidth = targetSize.width;
    CGFloat targetHeight = targetSize.height;
    CGFloat scaleFactor = 0.0;
    CGFloat scaledWidth = targetWidth;
    CGFloat scaledHeight = targetHeight;
    CGPoint thumbnailPoint = CGPointMake(0.0,0.0);
    if (CGSizeEqualToSize(imageSize, targetSize) == NO)
    {
        CGFloat widthFactor = targetWidth / width;
        CGFloat heightFactor = targetHeight / height;
        if (widthFactor > heightFactor)
            scaleFactor = widthFactor; // scale to fit height
        else
            scaleFactor = heightFactor; // scale to fit width
        scaledWidth= width * scaleFactor;
        scaledHeight = height * scaleFactor;
        // center the image
        if (widthFactor > heightFactor)
        {
            thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5;
        }
        else if (widthFactor < heightFactor)
        {
            thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
        }
    }
    UIGraphicsBeginImageContext(targetSize); // this will crop
    CGRect thumbnailRect = CGRectZero;
    thumbnailRect.origin = thumbnailPoint;
    thumbnailRect.size.width= scaledWidth;
    thumbnailRect.size.height = scaledHeight;
    [sourceImage drawInRect:thumbnailRect];
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    if(newImage == nil)
        NSLog(@"could not scale image");
    //pop the context to get back to the default
    UIGraphicsEndImageContext();
    return newImage;
}

@end

static UserProfileManager *sharedInstance = nil;
@interface UserProfileManager ()
{
    NSString *_curusername;
}

@property (nonatomic, strong) NSMutableDictionary *users;
@property (nonatomic, strong) NSString *objectId;

@end

@implementation UserProfileManager

+ (instancetype)sharedInstance{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

- (instancetype)init
{
    self = [super init];
    if (self) {

    }
    return self;
}

- (void)initParse
{
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    id objectId = [ud objectForKey:[NSString stringWithFormat:@"%@%@",kPARSE_HXUSER,kCURRENT_USERNAME]];
    if (objectId) {
        self.objectId = objectId;
    }
    _curusername = kCURRENT_USERNAME;
    [self initData];
}

- (void)clearParse
{
    self.objectId = nil;
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    [ud removeObjectForKey:[NSString stringWithFormat:@"%@%@",kPARSE_HXUSER,_curusername]];
     _curusername = nil;
    [self.users removeAllObjects];
}

- (void)initData
{

}

- (void)uploadUserHeadImageProfileInBackground:(UIImage*)image
                           completion:(void (^)(BOOL success, NSError *error))completion
{

}

- (void)updateUserProfileInBackground:(NSDictionary*)param
                           completion:(void (^)(BOOL success, NSError *error))completion
{

}

- (void)loadUserProfileInBackgroundWithBuddy:(NSArray*)buddyList
                                saveToLoacal:(BOOL)save
                                  completion:(void (^)(BOOL success, NSError *error))completion
{

}

- (void)loadUserProfileInBackground:(NSArray*)usernames
                       saveToLoacal:(BOOL)save
                         completion:(void (^)(BOOL success, NSError *error))completion
{

}

- (UserProfileEntity*)getUserProfileByUsername:(NSString*)username
{

    return nil;
}

- (UserProfileEntity*)getCurUserProfile
{

    
    return nil;
}

- (NSString*)getNickNameWithUsername:(NSString*)username
{
    UserProfileEntity* entity = [self getUserProfileByUsername:username];
    if (entity.nickname && entity.nickname.length > 0) {
        return entity.nickname;
    } else {
        return username;
    }
}

#pragma mark - private

- (void)savePFUserInDisk:(PFObject*)object
{

}

- (void)savePFUserInMemory:(PFObject*)object
{
    if (object) {
        UserProfileEntity *entity = [UserProfileEntity initWithPFObject:object];
        [_users setObject:entity forKey:entity.username];
    }
}

- (void)queryPFObjectWithCompletion:(void (^)(PFObject *object, NSError *error))completion
{

}

@end

@implementation UserProfileEntity

+ (instancetype) initWithPFObject:(PFObject *)object
{
  return nil;
}

@end
