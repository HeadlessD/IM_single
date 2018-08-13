//
//  NIMChatMediaView.h
//  QianbaoIM
//
//  Created by liyan on 14-3-31.
//  Copyright (c) 2014年 liu nian. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kChatMediaViewW        320
#define kChatMediaViewH        216

typedef enum {
    ChatMediaTypeNone       = 0,
    ChatMediaTypeExpression = 1000, // 表情
    ChatMediaTypeCamera,            // 相机、拍照
    ChatMediaTypeImage,             // 照片（本地）
    ChatMediaTypeLocation,          // 位置，定位功能
    ChatMediaTypeVideo,             // 视屏
    ChatMediaTypeVCard,             // 名片、联系人信息
    ChatMediaTypeBlessWord,         // 祝福短语
    ChatMediaTypePowerPoint,        // 幻灯片
    ChatMediaTypeFavorites,         // 收藏
    ChatMediaTypeRedMoney,           // 发红包
    ChatMediaTypeOrder              // 发订单

}ChatMediaType;

@class NIMChatMediaView;

@protocol ChatMediaViewDelegate <NSObject>

@optional
- (void)ChatMediaView:(NIMChatMediaView *)chatView buttonBeenClicked:(ChatMediaType)type;

@end


@interface NIMChatMediaView : UIView {
    CGPoint lastPoint;
    BOOL isdrag;
}
//是否处在subView页面
@property (nonatomic, assign) ChatMediaType isSubView;
-(void)resetUIWithChatUIType:(NSInteger)chatUIType;

@property (nonatomic, assign) id <ChatMediaViewDelegate> delegate;

@end
