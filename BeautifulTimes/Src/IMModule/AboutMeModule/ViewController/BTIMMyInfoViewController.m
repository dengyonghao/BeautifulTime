//
//  BTIMMyInfoViewController.m
//  BeautifulTimes
//
//  Created by dengyonghao on 16/2/22.
//  Copyright © 2016年 dengyonghao. All rights reserved.
//

#import "BTIMMyInfoViewController.h"
#import "BTXMPPTool.h"
#import "BTUserInfoModel.h"
#import "BTIMNavViewController.h"
#import "BTIMEditUserInfoViewController.h"

@interface BTIMMyInfoViewController () <BTEditUserInfoViewDelegate, UIActionSheetDelegate, UINavigationControllerDelegate,  UIImagePickerControllerDelegate>

@property (weak, nonatomic)  UIImageView *headView;
@property (nonatomic,strong) NSMutableArray *allArr;  //里面存放的arr数组
@property (nonatomic,strong) NSMutableArray *oneArr;//里面存放第一组的用户信息
@property (nonatomic,strong) NSMutableArray *twoArr;//里面存放第二组的用户信息
@end

@implementation BTIMMyInfoViewController

-(instancetype)init
{
    self=[super initWithStyle:UITableViewStyleGrouped];
    if(self){
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"个人信息";
    self.tableView.contentInset = UIEdgeInsetsMake(15, 0, 0, 0);
    [self loadUserinfo];
}

-(void)loadUserinfo
{
    BTXMPPTool *tool = [BTXMPPTool sharedInstance];
    
    XMPPvCardTemp *temp = tool.vCard.myvCardTemp;

    NSData *data = temp.photo ? temp.photo : UIImageJPEGRepresentation(BT_LOADIMAGE(@"com_ic_defaultIcon"), 1.0);
    
    BTUserInfoModel *pro1 = [BTUserInfoModel profileWithImage:data name:@"头像"];
    
    NSString *nickName = temp.nickname ? temp.nickname : @"未设置";
    BTUserInfoModel *pro2 = [BTUserInfoModel profileWithInfo:nickName infoType:UserNickName name:@"昵称"];
    
    NSString *account = [[NSUserDefaults standardUserDefaults] valueForKey:userID];
    BTUserInfoModel *pro3 = [BTUserInfoModel profileWithInfo:account infoType:UserWeixinNum name:@"私语号"];
    //添加到第一个数组中
    [self.oneArr addObject:pro1];
    [self.oneArr addObject:pro2];
    [self.oneArr addObject:pro3];
    [self.allArr addObject:_oneArr];
    
    //4.公司
    NSString *company = temp.orgName ? temp.orgName : @"未设置";
    BTUserInfoModel *pro4 = [BTUserInfoModel profileWithInfo:company infoType:UserCompany  name:@"公司"];
   
    //5.部门
    NSString *depart;
    if (temp.orgUnits.count > 0) {
        depart = temp.orgUnits[0];
    }
    depart = depart ? depart : @"未设置";
    BTUserInfoModel *pro5 = [BTUserInfoModel profileWithInfo:depart infoType:UserDepartment  name:@"部门"];
    //6.职位
    NSString *worker = temp.title ? temp.title : @"未设置";
    BTUserInfoModel *pro6 = [BTUserInfoModel profileWithInfo:worker infoType:UserWorker name:@"职位"];
    
    //7.电话
    // myVCard.telecomsAddresses 这个get方法，没有对电子名片的xml数据进行解析
    // 使用note字段充当电话
    NSString *tel = temp.note ? temp.note : @"未设置";
    BTUserInfoModel *pro7 = [BTUserInfoModel profileWithInfo:tel infoType:UserTel name:@"电话"];
    //7.邮件
    // 用mailer充当邮件
    NSString *email = temp.mailer ? temp.mailer : @"未设置";
    BTUserInfoModel *pro8 = [BTUserInfoModel profileWithInfo:email infoType:UserEmail name:@"邮箱"];
    [self.twoArr addObject:pro4];
    [self.twoArr addObject:pro5];
    [self.twoArr addObject:pro6];
    [self.twoArr addObject:pro7];
    [self.twoArr addObject:pro8];
    [self.allArr addObject:_twoArr];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.allArr.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    NSArray *arr=self.allArr[section];
    return arr.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"profileCell"];
    if(!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"profileCell"];
    }
    
    NSArray *arr = self.allArr[indexPath.section];
    BTUserInfoModel *profile = arr[indexPath.row];
    if(profile.image){
        UIImageView *imageV = [[UIImageView alloc]initWithImage:[UIImage imageWithData:profile.image]];
        imageV.frame = CGRectMake(0, 0, 50, 50);
        cell.accessoryView=imageV;
    }
    cell.textLabel.text = profile.name;
    cell.detailTextLabel.text = profile.info;
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

#pragma mark 设置单元格 的高度
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *arr = self.allArr[indexPath.section];
    BTUserInfoModel *profile = arr[indexPath.row];
    if(profile.image) {
        return 80;
    }
    return 44;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 2;
}
#pragma mark 单元格的点击事件
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *arr = self.allArr[indexPath.section];
    BTUserInfoModel *userInfo = arr[indexPath.row];
    //设置头像图片
    if(userInfo.image){
        UIActionSheet *sheet=[[UIActionSheet alloc]initWithTitle:@"选择图片" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"拍照" otherButtonTitles:@"从手机相册中选择", nil];
        [sheet showInView:self.view];
        
        return;
    }
    //不需要设置微信号
    if(userInfo.infoType==UserWeixinNum) return;
    
    BTIMEditUserInfoViewController *edit = [[BTIMEditUserInfoViewController alloc]init];
    edit.delegate=self;
    edit.indexPath=indexPath;
    if([userInfo.info isEqualToString:@"未设置"]){
        edit.str=nil;
    }else{
        edit.str=userInfo.info;
    }
    edit.title=userInfo.name;
    BTIMNavViewController *nav = [[BTIMNavViewController alloc] initWithRootViewController:edit];
    [self presentViewController:nav animated:YES completion:nil];
    
    
}
#pragma mark actionSheet的代理方法
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex==2) return;
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.delegate =self;
    imagePicker.allowsEditing = YES;
    [self presentViewController:imagePicker animated:YES completion:nil];
    
    switch (buttonIndex) {
        case 0: //拍照
        {
            imagePicker.sourceType=UIImagePickerControllerSourceTypeCamera;
        }
            break;
            
        case 1: //从相册中选择
        {
            imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        }
            break;
            
    }
}

#pragma mark 图片选择完成的方法
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *image=info[UIImagePickerControllerEditedImage];
    NSArray *arr=self.allArr[0];
    BTUserInfoModel *pro=arr[0];
    pro.image=UIImageJPEGRepresentation(image, 1.0);
    //保存头像图片的方法
    [self saveHeadImage:UIImageJPEGRepresentation(image, 0.7f)];
    
    //[self.tableView reloadData];
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark 保存头像图片的方法
-(void)saveHeadImage:(NSData*)data
{
    BTXMPPTool *tool = [BTXMPPTool sharedInstance];
    XMPPvCardTemp *temp = tool.vCard.myvCardTemp;
    temp.photo = data;
    
    NSArray *arr = self.allArr[0];
    BTUserInfoModel *userInfo = arr[0];
    userInfo.image = data;
    
    [self.tableView reloadData];
    
    [tool.vCard updateMyvCardTemp:temp];
    
    //发送通知
    NSNotification *note=[[NSNotification alloc]initWithName:@"changeHeadIcon" object:data userInfo:nil];
    [[NSNotificationCenter defaultCenter] postNotification:note];
    
}
#pragma mark 编辑控制器的代理方法
-(void)EditingFinshed:(BTIMEditUserInfoViewController *)edit indexPath:(NSIndexPath *)indexPath newInfo:(NSString *)newInfo
{
    NSArray *arr=self.allArr[indexPath.section];
    BTUserInfoModel *userInfo=arr[indexPath.row];
    userInfo.info=newInfo; //重新设置个人信息
    
    [self addProfileModel:userInfo newInfo:newInfo];
    
    [self.tableView reloadData];
}


-(void)addProfileModel:(BTUserInfoModel*)proModel newInfo:(NSString*)newInfo
{
    BTXMPPTool *app = [BTXMPPTool sharedInstance];
    XMPPvCardTemp *temp=app.vCard.myvCardTemp;
    NSLog(@"电子名片  %@",temp);
    switch (proModel.infoType) {
        case UserNickName:
            temp.nickname=newInfo;
            NSLog(@"nickna,e");
            break;
        case UserWeixinNum:
            //temp.uid=newInfo;
            //不需要操作
            break;
        case UserCompany:
            temp.orgName=newInfo;
            break;
        case UserDepartment:
        {
            if(newInfo.length>0){
                temp.orgUnits=@[newInfo];
            }
        }
            break;
        case UserWorker:
            temp.title=newInfo;
            break;
        case UserTel:
            temp.note=newInfo;
            break;
        case UserEmail:
            temp.mailer=newInfo;
            break;
    }
    [app.vCard updateMyvCardTemp:temp];
}

-(NSMutableArray *)allArr
{
    if(!_allArr){
        _allArr=[NSMutableArray array];
    }
    return _allArr;
}
-(NSMutableArray *)oneArr
{
    if(!_oneArr){
        _oneArr=[NSMutableArray array];
    }
    return _oneArr;
}
-(NSMutableArray *)twoArr
{
    if(!_twoArr){
        _twoArr=[NSMutableArray array];
    }
    return _twoArr;
}

@end
