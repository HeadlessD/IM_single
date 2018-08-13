//
//  ALAssetsLibrary+NIMCustomPhotoAlbum.h
//  QianbaoIM
//
//  Created by Yun on 14/10/11.
//  Copyright (c) 2014年 liu nian. All rights reserved.
//

#import <AssetsLibrary/AssetsLibrary.h>

typedef void(^SaveImageCompletion)(NSError* error);

@interface ALAssetsLibrary(NIMCustomPhotoAlbum)
-(void)nim_saveImage:(UIImage*)image toAlbum:(NSString*)albumName withCompletionBlock:(SaveImageCompletion)completionBlock;

-(void)nim_addAssetURL:(NSURL*)assetURL toAlbum:(NSString*)albumName withCompletionBlock:(SaveImageCompletion)completionBlock;
@end
