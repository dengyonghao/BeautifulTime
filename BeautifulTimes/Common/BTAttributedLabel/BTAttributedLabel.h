//
//  BTAttributedLabel.h
//  BeautifulTimes
//
//  Created by dengyonghao on 15/11/24.
//  Copyright © 2015年 dengyonghao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BTAttributedLabel : UIView

@property (nonatomic,strong)    UIFont *font;                   //字体
@property (nonatomic,strong)    UIColor *textColor;             //文字颜色
@property (nonatomic,assign)    NSInteger   numberOfLines;      //行数
@property (nonatomic,assign)    CTTextAlignment textAlignment;  //文字排版样式
@property (nonatomic,assign)    CTLineBreakMode lineBreakMode;  //LineBreakMode
@property (nonatomic,assign)    CGFloat lineSpacing;            //行间距
@property (nonatomic,assign)    CGFloat paragraphSpacing;       //段间距

//UI控件
- (void)appendView: (UIView *)view;
- (void)appendView: (UIView *)view
            margin: (UIEdgeInsets)margin;

//普通文本
- (void)setText:(NSString *)text;
- (void)appendText: (NSString *)text;

@end
