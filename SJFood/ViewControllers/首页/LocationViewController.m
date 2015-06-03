//
//  LocationViewController.m
//  SJFood
//
//  Created by 叶帆 on 15/5/31.
//  Copyright (c) 2015年 Ye Fan. All rights reserved.
//

//new year TODO

#import "LocationViewController.h"

@interface LocationViewController (){
    double currentDistance;
    
}
@property (nonatomic,strong)CLLocationManager* locationManager;
- (IBAction)fuckbutton:(id)sender;
@property (nonatomic,strong)CLLocation *currentcoordinates;
@end

@implementation LocationViewController
@synthesize locationManager;
@synthesize currentcoordinates;
- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


-(void) setupLocationManager{
    self.locationManager = [[CLLocationManager alloc]init];
    if ([CLLocationManager locationServicesEnabled]) {
        NSLog(@"Starting CLLocationManager");
        self.locationManager.delegate = self;
        [self.locationManager requestAlwaysAuthorization];
        self.locationManager.distanceFilter = 200;
        self.locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters;
        [self.locationManager startUpdatingLocation];
    }else{
        NSLog(@"Cannot Starting CLLocationManaer");
    }
}
//
//-(double)distanceBetweenOrderBy:(CLLocation *)currentLocation : (CLLocation *)destinateLocation{
//    double distance = [currentLocation distanceFromLocation:destinateLocation];
//    return distance;
//}

#pragma mark - CLLocationManagerDelegate
-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error{
    NSLog(@"定位失败： %@",error);
}
- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation
           fromLocation:(CLLocation *)oldLocation {
    self.currentcoordinates = newLocation;
    NSLog(@"%f,%f",self.currentcoordinates.coordinate.latitude,self.currentcoordinates.coordinate.longitude);
//    currentDistance = [self distanceBetweenOrderBy:newLocation :oldLocation];
//    NSLog(@"%f",currentDistance);
}

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
    switch (status) {
        case kCLAuthorizationStatusNotDetermined:
            if ([self.locationManager respondsToSelector:@selector(requestAlwaysAuthorization)]) {
                [self.locationManager requestWhenInUseAuthorization];
            }break;
        default:
            break;
    }
}
- (IBAction)fuckbutton:(id)sender {
    [self setupLocationManager];
}
@end
