//
//  LocationViewController.m
//  SJFood
//
//  Created by 叶帆 on 15/5/31.
//  Copyright (c) 2015年 Ye Fan. All rights reserved.
//

//new year TODO

#import "LocationViewController.h"


@interface LocationViewController()
@property(nonatomic,strong)CLLocation *currLocation;
@property(nonatomic,strong)NSMutableArray *schoollocationarray;
@property(nonatomic,strong)NSMutableArray *locationnames;
@end
@implementation LocationViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTitle:@"校区选择"];
    [self AddrCoorInfo];
    [self setupLocationManager];
    [NSTimer scheduledTimerWithTimeInterval:0.1f target:self selector:@selector(CompareLocation) userInfo:nil repeats:NO];
    [[YFProgressHUD sharedProgressHUD] stoppedNetWorkActivity];
    self.locationtable.delegate = self;
    self.locationtable.dataSource = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
- (void) setupLocationManager {
    self.locationManager = [[CLLocationManager alloc] init];
    if ([CLLocationManager locationServicesEnabled]) {
        NSLog( @"Starting CLLocationManager" );
        self.locationManager.delegate = self;
        [self.locationManager requestAlwaysAuthorization];
        self.locationManager.distanceFilter = 200;
        self.locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters;
        [self.locationManager startUpdatingLocation];
    } else {
        NSLog( @"Cannot Starting CLLocationManager" );
    }
}


#pragma mark - CLLocationManagerDelegate
-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error{
    NSLog(@"定位失败： %@",error);
}
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)Locations{
    self.currLocation = [Locations lastObject];
    
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
#pragma mark - Dealdata Method

-(void)AddrCoorInfo{
    self.mindisLocation = [[LocationModel alloc]init];
    self.mindisLocation.LocationName = @"无";
    self.mindisLocation.LocationCoor = [[CLLocation alloc]initWithLatitude:10 longitude:10];
    
    self.locationXJD = [[LocationModel alloc]init];
    self.locationXJD.LocationName = @"西交利物浦大学";
    self.locationXJD.LocationCoor = [[CLLocation alloc]initWithLatitude:31.274672 longitude:120.738152];
    
    self.locationSDBB = [[LocationModel alloc]init];
    self.locationSDBB.LocationName = @"苏州大学本部";
    self.locationSDBB.LocationCoor = [[CLLocation alloc]initWithLatitude:31.303036 longitude:120.639560];
    
    self.locationSKD = [[LocationModel alloc]init];
    self.locationSKD.LocationName = @"苏州科技大学";
    self.locationSKD.LocationCoor = [[CLLocation alloc]initWithLatitude:31.300404 longitude:120.559416];
    
    self.schoollocationarray = [[NSMutableArray alloc]initWithObjects:self.locationXJD,self.locationSDBB,self.locationSKD, nil];
    
    self.locationnames = [[NSMutableArray alloc]initWithCapacity:10];
    int j;
    for (j=0; j<self.schoollocationarray.count; j++) {
        self.locationnames[j] = [self.schoollocationarray[j] LocationName];
    }
    
}
//比较当前位置与其他所有位置的距离，计算出最小的距离，将其所对应的数据保存
-(void)CompareLocation {
    double dis[10];
    double mindis;
    int i;
    for(i=0;i<self.schoollocationarray.count;i++){
        dis[i] = [self.currLocation distanceFromLocation:[self.schoollocationarray[i] LocationCoor] ];
        //        NSLog(@"%f",dis[i]);
    }
    mindis = dis[0];
    for(i=0;i<self.schoollocationarray.count;i++){
        if (mindis>=dis[i]) {
            mindis = dis[i];
            self.mindisLocation = self.schoollocationarray[i];
        }
    }
    //    NSLog(@"%@",self.mindisLocation.LocationName);
    //    NSLog(@"%@",self.mindisLocation.LocationCoor);
    self.showLocationLabel.text = [NSString stringWithFormat:@"%@",self.mindisLocation.LocationName];
}


#pragma tableview Method

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.locationtable reloadData];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.locationnames.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LocationIdentifier"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"LocationIdentifier"];
    }
    int i;
    for (i=0; i<self.schoollocationarray.count; i++) {
        self.locationnames[i] = [self.schoollocationarray[i] LocationName];
    }
    cell.textLabel.text = [self.locationnames objectAtIndex:[indexPath row]];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *rowstring = [self.locationnames objectAtIndex:[indexPath row]];
    self.showLocationLabel.text = [NSString stringWithFormat:@"%@",rowstring];
    [[NSNotificationCenter defaultCenter]postNotificationName:kSelectChooseLocationNotification object: rowstring];
    [self.navigationController popViewControllerAnimated:YES];
}
@end
