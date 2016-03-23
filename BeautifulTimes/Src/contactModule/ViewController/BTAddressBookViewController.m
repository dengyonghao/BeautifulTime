//
//  BTAddressBookViewController.m
//  BeautifulTimes
//
//  Created by dengyonghao on 15/12/11.
//  Copyright © 2015年 dengyonghao. All rights reserved.
//

#import "BTAddressBookViewController.h"
#import "BTAddressBookManager.h"
#import "BTAddressBook.h"
#import "BTAdressBookCell.h"

static NSString *kAddressBookIndentifier = @"kAddressBookIndentifier";

@interface BTAddressBookViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic,strong) NSMutableArray *keys;//存放所有标示图分区的键
//定义一个字典的集合  用来存贮联系人名字拼音的首字母相同的人   一个键可以对应多个值
@property (strong,nonatomic)NSMutableDictionary *data;
//定义好友的键
@property (nonatomic,strong) NSMutableArray *otherKey;

@property (nonatomic, strong) UITableView *tableview;

@end

@implementation BTAddressBookViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.bodyView addSubview:self.tableview];
    self.titleLabel.text = @"选择联系人";
    [self devideContacter];
    self.tableview.sectionIndexColor = [UIColor grayColor];
    self.tableview.sectionIndexBackgroundColor = [UIColor clearColor];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    WS(weakSelf);
    [self.tableview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(weakSelf.bodyView).insets(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

-(void)dealloc
{

}

#pragma mark 通讯录分区
-(void)devideContacter
{
    [self.data removeAllObjects];
    [self.keys removeAllObjects];
    [self.otherKey removeAllObjects];
    NSMutableArray *array = [BTAddressBookManager getAddressBookData];
    for(BTAddressBook *user in array){
        

        NSString *firstName = [[user.name stringToPinyin] substringToIndex:1];
        firstName = [firstName uppercaseString];
        
        //获得key所对应的数据(数组)
        NSArray *arr = [self.data objectForKey:firstName];
        NSMutableArray *contacter; //临时数据
        //如果没有值
        if(arr == nil){
            contacter = [NSMutableArray arrayWithObject:user];
        }else{
            contacter = [NSMutableArray arrayWithArray:arr];
            [contacter addObject:user];
        }
        //设置字典的键和值
        [self.data setObject:contacter forKey:firstName];
        
    }
    //获得所有的键
    NSArray *key = [self.data allKeys];
    for(NSString *str in key){
        if(![str isEqualToString:@"🔍"]){
            [self.otherKey addObject:str];
        }
    }
    
    NSArray *k = [self.otherKey sortedArrayUsingSelector:@selector(compare:)];
    [self.keys addObjectsFromArray:k];
}


#pragma  mark 去掉@符号
-(NSString*)cutStr:(NSString*)str {
    NSArray *arr = [str componentsSeparatedByString:@"@"];
    return arr[0];
}

#pragma mark - tableview delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.keys.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSString *key=self.keys[section];
    NSArray *arr=[self.data objectForKey:key];
    return arr.count;
}

#pragma mark 设置每个区的标题
-(NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSString *title=self.keys[section];
    return title;
}

#pragma mark 表单元的设置
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BTAdressBookCell *cell = [tableView dequeueReusableCellWithIdentifier:kAddressBookIndentifier];
    if (!cell) {
        cell = [[BTAdressBookCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kAddressBookIndentifier];
    }
    NSString *key = self.keys[indexPath.section];
    NSArray *arr = [self.data objectForKey:key];
    BTAddressBook *contacter = arr[indexPath.row];
    [cell bindData:contacter];
    return cell;
}

#pragma mark 选中单元格的事件
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

#pragma mark 返回分区头的高度
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 25;
    }
    return 10;
}

#pragma mark 返回标示图的索引
-(NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    return self.keys;
}

#pragma mark setter
- (UITableView *)tableview {
    if (!_tableview) {
        _tableview = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableview.delegate = self;
        _tableview.dataSource =self;
    }
    return _tableview;
}

-(NSMutableArray *)keys
{
    if(_keys==nil) {
        _keys=[NSMutableArray array];
    }
    return _keys;
}
-(NSMutableDictionary *)data
{
    if(!_data){
        _data = [NSMutableDictionary dictionary];
    }
    return _data;
}

-(NSMutableArray *)otherKey
{
    if(_otherKey==nil){
        _otherKey=[NSMutableArray array];
    }
    return _otherKey;
}

@end
