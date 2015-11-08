//
//  BTNetManager.h
//  BeatuifulTime
//
//  Created by dengyonghao on 15/11/8.
//  Copyright © 2015年 dengyonghao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"
#import "BTBlockType.h"

@interface BTNetManager : NSObject

+ (AFHTTPRequestOperation *) netManagerReqeustWeatherInfo:(NSString *)cityName
                                                    successCallback:(DictionaryResponseBlock)successCallback
                                                       failCallback:(errorBlock)failCallback;
@end
