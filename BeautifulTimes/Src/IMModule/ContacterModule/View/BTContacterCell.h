//
//  ContacterCell.h
//  微信
//
//  Created by Think_lion on 15/6/18.
//  Copyright (c) 2015年 Think_lion. All rights reserved.
//

#import <UIKit/UIKit.h>
@class BTContacterModel;
@interface BTContacterCell : UITableViewCell


@property (nonatomic,strong) BTContacterModel *contacerModel;

+(instancetype)cellWithTableView:(UITableView*)tableView indentifier:(NSString*)indentifier;

@end
