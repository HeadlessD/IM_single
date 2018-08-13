//
//  NIMMatchParseData.m
//  DoctorClient
//
//  Created by weqia on 14-5-3.
//  Copyright (c) 2014年 xhb. All rights reserved.
//

#import "NIMMatchParseData.h"
#import "NSString+NIMMD5.h"

@interface NIMMatchParseData()
@property (nonatomic, assign)float emojiWidth;
@end

@implementation NIMMatchParseData

+(NSCache*)shareCache
{
    static NSCache * cache=nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        cache=[[NSCache alloc]init];
        [cache setTotalCostLimit:0.2*1024*1024];
    });
    return cache;
}

- (void)setFont:(UIFont *)font
{
    _font = font;
    self.emojiWidth = font.pointSize;
}

-(NIMMatchParser*)getMatch
{
    if (_match&&[_match isKindOfClass:[NIMMatchParser class]])
    {
        return _match;
    }
    else
    {
        NSString * md = [NSString stringWithFormat:@"%@:%@",[self class],self.content];
        NSString *key = [md nim_MD5Hash];
        NIMMatchParser *parser = [[NIMMatchParseData shareCache] objectForKey:key];
        if (parser)
        {
            _match = parser;
            parser.data = self;
            self.height = parser.height;
            return parser;
        }
        else
        {
            NIMMatchParser * parser = [self createMatch:self.width];
            if (parser)
            {
                [[NIMMatchParseData shareCache]  setObject:parser forKey:key];
            }
            return _match;
        }
    }
}
-(void)getMatch:(void (^)(NIMMatchParser *, id))complete data:(id)data
{
    if (_match&&[_match isKindOfClass:[NIMMatchParser class]])
    {
        if (complete)
        {
            complete(_match,data);
        }
    }
    else
    {
        NSString *key=[[NSString stringWithFormat:@"%@:%@",[self class],self.content] nim_MD5Hash];
        NIMMatchParser *parser=[[NIMMatchParseData shareCache] objectForKey:key];
        if (parser)
        {
            _match = parser;
            parser.data = self;
            self.height = parser.height;
            if (complete)
            {
                complete(_match,data);
            }
        }
        else
        {
            NIMMatchParser* parser = [self createMatch:self.width];
            if (parser)
            {
                [[NIMMatchParseData shareCache]  setObject:parser forKey:key];
            }
            if (complete)
            {
                complete(_match,data);
            }
        }
    }
}

-(void)setMatch
{
    if (_match&&[_match isKindOfClass:[NIMMatchParser class]])
    {
        return;
    }
    else
    {
        NSString *key=[[NSString stringWithFormat:@"%@:%@",[self class],self.content] nim_MD5Hash];
        NIMMatchParser *parser=[[NIMMatchParseData shareCache] objectForKey:key];
        if (parser)
        {
            _match=parser;
            self.height=parser.height;
            parser.data=self;
        }
        else
        {
            NIMMatchParser* parser=[self createMatch:200];
            if (parser)
            {
                [[NIMMatchParseData shareCache]  setObject:parser forKey:key];
            }
        }
    }
}

-(void)setMatch:(NIMMatchParser *)match1
{
    _match = match1;
}

-(NIMMatchParser*)createMatch:(float)width
{
    NSString * content1 = (NSString*)self.content;
    if(_match == nil || ![_match isKindOfClass:[NIMMatchParser class]])
    {
        NIMMatchParser * parser= [[NIMMatchParser alloc]init];
        parser.font         = self.font;
        parser.iconSize     = self.emojiWidth+2;
        parser.keyWorkColor = [SSIMSpUtil getColor:@"0f77e8"];
        parser.width        = width;
        parser.sendNickName = self.sendNickName;
        parser.toTragetName = self.toTragetName;
        [parser match:content1];
        _match              = parser;
        parser.data         = self;
        self.height         = parser.height;
        return parser;
    }
    return nil;
}

-(void)updateMatch:(void (^)(NSMutableAttributedString *, NSRange))link
{
    NSString * content1 = (NSString*)self.content;
    if(_match != nil || [_match isKindOfClass:[NIMMatchParser class]])
    {
        [_match match:content1 atCallBack:nil title:nil link:link];
    }
}

@end
