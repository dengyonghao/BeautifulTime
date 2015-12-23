//
//  BTSelectPhotosViewController.m
//  BeautifulTimes
//
//  Created by deng on 15/11/22.
//  Copyright © 2015年 dengyonghao. All rights reserved.
//

#import "BTSelectPhotosViewController.h"
#import <MobileCoreServices/MobileCoreServices.h>

@interface BTSelectPhotosViewController () <UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@property (nonatomic, strong) UIImagePickerController *picker;
@property(nonatomic,copy) NSString *chosenMediaType;

@end

@implementation BTSelectPhotosViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.titleLabel.text = @"添加照片";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)selectPhotoSource{
    UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"请选择图片来源" message:@"" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"拍照",@"从手机相册选择", nil];
    [alert show];
}

#pragma 拍照选择模块
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(buttonIndex==1)
        [self shootPiicturePrVideo];
    else if(buttonIndex==2)
        [self selectExistingPictureOrVideo];
}

#pragma  mark- 拍照模块
//从相机上选择
-(void)shootPiicturePrVideo{
    [self getMediaFromSource:UIImagePickerControllerSourceTypeCamera];
}
//从相册中选择
-(void)selectExistingPictureOrVideo{
    [self getMediaFromSource:UIImagePickerControllerSourceTypePhotoLibrary];
}

#pragma 拍照模块
-(void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    self.chosenMediaType=[info objectForKey:UIImagePickerControllerMediaType];
    if([self.chosenMediaType isEqual:(NSString *) kUTTypeImage]){
        UIImage *chosenImage=[info objectForKey:UIImagePickerControllerOriginalImage];
        
        
    }
    if([self.chosenMediaType isEqual:(NSString *) kUTTypeMovie]){
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"提示信息!" message:@"系统只支持图片格式" delegate:nil cancelButtonTitle:@"确认" otherButtonTitles: nil];
        [alert show];
        
    }
    [picker dismissViewControllerAnimated:YES completion:^{
        
    }];
}
-(void) imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [picker dismissViewControllerAnimated:YES completion:^{
        
    }];
}
-(void)getMediaFromSource:(UIImagePickerControllerSourceType)sourceType{
    NSArray *mediatypes = [UIImagePickerController availableMediaTypesForSourceType:sourceType];
    if([UIImagePickerController isSourceTypeAvailable:sourceType] &&[mediatypes count]>0){
        NSArray *mediatypes = [UIImagePickerController availableMediaTypesForSourceType:sourceType];
        self.picker.mediaTypes = mediatypes;
        self.picker.sourceType = sourceType;
        NSString *requiredmediatype = (NSString *)kUTTypeImage;
        NSArray *arrmediatypes = [NSArray arrayWithObject:requiredmediatype];
        [self.picker setMediaTypes:arrmediatypes];
        [self presentViewController:self.picker animated:YES completion:^{
            
        }];
    }
    else{
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"错误信息!" message:@"当前设备不支持拍摄功能" delegate:nil cancelButtonTitle:@"确认" otherButtonTitles: nil];
        [alert show];
    }
}

- (UIImagePickerController *)picker {
    if (!_picker) {
        _picker = [[UIImagePickerController alloc] init];
        _picker.delegate = self;
    }
    return _picker;
}

@end
