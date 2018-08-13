//
//  UIActionSheet+nimphoto.h
//  Qianbao
//
//  Created by liyan1 on 13-4-19.
//  Copyright (c) 2013年 qianwang365. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIActionSheet (nimphoto)


/**********************************************************
 * 相片 选项 UIActionSheet
 **********************************************************/
+ (id)nim_actionSheetWithDelegate:(id<UIActionSheetDelegate>)delegate;

+ (BOOL)nim_checkCamera;

+ (BOOL)nim_checkPhotoLibrary;

+ (void)nim_canPhotoLibraryWithYES:(void(^)(void))yesAction withNO:(void(^)(void))noAction;


+ (void)nim_canCameraWithYES:(void(^)(void))yesAction withNO:(void(^)(void))noAction;

- (void)nim_presentUIImagePickerControllerWithTarget:(id)target
                            clickedButtonAtIndex:(NSInteger)buttonIndex
                                        animated:(BOOL)animated;

- (void)nim_presentUIImagePickerControllerWithTarget:(id)target
                            clickedButtonAtIndex:(NSInteger)buttonIndex
                         allowsMultipleSelection:(BOOL)allowsMultipleSelection
                                        animated:(BOOL)animated;

- (void)nim_presentUIImagePickerControllerWithTarget:(id)target
                            clickedButtonAtIndex:(NSInteger)buttonIndex
                         allowsMultipleSelection:(BOOL)allowsMultipleSelection
                                        animated:(BOOL)animated
                                            edit:(BOOL)edit;

-(void)nim_newCheckPhoto;
/**********************************************************
 * 相片 选项 UIActionSheet 结束
 **********************************************************/

@end
