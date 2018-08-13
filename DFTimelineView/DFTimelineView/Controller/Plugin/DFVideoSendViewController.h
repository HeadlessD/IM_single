//
//  DFVideoSendViewController.h
//  IM_single
//
//  Created by Zhang jiyong on 2018/5/11.
//  Copyright © 2018年 豆凯强. All rights reserved.
//

#import <DFCommon/DFCommon.h>
#import "DFVideoLineItem.h"

@protocol DFVideoSendViewControllerDelegate <NSObject>

@optional

-(void) onSendTextVideoItem:(DFVideoLineItem *)item;


@end
@interface DFVideoSendViewController : DFBaseViewController
@property (nonatomic, weak) id<DFVideoSendViewControllerDelegate> delegate;
@property (nonatomic, strong) NSString *localPath;
@property (nonatomic, strong) UIImage *screenShot;

@end
