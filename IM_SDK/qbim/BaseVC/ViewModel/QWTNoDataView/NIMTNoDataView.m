//
//  NIMTNoDataView.m
//  QianbaoIM
//
//  Created by liyan on 10/12/14.
//  Copyright (c) 2014 liu nian. All rights reserved.
//

#import "NIMTNoDataView.h"
#import "Masonry.h"
#import "NIMConstHeader.h"
@interface NIMTNoDataView ()



@end

@implementation NIMTNoDataView

- (void)dealloc
{
    RELEASE_SAFELY(_iconError);
    RELEASE_SAFELY(_labError);
    RELEASE_SUPER_DEALLOC;
}

- (id)initWithFrame:(CGRect)frame
{
    CGRect rect=CGRectMake(0, 0, 100, 100);
    self = [super initWithFrame:rect];
    
    if (self) {
         
        if (self.iconError) {
            [self addSubview:self.iconError];
            
            [self.iconError mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.equalTo(self.mas_centerX);
                make.top.equalTo(@(0));
                make.width.equalTo(@(self.iconError.image.size.width));
                make.height.equalTo(@(self.iconError.image.size.height));
            }];

        }
        if (self.labError) {
            [self addSubview:self.labError];
            
            [self.labError mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.equalTo(self.mas_centerX);
                make.top.equalTo(self.iconError.mas_bottom).offset(5);
                make.width.equalTo(self.mas_width);
                make.height.equalTo(@40);
            }];
        }

 
    }
    return self;
}

- (void)setUserIMG:(BOOL)userIMG
{
    _userIMG = userIMG;
    if(userIMG)
    {
        
    }
    else
    {
        self.iconError.hidden = YES;
        [self.labError mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.mas_centerX);
            make.centerY.equalTo(self.mas_centerY);

            make.width.equalTo(self.mas_width);
            make.height.equalTo(@(19));
        }];
        
    }
}


- (void)doErrAction
{
    SEL callBack = @selector(noDataViewHandle:);
    if([self.delegate respondsToSelector:callBack])
    {
        [self.delegate noDataViewHandle:self];
    }
}

#pragma mark -- getter
_GETTER_BEGIN(UIImageView, iconError)
{
    _iconError = [[UIImageView alloc]initWithImage:IMGGET(@"icon_point_blank.png")];
    [_iconError setUserInteractionEnabled:YES];
}
_GETTER_END(iconError)

_GETTER_BEGIN(UILabel, labError)
{
    _CREATE_LABEL(_labError, CGRectZero, 12);
    _labError.numberOfLines = 0;
    [_labError setTextAlignment:ALIGN_CENTER];
    [_labError setTextColor:[SSIMSpUtil getColor:@"9c9c9c"]];
    [_labError setText:@"xxxx"];
}
_GETTER_END(labError)


@end
