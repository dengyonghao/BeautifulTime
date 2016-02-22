//
//  BTCommon.h
//  BeautifulTimes
//
//  Created by dengyonghao on 15/10/15.
//  Copyright (c) 2015年 dengyonghao. All rights reserved.
//

#import <Foundation/Foundation.h>

#ifndef BTCommon_h
#define BTCommon_h

#pragma mark -- inline function
//静态内联函数，修改BNAVI_UIIMAGE宏定义，不添加缓存
static inline UIImage* naviimage_from_mainbundle(NSString* filename_and_type)
{
    if (!filename_and_type || !filename_and_type.length)
    {
        return nil;
    }
    NSMutableString* imagename = [NSMutableString stringWithString:[filename_and_type stringByDeletingPathExtension]];
    //图片名字是否有@2x(@3x后缀后续可能需要考虑)
    if (![imagename hasSuffix:@"@2x"])
    {
        [imagename appendString:@"@2x"];
    }
    NSString* imagetype = [imagename pathExtension];
    //不添加后缀默认为png
    if (!imagetype || imagetype.length == 0)
    {
        imagetype = @"png";
    }
    UIImage* image = [[UIImage alloc] initWithContentsOfFile:
                      [[NSBundle mainBundle] pathForResource:imagename ofType:imagetype]];
    return image;
}

#define firstLaunch              @"firstLaunch"
#define currentCity               @"btCurrentCity"
#define userID                   @"btUserID"
#define userPassword             @"btPassword"
#define isLogin                  @"kIsLogin"

// 弱引用
#define WS(weakSelf)  __weak __typeof(&*self)weakSelf = self;

#define BT_UIIMAGE(_FILE_)          ([UIImage imageNamed:(_FILE_)])
#define BT_LOADIMAGE(_FILE_)        ([[BTThemeManager getInstance]loadImageInDefaultThemeWithName:(_FILE_)])

// 版本大于iOS7
//#define     IOS7_OR_HIGHER       ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7)

#define     IOS8_OR_HIGHER       ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8)
#define     IOS8_3_OR_HIGHER       ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.3f)
#define     IOS9_0_OR_HIGHER       ([[[UIDevice currentDevice] systemVersion] floatValue] >= 9.0f)

//发送消息的通知名
#define SendMsgName @"sendMessage"

//删除好友时发出的通知名
#define DeleteFriend @"deleteFriend"

//发送表情的按钮
#define FaceSendButton @"faceSendButton"

//收到好友申请通知名
#define AddFriendRequst @"kAddFriendRequst"

//更新好友列表通知名
#define UpdateContacterList @"kUpdateContacterList"

/** 表情相关 */
// 表情的最大行数
#define HMEmotionMaxRows 3
// 表情的最大列数
#define HMEmotionMaxCols 7
// 每页最多显示多少个表情
#define HMEmotionMaxCountPerPage (HMEmotionMaxRows * HMEmotionMaxCols - 1)

// 表情选中的通知
#define HMEmotionDidSelectedNotification @"HMEmotionDidSelectedNotification"
// 点击删除按钮的通知
#define HMEmotionDidDeletedNotification @"HMEmotionDidDeletedNotification"
// 通知里面取出表情用的key
#define HMSelectedEmotion @"HMSelectedEmotion"


//服务器的ip地址
#define ServerAddress @"119.29.115.132"

//服务器的端口号
#define ServerPort 5222

//服务器的域名
#define ServerName @"vm-40-145-ubuntu"

// 状态栏高度
#define     BT_STATUSBAR_HEIGHT  0
// 屏幕的高度
#define     BT_SCREEN_HEIGHT     (IOS8_OR_HIGHER?[UIScreen mainScreen].bounds.size.height:[UIScreen mainScreen].bounds.size.height)
// 屏幕的宽度
#define     BT_SCREEN_WIDTH      (IOS8_OR_HIGHER?[UIScreen mainScreen].bounds.size.width:[UIScreen mainScreen].bounds.size.width)

// View的right
#define BT_ViewRight(View)              (View.frame.origin.x + View.frame.size.width)
// View的left
#define BT_ViewLeft(View)               (View.frame.origin.x)
// View的bottom
#define BT_ViewBottom(View)             (View.frame.origin.y + View.frame.size.height)
// View的top
#define BT_ViewTop(View)                (View.frame.origin.y)
// View的width
#define BT_ViewWidth(View)              (View.frame.size.width)
// View的height
#define BT_ViewHeight(View)             (View.frame.size.height)

//判断设备是不是6Plus
#define iPhone6Plus ([UIScreen instancesRespondToSelector:@selector(scale)]?[[UIScreen mainScreen] scale]:1) >= 2.8

//是否为4寸屏
#define BT_4INCH_SCREEN          (CGSizeEqualToSize(CGSizeMake(320*[UIScreen mainScreen].scale, 568*[UIScreen mainScreen].scale),[[UIScreen mainScreen] currentMode].size))

//是否为4.7寸屏
#define BT_47INCH_SCREEN          (CGSizeEqualToSize(CGSizeMake(375*[UIScreen mainScreen].scale, 667*[UIScreen mainScreen].scale),[[UIScreen mainScreen] currentMode].size))

//是否为5.5寸屏
#define BT_55INCH_SCREEN          (CGSizeEqualToSize(CGSizeMake(414*[UIScreen mainScreen].scale, 736*[UIScreen mainScreen].scale),[[UIScreen mainScreen] currentMode].size))

#define BT_IOS7_OR_HIGHER        ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7)
#define BT_IOS8_OR_HIGHER        ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8)

// 透明色
#define BT_CLEARCOLOR            ([UIColor clearColor])

// 根据大小创建字体
#define BT_FONTSIZE(_SIZE_)      ([UIFont systemFontOfSize:_SIZE_])

// CVString转换为NSString
#define CVSTRING_TO_NSSTRING(string) [[[NSString alloc] initWithBytes:(const void*)string.GetBuffer() length:sizeof(VVChar) * string.GetLength() encoding:NSUTF16LittleEndianStringEncoding] autorelease]

// ARC下CVString转换为NSString
#define CVSTRING_TO_NSSTRING_ARC(string) [[NSString alloc] initWithBytes:(const void*)string.GetBuffer() length:sizeof(VVChar) * string.GetLength() encoding:NSUTF16LittleEndianStringEncoding]

//CVString指针转化为NSString
#define TRANS_NSSTRING_FROM_CVSTRING(cvstringObjectPtr) \
[[[NSString alloc] initWithBytes:(const void*)(cvstringObjectPtr)->GetBuffer() length:sizeof(VVChar) * (cvstringObjectPtr)->GetLength() encoding:NSUTF16LittleEndianStringEncoding]autorelease]

//ARC下CVString指针转化为NSString
#define TRANS_NSSTRING_FROM_CVSTRING_ARC(cvstringObjectPtr) \
[[NSString alloc] initWithBytes:(const void*)(cvstringObjectPtr)->GetBuffer() length:sizeof(VVChar) * (cvstringObjectPtr)->GetLength() encoding:NSUTF16LittleEndianStringEncoding]

//NSString转换成CVString
#define NSSTRING_TO_CVSTRING(nstring)  CVString((const VUShort*)[nstring cStringUsingEncoding:NSUnicodeStringEncoding])

#endif