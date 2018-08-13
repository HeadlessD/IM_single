//
//  UIImage+NIMEllipse.m
//  QianbaoIM
//
//  Created by liu nian on 6/7/14.
//  Copyright (c) 2014 liu nian. All rights reserved.
//

#import "UIImage+NIMEllipse.h"
#import <QuartzCore/QuartzCore.h>
#import <Accelerate/Accelerate.h>

@implementation UIImage (NIMEllipse)
//不要边框，只把图片变成圆形

- (UIImage *) nim_ellipseImage: (UIImage *) image withInset: (CGFloat) inset withBorderWidth:(CGFloat)width withBorderColor:(UIColor*)color size:(CGSize )size
{
    UIGraphicsBeginImageContext(size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGRect rect = CGRectMake(inset, inset, size.width - inset * 2.0f ,size.height - inset * 2.0f);
    
    CGContextAddEllipseInRect(context, rect);
    CGContextClip(context);
    [image drawInRect:rect];
    
    if (width > 0) {
        CGContextSetStrokeColorWithColor(context, color.CGColor);
        CGContextSetLineCap(context,kCGLineCapButt);
        CGContextSetLineWidth(context, width);
        CGContextAddEllipseInRect(context, CGRectMake(inset + width/2, inset +  width/2, size.width - width- inset * 2.0f, size.height - width - inset * 2.0f));//在这个框中画圆
        
        CGContextStrokePath(context);
    }
    
    
    UIImage *newimg = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newimg;
}

+ (UIImage*)nim_transferImage:(UIImage*)oriImage orientation:(UIImageOrientation)orientation
{
    CGImageRef imgRef = oriImage.CGImage;
    CGFloat width = CGImageGetWidth(imgRef);
    CGFloat height = CGImageGetHeight(imgRef);
    
    CGAffineTransform transform = CGAffineTransformIdentity;
    CGRect bounds = CGRectMake(0, 0, width, height);

    CGFloat scaleRatio = bounds.size.width / width;
    CGSize imageSize = CGSizeMake(CGImageGetWidth(imgRef), CGImageGetHeight(imgRef));
    CGFloat boundHeight;
    
    switch(orientation) {
        case UIImageOrientationUp:
            transform = CGAffineTransformIdentity;
            break;
        case UIImageOrientationUpMirrored:
            transform = CGAffineTransformMakeTranslation(imageSize.width, 0.0);
            transform = CGAffineTransformScale(transform, -1.0, 1.0);
            break;
        case UIImageOrientationDown:
            transform = CGAffineTransformMakeTranslation(imageSize.width, imageSize.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformMakeTranslation(0.0, imageSize.height);
            transform = CGAffineTransformScale(transform, 1.0, -1.0);
            break;
        case UIImageOrientationLeftMirrored:
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeTranslation(imageSize.height, imageSize.width);
            transform = CGAffineTransformScale(transform, -1.0, 1.0);
            transform = CGAffineTransformRotate(transform, 3.0 * M_PI / 2.0);
            break;
        case UIImageOrientationLeft:
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeTranslation(0.0, imageSize.width);
            transform = CGAffineTransformRotate(transform, 3.0 * M_PI / 2.0);
            break;
        case UIImageOrientationRightMirrored:
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeScale(-1.0, 1.0);
            transform = CGAffineTransformRotate(transform, M_PI / 2.0);
            break;
        case UIImageOrientationRight:
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeTranslation(imageSize.height, 0.0);
            transform = CGAffineTransformRotate(transform, M_PI / 2.0);
            break;
        default:
            [NSException raise:NSInternalInconsistencyException format:@"Invalid image orientation"];
    }
    
    UIGraphicsBeginImageContext(bounds.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    if (orientation == UIImageOrientationRight || orientation == UIImageOrientationLeft) {
        CGContextScaleCTM(context, -scaleRatio, scaleRatio);
        CGContextTranslateCTM(context, -height, 0);
    } else {
        CGContextScaleCTM(context, scaleRatio, -scaleRatio);
        CGContextTranslateCTM(context, 0, -height);
    }
    
    CGContextConcatCTM(context, transform);
    CGContextDrawImage(UIGraphicsGetCurrentContext(), CGRectMake(0, 0, width, height), imgRef);
    UIImage *imageCopy = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return imageCopy;
}

//TODO:compraseImage
- (UIImage *)nim_compraseImage:(UIImage *)largeImage
{
//    largeImage = [self transferImage:largeImage];//处理图片旋转
    double compressionRatio = 1;
    int resizeAttempts = 5;
    UIImage *savedImage = nil;
    
    NSData * imgData = UIImageJPEGRepresentation(largeImage,compressionRatio);
    
    DBLog(@"Starting Size: %lu", (unsigned long)[imgData length]);
    
    //Trying to push it below around about 0.4 meg
    while ([imgData length] > 1024*1024 && resizeAttempts > 0) {
        resizeAttempts -= 1;
        
        DBLog(@"Image was bigger than 400000 Bytes. Resizing.");
        DBLog(@"%i Attempts Remaining",resizeAttempts);
        
        //Increase the compression amount
        compressionRatio = compressionRatio*0.1;
        DBLog(@"compressionRatio %f",compressionRatio);
        //Test size before compression
        DBLog(@"Current Size: %lu",(unsigned long)[imgData length]);
        imgData = UIImageJPEGRepresentation(largeImage,compressionRatio);
        
        //Test size after compression
        DBLog(@"New Size: %lu",(unsigned long)[imgData length]);
    }
    
    //Set image by comprssed version
    savedImage = [UIImage imageWithData:imgData];
    return savedImage;
}

//截图
+ (UIImage *)nim_imgWithVC:(UIViewController *)vc
{
    CGSize imageSize = [[UIScreen mainScreen] bounds].size;
    
    if (NULL != &UIGraphicsBeginImageContextWithOptions) {
        UIGraphicsBeginImageContextWithOptions(imageSize, NO, 0);
    } else {
        UIGraphicsBeginImageContext(imageSize);
    }
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    for (UIWindow *window in [[UIApplication sharedApplication] windows]) {
        if (![window respondsToSelector:@selector(screen)] || [window screen] == [UIScreen mainScreen]) {
            CGContextSaveGState(context);
            
            CGContextTranslateCTM(context, [window center].x, [window center].y);
            
            CGContextConcatCTM(context, [window transform]);
            
            CGContextTranslateCTM(context,
                                  -[window bounds].size.width * [[window layer] anchorPoint].x,
                                  -[window bounds].size.height * [[window layer] anchorPoint].y);
            
            [[window layer] renderInContext:context];
            
            CGContextRestoreGState(context);
        }
    }
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    return image;
}

+ (UIImage *)nim_imageWithColor:(UIColor *)color andSize:(CGSize)size
{
    CGRect rect = CGRectMake(0.0f, 0.0f, size.width, size.height);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

//改变图片颜色
- (UIImage *)nim_imageWithColor:(UIColor *)color
{
    UIGraphicsBeginImageContextWithOptions(self.size, NO, self.scale);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextTranslateCTM(context, 0, self.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    CGContextSetBlendMode(context, kCGBlendModeNormal);
    CGRect rect = CGRectMake(0, 0, self.size.width, self.size.height);
    CGContextClipToMask(context, rect, self.CGImage);
    [color setFill];
    CGContextFillRect(context, rect);
    UIImage*newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

- (UIImage*)nim_uie_boxblurImageWithBlur:(CGFloat)blur
{
    if (blur < 0.f || blur > 1.f) {
        blur = 0.5f;
    }
    int boxSize = (int)(blur * 40);
    boxSize = boxSize - (boxSize % 2) + 1;
    
    CGImageRef img = self.CGImage;
    vImage_Buffer inBuffer, outBuffer;
    vImage_Error error;
    void *pixelBuffer;
    
    //create vImage_Buffer with data from CGImageRef
    CGDataProviderRef inProvider = CGImageGetDataProvider(img);
    CFDataRef inBitmapData = CGDataProviderCopyData(inProvider);
    
    inBuffer.width = CGImageGetWidth(img);
    inBuffer.height = CGImageGetHeight(img);
    inBuffer.rowBytes = CGImageGetBytesPerRow(img);
    
    inBuffer.data = (void*)CFDataGetBytePtr(inBitmapData);
    
    //create vImage_Buffer for output
    pixelBuffer = malloc(CGImageGetBytesPerRow(img) * CGImageGetHeight(img));
    
    if(pixelBuffer == NULL)
        NSLog(@"No pixelbuffer");
    
    outBuffer.data = pixelBuffer;
    outBuffer.width = CGImageGetWidth(img);
    outBuffer.height = CGImageGetHeight(img);
    outBuffer.rowBytes = CGImageGetBytesPerRow(img);
    
    // Create a third buffer for intermediate processing
    /*void *pixelBuffer2 = malloc(CGImageGetBytesPerRow(img) * CGImageGetHeight(img));
     vImage_Buffer outBuffer2;
     outBuffer2.data = pixelBuffer2;
     outBuffer2.width = CGImageGetWidth(img);
     outBuffer2.height = CGImageGetHeight(img);
     outBuffer2.rowBytes = CGImageGetBytesPerRow(img);*/
    
    //perform convolution
    error = vImageBoxConvolve_ARGB8888(&inBuffer, &outBuffer, NULL, 0, 0, boxSize, boxSize, NULL, kvImageEdgeExtend)
    ?: vImageBoxConvolve_ARGB8888(&outBuffer, &inBuffer, NULL, 0, 0, boxSize, boxSize, NULL, kvImageEdgeExtend)
    ?: vImageBoxConvolve_ARGB8888(&inBuffer, &outBuffer, NULL, 0, 0, boxSize, boxSize, NULL, kvImageEdgeExtend);
    
    if (error) {
        NSLog(@"error from convolution %ld", error);
    }
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef ctx = CGBitmapContextCreate(outBuffer.data,
                                             outBuffer.width,
                                             outBuffer.height,
                                             8,
                                             outBuffer.rowBytes,
                                             colorSpace,
                                             (CGBitmapInfo)kCGImageAlphaNoneSkipLast);
    CGImageRef imageRef = CGBitmapContextCreateImage (ctx);
    UIImage *returnImage = [UIImage imageWithCGImage:imageRef];
    
    //clean up
    CGContextRelease(ctx);
    CGColorSpaceRelease(colorSpace);
    
    free(pixelBuffer);
    //free(pixelBuffer2);
    
    CFRelease(inBitmapData);
    
    CGImageRelease(imageRef);
    
    
    
    return returnImage;
}


- (UIImage*) nim_stackBlur:(NSUInteger)inradius{
    
    int radius=inradius; // Transform unsigned into signed for further operations
    
    if (radius<1){
        return self;
    }
    
    //	return [other applyBlendFilter:filterOverlay  other:self context:nil];
    // First get the image into your data buffer
    
    CGImageRef inImage = self.CGImage;
    CFDataRef m_DataRef = CGDataProviderCopyData(CGImageGetDataProvider(inImage));
    UInt8 * m_PixelBuf = (UInt8 *) CFDataGetBytePtr(m_DataRef);
    
    
    CGContextRef ctx = CGBitmapContextCreate(m_PixelBuf,
                                             CGImageGetWidth(inImage),
                                             CGImageGetHeight(inImage),
                                             CGImageGetBitsPerComponent(inImage),
                                             CGImageGetBytesPerRow(inImage),
                                             CGImageGetColorSpace(inImage),
                                             CGImageGetBitmapInfo(inImage)
                                             );
    
    
    int w=CGImageGetWidth(inImage);
    int h=CGImageGetHeight(inImage);
    int wm=w-1;
    int hm=h-1;
    int wh=w*h;
    int div=radius+radius+1;
    int *r=malloc(wh*sizeof(int));
    int *g=malloc(wh*sizeof(int));
    int *b=malloc(wh*sizeof(int));
    memset(r,0,wh*sizeof(int));
    memset(g,0,wh*sizeof(int));
    memset(b,0,wh*sizeof(int));
    int rsum,gsum,bsum,x,y,i,p,yp,yi,yw;
    int *vmin = malloc(sizeof(int)*MAX(w,h));
    memset(vmin,0,sizeof(int)*MAX(w,h));
    int divsum=(div+1)>>1;
    divsum*=divsum;
    int *dv=malloc(sizeof(int)*(256*divsum));
    for (i=0;i<256*divsum;i++){
        dv[i]=(i/divsum);
    }
    
    yw=yi=0;
    
    int *stack=malloc(sizeof(int)*(div*3));
    int stackpointer;
    int stackstart;
    int *sir;
    int rbs;
    int r1=radius+1;
    int routsum,goutsum,boutsum;
    int rinsum,ginsum,binsum;
    memset(stack,0,sizeof(int)*div*3);
    
    for (y=0;y<h;y++){
        rinsum=ginsum=binsum=routsum=goutsum=boutsum=rsum=gsum=bsum=0;
        
        for(int i=-radius;i<=radius;i++){
            sir=&stack[(i+radius)*3];
            /*			p=m_PixelBuf[yi+MIN(wm,MAX(i,0))];
             sir[0]=(p & 0xff0000)>>16;
             sir[1]=(p & 0x00ff00)>>8;
             sir[2]=(p & 0x0000ff);
             */
            int offset=(yi+MIN(wm,MAX(i,0)))*4;
            sir[0]=m_PixelBuf[offset];
            sir[1]=m_PixelBuf[offset+1];
            sir[2]=m_PixelBuf[offset+2];
            
            rbs=r1-abs(i);
            rsum+=sir[0]*rbs;
            gsum+=sir[1]*rbs;
            bsum+=sir[2]*rbs;
            if (i>0){
                rinsum+=sir[0];
                ginsum+=sir[1];
                binsum+=sir[2];
            } else {
                routsum+=sir[0];
                goutsum+=sir[1];
                boutsum+=sir[2];
            }
        }
        stackpointer=radius;
        
        
        for (x=0;x<w;x++){
            r[yi]=dv[rsum];
            g[yi]=dv[gsum];
            b[yi]=dv[bsum];
            
            rsum-=routsum;
            gsum-=goutsum;
            bsum-=boutsum;
            
            stackstart=stackpointer-radius+div;
            sir=&stack[(stackstart%div)*3];
            
            routsum-=sir[0];
            goutsum-=sir[1];
            boutsum-=sir[2];
            
            if(y==0){
                vmin[x]=MIN(x+radius+1,wm);
            }
            
            /*			p=m_PixelBuf[yw+vmin[x]];
             
             sir[0]=(p & 0xff0000)>>16;
             sir[1]=(p & 0x00ff00)>>8;
             sir[2]=(p & 0x0000ff);
             */
            int offset=(yw+vmin[x])*4;
            sir[0]=m_PixelBuf[offset];
            sir[1]=m_PixelBuf[offset+1];
            sir[2]=m_PixelBuf[offset+2];
            rinsum+=sir[0];
            ginsum+=sir[1];
            binsum+=sir[2];
            
            rsum+=rinsum;
            gsum+=ginsum;
            bsum+=binsum;
            
            stackpointer=(stackpointer+1)%div;
            sir=&stack[((stackpointer)%div)*3];
            
            routsum+=sir[0];
            goutsum+=sir[1];
            boutsum+=sir[2];
            
            rinsum-=sir[0];
            ginsum-=sir[1];
            binsum-=sir[2];
            
            yi++;
        }
        yw+=w;
    }
    for (x=0;x<w;x++){
        rinsum=ginsum=binsum=routsum=goutsum=boutsum=rsum=gsum=bsum=0;
        yp=-radius*w;
        for(i=-radius;i<=radius;i++){
            yi=MAX(0,yp)+x;
            
            sir=&stack[(i+radius)*3];
            
            sir[0]=r[yi];
            sir[1]=g[yi];
            sir[2]=b[yi];
            
            rbs=r1-abs(i);
            
            rsum+=r[yi]*rbs;
            gsum+=g[yi]*rbs;
            bsum+=b[yi]*rbs;
            
            if (i>0){
                rinsum+=sir[0];
                ginsum+=sir[1];
                binsum+=sir[2];
            } else {
                routsum+=sir[0];
                goutsum+=sir[1];
                boutsum+=sir[2];
            }
            
            if(i<hm){
                yp+=w;
            }
        }
        yi=x;
        stackpointer=radius;
        for (y=0;y<h;y++){
            //			m_PixelBuf[yi]=0xff000000 | (dv[rsum]<<16) | (dv[gsum]<<8) | dv[bsum];
            int offset=yi*4;
            m_PixelBuf[offset]=dv[rsum];
            m_PixelBuf[offset+1]=dv[gsum];
            m_PixelBuf[offset+2]=dv[bsum];
            rsum-=routsum;
            gsum-=goutsum;
            bsum-=boutsum;
            
            stackstart=stackpointer-radius+div;
            sir=&stack[(stackstart%div)*3];
            
            routsum-=sir[0];
            goutsum-=sir[1];
            boutsum-=sir[2];
            
            if(x==0){
                vmin[y]=MIN(y+r1,hm)*w;
            }
            p=x+vmin[y];
            
            sir[0]=r[p];
            sir[1]=g[p];
            sir[2]=b[p];
            
            rinsum+=sir[0];
            ginsum+=sir[1];
            binsum+=sir[2];
            
            rsum+=rinsum;
            gsum+=ginsum;
            bsum+=binsum;
            
            stackpointer=(stackpointer+1)%div;
            sir=&stack[(stackpointer)*3];
            
            routsum+=sir[0];
            goutsum+=sir[1];
            boutsum+=sir[2];
            
            rinsum-=sir[0];
            ginsum-=sir[1];
            binsum-=sir[2];
            
            yi+=w;
        }
    }
    free(r);
    free(g);
    free(b);
    free(vmin);
    free(dv);
    free(stack);
    CGImageRef imageRef = CGBitmapContextCreateImage(ctx);
    CGContextRelease(ctx);
    
    //	CFRelease(m_DataRef);
    UIImage *finalImage = [UIImage imageWithCGImage:imageRef];
    CGImageRelease(imageRef);
    CFRelease(m_DataRef);
    return finalImage;
}



@end
