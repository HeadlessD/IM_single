//
//  NIMGroupUserIcon.m
//  QianbaoIM
//
//  Created by Yun on 14/9/20.
//  Copyright (c) 2014年 liu nian. All rights reserved.
//  用户以及群组图像

#import "NIMGroupUserIcon.h"
#import "GMember+CoreDataClass.h"
#import "NIMManager.h"

@interface NIMGroupUserIcon()
@property (nonatomic, strong) UIImageView* image1;
@property (nonatomic, strong) UIImageView* image2;
@property (nonatomic, strong) UIImageView* image3;
@property (nonatomic, strong) UIImageView* image4;
@property (nonatomic, strong) UIImageView* image5;
@property (nonatomic, strong) UIImageView* image6;
@property (nonatomic, strong) UIImageView* image7;
@property (nonatomic, strong) UIImageView* image8;
@property (nonatomic, strong) UIImageView* image9;
@property (nonatomic, assign) NSInteger loadCount;
@end

@implementation NIMGroupUserIcon

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{

    if(_delegate && [_delegate respondsToSelector:@selector(NIMGroupUserIconClick)])
    {
        [_delegate NIMGroupUserIconClick];
    }
}

#pragma mark checkAndMakeLocalPic
- (UIImage*)checkAndMakeLocalPic:(NSInteger)groupCount groupId:(int64_t)groupId
{
    return [[SDImageCache sharedImageCache] imageFromDiskCacheForKey:[NSString stringWithFormat:@"%.0lld_%ld.jpg",groupId,(long)groupCount]];
}

- (void)getLocalPic:(NSInteger)groupCount groupId:(int64_t)groupId
{
    [self clearnOldImage];
    
    groupCount = groupCount>9?9:groupCount;
    UIImage* img = [self checkAndMakeLocalPic:groupCount groupId:groupId];
    if(img)
    {
        [self setAutoLayout:1];
        [self.image1 setImage:img];
        return;
    }
}

- (UIImage*)getImage:(NSString*)avatar
{
    UIImage* img = [[SDImageCache sharedImageCache] imageFromMemoryCacheForKey:avatar];
    if(img == nil)
    {
        img = [UIImage imageNamed:@"fclogo"];
    }
    return img;
}

#pragma mark saveImageToDisk
- (void)saveImageToDisk:(NSArray*)users groupId:(int64_t)groupId
{
    if(_loadCount == users.count)
    {
        //首先把该群缓存图片删除
        [[SDImageCache sharedImageCache] removeImageForKey:[NSString stringWithFormat:@"%.0lld_1.jpg",groupId] fromDisk:YES withCompletion:nil];
        [[SDImageCache sharedImageCache] removeImageForKey:[NSString stringWithFormat:@"%.0lld_2.jpg",groupId] fromDisk:YES withCompletion:nil];
        [[SDImageCache sharedImageCache] removeImageForKey:[NSString stringWithFormat:@"%.0lld_3.jpg",groupId] fromDisk:YES withCompletion:nil];
        [[SDImageCache sharedImageCache] removeImageForKey:[NSString stringWithFormat:@"%.0lld_4.jpg",groupId] fromDisk:YES withCompletion:nil];
        [[SDImageCache sharedImageCache] removeImageForKey:[NSString stringWithFormat:@"%.0lld_5.jpg",groupId] fromDisk:YES withCompletion:nil];
        [[SDImageCache sharedImageCache] removeImageForKey:[NSString stringWithFormat:@"%.0lld_6.jpg",groupId] fromDisk:YES withCompletion:nil];
        [[SDImageCache sharedImageCache] removeImageForKey:[NSString stringWithFormat:@"%.0lld_7.jpg",groupId] fromDisk:YES withCompletion:nil];
        [[SDImageCache sharedImageCache] removeImageForKey:[NSString stringWithFormat:@"%.0lld_8.jpg",groupId] fromDisk:YES withCompletion:nil];
        [[SDImageCache sharedImageCache] removeImageForKey:[NSString stringWithFormat:@"%.0lld_9.jpg",groupId] fromDisk:YES withCompletion:nil];

        //通过layer生成本地图片
        UIView* v = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 104, 104)];
        v.backgroundColor = [UIColor colorWithRed:0.937255 green:0.937255 blue:0.956863 alpha:1];
        if(users.count == 1){
            NSString* avatar = [users objectAtIndex:0];
            UIImage* img = [self getImage:avatar];
            CALayer *imageLayer = [CALayer layer];
            imageLayer.frame = CGRectMake(0, 0, 100, 100);
            imageLayer.contents = (id) img.CGImage;
            [v.layer addSublayer:imageLayer];
        }
        if(users.count == 2){
            NSString* avatar1 = [users objectAtIndex:0];
            NSString* avatar2 = [users objectAtIndex:1];
            UIImage* img = [self getImage:avatar1];
            CALayer *imageLayer = [CALayer layer];
            imageLayer.frame = CGRectMake(0, 27, 50, 50);
            imageLayer.contents = (id) img.CGImage;
            [v.layer addSublayer:imageLayer];
            
            UIImage* img2 = [self getImage:avatar2];
            CALayer *imageLayer2 = [CALayer layer];
            imageLayer2.frame = CGRectMake(54, 27, 50, 50);
            imageLayer2.contents = (id) img2.CGImage;
            [v.layer addSublayer:imageLayer2];
        }
        if(users.count == 3){
            NSString* avatar1 = [users objectAtIndex:0];
            NSString* avatar2 = [users objectAtIndex:1];
            NSString* avatar3 = [users objectAtIndex:2];
            UIImage* img = [self getImage:avatar1];
            CALayer *imageLayer = [CALayer layer];
            imageLayer.frame = CGRectMake(27, 0, 50, 50);
            imageLayer.contents = (id) img.CGImage;
            [v.layer addSublayer:imageLayer];
            
            UIImage* img2 = [self getImage:avatar2];
            CALayer *imageLayer2 = [CALayer layer];
            imageLayer2.frame = CGRectMake(0, 54, 50, 50);
            imageLayer2.contents = (id) img2.CGImage;
            [v.layer addSublayer:imageLayer2];
            
            UIImage* img3 = [self getImage:avatar3];
            CALayer *imageLayer3 = [CALayer layer];
            imageLayer3.frame = CGRectMake(54, 54, 50, 50);
            imageLayer3.contents = (id) img3.CGImage;
            [v.layer addSublayer:imageLayer3];
        }
        if(users.count == 4){
            NSString* avatar1 = [users objectAtIndex:0];
            NSString* avatar2 = [users objectAtIndex:1];
            NSString* avatar3 = [users objectAtIndex:2];
            NSString* avatar4 = [users objectAtIndex:3];

            UIImage* img = [self getImage:avatar1];
            CALayer *imageLayer = [CALayer layer];
            imageLayer.frame = CGRectMake(0, 0, 50, 50);
            imageLayer.contents = (id) img.CGImage;
            [v.layer addSublayer:imageLayer];
            
            UIImage* img2 = [self getImage:avatar2];
            CALayer *imageLayer2 = [CALayer layer];
            imageLayer2.frame = CGRectMake(54, 0, 50, 50);
            imageLayer2.contents = (id) img2.CGImage;
            [v.layer addSublayer:imageLayer2];
            
            UIImage* img3 = [self getImage:avatar3];
            CALayer *imageLayer3 = [CALayer layer];
            imageLayer3.frame = CGRectMake(0, 54, 50, 50);
            imageLayer3.contents = (id) img3.CGImage;
            [v.layer addSublayer:imageLayer3];
            
            UIImage* img4 = [self getImage:avatar4];
            CALayer *imageLayer4 = [CALayer layer];
            imageLayer4.frame = CGRectMake(54, 54, 50, 50);
            imageLayer4.contents = (id) img4.CGImage;
            [v.layer addSublayer:imageLayer4];
        }
        if(users.count == 5){
            NSString* avatar1 = [users objectAtIndex:0];
            NSString* avatar2 = [users objectAtIndex:1];
            NSString* avatar3 = [users objectAtIndex:2];
            NSString* avatar4 = [users objectAtIndex:3];
            NSString* avatar5 = [users objectAtIndex:4];

            UIImage* img = [self getImage:avatar1];
            CALayer *imageLayer = [CALayer layer];
            imageLayer.frame = CGRectMake(17, 17, 33, 33);
            imageLayer.contents = (id) img.CGImage;
            [v.layer addSublayer:imageLayer];
            
            UIImage* img2 = [self getImage:avatar2];
            CALayer *imageLayer2 = [CALayer layer];
            imageLayer2.frame = CGRectMake(51, 17, 33, 33);
            imageLayer2.contents = (id) img2.CGImage;
            [v.layer addSublayer:imageLayer2];
            
            UIImage* img3 = [self getImage:avatar3];
            CALayer *imageLayer3 = [CALayer layer];
            imageLayer3.frame = CGRectMake(0, 51, 33, 33);
            imageLayer3.contents = (id) img3.CGImage;
            [v.layer addSublayer:imageLayer3];
            
            UIImage* img4 = [self getImage:avatar4];
            CALayer *imageLayer4 = [CALayer layer];
            imageLayer4.frame = CGRectMake(34, 51, 33, 33);
            imageLayer4.contents = (id) img4.CGImage;
            [v.layer addSublayer:imageLayer4];
            
            UIImage* img5 = [self getImage:avatar5];
            CALayer *imageLayer5 = [CALayer layer];
            imageLayer5.frame = CGRectMake(67, 51, 33, 33);
            imageLayer5.contents = (id) img5.CGImage;
            [v.layer addSublayer:imageLayer5];
        }
        if(users.count == 6){
            NSString* avatar1 = [users objectAtIndex:0];
            NSString* avatar2 = [users objectAtIndex:1];
            NSString* avatar3 = [users objectAtIndex:2];
            NSString* avatar4 = [users objectAtIndex:3];
            NSString* avatar5 = [users objectAtIndex:4];
            NSString* avatar6 = [users objectAtIndex:5];

            UIImage* img = [self getImage:avatar1];
            CALayer *imageLayer = [CALayer layer];
            imageLayer.frame = CGRectMake(0, 17, 33, 33);
            imageLayer.contents = (id) img.CGImage;
            [v.layer addSublayer:imageLayer];
            
            UIImage* img2 = [self getImage:avatar2];
            CALayer *imageLayer2 = [CALayer layer];
            imageLayer2.frame = CGRectMake(34, 17, 33, 33);
            imageLayer2.contents = (id) img2.CGImage;
            [v.layer addSublayer:imageLayer2];
            
            UIImage* img3 = [self getImage:avatar3];
            CALayer *imageLayer3 = [CALayer layer];
            imageLayer3.frame = CGRectMake(67, 17, 33, 33);
            imageLayer3.contents = (id) img3.CGImage;
            [v.layer addSublayer:imageLayer3];
            
            
            UIImage* img4 = [self getImage:avatar4];
            CALayer *imageLayer4 = [CALayer layer];
            imageLayer4.frame = CGRectMake(0, 51, 33, 33);
            imageLayer4.contents = (id) img4.CGImage;
            [v.layer addSublayer:imageLayer4];
            
            UIImage* img5 = [self getImage:avatar5];
            CALayer *imageLayer5 = [CALayer layer];
            imageLayer5.frame = CGRectMake(34, 51, 33, 33);
            imageLayer5.contents = (id) img5.CGImage;
            [v.layer addSublayer:imageLayer5];
            
            UIImage* img6 = [self getImage:avatar6];
            CALayer *imageLayer6 = [CALayer layer];
            imageLayer6.frame = CGRectMake(67, 51, 33, 33);
            imageLayer6.contents = (id) img6.CGImage;
            [v.layer addSublayer:imageLayer6];
            
            
        }
        
        if(users.count == 7){
            NSString* avatar1 = [users objectAtIndex:0];
            NSString* avatar2 = [users objectAtIndex:1];
            NSString* avatar3 = [users objectAtIndex:2];
            NSString* avatar4 = [users objectAtIndex:3];
            NSString* avatar5 = [users objectAtIndex:4];
            NSString* avatar6 = [users objectAtIndex:5];
            NSString* avatar7 = [users objectAtIndex:6];

            UIImage* img = [self getImage:avatar1];
            CALayer *imageLayer = [CALayer layer];
            imageLayer.frame = CGRectMake(34, 0, 33, 33);
            imageLayer.contents = (id) img.CGImage;
            [v.layer addSublayer:imageLayer];
            
            UIImage* img2 = [self getImage:avatar2];
            CALayer *imageLayer2 = [CALayer layer];
            imageLayer2.frame = CGRectMake(0, 34, 33, 33);
            imageLayer2.contents = (id) img2.CGImage;
            [v.layer addSublayer:imageLayer2];
            
            UIImage* img3 = [self getImage:avatar3];
            CALayer *imageLayer3 = [CALayer layer];
            imageLayer3.frame = CGRectMake(34, 34, 33, 33);
            imageLayer3.contents = (id) img3.CGImage;
            [v.layer addSublayer:imageLayer3];
            
            
            UIImage* img4 = [self getImage:avatar4];
            CALayer *imageLayer4 = [CALayer layer];
            imageLayer4.frame = CGRectMake(67, 34, 33, 33);
            imageLayer4.contents = (id) img4.CGImage;
            [v.layer addSublayer:imageLayer4];
            
            UIImage* img5 = [self getImage:avatar5];
            CALayer *imageLayer5 = [CALayer layer];
            imageLayer5.frame = CGRectMake(0, 67, 33, 33);
            imageLayer5.contents = (id) img5.CGImage;
            [v.layer addSublayer:imageLayer5];
            
            UIImage* img6 = [self getImage:avatar6];
            CALayer *imageLayer6 = [CALayer layer];
            imageLayer6.frame = CGRectMake(34, 67, 33, 33);
            imageLayer6.contents = (id) img6.CGImage;
            [v.layer addSublayer:imageLayer6];

            UIImage* img7 = [self getImage:avatar7];
            CALayer *imageLayer7 = [CALayer layer];
            imageLayer7.frame = CGRectMake(67, 67, 33, 33);
            imageLayer7.contents = (id) img7.CGImage;
            [v.layer addSublayer:imageLayer7];
        }
        
        if(users.count == 8){
            NSString* avatar1 = [users objectAtIndex:0];
            NSString* avatar2 = [users objectAtIndex:1];
            NSString* avatar3 = [users objectAtIndex:2];
            NSString* avatar4 = [users objectAtIndex:3];
            NSString* avatar5 = [users objectAtIndex:4];
            NSString* avatar6 = [users objectAtIndex:5];
            NSString* avatar7 = [users objectAtIndex:6];
            NSString* avatar8 = [users objectAtIndex:7];

            UIImage* img = [self getImage:avatar1];
            CALayer *imageLayer = [CALayer layer];
            imageLayer.frame = CGRectMake(17, 0, 33, 33);
            imageLayer.contents = (id) img.CGImage;
            [v.layer addSublayer:imageLayer];
            
            UIImage* img2 = [self getImage:avatar2];
            CALayer *imageLayer2 = [CALayer layer];
            imageLayer2.frame = CGRectMake(51, 0, 33, 33);
            imageLayer2.contents = (id) img2.CGImage;
            [v.layer addSublayer:imageLayer2];
            
            UIImage* img3 = [self getImage:avatar3];
            CALayer *imageLayer3 = [CALayer layer];
            imageLayer3.frame = CGRectMake(0, 34, 33, 33);
            imageLayer3.contents = (id) img3.CGImage;
            [v.layer addSublayer:imageLayer3];
            
            
            UIImage* img4 = [self getImage:avatar4];
            CALayer *imageLayer4 = [CALayer layer];
            imageLayer4.frame = CGRectMake(34, 34, 33, 33);
            imageLayer4.contents = (id) img4.CGImage;
            [v.layer addSublayer:imageLayer4];
            
            UIImage* img5 = [self getImage:avatar5];
            CALayer *imageLayer5 = [CALayer layer];
            imageLayer5.frame = CGRectMake(67, 34, 33, 33);
            imageLayer5.contents = (id) img5.CGImage;
            [v.layer addSublayer:imageLayer5];
            
            UIImage* img6 = [self getImage:avatar6];
            CALayer *imageLayer6 = [CALayer layer];
            imageLayer6.frame = CGRectMake(0, 67, 33, 33);
            imageLayer6.contents = (id) img6.CGImage;
            [v.layer addSublayer:imageLayer6];
            
            UIImage* img7 = [self getImage:avatar7];
            CALayer *imageLayer7 = [CALayer layer];
            imageLayer7.frame = CGRectMake(34, 67, 33, 33);
            imageLayer7.contents = (id) img7.CGImage;
            [v.layer addSublayer:imageLayer7];
            
            UIImage* img8 = [self getImage:avatar8];
            CALayer *imageLayer8 = [CALayer layer];
            imageLayer8.frame = CGRectMake(67, 67, 33, 33);
            imageLayer8.contents = (id) img8.CGImage;
            [v.layer addSublayer:imageLayer8];
        }
        
        if(users.count >= 9){
            NSString* avatar1 = [users objectAtIndex:0];
            NSString* avatar2 = [users objectAtIndex:1];
            NSString* avatar3 = [users objectAtIndex:2];
            NSString* avatar4 = [users objectAtIndex:3];
            NSString* avatar5 = [users objectAtIndex:4];
            NSString* avatar6 = [users objectAtIndex:5];
            NSString* avatar7 = [users objectAtIndex:6];
            NSString* avatar8 = [users objectAtIndex:7];
            NSString* avatar9 = [users objectAtIndex:8];

            UIImage* img = [self getImage:avatar1];
            CALayer *imageLayer = [CALayer layer];
            imageLayer.frame = CGRectMake(0, 0, 33, 33);
            imageLayer.contents = (id) img.CGImage;
            [v.layer addSublayer:imageLayer];
            
            UIImage* img2 = [self getImage:avatar2];
            CALayer *imageLayer2 = [CALayer layer];
            imageLayer2.frame = CGRectMake(34, 0, 33, 33);
            imageLayer2.contents = (id) img2.CGImage;
            [v.layer addSublayer:imageLayer2];
            
            UIImage* img3 = [self getImage:avatar3];
            CALayer *imageLayer3 = [CALayer layer];
            imageLayer3.frame = CGRectMake(67, 0, 33, 33);
            imageLayer3.contents = (id) img3.CGImage;
            [v.layer addSublayer:imageLayer3];
            
            
            UIImage* img4 = [self getImage:avatar4];
            CALayer *imageLayer4 = [CALayer layer];
            imageLayer4.frame = CGRectMake(0, 34, 33, 33);
            imageLayer4.contents = (id) img4.CGImage;
            [v.layer addSublayer:imageLayer4];
            
            UIImage* img5 = [self getImage:avatar5];
            CALayer *imageLayer5 = [CALayer layer];
            imageLayer5.frame = CGRectMake(34, 34, 33, 33);
            imageLayer5.contents = (id) img5.CGImage;
            [v.layer addSublayer:imageLayer5];
            
            UIImage* img6 = [self getImage:avatar6];
            CALayer *imageLayer6 = [CALayer layer];
            imageLayer6.frame = CGRectMake(67, 34, 33, 33);
            imageLayer6.contents = (id) img6.CGImage;
            [v.layer addSublayer:imageLayer6];
            
            UIImage* img7 = [self getImage:avatar7];
            CALayer *imageLayer7 = [CALayer layer];
            imageLayer7.frame = CGRectMake(0, 67, 33, 33);
            imageLayer7.contents = (id) img7.CGImage;
            [v.layer addSublayer:imageLayer7];
            
            UIImage* img8 = [self getImage:avatar8];
            CALayer *imageLayer8 = [CALayer layer];
            imageLayer8.frame = CGRectMake(34, 67, 33, 33);
            imageLayer8.contents = (id) img8.CGImage;
            [v.layer addSublayer:imageLayer8];
            
            UIImage* img9 = [self getImage:avatar9];
            CALayer *imageLayer9 = [CALayer layer];
            imageLayer9.frame = CGRectMake(67, 67, 33, 33);
            imageLayer9.contents = (id) img9.CGImage;
            [v.layer addSublayer:imageLayer9];
        }
        
        UIGraphicsBeginImageContext(v.bounds.size);
        [v.layer renderInContext:UIGraphicsGetCurrentContext()];
        UIImage *aImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        NSData *imageData = UIImageJPEGRepresentation(aImage, 1);
        UIImage *img = [UIImage imageWithData:imageData];//生成的图片
        UIImage *image = [[SDImageCache sharedImageCache] imageFromDiskCacheForKey:GROUP_ICON_URL(groupId)];
        if (image) {
            [[SDImageCache sharedImageCache] removeImageForKey:GROUP_ICON_URL(groupId) withCompletion:nil];
        }
        [[SDImageCache sharedImageCache] storeImage:img forKey:GROUP_ICON_URL(groupId)];
//        [[SDImageCache sharedImageCache] storeImage:img forKey:GROUP_ICON_URL(groupId) completion:nil];
        [[NIMManager sharedImManager] uploadGroupIcon:img groupid:groupId completeBlock:^(id object, NIMResultMeta *result) {
            
            if (object) {
                [[NSNotificationCenter defaultCenter] postNotificationName:NC_GROUP_AVATAR_MODIFY object:object];
            }else{
                
            }
            
            
        }];
    }
}

#pragma mark setDataSource
- (void)setViewDataSourceFromUrlString:(NSString*)usrStr//设置图片url设置单个用户图像
{
    [self clearnOldImage];
    [self setAutoLayout:1];
    
    UIImage *image = [[SDImageCache sharedImageCache] imageFromDiskCacheForKey:usrStr];
    if (image) {
        _image1.image = image;
        
        [NIMBaseUtil isAvailableURL:usrStr success:^{
            
        } failure:^{
            //图片链接不存在重新上传
            NSArray *arr = [usrStr componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"/_."]];
            if ([arr containsObject:@"group"]) {
                int64_t groupid =  [[arr objectAtIndex:arr.count-2] longLongValue];
                BOOL isIcon = [getObjectFromUserDefault(KEY_Group_Icon(groupid)) boolValue];
                if (isIcon==NO) {
                    setObjectToUserDefault(KEY_Group_Icon(groupid), @YES);
                    [[NIMManager sharedImManager] uploadGroupIcon:image groupid:groupid completeBlock:^(id object, NIMResultMeta *result) {
                        setObjectToUserDefault(KEY_Group_Icon(groupid), @NO);
                        if (!object) {
                            
                        }
                    }];
                }
                
                
            }
        }];
        
    }else{
        [_image1 sd_setImageWithURL:[NSURL URLWithString:usrStr] placeholderImage:[UIImage imageNamed:@"fclogo"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            if (image) {
                [[SDImageCache sharedImageCache] storeImage:image forKey:usrStr];
            }else{
                //图片链接不存在重新上传
                NSArray *arr = [usrStr componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"/_."]];
                if ([arr containsObject:@"group"]) {
                    
                    int64_t groupid =  [[arr objectAtIndex:arr.count-2] longLongValue];

                    BOOL isIcon = [getObjectFromUserDefault(KEY_Group_Icon(groupid)) boolValue];

                    if (isIcon==NO) {
                        
                        setObjectToUserDefault(KEY_Group_Icon(groupid), @YES);

                        
                        [[NIMGroupOperationBox sharedInstance] sendGroupMemberRQ:groupid complete:^(id object, NIMResultMeta *result) {
                            
                            setObjectToUserDefault(KEY_Group_Icon(groupid), @NO);
                            if (object) {
                                NSArray *members = object;
                                NSUInteger cnt = members.count>=9?9:members.count;
                                if (cnt==0) {
                                    return ;
                                }
                                
                                NSMutableArray *iconArr = [NSMutableArray arrayWithCapacity:10];
                                
                                for (int i=0; i<cnt; i++) {
                                    NSDictionary *dict = [members objectAtIndex:i];
                                    int64_t memberid = [[dict objectForKey:@"userId"] longLongValue];
                                    [iconArr addObject:USER_ICON_URL(memberid)];
                                    
                                }
                                [self setViewDataSource:iconArr groupId:groupid];
                            }
                        }];
                    }
                    
                }
            }
        }];
    }
    
}
- (void)setViewIconFromImage:(UIImage*)image//直接通过图片设置image
{
    if([image isKindOfClass:[UIImage class]]){
        [self clearnOldImage];
        [self setAutoLayout:1];
        [_image1 setImage:image];
    }
}

- (void)setViewDataSource:(NSArray*)users groupId:(int64_t)groupId
{
    _loadCount = 0;
    [self clearnOldImage];
    [self updateGroupIconDataSource:users groupId:groupId];
    /*
    if (!isUpdate) {
        UIImage* img = [self checkAndMakeLocalPic:users.count groupId:groupId];
        if(img)
        {
            [self setAutoLayout:1];
            [self.image1 setImage:img];
        }else{
            [self updateGroupIconDataSource:users groupId:groupId];
        }
    }else{
        [self updateGroupIconDataSource:users groupId:groupId];
    }
     */
}


-(void)updateGroupIconDataSource:(NSArray*)users groupId:(int64_t)groupId
{
    [self setAutoLayout:users.count];
    if(users.count >= 1)
    {
        NSString* avatar = [users objectAtIndex:0];
        [_image1 sd_setImageWithURL:[NSURL URLWithString:avatar]
                   placeholderImage:[UIImage imageNamed:@"fclogo"]
                          completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                              _loadCount++;
                              [self saveImageToDisk:users groupId:groupId];
                          }];
    }
    if(users.count >= 2)
    {
        NSString* avatar = [users objectAtIndex:1];
        [_image2 sd_setImageWithURL:[NSURL URLWithString:avatar]
                   placeholderImage:[UIImage imageNamed:@"fclogo"]
                          completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                              _loadCount++;
                              [self saveImageToDisk:users groupId:groupId];
                          }];
    }
    if(users.count >= 3)
    {
        NSString* avatar = [users objectAtIndex:2];
        [_image3 sd_setImageWithURL:[NSURL URLWithString:avatar]
                   placeholderImage:[UIImage imageNamed:@"fclogo"]
                          completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                              _loadCount++;
                              [self saveImageToDisk:users groupId:groupId];
                          }];
    }
    if(users.count >= 4)
    {
        NSString* avatar = [users objectAtIndex:3];
        [_image4 sd_setImageWithURL:[NSURL URLWithString:avatar]
                   placeholderImage:[UIImage imageNamed:@"fclogo"]
                          completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                              _loadCount++;
                              [self saveImageToDisk:users groupId:groupId];
                          }];
    }
    
    if(users.count >= 5)
    {
        NSString* avatar = [users objectAtIndex:4];
        [_image5 sd_setImageWithURL:[NSURL URLWithString:avatar]
                   placeholderImage:[UIImage imageNamed:@"fclogo"]
                          completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                              _loadCount++;
                              [self saveImageToDisk:users groupId:groupId];
                          }];
    }
    if(users.count >= 6)
    {
        NSString* avatar = [users objectAtIndex:5];
        [_image6 sd_setImageWithURL:[NSURL URLWithString:avatar]
                   placeholderImage:[UIImage imageNamed:@"fclogo"]
                          completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                              _loadCount++;
                              [self saveImageToDisk:users groupId:groupId];
                          }];
    }
    if(users.count >= 7)
    {
        NSString* avatar = [users objectAtIndex:6];
        [_image7 sd_setImageWithURL:[NSURL URLWithString:avatar]
                   placeholderImage:[UIImage imageNamed:@"fclogo"]
                          completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                              _loadCount++;
                              [self saveImageToDisk:users groupId:groupId];
                          }];
    }
    if(users.count >= 8)
    {
        NSString* avatar = [users objectAtIndex:7];
        [_image8 sd_setImageWithURL:[NSURL URLWithString:avatar]
                   placeholderImage:[UIImage imageNamed:@"fclogo"]
                          completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                              _loadCount++;
                              [self saveImageToDisk:users groupId:groupId];
                          }];
    }
    if(users.count >= 9)
    {
        NSString* avatar = [users objectAtIndex:8];
        [_image9 sd_setImageWithURL:[NSURL URLWithString:avatar]
                   placeholderImage:[UIImage imageNamed:@"fclogo"]
                          completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                              _loadCount++;
                              [self saveImageToDisk:users groupId:groupId];
                          }];
    }

}

- (void)clearnOldImage
{
    NSArray* subViews = self.subviews;
    [subViews enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if([obj isKindOfClass:[UIImageView class]])
        {
            UIImageView* imgV = (UIImageView*)obj;
            imgV.image = nil;
        }
    }];
}

#pragma mark setAutoLayout
- (void)setAutoLayout:(NSInteger)count
{
    CGFloat imageWidth = self.bounds.size.height/2.0-1;
    CGFloat imageWidth2 = self.bounds.size.height/3.0-1;
    if(count >= 9)
    {
        [self.image1 mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(self.mas_leading);
            make.top.equalTo(self.mas_top);
            make.height.with.offset(imageWidth2);
            make.width.with.offset(imageWidth2);
        }];
        
        [self.image2 mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(self.image1.mas_trailing).with.offset(1);
            make.top.equalTo(self.mas_top);
            make.height.with.offset(imageWidth2);
            make.width.with.offset(imageWidth2);
        }];
        
        [self.image3 mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.trailing.equalTo(self.mas_trailing);
            make.top.equalTo(self.mas_top);
            make.height.with.offset(imageWidth2);
            make.width.with.offset(imageWidth2);
        }];
        
        [self.image4 mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(self.mas_leading);
            make.top.equalTo(self.mas_top).with.offset(imageWidth2+1);
            make.height.with.offset(imageWidth2);
            make.width.with.offset(imageWidth2);
        }];
        
        [self.image5 mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(self.image4.mas_trailing).with.offset(1);
            make.top.equalTo(self.mas_top).with.offset(imageWidth2+1);
            make.height.with.offset(imageWidth2);
            make.width.with.offset(imageWidth2);
        }];
        
        [self.image6 mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.trailing.equalTo(self.mas_trailing);
            make.top.equalTo(self.mas_top).with.offset(imageWidth2+1);
            make.height.with.offset(imageWidth2);
            make.width.with.offset(imageWidth2);
        }];
        
        [self.image7 mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(self.mas_leading);
            make.bottom.equalTo(self.mas_bottom);
            make.height.with.offset(imageWidth2);
            make.width.with.offset(imageWidth2);
        }];
        
        [self.image8 mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(self.image7.mas_trailing).with.offset(1);
            make.bottom.equalTo(self.mas_bottom);
            make.height.with.offset(imageWidth2);
            make.width.with.offset(imageWidth2);
        }];
        
        [self.image9 mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.trailing.equalTo(self.mas_trailing);
            make.bottom.equalTo(self.mas_bottom);
            make.height.with.offset(imageWidth2);
            make.width.with.offset(imageWidth2);
        }];
    }
    
    if(count == 8)
    {
        [self.image1 mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(self.mas_leading).with.offset(imageWidth2/2.0);
            make.top.equalTo(self.mas_top);
            make.height.with.offset(imageWidth2);
            make.width.with.offset(imageWidth2);
        }];
        
        [self.image2 mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.trailing.equalTo(self.mas_trailing).with.offset(-imageWidth2/2.0);
            make.top.equalTo(self.mas_top);
            make.height.with.offset(imageWidth2);
            make.width.with.offset(imageWidth2);
        }];
        
        [self.image3 mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(self.mas_leading);
            make.top.equalTo(self.mas_top).with.offset(imageWidth2+1);
            make.height.with.offset(imageWidth2);
            make.width.with.offset(imageWidth2);
        }];
        
        [self.image4 mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(self.image3.mas_trailing).with.offset(1);
            make.top.equalTo(self.mas_top).with.offset(imageWidth2+1);
            make.height.with.offset(imageWidth2);
            make.width.with.offset(imageWidth2);
        }];
        
        [self.image5 mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.trailing.equalTo(self.mas_trailing);
            make.top.equalTo(self.mas_top).with.offset(imageWidth2+1);
            make.height.with.offset(imageWidth2);
            make.width.with.offset(imageWidth2);
        }];
        
        [self.image6 mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(self.mas_leading);
            make.bottom.equalTo(self.mas_bottom);
            make.height.with.offset(imageWidth2);
            make.width.with.offset(imageWidth2);
        }];
        
        [self.image7 mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(self.image6.mas_trailing).with.offset(1);
            make.bottom.equalTo(self.mas_bottom);
            make.height.with.offset(imageWidth2);
            make.width.with.offset(imageWidth2);
        }];
        
        [self.image8 mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.trailing.equalTo(self.mas_trailing);
            make.bottom.equalTo(self.mas_bottom);
            make.height.with.offset(imageWidth2);
            make.width.with.offset(imageWidth2);
        }];
    }

    
    if(count == 7)
    {
        [self.image1 mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.mas_centerX);
            make.top.equalTo(self.mas_top);
            make.height.with.offset(imageWidth2);
            make.width.with.offset(imageWidth2);
        }];
        
        [self.image2 mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(self.mas_leading);
            make.top.equalTo(self.mas_top).with.offset(imageWidth2+1);
            make.height.with.offset(imageWidth2);
            make.width.with.offset(imageWidth2);
        }];
        
        [self.image3 mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(self.image2.mas_trailing).with.offset(1);
            make.top.equalTo(self.mas_top).with.offset(imageWidth2+1);
            make.height.with.offset(imageWidth2);
            make.width.with.offset(imageWidth2);
        }];
        
        [self.image4 mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.trailing.equalTo(self.mas_trailing);
            make.top.equalTo(self.mas_top).with.offset(imageWidth2+1);
            make.height.with.offset(imageWidth2);
            make.width.with.offset(imageWidth2);
        }];
        
        [self.image5 mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(self.mas_leading);
            make.bottom.equalTo(self.mas_bottom);
            make.height.with.offset(imageWidth2);
            make.width.with.offset(imageWidth2);
        }];
        
        [self.image6 mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(self.image5.mas_trailing).with.offset(1);
            make.bottom.equalTo(self.mas_bottom);
            make.height.with.offset(imageWidth2);
            make.width.with.offset(imageWidth2);
        }];
        
        [self.image7 mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.trailing.equalTo(self.mas_trailing);
            make.bottom.equalTo(self.mas_bottom);
            make.height.with.offset(imageWidth2);
            make.width.with.offset(imageWidth2);
        }];
    }

    
    if(count == 6)
    {
        [self.image1 mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(self.mas_leading);
            make.top.equalTo(self.mas_top).with.offset(imageWidth2/2.0);
            make.height.with.offset(imageWidth2);
            make.width.with.offset(imageWidth2);
        }];
        
        [self.image2 mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(self.image1.mas_trailing).with.offset(1);
            make.top.equalTo(self.mas_top).with.offset(imageWidth2/2.0);
            make.height.with.offset(imageWidth2);
            make.width.with.offset(imageWidth2);
        }];
        
        [self.image3 mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.trailing.equalTo(self.mas_trailing);
            make.top.equalTo(self.mas_top).with.offset(imageWidth2/2.0);
            make.height.with.offset(imageWidth2);
            make.width.with.offset(imageWidth2);
        }];
        
        [self.image4 mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(self.mas_leading);
            make.bottom.equalTo(self.mas_bottom).with.offset(-imageWidth2/2.0);
            make.height.with.offset(imageWidth2);
            make.width.with.offset(imageWidth2);
        }];
        
        [self.image5 mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(self.image4.mas_trailing).with.offset(1);
            make.bottom.equalTo(self.mas_bottom).with.offset(-imageWidth2/2.0);
            make.height.with.offset(imageWidth2);
            make.width.with.offset(imageWidth2);
        }];
        
        [self.image6 mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.trailing.equalTo(self.mas_trailing);
            make.bottom.equalTo(self.mas_bottom).with.offset(-imageWidth2/2.0);
            make.height.with.offset(imageWidth2);
            make.width.with.offset(imageWidth2);
        }];
    }
    
    if(count == 5)
    {
        [self.image1 mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(self.mas_leading).with.offset(imageWidth2/2.0);
            make.top.equalTo(self.mas_top).with.offset(imageWidth2/2.0);
            make.height.with.offset(imageWidth2);
            make.width.with.offset(imageWidth2);
        }];
        
        [self.image2 mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(self.image1.mas_trailing).with.offset(1);
            make.top.equalTo(self.mas_top).with.offset(imageWidth2/2.0);
            make.height.with.offset(imageWidth2);
            make.width.with.offset(imageWidth2);
        }];
        
        [self.image3 mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(self.mas_leading);
            make.bottom.equalTo(self.mas_bottom).with.offset(-imageWidth2/2.0);
            make.height.with.offset(imageWidth2);
            make.width.with.offset(imageWidth2);
        }];
        
        [self.image4 mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(self.image3.mas_trailing).with.offset(1);
            make.bottom.equalTo(self.mas_bottom).with.offset(-imageWidth2/2.0);
            make.height.with.offset(imageWidth2);
            make.width.with.offset(imageWidth2);
        }];
        
        [self.image5 mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.trailing.equalTo(self.mas_trailing);
            make.bottom.equalTo(self.mas_bottom).with.offset(-imageWidth2/2.0);
            make.height.with.offset(imageWidth2);
            make.width.with.offset(imageWidth2);
        }];    }
    
    if(count == 4)
    {
        [self.image1 mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(self.mas_leading);
            make.top.equalTo(self.mas_top);
            make.height.with.offset(imageWidth);
            make.width.with.offset(imageWidth);
            
        }];
        
        [self.image2 mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.trailing.equalTo(self.mas_trailing);
            make.top.equalTo(self.mas_top);
            make.height.with.offset(imageWidth);
            make.width.with.offset(imageWidth);
        }];
        
        [self.image3 mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(self.mas_leading);
            make.bottom.equalTo(self.mas_bottom);
            make.height.with.offset(imageWidth);
            make.width.with.offset(imageWidth);
        }];
        
        [self.image4 mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.trailing.equalTo(self.mas_trailing);
            make.bottom.equalTo(self.mas_bottom);
            make.height.with.offset(imageWidth);
            make.width.with.offset(imageWidth);
        }];
    }
    if(count == 3)
    {
        [self.image1 mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.mas_centerX);
            make.top.equalTo(self.mas_top);
            make.height.with.offset(imageWidth);
            make.width.with.offset(imageWidth);
        }];
        
        [self.image2 mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(self.mas_leading);
            make.bottom.equalTo(self.mas_bottom);
            make.height.with.offset(imageWidth);
            make.width.with.offset(imageWidth);
        }];
        
        [self.image3 mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.trailing.equalTo(self.mas_trailing);
            make.bottom.equalTo(self.mas_bottom);
            make.height.with.offset(imageWidth);
            make.width.with.offset(imageWidth);
        }];
    }
    if(count == 2)
    {
        [self.image1 mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(self.mas_leading);
            make.centerY.equalTo(self.mas_centerY);
            make.height.with.offset(imageWidth);
            make.width.with.offset(imageWidth);
            
        }];
        
        [self.image2 mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.trailing.equalTo(self.mas_trailing);
            make.centerY.equalTo(self.mas_centerY);
            make.height.with.offset(imageWidth);
            make.width.with.offset(imageWidth);
        }];
    }
    if(count == 1)
    {
        [self.image1 mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(self.mas_leading);
            make.trailing.equalTo(self.mas_trailing);
            make.top.equalTo(self.mas_top);
            make.bottom.equalTo(self.mas_bottom);
        }];
    }
}

#pragma mark getter
- (UIImageView*)image1
{
    if(!_image1)
    {
        _image1 = [[UIImageView alloc] init];
        [self addSubview:_image1];
    }
    return _image1;
}

- (UIImageView*)image2
{
    if(!_image2)
    {
        _image2 = [[UIImageView alloc] init];
        [self addSubview:_image2];
    }
    return _image2;
}

- (UIImageView*)image3
{
    if(!_image3)
    {
        _image3 = [[UIImageView alloc] init];
        [self addSubview:_image3];
    }
    return _image3;
}

- (UIImageView*)image4
{
    if(!_image4)
    {
        _image4 = [[UIImageView alloc] init];
        [self addSubview:_image4];
    }
    return _image4;
}

- (UIImageView*)image5
{
    if(!_image5)
    {
        _image5 = [[UIImageView alloc] init];
        [self addSubview:_image5];
    }
    return _image5;
}

- (UIImageView*)image6
{
    if(!_image6)
    {
        _image6 = [[UIImageView alloc] init];
        [self addSubview:_image6];
    }
    return _image6;
}

- (UIImageView*)image7
{
    if(!_image7)
    {
        _image7 = [[UIImageView alloc] init];
        [self addSubview:_image7];
    }
    return _image7;
}

- (UIImageView*)image8
{
    if(!_image8)
    {
        _image8 = [[UIImageView alloc] init];
        [self addSubview:_image8];
    }
    return _image8;
}
- (UIImageView*)image9
{
    if(!_image9)
    {
        _image9 = [[UIImageView alloc] init];
        [self addSubview:_image9];
    }
    return _image9;
}
@end
