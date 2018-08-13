//
//  POI.m
//  QianbaoIM
//
//  Created by Yun on 14/9/12.
//  Copyright (c) 2014年 liu nian. All rights reserved.
//

#import "POI.h"

@implementation POI
- (id) initWithCoords:(CLLocationCoordinate2D) coords{
    
    self = [super init];
    
    if (self != nil) {
        
        _coordinate = coords;
        
    }
    
    return self;
}
@end
