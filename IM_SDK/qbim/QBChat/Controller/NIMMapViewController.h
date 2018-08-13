//
//  NIMMapViewController.h
//  QianbaoIM
//
//  Created by liu nian on 14-4-3.
//  Copyright (c) 2014年 liu nian. All rights reserved.
//

#import "NIMViewController.h"


@protocol NIMMapViewControllerDelegate;

@interface NIMMapViewController : NIMViewController<BMKMapViewDelegate,BMKLocationServiceDelegate,BMKGeoCodeSearchDelegate>
{
    BMKLocationService* _locService;
    BMKGeoCodeSearch *_geoCodeSearch;
    BMKReverseGeoCodeOption *reverseGeoCodeOption;
}
@property (strong, nonatomic) IBOutlet BMKMapView *mapView;


@property (nonatomic, strong) id<NIMMapViewControllerDelegate> delegate;
@property (nonatomic, strong) NSString *placemark;
@property (nonatomic, strong) CLGeocoder *geocoder;
@property (nonatomic) BOOL willSendLocation;
@property (nonatomic) CLLocationCoordinate2D address2D;
@property (nonatomic,strong) NSString *address;
@property (nonatomic, strong) NSDictionary *record;
//@property (nonatomic,strong) IBOutlet
//@property (nonatomic, strong) MKPlacemark *placemark;
@end

@protocol NIMMapViewControllerDelegate <NSObject>

@optional
- (void)NIMMapViewController:(NIMMapViewController *)viewController didSendLocation:(NSDictionary*)location;

@end
