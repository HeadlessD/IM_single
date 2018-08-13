//
//  NIMQBLabel.m
//  QianbaoIM
//
//  Created by liu nian on 14-3-24.
//  Copyright (c) 2014年 liu nian. All rights reserved.
//

#import "NIMQBLabel.h"

@implementation NIMQBLabel

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self setTxtColor:self.textColor];
    }
    return self;
}
#pragma -mark 私有方法
+ (NSDictionary*)getFaceMap
{
    static NSDictionary * dic=nil;
    if(dic==nil){
        NSString* path=[[NSBundle mainBundle] pathForResource:@"faceMapQQNew" ofType:@"plist"];
        dic =[NSDictionary dictionaryWithContentsOfFile:path];
    }
    return dic;
}

+ (NSDictionary *)getBigFaceMap
{
    static NSDictionary * dic=nil;
    if(dic==nil){
        NSString* path=[[NSBundle mainBundle] pathForResource:@"faceMapGif" ofType:@"plist"];
        dic =[NSDictionary dictionaryWithContentsOfFile:path];
    }
    return dic;
}

+ (NSString*)faceKeyForValue:(NSString*)value  map:(NSDictionary*) map
{
    NSArray * keys=[map allKeys];
    int count=[keys count];
    for(int i=0;i<count;i++)
    {
        NSString * key=[keys objectAtIndex:i];
        if([[map objectForKey:key] isEqualToString:value])
            return key;
    }
    return nil;
}

-(int)getRightIndex:(NSString*)resource forWidth:(float)width
{
    int length=[resource length];
    for(int i=1;i<length;i++){
        NSString * subStr=[resource substringToIndex:i];
        CGSize size=[subStr sizeWithAttributes:@{NSFontAttributeName:self.font}];
        if(size.width>width)
            return i-1;
    }
    return length-1;
}

-(void)drawText:(NSString*)string
{
    if(xIndex+SPACE_WIDTH+5>maxWidth)
    {
        xIndex          = 0.0f;
        yIndex          += LINE_HEIGHT;
    }
    CGSize size=[string sizeWithAttributes:@{NSFontAttributeName:self.font}];
    while (size.width>(maxWidth-xIndex))
    {
        int index=[self getRightIndex:string forWidth:maxWidth-xIndex];
        NSString * sub=[string substringToIndex:index];
        CGSize subSize=[sub sizeWithAttributes:@{NSFontAttributeName:self.font}];
        UILabel * label=[[UILabel alloc]initWithFrame:CGRectMake(xIndex, yIndex,subSize.width , subSize.height)];
        label.text      = sub;
        label.textColor = self.txtColor;
        label.font      = self.font;
        label.backgroundColor=[UIColor clearColor];
        [self addSubview:label];
        xIndex          = 0;
        line++;
        yIndex          += LINE_HEIGHT;
        string=[string substringFromIndex:index];
        size=[string sizeWithAttributes:@{NSFontAttributeName:self.font}];
    }
    UILabel * label=[[UILabel alloc]initWithFrame:CGRectMake(xIndex, yIndex,size.width , size.height)];
    label.text      = string;
    label.textColor = self.txtColor;
    label.font      = self.font;
    label.backgroundColor=[UIColor clearColor];
    [self addSubview:label];
    xIndex          += size.width;
}

-(void)drawIcon:(NSString*)string
{
    NSString * icon=[NIMQBLabel faceKeyForValue:string map:[NIMQBLabel getFaceMap]];
    if(icon==nil)
    {
        [self drawText:string];
        return;
    }
    NSMutableString * iconFile=[NSMutableString stringWithString:icon];
    [iconFile appendFormat:@".png"];
    UIImageView *image = [[UIImageView alloc] initWithImage:IMGGET(iconFile)];
    if(xIndex+ICON_SIZE+SPACE_WIDTH>=maxWidth)
    {
        xIndex=0.0f;
        yIndex+=LINE_HEIGHT;
        line++;
    }
    image.frame=CGRectMake(SPACE_WIDTH+xIndex,(LINE_HEIGHT-ICON_SIZE)/2+yIndex -1, ICON_SIZE, ICON_SIZE);
    [self addSubview:image];
    xIndex=xIndex+ICON_SIZE+SPACE_WIDTH;
}


#pragma -mrak 接口方法
- (void)setTxtColor:(UIColor *)txtColor{
    _txtColor = txtColor;
}

- (void)clear
{
    NSArray * subvies = [self subviews];
    {
        for (UIView *subView in subvies) {
            [subView removeFromSuperview];
        }
    }
}
- (void)setTextAndIcon:(NSString*)string
{
    [self setTextAndIcon:string offX:0 offY:0];
}

+ (UIImage *)bigQBFaceWithTxt:(NSString *)faceKey{
    NIMIconMatch * match=[[NIMIconMatch alloc]init];
    NSArray *strs=[match MatchBig:faceKey];
    int count = [strs count];
    for(int i = 0;i<count;i++){
        NSString * string=[strs objectAtIndex:i];
        if([string hasPrefix:BEGINBIG_TAG]&&[string hasSuffix:END_TAG]){
            NSString *icon=[NIMQBLabel faceKeyForValue:string map:[NIMQBLabel getBigFaceMap]];
            if(icon == nil){
                return nil;
            }
            NSMutableString * iconFile = [NSMutableString stringWithString:icon];
            [iconFile appendFormat:@".png"];
            return IMGGET(iconFile);
        }
    }
    return nil;
}

- (void)setTextAndIcon:(NSString *)string  offX:(float)offx offY:(float)offy
{
    NIMIconMatch * match=[[NIMIconMatch alloc]init];
    NSArray * strs=[match Match:string];
    line=1;
    xIndex=offx;
    yIndex=offy;
    maxWidth=self.frame.size.width;
    int count=[strs count];
    for(int i=0;i<count;i++){
        NSString * string=[strs objectAtIndex:i];
        if([string hasPrefix:BEGIN_TAG]&&[string hasSuffix:END_TAG])
        {
            [self drawIcon:string];
        }else
        {
            [self drawText:string];
        }
    }
    CGRect frame=self.frame;
    frame.size.height=yIndex+21;
    if(line==1)
        frame.size.width=xIndex;
    self.frame=frame;
}


// 修改绘制文字的区域，edgeInsets增加bounds
-(CGRect)textRectForBounds:(CGRect)bounds limitedToNumberOfLines:(NSInteger)numberOfLines
{
    
    /*
     调用父类该方法
     注意传入的UIEdgeInsetsInsetRect(bounds, self.edgeInsets),bounds是真正的绘图区域
     */
    CGRect rect = [super textRectForBounds:UIEdgeInsetsInsetRect(bounds,
                                                                 self.edgeInsets) limitedToNumberOfLines:numberOfLines];
    //根据edgeInsets，修改绘制文字的bounds
    rect.origin.x -= self.edgeInsets.left;
    rect.origin.y -= self.edgeInsets.top;
    rect.size.width += self.edgeInsets.left + self.edgeInsets.right;
    rect.size.height += self.edgeInsets.top + self.edgeInsets.bottom;
    return rect;
}

//绘制文字
- (void)drawTextInRect:(CGRect)rect
{
    //令绘制区域为原始区域，增加的内边距区域不绘制
    [super drawTextInRect:UIEdgeInsetsInsetRect(rect, self.edgeInsets)];
}


@end


@implementation NSString (HBLabel)

-(CGSize) hbSizeWithFont:(UIFont *)font constrainedToSize:(CGSize)size
{
    return [self hbSizeWithFont:font constrainedToSize:size offX:0.0f offY:0.0f];
}
-(CGSize) hbSizeWithFont:(UIFont *)font constrainedToSize:(CGSize)size offX:(float)offx offY:(float)offy;
{
    
    NIMIconMatch * match=[[NIMIconMatch alloc]init];
    NSArray * strs=[match Match:self];
    float xIndex=offx;
    float yIndex=offy;
    float maxWidth=size.width;
    int count=[strs count];
    for(int i=0;i<count;i++){
        NSString * string=[strs objectAtIndex:i];
        if([string hasPrefix:BEGIN_TAG]&&[string hasSuffix:END_TAG]){
            NSString * icon=[NIMQBLabel faceKeyForValue:string map:[NIMQBLabel getFaceMap]];
            if(icon==nil)
            {
                if(xIndex+SPACE_WIDTH+5>maxWidth)
                {
                    xIndex=0.0f;
                    yIndex+=LINE_HEIGHT;
                }
                CGSize size=[string sizeWithAttributes:@{NSFontAttributeName:font}];
                while (size.width>(maxWidth-xIndex))
                {
                    int index=[self getRightIndex:string forWidth:maxWidth-xIndex withFont:font];
                    xIndex=0;
                    yIndex+=LINE_HEIGHT;
                    string=[string substringFromIndex:index];
                    size=[string sizeWithAttributes:@{NSFontAttributeName:font}];
                }
                xIndex+=size.width;
            }
            if(xIndex+ICON_SIZE+SPACE_WIDTH>=maxWidth)
            {
                xIndex=0.0f;
                yIndex+=LINE_HEIGHT;
            }
            xIndex=xIndex+ICON_SIZE+SPACE_WIDTH;
        }else{
            if(xIndex+SPACE_WIDTH+5>maxWidth)
            {
                xIndex=0.0f;
                yIndex+=LINE_HEIGHT;
            }
            CGSize size=[string sizeWithAttributes:@{NSFontAttributeName:font}];
            while (size.width>(maxWidth-xIndex))
            {
                int index=[self getRightIndex:string forWidth:maxWidth-xIndex withFont:font];
                xIndex=0;
                yIndex+=LINE_HEIGHT;
                string=[string substringFromIndex:index];
                
                size=[string sizeWithAttributes:@{NSFontAttributeName:font}];
            }
            xIndex+=size.width;
        }
    }
    return CGSizeMake(xIndex, yIndex+LINE_HEIGHT);
}

-(int)getRightIndex:(NSString*)resource forWidth:(float)width withFont:(UIFont*)font
{
    int length=[resource length];
    for(int i=1;i<length;i++)
    {
        NSString * subStr=[resource substringToIndex:i];
        CGSize size=[subStr sizeWithAttributes:@{NSFontAttributeName:font}];
        if(size.width>width)
            return i-1;
    }
    return length-1;
}
@end
