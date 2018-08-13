//
//  NIMLoginViewController.h
//  QianbaoIM
//
//  Created by xuqing on 16/2/19.
//  Copyright © 2016年 qianbao.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NIMViewController.h"
#import "NIMBottomView.h"
#import "NIMCustomTextField.h"
#import "NIMLoginHistoryCell.h"
#import "NIMAccountsManager.h"


typedef NS_ENUM(NSInteger,ClickType){
    clicktypeNone,
    clicktypeUser,
    clicktypePass
};
typedef enum _LOGIN_TTPE
{
    LOGIN_DEFAULT,              //正常登录
    LOGIN_GETHANDCODE,          //忘记手势密码登录
    LOGIN_THIRD,                //第三方登录
    LOGIN_TOUCHID,              //TOUCHID 登录
}LOGIN_TYPE;

typedef NS_ENUM(NSInteger, NIM_LOGIN_TYPE) {
    NIM_LOGIN_TYPE_K             = 0,       //  开发登录
    NIM_LOGIN_TYPE_C             = 1,       //  测试登录
    NIM_LOGIN_TYPE_Y             = 2,       //  预发布登录
    NIM_LOGIN_TYPE_L             = 3,       //  线网登录

};

@class NIMLoginViewController;
@protocol NIMLoginViewControllerDelegate <NSObject>
//- (void)authLoginViewController:(NIMLoginViewController *)vc loginSuccess:(LOGIN_TYPE)loginType;
//- (void)authLoginViewDismissed;
@end

@interface NIMLoginViewController : NIMViewController<UICollectionViewDataSource,UICollectionViewDelegate,UITextFieldDelegate,NIMLoginHistoryCellDelegate>
@property (strong,nonatomic) NIMCustomTextField *userNameTextField;
@property (strong,nonatomic) NIMCustomTextField *PassWordTextField;
@property (strong,nonatomic) UIButton *arrowButton;
@property (strong,nonatomic) UIView *headView;
@property (strong,nonatomic) UIView *midView;
@property (strong,nonatomic) UIButton *forgetButton;
@property (strong,nonatomic) UIButton *kloginBtn;
@property (strong,nonatomic) UIButton *cloginBtn;
@property (strong,nonatomic) UIButton *yloginBtn;
@property (assign,nonatomic) NIM_LOGIN_TYPE nim_loginType;

@property (strong,nonatomic) UIButton *signBtn;
@property (strong,nonatomic) UIBarButtonItem *qb_closeBarButton;
@property (strong,nonatomic) UIButton *closeButton;
@property (nonatomic,assign) BOOL isshowBaoer;
@property (nonatomic,assign) BOOL showDropView;
@property (nonatomic,strong) UIImageView *iconImage;
@property (nonatomic,strong) UIImageView *userline;
@property (nonatomic,strong) UIImageView *passline;
//宝儿的手
@property (strong,nonatomic) UIImageView *lefthand;
@property (strong,nonatomic) UIImageView *righthand;
@property (strong,nonatomic) UIImageView* header;
@property (strong,nonatomic) NSMutableArray *accuntArr;
//宝儿的胳膊
@property (strong,nonatomic) UIImageView *lefthArm;
@property (strong,nonatomic) UIImageView *rightArm;
@property (assign,nonatomic) ClickType clicktype;

@property (strong,nonatomic) NIMBottomView *bottomView;
@property (strong,nonatomic) UICollectionView *dropDownView;
@property (strong,nonatomic) UIView *moveDownView;

@property (assign,nonatomic) int timeout;

@property (assign,nonatomic) LOGIN_TYPE          loginType;
@property (weak,nonatomic) id<NIMLoginViewControllerDelegate> delegate;
@property (nonatomic , copy) void(^loginOk)();

- (void)updateBottom;
- (void)showTouchID;
- (void)reShowTouchID;
- (void)qb_firstAuthVC;
-(void)qb_close;
- (void)loginWithName:(NSString*)username passwd:(NSString*)password fromRegister:(BOOL)fromRegister;

@end
