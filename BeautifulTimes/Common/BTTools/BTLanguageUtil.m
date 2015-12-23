//
//  BTLanguageUtil.m
//  BeautifulTimes
//
//  Created by deng on 15/11/22.
//  Copyright © 2015年 dengyonghao. All rights reserved.
//

#import "BTLanguageUtil.h"

static NSString * const kDefaultLanguage   = @"zh-Hans";
static NSString * const kSupportLanguages  = @"en, zh-Hans";
static NSString * const keyLanguageIdentifier = @"kLanguageIdentifier";
static BTLanguageUtil *sharedInstance = nil;

@interface BTLanguageUtil ()

@property (nonatomic, retain) NSString *currentLanguage;

@end

@implementation BTLanguageUtil

+ (BTLanguageUtil *)sharedInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[BTLanguageUtil alloc] init];
    });
    return sharedInstance;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        NSString *currentLanguageString =
        [[NSUserDefaults standardUserDefaults] objectForKey:keyLanguageIdentifier];
        if (currentLanguageString.length > 0) {
            self.currentLanguage = currentLanguageString;
        }
        else {
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            NSArray *languages = [defaults objectForKey:@"AppleLanguages"];
            NSString *currentLanguage = languages[0];
            
            NSString *newLanguage =
            [kDefaultLanguage stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            if ([self doSupportTheNewLanguage:currentLanguage]) {
                newLanguage = currentLanguage;
            }
            
            [self setLanguage:newLanguage];
        }
    }
    return self;
}

- (void)setLanguage:(NSString *)language {
    if ([self doSupportTheNewLanguage:language]) {
        self.currentLanguage = language;
        [[NSUserDefaults standardUserDefaults] setObject:language forKey:keyLanguageIdentifier];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

- (NSString *)localizedStringForKey:(NSString *)key {
    return  [[self manualLanguageBundle:[NSBundle mainBundle]] localizedStringForKey:(key) value:@"" table:nil];
}

- (NSBundle *)manualLanguageBundle:(NSBundle *)bundle {
    NSBundle *newBundle = bundle;
    
    NSString *currentLanguageString = [[NSUserDefaults standardUserDefaults] objectForKey:keyLanguageIdentifier];
   
    NSString *path = [bundle pathForResource:currentLanguageString ofType:@"lproj" ];
    
    if (path) {
        newBundle = [NSBundle bundleWithPath:path];
    }
    
    return newBundle;
}

- (BOOL)doSupportTheNewLanguage:(NSString *)newLanguage {
    NSArray *supportLanguagesArray = [kSupportLanguages componentsSeparatedByString:@","];
    for (NSString *language in supportLanguagesArray) {
        NSString *cleanLanguage = [language stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        if ([newLanguage isEqualToString:cleanLanguage]) {
            return YES;NSLocalizedString(@"play",@"");
        }
    }
    return NO;
}

@end
