//
//  LocationViewController.h
//  SJFood
//
//  Created by 叶帆 on 15/5/31.
//  Copyright (c) 2015年 Ye Fan. All rights reserved.
//

#import "BaseViewController.h"
#import <UIKit/UIKit.h>
#import "CoreLocation/CoreLocation.h"
#import "LocationModel.h"

@interface LocationViewController : BaseViewController<CLLocationManagerDelegate,UITableViewDataSource,UITableViewDelegate>


@property (strong, nonatomic) IBOutlet UILabel *showLocationLabel;
@property (strong, nonatomic) IBOutlet UITableView *locationtable;

@property (nonatomic,retain)CLLocationManager* locationManager;
@property(nonatomic,strong)LocationModel *mindisLocation;
@property(nonatomic,strong)LocationModel *locationXJD;
@property(nonatomic,strong)LocationModel *locationSDBB;
@property(nonatomic,strong)LocationModel *locationSKD;



@end