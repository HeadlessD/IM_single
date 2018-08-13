//
//  NIMMessageNotifyVC.m
//  QBNIMClient
//
//  Created by 秦雨 on 17/7/29.
//  Copyright © 2017年 秦雨. All rights reserved.
//

#import "NIMMessageNotifyVC.h"

@interface NIMMessageNotifyVC ()
@property (unsafe_unretained, nonatomic) IBOutlet UISwitch *soundSwitch;
@property (unsafe_unretained, nonatomic) IBOutlet UISwitch *shockSwitch;

@property (unsafe_unretained, nonatomic) IBOutlet UISwitch *earSwitch;


@property (nonatomic,assign)NIM_MESSAGE_MODE mode;
@end

@implementation NIMMessageNotifyVC


-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:YES];
//    [self.tableView setFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - IPX_NAVI_H - IPX_BOTTOM_SAFE_H)];
}

//-(void)viewWillLayoutSubviews{
//    [super viewWillLayoutSubviews];
//    if (KIsiPhoneX) {
//        [self.tableView setFrame:CGRectMake(0, 88, SCREEN_WIDTH, SCREEN_HEIGHT-118)];
//    }
//}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NIM_MESSAGE_MODE m_medo =  [getObjectFromUserDefault(KEY_Message_Mode) integerValue];
    
    BOOL isSound = YES;
    BOOL isShock = NO;
    
    switch (m_medo) {
        case MESSAGE_MODE_SOUND:
        {
            isSound = YES;
            isShock = NO;
        }
            break;
        case MESSAGE_MODE_SHOCK:
        {
            isSound = NO;
            isShock = YES;
        }
            break;
        case MESSAGE_MODE_BOTH:
        {
            isSound = YES;
            isShock = YES;
        }
            break;
        case MESSAGE_MODE_NONE:
        {
            isSound = NO;
            isShock = NO;
        }
            break;
            
        default:
            break;
    }
    
    self.soundSwitch.on = isSound;
    self.shockSwitch.on = isShock;
    BOOL isEarphone =  [getObjectFromUserDefault(KEY_Earphone) boolValue];
    self.earSwitch.on = isEarphone;
    
    self.view.backgroundColor = [SSIMSpUtil getColor:@"F1F1F1"];
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 0.01;
    }
    return 15;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}


- (IBAction)switchSound:(UISwitch *)sender {
    switch (self.shockSwitch.on) {
        case YES:
        {
            switch (sender.on) {
                case YES:
                    _mode = MESSAGE_MODE_BOTH;
                    break;
                case NO:
                    _mode = MESSAGE_MODE_SHOCK;
                    break;
                    
                default:
                    break;
            }
        }
            break;
            
        case NO:
        {
            switch (sender.on) {
                case YES:
                    _mode = MESSAGE_MODE_SOUND;
                    break;
                case NO:
                    _mode = MESSAGE_MODE_NONE;
                    break;
                    
                default:
                    break;
            }
        }
            break;
            
        default:
            break;
    }
    
    NIM_MESSAGE_MODE m_medo =  [getObjectFromUserDefault(KEY_Message_Mode) integerValue];
    if (m_medo != _mode) {
        setObjectToUserDefault(KEY_Message_Mode, @(_mode));
    }
    
    
}

- (IBAction)switchShock:(id)sender {
    
    UISwitch *switchBtn = sender;
    switch (self.soundSwitch.on) {
        case YES:
        {
            switch (switchBtn.on) {
                case YES:
                    _mode = MESSAGE_MODE_BOTH;
                    break;
                case NO:
                    _mode = MESSAGE_MODE_SOUND;
                    break;
                    
                default:
                    break;
            }
        }
            break;
            
        case NO:
        {
            switch (switchBtn.on) {
                case YES:
                    _mode = MESSAGE_MODE_SHOCK;
                    break;
                case NO:
                    _mode = MESSAGE_MODE_NONE;
                    break;
                    
                default:
                    break;
            }
        }
            break;
            
        default:
            break;
    }
    
    NIM_MESSAGE_MODE m_medo =  [getObjectFromUserDefault(KEY_Message_Mode) integerValue];
    if (m_medo != _mode) {
        setObjectToUserDefault(KEY_Message_Mode, @(_mode));
    }
}

- (IBAction)switchEar:(UISwitch *)sender {
    
    BOOL isEarphone =  [getObjectFromUserDefault(KEY_Earphone) boolValue];
    if (sender.on!=isEarphone) {
        setObjectToUserDefault(KEY_Earphone, @(sender.on));
    }
    
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
