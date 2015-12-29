//
//  BTSelectPhotosViewController.m
//  BeautifulTimes
//
//  Created by deng on 15/11/22.
//  Copyright © 2015年 dengyonghao. All rights reserved.
//

#import "BTSelectPhotosViewController.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import "BTAlbumCollectionViewCell.h"

static  NSString *kcellIdentifier = @"kSelectPhotosCollectionCellID";
static int const showNumber = 3;

@interface BTSelectPhotosViewController () <UINavigationControllerDelegate, UIImagePickerControllerDelegate, UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic, strong) UIImagePickerController *picker;
@property (nonatomic, copy) NSString *chosenMediaType;
@property (nonatomic, strong) UIButton *usePhoto;
@property (nonatomic, strong) UIButton *useCamera;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSArray *dataSource;

@end

@implementation BTSelectPhotosViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.titleLabel.text = @"添加照片";
    [self.finishButton setTitle:@"完成" forState:UIControlStateNormal];
    [self.bodyView addSubview:self.collectionView];
    [self.bodyView addSubview:self.usePhoto];
    [self.bodyView addSubview:self.useCamera];
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    WS(weakSelf);
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        
    }];
    
    [self.usePhoto mas_makeConstraints:^(MASConstraintMaker *make) {
        
    }];
    
    [self.useCamera mas_makeConstraints:^(MASConstraintMaker *make) {
        
    }];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.collectionView registerClass:[BTAlbumCollectionViewCell class] forCellWithReuseIdentifier:kcellIdentifier];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)finishButtonClick {

}

- (void)usePhotoClick {
    [self shootPiicturePrVideo];
}

- (void)useCameraClick {
    [self selectExistingPictureOrVideo];
}

#pragma  mark- 拍照模块
//从相机上选择
-(void)shootPiicturePrVideo{
    [self getMediaFromSource:UIImagePickerControllerSourceTypeCamera];
}
//从相册中选择
-(void)selectExistingPictureOrVideo{
//    [self getMediaFromSource:UIImagePickerControllerSourceTypePhotoLibrary];
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
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:nil message:@"当前设备不支持拍摄功能" delegate:nil cancelButtonTitle:@"确认" otherButtonTitles: nil];
        [alert show];
    }
}

#pragma mark - UICollectionView delegate
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    if (self.dataSource.count % showNumber == 0) {
        return self.dataSource.count / showNumber;
    }
    
    return self.dataSource.count / showNumber + 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (self.dataSource.count % showNumber != 0) {
        if (section == self.dataSource.count / showNumber) {
            return self.dataSource.count % showNumber;
        }
    }
    
    return showNumber;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(100, 100);
    
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
        return nil;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
   
}

//定义UICollectionView 的 margin
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0, 0, 0, 0);
}

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.minimumLineSpacing = 0;
        layout.minimumInteritemSpacing = 0;
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView.backgroundColor = [UIColor clearColor];
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
    }
    return _collectionView;
}

- (NSArray *)dataSource
{
    if (!_dataSource) {
        _dataSource = [[NSArray alloc] init];
    }
    return _dataSource;
}

- (UIImagePickerController *)picker {
    if (!_picker) {
        _picker = [[UIImagePickerController alloc] init];
        _picker.delegate = self;
    }
    return _picker;
}

-(UIButton *)usePhoto {
    if (!_usePhoto) {
        _usePhoto = [[UIButton alloc] init];
        [_usePhoto setTitle:@"从相册中选择" forState:UIControlStateNormal];
        [_usePhoto addTarget:self action:@selector(usePhotoClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _usePhoto;
}

-(UIButton *)useCamera {
    if (!_useCamera) {
        _useCamera = [[UIButton alloc] init];
        [_useCamera setTitle:@"拍照" forState:UIControlStateNormal];
        [_useCamera addTarget:self action:@selector(useCameraClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _useCamera;
}

@end
