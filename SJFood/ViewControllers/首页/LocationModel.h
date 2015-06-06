//
//  LocationModel.h
//  MyLocation
//
//  Created by niuyan on 15/6/3.
//  Copyright (c) 2015年 niuyan. All rights reserved.
//
#import "CoreLocation/CoreLocation.h"
#import <Foundation/Foundation.h>

@interface LocationModel : NSObject

@property (strong, nonatomic) NSString *LocationName;
@property (nonatomic, strong) CLLocation *LocationCoor;
@property(nonatomic,strong)NSString *Location;

@end
