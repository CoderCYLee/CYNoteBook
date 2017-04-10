//
//  LocationManager.m
//  TestNoteBook
//
//  Created by Cyrill on 2017/4/2.
//  Copyright © 2017年 Cyrill. All rights reserved.
//

#import "LocationManager.h"
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>

@interface LocationManager () <MKMapViewDelegate, CLLocationManagerDelegate>

@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, strong) MKMapView *mapView;
@property (strong, nonatomic) CLLocation *currentLocation;
@property (strong, nonatomic) NSString *currentCity;


@end

@implementation LocationManager

// Methods
+ (instancetype)shareInstance {
    
    static LocationManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[LocationManager alloc] init];
    });
    return manager;
}

- (instancetype)init
{
    self = [super init];
    if (!self) {
        return nil;
    }
    
    _locationManager = [[CLLocationManager alloc] init];
    //获取用户授权
    [_locationManager requestAlwaysAuthorization];
    
    //获取当前授权状态
    CLAuthorizationStatus status = [CLLocationManager authorizationStatus];
    if (status == kCLAuthorizationStatusAuthorizedAlways || status == kCLAuthorizationStatusAuthorizedWhenInUse) {
        NSLog(@"授权通过");
    } else {
        NSLog(@"授权不通过");
    }
    //设置代理
    _locationManager.delegate = self;
    //设置经度
    _locationManager.desiredAccuracy =kCLLocationAccuracyBest;
    
    return self;
}

- (void)findCurrentLocation {
    self.mapView.showsUserLocation = YES;
}

- (void)searchHintResultsWithKeyWord:(NSString *)keyWord {
    
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations {
    
    // NSLog(@"%@",locations);
    //取出位置信息
    CLLocation *location = [locations lastObject];
    
    [_locationManager stopUpdatingLocation];
    
    //创建地理信息编解码对象
    CLGeocoder *geoCoder = [[CLGeocoder alloc]init];
    
    //转换位置信息
    [geoCoder reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks, NSError *error) {
        //        NSLog(@"%@",placemarks[0]);
        CLPlacemark *placeMark = placemarks[0];
        NSLog(@"%@%@",placeMark.country,placeMark.locality);
        
        self.address = [NSString stringWithFormat:@"%@ %@ %@ %@ %@",placeMark.country,placeMark.locality,placeMark.subLocality, placeMark.thoroughfare, placeMark.subThoroughfare];
        
        self.addressBlock(self.address);
        
        NSLog(@"%@",self.address);
    }];
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    NSLog(@"%@",error);
}

- (void)startUpdatingLocation {
    
    self.address = @"";
    
    //开始定位
    [_locationManager startUpdatingLocation];
    
}

- (void)stopUpdatingLocation {
    //停止定位
    [_locationManager stopUpdatingLocation];
}

@end
