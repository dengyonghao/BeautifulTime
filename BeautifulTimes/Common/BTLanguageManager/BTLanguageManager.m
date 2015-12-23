//
//  BTLanguageManager.m
//  BeautifulTimes
//
//  Created by dengyonghao on 15/11/23.
//  Copyright © 2015年 dengyonghao. All rights reserved.
//

#import "BTLanguageManager.h"

#define BTLanguageChangeNotification @"kBTLanguageChangeNotification"

static NSString * const kDefaultLanguage   = @"zh-Hans";
static NSString * const kSupportLanguages  = @"en, zh-Hans";
static NSString * const keyLanguageIdentifier = @"kLanguageIdentifier";
static BTLanguageManager *languageManager = nil;

@interface BTLanguageManager ()

@property (nonatomic, strong) NSString *currentLanguage;

@end


@implementation BTLanguageManager

+ (BTLanguageManager *)sharedInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        languageManager = [[BTLanguageManager alloc] init];
    });
    return languageManager;
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
            return YES;
        }
    }
    return NO;
}

- (void)addLanguageListener:(id )obj
{
    if([obj respondsToSelector:@selector(BTThemeDidNeedUpdateStyle)]){
        [[NSNotificationCenter defaultCenter] addObserver:obj selector:@selector(BTLanguageDidNeedUpdateType) name:BTLanguageChangeNotification object:nil];
    }
    
}

- (void) removeLanguageListener:(id)obj
{
    if (obj) {
        [[NSNotificationCenter defaultCenter] removeObserver:obj];
    }
}


@end
