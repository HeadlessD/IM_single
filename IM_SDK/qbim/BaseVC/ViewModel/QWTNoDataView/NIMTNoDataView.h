//
//  NIMTNoDataView.h
//  QianbaoIM
//
//  Created by liyan on 10/12/14.
//  Copyright (c) 2014 liu nian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NIMConstHeader.h"
@class NIMTNoDataView;
@protocol NIMTNoDataViewDelegate <NSObject>

@optional
- (void)noDataViewHandle:(NIMTNoDataView*)sender;

@end
@interface NIMTNoDataView : UIView
_PROPERTY_NONATOMIC_RETAIN(UIImageView,    iconError);
_PROPERTY_NONATOMIC_RETAIN(UILabel,        labError);
_PROPERTY_NONATOMIC_ASSIGN(BOOL,           userIMG);
_PROPERTY_NONATOMIC_ASSIGN(id<NIMTNoDataViewDelegate>, delegate);
@end
