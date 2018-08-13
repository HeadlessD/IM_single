//
//  UIImage+NIMHBClass.m
//  MyTest
//
//  Created by weqia on 13-7-30.
//  Copyright (c) 2013年 weqia. All rights reserved.
//

#import "UIImage+NIMHBClass.h"

@implementation UIImage (NIMHBClass)
-(UIImage*) nim_getLimitImage:(CGSize) size
{
    // 排错
    if(size.width==0||size.height==0)
        return self;
    CGSize imgSize=self.size;
    float scale=size.height/size.width;
    float imgScale=imgSize.height/imgSize.width;
    float width=0.0f,height=0.0f;
    if(imgScale<scale&&imgSize.width>size.width){
        width=size.width;
        height=width*imgScale;
    }else if(imgScale > scale&&imgSize.height>size.height){
        height=size.height;
        width=height/imgScale;
    }
    else
    {
        width = size.width;
        height = size.height;
    }
    UIGraphicsBeginImageContext(CGSizeMake(width, height));
    [self drawInRect:CGRectMake(0, 0, width, height)];
    UIImage * image= UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

-(UIImage*) nim_getClickImage:(CGSize) size
{
    // 排错
    if(size.width==0||size.height==0)
        return self;
    CGSize imgSize=self.size;
    UIImageOrientation  orientation=self.imageOrientation;
    CGRect rect;
    if(size.height>=imgSize.height&&size.width>=imgSize.width)
        return self;
    else if(size.height>=imgSize.height&&size.width<imgSize.width)
         rect=CGRectMake((imgSize.width-size.width)/2, 0, size.width, imgSize.height);
    else if(size.height<imgSize.height&&size.width>=imgSize.width)
         rect=CGRectMake(0, (imgSize.height-size.height)/2, imgSize.width, size.height);
    else
         rect=CGRectMake((imgSize.width-size.width)/2,(imgSize.height-size.height)/2, size.width, size.height);
    CGImageRef imgRef=CGImageCreateWithImageInRect(self.CGImage, rect);
    return [UIImage imageWithCGImage:imgRef scale:1 orientation:orientation];
}

-(UIImage*)nim_scaleToSize:(CGSize)size
{
    CGFloat width = CGImageGetWidth(self.CGImage);
    CGFloat height = CGImageGetHeight(self.CGImage);

    float verticalRadio = size.height*1.0/height;
    float horizontalRadio = size.width*1.0/width;

    float radio = 1;
    if(verticalRadio>1 && horizontalRadio>1)
        {
            radio = verticalRadio > horizontalRadio ? horizontalRadio : verticalRadio;
        }
    else
        {
            radio = verticalRadio < horizontalRadio ? verticalRadio : horizontalRadio;
        }

    width = width*radio;
    height = height*radio;

    int xPos = (size.width - width)/2;
    int yPos = (size.height-height)/2;

    // 创建一个bitmap的context
    // 并把它设置成为当前正在使用的context
    UIGraphicsBeginImageContext(size);

    // 绘制改变大小的图片
    [self drawInRect:CGRectMake(xPos, yPos, width, height)];

    // 从当前context中创建一个改变大小后的图片
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();

    // 使当前的context出堆栈
    UIGraphicsEndImageContext();

    // 返回新的改变大小后的图片
    return scaledImage;
}

+ (UIImage *)nim_generatePhotoThumbnail:(UIImage *)image {
	// Create a thumbnail version of the image for the event object.
	CGSize size = image.size;
	CGSize croppedSize;
//	CGFloat ratio = 64.0;

    CGFloat ratio_width = 200;
    CGFloat ratio_height = 200;

	CGFloat offsetX = 0.0;
	CGFloat offsetY = 0.0;



	// check the size of the image, we want to make it
	// a square with sides the size of the smallest dimension
	if (size.width > size.height) {
		offsetX = 0;
		croppedSize = CGSizeMake(size.height, size.height);
        ratio_width = ratio_width;
        ratio_height = (size.height / size.width ) * 200;

	} else {
		offsetY = 0;
		croppedSize = CGSizeMake(size.width, size.width);
        ratio_height = ratio_height;
        ratio_width = (size.width / size.height ) * 200;
	}

	// Crop the image before resize
	CGRect clippedRect = CGRectMake(offsetX * -1, offsetY * -1, croppedSize.width, croppedSize.height);
	CGImageRef imageRef = CGImageCreateWithImageInRect([image CGImage], clippedRect);
	// Done cropping

	// Resize the image
	CGRect rect = CGRectMake(0.0, 0.0, ratio_width, ratio_height);

	UIGraphicsBeginImageContext(rect.size);
	[[UIImage imageWithCGImage:imageRef] drawInRect:rect];
	UIImage *thumbnail = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	// Done Resizing

	return thumbnail;
}
@end
