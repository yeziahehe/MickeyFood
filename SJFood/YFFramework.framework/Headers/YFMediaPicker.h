//
//  YFMediaPicker.h
//  SJFood
//
//  Created by 叶帆 on 14/12/10.
//  Copyright (c) 2014年 Ye Fan. All rights reserved.
//


/**
 用于管理设备的照片选择（拍照或者从相机选择）
 可以获取文件的信息
 */

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import <UIKit/UIKit.h>

typedef enum {
    kAllType = 0,
    kPhotoType,
    kMovieType
}FileType;

@protocol  YFMediaPickerDelegate;

@interface YFMediaPicker : NSObject<UINavigationControllerDelegate, UIImagePickerControllerDelegate,CLLocationManagerDelegate>

@property (nonatomic, assign) NSInteger tag;
@property (nonatomic, assign) BOOL showExtraInfo;       //是否获取media文件的详细信息，默认no
@property (nonatomic, assign) id<YFMediaPickerDelegate> delegate;
@property (nonatomic, assign) id parentController;      //基于parentController present picker
@property (nonatomic, assign) BOOL mediaEditing;        //media文件是否能编辑，默认no
@property (nonatomic, assign) FileType fileType;        //media文件的类型

//详细信息
@property (nonatomic, strong) CLLocation *fileLocation; //media文件的经纬度
@property (nonatomic, strong) NSDate *fileDate;         //media文件的日期
@property (nonatomic, copy) NSString *fileLocationName; //media文件的地址名称

//基本信息
@property (nonatomic, strong) NSData *fileData;         //media文件的二进制流数据
@property (nonatomic, strong) NSString *fileName;       //media文件的文件名 - 唯一识别名称

+ (YFMediaPicker *)sharedPicker;

/**
	打开摄像头拍照
 */
- (void)takePhotoWithCamera;

/**
	获取本地照片库文件
	@returns 如果是iphone设备直接显示照片库，如果是ipad设备，返回UIImagePickerController句柄，ipad照片库选择需要用popover展示
 */
- (UIImagePickerController *)getPhotoFromLibrary;

@end

@protocol YFMediaPickerDelegate <NSObject>
- (void)didGetFileWithData:(YFMediaPicker *)mediaPicker;
- (void)didGetFileFailedWithMessage:(NSString *)mes;
@end
