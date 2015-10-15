//
//  BTCommon.h
//  BeatuifulTime
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

// 弱引用
#define WS(weakSelf)  __weak __typeof(&*self)weakSelf = self;

#define BT_UIIMAGE(_FILE_)          ([UIImage imageNamed:(_FILE_)])

// 版本大于iOS7
//#define     IOS7_OR_HIGHER       ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7)

#define     IOS8_OR_HIGHER       ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8)
#define     IOS8_3_OR_HIGHER       ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.3f)
#define     IOS9_0_OR_HIGHER       ([[[UIDevice currentDevice] systemVersion] floatValue] >= 9.0f)

// 屏幕的高度
#define     BT_SCREEN_HEIGHT     (IOS8_OR_HIGHER?[UIScreen mainScreen].bounds.size.height:[UIScreen mainScreen].bounds.size.height)
// 屏幕的宽度
#define     BT_SCREEN_WIDTH      (IOS8_OR_HIGHER?[UIScreen mainScreen].bounds.size.width:[UIScreen mainScreen].bounds.size.width)

//判断设备是不是6Plus
#define iPhone6Plus ([UIScreen instancesRespondToSelector:@selector(scale)]?[[UIScreen mainScreen] scale]:1) >= 2.8

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