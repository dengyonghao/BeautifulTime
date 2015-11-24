//
//  BTLanguageUtil.h
//  BeatuifulTime
//
//  Created by deng on 15/11/22.
//  Copyright © 2015年 dengyonghao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BTLanguageUtil : NSObject

+ (BTLanguageUtil*)sharedInstance;

- (void)setLanguage:(NSString *)language;

- (NSString *)localizedStringForKey:(NSString *)key;

@end
