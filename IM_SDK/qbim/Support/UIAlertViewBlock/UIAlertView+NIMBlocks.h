//
//  UIAlertView+NIMBlocks.h
//  Shibui
//
//  Created by Jiva DeVoe on 12/28/10.
//  Copyright 2010 Random Ideas, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NIMRIButtonItem.h"

@interface UIAlertView (NIMBlocks)

-(id)initWithNimTitle:(NSString *)inTitle message:(NSString *)inMessage cancelButtonItem:(NIMRIButtonItem *)inCancelButtonItem otherButtonItems:(NIMRIButtonItem *)inOtherButtonItems, ... NS_REQUIRES_NIL_TERMINATION;

- (NSInteger)nim_addButtonItem:(NIMRIButtonItem *)item;

- (void)nim_addCancelButtonItem:(NIMRIButtonItem *)inCancelButtonItem otherButtonItems:(NIMRIButtonItem *)inOtherButtonItems, ... NS_REQUIRES_NIL_TERMINATION;

@end
