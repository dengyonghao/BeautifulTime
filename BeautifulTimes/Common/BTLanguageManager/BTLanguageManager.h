//
//  BTLanguageManager.h
//  BeautifulTimes
//
//  Created by dengyonghao on 15/11/23.
//  Copyright © 2015年 dengyonghao. All rights reserved.
//

#import <Foundation/Foundation.h>

#undef NSLocalizedString
#define NSLocalizedString(key, comment) [[ACLanguageUtil sharedInstance] localizedStringForKey:(key)]

typedef enum {
    BTLanguageType_en = 1,
    BTLanguageType_zh_Hans = 2,
}BTLanguageType;

@protocol BTLanguageListenerProtocol <NSObject>

- (void) BTLanguageDidNeedUpdateType;

@end

@interface BTLanguageManager : NSObject

+ (BTLanguageManager *)sharedInstance;

/*
 * 设置语言
 */
- (void)setLanguage:(NSString *)language;

- (NSString *)localizedStringForKey:(NSString *)key;

/*
 * 注册监听
 */
- (void) addLanguageListener:(id) obj;
/*
 *移除监听
 */
- (void) removeLanguageListener:(id) obj;


@end
