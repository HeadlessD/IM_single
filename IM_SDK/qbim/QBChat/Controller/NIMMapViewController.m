//
//  NIMMapViewController.m
//  QianbaoIM
//
//  Created by liu nian on 14-4-3.
//  Copyright (c) 2014年 liu nian. All rights reserved.
//  聊天选择地址界面

#import "NIMMapViewController.h"
#import <CoreLocation/CoreLocation.h>
#import "POI.h"
#import <AVFoundation/AVFoundation.h>


@interface NIMMapViewController ()<MKMapViewDelegate,CLLocationManagerDelegate>
@property (nonatomic,strong) CLLocationManager *manager;
@property (nonatomic,strong) BMKUserLocation *userlocation;
@property (nonatomic,strong) UIImageView* centerImgView;
@property (nonatomic,strong) UILabel* localL;

@end

@implementation NIMMapViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    _geoCodeSearch = [[BMKGeoCodeSearch alloc]init];
    _geoCodeSearch.delegate = self;
    //初始化逆地理编码类
    reverseGeoCodeOption= [[BMKReverseGeoCodeOption alloc] init];
    
    self.mapView.frame = self.view.frame;
    _locService =[[BMKLocationService alloc]init];
    _mapView.delegate = self; // 此处记得不用的时候需要置nil，否则影响内存的释放
    _locService.delegate = self;
    [_locService startUserLocationService];
    _mapView.showsUserLocation = NO;//先关闭显示的定位图层
    _mapView.userTrackingMode = BMKUserTrackingModeNone;//设置定位的状态
    _mapView.showsUserLocation = YES;//显示定位图层
    [self.navigationItem.rightBarButtonItem setEnabled:NO];
    [self.view addSubview:self.centerImgView];
    [self.view addSubview:self.localL];
    
    [self.localL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.view.mas_leading).with.offset(0);
        make.bottom.equalTo(self.view.mas_bottom).with.offset(0);
        make.trailing.equalTo(self.view.mas_trailing).with.offset(0);
        make.height.equalTo(@40);
    }];
    
    [self qb_setTitleText:@"位置"];
    if (self.willSendLocation) {
        //发地址
        if (![CLLocationManager locationServicesEnabled])
        {
            UIAlertController *alertController= [UIAlertController alertControllerWithTitle:@"提示" message:@"请在设备的\"设置-隐私-定位服务\"中打开定位服务。" preferredStyle: UIAlertControllerStyleAlert];
            
            UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [self dismissViewControllerAnimated:YES completion:nil];
            }];
            [alertController addAction:action];
            [self presentViewController:alertController animated:YES completion:nil];

            return;
        }
        [self qb_showRightButton:@"发送"];
       
    }else{
        //显示收到的地址
        NSString *address =PUGetObjFromDict(@"address", self.record, [NSString class]);
        if (!IsStrEmpty(address)) {
            [self qb_setTitleText:[address substringToIndex:6]];
        }
        [self qb_showRightButton:@"我的位置"];
        CLLocationDegrees lng=[self.record[@"lng"] doubleValue];
        CLLocationDegrees lat=[self.record[@"lat"] doubleValue];
        self.address2D = CLLocationCoordinate2DMake(lat, lng);
    }
}
-(void)qb_back
{
    [self.navigationController dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (void)qb_rightButtonAction{
    if (self.willSendLocation)
    {
        [self sendLocaltion];
    }
    else
    {
        [self showMyLocation];
    }
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.translucent = YES;
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    _mapView.delegate = nil;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if (!self.willSendLocation) {
        if (CLLocationCoordinate2DIsValid(self.address2D)) {
            BMKCoordinateRegion to2D=BMKCoordinateRegionMakeWithDistance(self.address2D, 3000, 3000);
            [self.mapView setCenterCoordinate:self.address2D animated:YES];
            [self.mapView setRegion:to2D animated:YES];
        }else{
            UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"提示" message:@"地址无效" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
        }
        
    }else{
    }
}
- (void)showMyLocation
{
    self.mapView.showsUserLocation = NO;//先关闭显示的定位图层
    self.mapView.userTrackingMode = BMKUserTrackingModeNone;//设置定位的状态
    self.mapView.showsUserLocation = YES;//显示定位图层
    BMKCoordinateRegion region;
    
    region.center.latitude  = self.userlocation.location.coordinate.latitude;
    region.center.longitude = self.userlocation.location.coordinate.longitude;
    region.span.latitudeDelta  = 0.03;
    region.span.longitudeDelta = 0.03;
    [self.mapView setCenterCoordinate:self.userlocation.location.coordinate animated:YES];
    [self.mapView setRegion:region animated:YES];
    
    
}
//- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
//{
////    static dispatch_once_t centerMapFirstTime;
//    MKCoordinateRegion to2D;
//    if ((userLocation.coordinate.latitude != 0.0) && (userLocation.coordinate.longitude != 0.0)) {
//        
//        if (self.willSendLocation) {
//            to2D=MKCoordinateRegionMakeWithDistance(userLocation.location.coordinate, 0.03, 0.03);
//            
//        }else{
//            MKCoordinateSpan span = MKCoordinateSpanMake(0.03, 0.03);
//            to2D = MKCoordinateRegionMake(self.address2D, span);
//        }
//        [self.map setRegion:to2D animated:YES];
//    }
//    
//    // Lookup the information for the current location of the user.
//    [self.geocoder reverseGeocodeLocation:self.map.userLocation.location completionHandler:^(NSArray *placemarks, NSError *error) {
//        if ((placemarks != nil) && (placemarks.count > 0)) {
//            // If the placemark is not nil then we have at least one placemark. Typically there will only be one.
//            _placemark = [placemarks objectAtIndex:0];
//            
//            // we have received our current location, so enable the "Get Current Address" button
//            //[self.getAddressButton setEnabled:YES];
//            if (self.willSendLocation) {
//                [self.navigationItem.rightBarButtonItem setEnabled:YES];
//            }
//            
//            NSString *address=[self getAddressWithPlaceMark:_placemark];
//            CLLocationCoordinate2D userLocation=self.map.userLocation.location.coordinate;
//            if(address.length != 0 && (userLocation.latitude!=0.0 && userLocation.longitude!=0.0))
//            {
//                
//                POI* poi = [[POI alloc] initWithCoords:CLLocationCoordinate2DMake(userLocation.latitude, userLocation.longitude)];
//                poi.title = @"位置";
//                poi.subtitle = address;
////                [self.map addAnnotation:poi];
//            }
//        }
//        else {
//            // Handle the nil case if necessary.
//        }
//    }];
//}
-(void)didFailToLocateUserWithError:(NSError *)error
{
    NSString* s = [NSString stringWithFormat:@"%@",error];
    //[s containsString:@"Code=1"]
    if([SSIMSpUtil stringA:s containString:@"Code=1"]){
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请在设备的\"设置-隐私-定位服务\"中打开定位服务。" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alert show];
        return;
    }
    [MBTip showError:@"定位失败" toView:self.view];
}

/**
 *用户位置更新后，会调用此函数
 *@param userLocation 新的用户位置
 */


-(void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation
{
    if ((userLocation.location.coordinate.latitude != 0.0) && (userLocation.location.coordinate.longitude != 0.0))
    {
        BMKCoordinateRegion region;
        if (self.willSendLocation) {
            
            region.center.latitude  = userLocation.location.coordinate.latitude;
            region.center.longitude = userLocation.location.coordinate.longitude;
            region.span.latitudeDelta  = 0.03;
            region.span.longitudeDelta = 0.03;
            [self.mapView setCenterCoordinate:userLocation.location.coordinate animated:YES];
            [self.mapView setRegion:region animated:YES];
            if (self.willSendLocation) {
                if (self.mapView.annotations.count>0) {
                    [self.mapView removeAnnotations:self.mapView.annotations];
                }
                CLLocationDegrees lng=userLocation.location.coordinate.longitude;
                CLLocationDegrees lat=userLocation.location.coordinate.latitude;
                self.address2D = CLLocationCoordinate2DMake(lat, lng);
            }
            
        }
        else
        {
        }
    }
    self.userlocation = userLocation;
    [_mapView updateLocationData:userLocation];
    [_locService stopUserLocationService];
    
    //需要逆地理编码的坐标位置
    reverseGeoCodeOption.reverseGeoPoint = userLocation.location.coordinate;
    [_geoCodeSearch reverseGeoCode:reverseGeoCodeOption];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)sendLocaltion{
    if (_delegate && [_delegate respondsToSelector:@selector(NIMMapViewController:didSendLocation:)]) {
        
        NSString *address=self.placemark;
        CLLocationCoordinate2D userLocation=self.address2D;
        if(address.length == 0 || (userLocation.latitude==0.0 && userLocation.longitude==0.0))
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                [MBTip showError:@"地址获取失败，请重新获取" toView:self.view];
            });
            return;
        }
        NSDictionary* dic = [NSDictionary dictionaryWithObjects:@[address,[NSNumber numberWithDouble: userLocation.longitude],[NSNumber numberWithDouble: userLocation.latitude]] forKeys:@[@"address",@"lng",@"lat"]];
        [_delegate NIMMapViewController:self didSendLocation:dic];
    }
    [self.navigationController dismissViewControllerAnimated:YES completion:^{
        
    }];
}
- (NSString*)getAddressWithPlaceMark:(MKPlacemark*)mark
{
    NSDictionary* dic = mark.addressDictionary;
    if(dic)
    {
        NSString* name = dic[@"Name"];
        NSArray* tmp = dic[@"FormattedAddressLines"];
        NSString* address = nil;
        if(tmp)
            address = tmp.firstObject;
        if(name)
        {
            return [NSString stringWithFormat:@"%@ %@",name,address];
        }
        return address;
    }
    return nil;
}


//- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation
//{
//    if([annotation isKindOfClass:[MKUserLocation class]])
//    {
//        
//        MKUserLocation *location = annotation;
//        DBLog(@"%@",location.title);
//        return nil;
//    }
//    MKPinAnnotationView *pinView = nil;
//    static NSString *defaultPinID = @"com.invasivecode.pin";
//    pinView = (MKPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:defaultPinID];
//    if ( pinView == nil )
//        pinView = [[MKPinAnnotationView alloc]
//                   initWithAnnotation:annotation reuseIdentifier:defaultPinID];
//    pinView.pinColor = MKPinAnnotationColorGreen;
//    pinView.canShowCallout = YES;
//    pinView.animatesDrop = YES;
//    return pinView;
//}

- (BMKAnnotationView *)mapView:(BMKMapView *)mapView viewForAnnotation:(id <BMKAnnotation>)annotation
{
    if([annotation isKindOfClass:[BMKUserLocation class]])
    {
        
        BMKUserLocation *location = annotation;
        DBLog(@"%@",location.title);
        return nil;
    }
    BMKPinAnnotationView *pinView = nil;
    static NSString *defaultPinID = @"com.invasivecode.pin";
    pinView = (BMKPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:defaultPinID];
    if ( pinView == nil )
        pinView = [[BMKPinAnnotationView alloc]initWithAnnotation:annotation reuseIdentifier:defaultPinID];
    pinView.pinColor =BMKPinAnnotationColorGreen;
    pinView.canShowCallout = YES;
    pinView.animatesDrop = YES;
    return pinView;

}

- (void)mapView:(BMKMapView *)mapView regionDidChangeAnimated:(BOOL)animated{
    NSLog(@"regionDidChangeAnimated");
    
    
    CGPoint touchPoint = mapView.center;
    
    CLLocationCoordinate2D touchMapCoordinate =
    [self.mapView convertPoint:touchPoint toCoordinateFromView:self.mapView];//这里touchMapCoordinate就是该点的经纬度了
    NSLog(@"touching %f,%f",touchMapCoordinate.latitude,touchMapCoordinate.longitude);
    reverseGeoCodeOption.reverseGeoPoint = touchMapCoordinate;
    [_geoCodeSearch reverseGeoCode:reverseGeoCodeOption];
}


- (void)onGetReverseGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKReverseGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error
{
    self.placemark = result.address;
    self.localL.text = self.placemark;
    if (self.willSendLocation) {
        CLLocationDegrees lng=result.location.longitude;
        CLLocationDegrees lat=result.location.latitude;
        self.address2D = CLLocationCoordinate2DMake(lat, lng);
//        if (self.mapView.annotations.count>0) {
//            [self.mapView removeAnnotations:self.mapView.annotations];
//        }
    }
}

-(UIImageView *)centerImgView
{
    if (!_centerImgView) {
        _centerImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
        _centerImgView.center = self.view.center;
        _centerImgView.image = IMGGET(@"icon_coordinates_01");
    }
    
    return _centerImgView;
}

-(UILabel *)localL
{
    if (!_localL) {
        _localL = [[UILabel alloc] init];
        _localL.textAlignment = NSTextAlignmentLeft;
        _localL.backgroundColor = [UIColor whiteColor];
    }
    return _localL;
}

@end
