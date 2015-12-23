//
//  BTAddressBookTableViewCell.m
//  BeautifulTimes
//
//  Created by deng on 15/12/9.
//  Copyright © 2015年 dengyonghao. All rights reserved.
//

#import "BTAddressBookTableViewCell.h"

@interface BTAddressBookTableViewCell() <BTThemeListenerProtocol>

@end

@implementation BTAddressBookTableViewCell{
    BOOL show;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

- (void) setHighlighted:(BOOL)highlighted animated:(BOOL)animated {
    [super setHighlighted:highlighted animated:animated];
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectedBackgroundView = [[UIView alloc] init];
        [self addSubview:self.pullButton];
        
        
        [[BTThemeManager getInstance] addThemeListener:self];
        
        [self CLThemeDidNeedUpdateStyle];
        
    }
    return self;
}

- (void)dealloc {
    [[BTThemeManager getInstance] removeThemeListener:self];
}

- (void)layoutSubviews {
    
    self.nameLabel.frame = CGRectMake(16, (BT_ViewHeight(self) - 44) / 2.0, 300, 22);
//    self.nameLabel.textColor = BT_HEXRGBCOLOR(CL_CONT_E);
    
    CGFloat pullbuttonWidth = 16;
    self.pullButton.frame = CGRectMake(BT_ViewWidth(self) - 8 - pullbuttonWidth - 64, (BT_ViewHeight(self) - 44) / 2.0 + 20, pullbuttonWidth, pullbuttonWidth);
//    [self.pullButton setEnlargeEdgeWithTop:30 right:10 bottom:30 left:20];
    
    self.telLabel.frame = CGRectMake(BT_ViewLeft(self.nameLabel), BT_ViewBottom(self.nameLabel), 300, 22);
    
    self.line.frame = CGRectMake(BT_ViewLeft(self.nameLabel), BT_ViewHeight(self) - 0.5, BT_ViewWidth(self.pullButton) + BT_ViewLeft(self.pullButton) - BT_ViewLeft(self.nameLabel), 0.5);
    
    self.selectedBackgroundView.frame = CGRectMake(BT_ViewLeft(self.nameLabel), 0, BT_ViewWidth(self.line), BT_ViewHeight(self));
    
    show = NO;
}


- (void)CLThemeDidNeedUpdateStyle {
    self.backgroundColor = [[BTThemeManager getInstance] BTThemeColor:@"cl_bg_c_main"];
    
    self.nameLabel.textColor = [[BTThemeManager getInstance] BTThemeColor:@"cl_text_a5_content"];
    
    UIButton * tmpButton = self.pullButton;
    [[BTThemeManager getInstance] BTThemeImage:@"phone_ic_more" completionHandler:^(UIImage *image) {
        [tmpButton setImage:image forState:UIControlStateNormal];
    }];
    
    self.telLabel.textColor = [[BTThemeManager getInstance] BTThemeColor:@"cl_text_a2_content"];
    
    UIColor * lineColor = [[BTThemeManager getInstance] BTThemeColor:@"cl_line_a1_item"];
    self.line.backgroundColor = lineColor;
    
    self.selectedBackgroundView.backgroundColor = [[BTThemeManager getInstance] BTThemeColor:@"cl_press_b_item"];
}


- (UILabel *) nameLabel {
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc]init];
        [self.contentView addSubview:_nameLabel];
        _nameLabel.lineBreakMode = NSLineBreakByTruncatingMiddle;
        _nameLabel.font = BT_FONTSIZE(18);
    }
    return _nameLabel;
}
- (UILabel *) telLabel {
    if (!_telLabel) {
        _telLabel = [[UILabel alloc]init];
        [self.contentView addSubview:_telLabel];
        _telLabel.lineBreakMode = NSLineBreakByTruncatingMiddle;
        _telLabel.font = BT_FONTSIZE(14);
    }
    return _telLabel;
}

- (UIButton*) pullButton {
    if (!_pullButton) {
        _pullButton = [[UIButton alloc]init];
        [_pullButton addTarget:self action:@selector(pullButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _pullButton;
}

- (void) pullButtonClicked:(UIButton *) sender {
    if (_pullBlock) {
        _pullBlock(self.indexPath);
    }
}

- (UIView *) line {
    if (!_line) {
        _line = [[UIView alloc]init];
        [self.contentView addSubview:_line];
    }
    return _line;
}

@end
