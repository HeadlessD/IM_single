//
//  POI.h
//  QianbaoIM
//
//  Created by Yun on 14/9/12.
//  Copyright (c) 2014年 liu nian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>
@interface POI : NSObject<BMKAnnotation>
@property (nonatomic,readonly) CLLocationCoordinate2D coordinate;
@property (nonatomic,copy) NSString *subtitle;
@property (nonatomic,copy) NSString *title;

-(id)initWithCoords:(CLLocationCoordinate2D) coords;
@end
