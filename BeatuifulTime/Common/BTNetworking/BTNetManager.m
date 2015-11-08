//
//  BTNetManager.m
//  BeatuifulTime
//
//  Created by dengyonghao on 15/11/8.
//  Copyright © 2015年 dengyonghao. All rights reserved.
//

#import "BTNetManager.h"

@implementation BTNetManager

+ (AFHTTPRequestOperation *) netManagerReqeustWeatherInfo:(NSString *)cityName
                                                    successCallback:(DictionaryResponseBlock)successCallback
                                                       failCallback:(errorBlock)failCallback
{
//    NSMutableDictionary *infoDic = [[NSMutableDictionary alloc] init];
//    
//    [infoDic setObject:channelID forKey:@"channel_number"];
//    
//    AFHTTPRequestOperationManager *manager= [self configureAFHTTPRequestManagerWithURL:CARINFO_HOST];
//    AFHTTPRequestOperation *op = [manager GET:API_PATH_BLACKLIST parameters:infoDic success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        NSDictionary *result =  (NSDictionary*)responseObject;
//        successCallback(result);
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        failCallback(error);
//    }];
//    return op;
    return nil;
}

@end
