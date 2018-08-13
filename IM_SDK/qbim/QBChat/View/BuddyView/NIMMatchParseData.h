//
//  NIMMatchParseData.h
//  DoctorClient
//
//  Created by weqia on 14-5-3.
//  Copyright (c) 2014年 xhb. All rights reserved.
//

//#import "BaseData.h"
#import "NIMMatchParser.h"
//#import "UIColor+setting.h"


@interface NIMMatchParseData : NSObject<NIMMatchParserDelegate>
{
    __weak NIMMatchParser * _match;
}
@property(nonatomic)float width;
@property(nonatomic)float height;
@property(nonatomic,strong)NSString * content;
@property (nonatomic,copy) NSString *sendNickName;
@property (nonatomic,copy) NSString *toTragetName;
@property (nonatomic,strong)UIFont  *font;
-(void)setMatch:(NIMMatchParser *)match1;

+(NSCache*)shareCache;
@end
