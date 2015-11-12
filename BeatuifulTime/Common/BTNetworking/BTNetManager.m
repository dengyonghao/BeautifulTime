//
//  BTNetManager.m
//  BeatuifulTime
//
//  Created by dengyonghao on 15/11/8.
//  Copyright © 2015年 dengyonghao. All rights reserved.
//

#import "BTNetManager.h"

#define WEATHERINFO_HOST @"http://api.map.baidu.com"

#define API_PATH_WEATHER @"/telematics/v3/weather"

#define API_AK @"xfkg5isLkdyXDGAPYezFjtpb"

#define DATA_TYPE @"json"

@implementation BTNetManager

+ (AFHTTPRequestOperation *) netManagerReqeustWeatherInfo:(NSString *)cityName
                                                    successCallback:(DictionaryResponseBlock)successCallback
                                                       failCallback:(errorBlock)failCallback
{
    NSMutableDictionary *infoDic = [[NSMutableDictionary alloc] init];
    [infoDic setObject:cityName forKey:@"location"];
    [infoDic setObject:DATA_TYPE forKey:@"output"];
    [infoDic setObject:API_AK forKey:@"ak"];
    
    AFHTTPRequestOperationManager *manager= [self configureAFHTTPRequestManagerWithURL:WEATHERINFO_HOST];
    AFHTTPRequestOperation *operation = [manager GET:API_PATH_WEATHER parameters:infoDic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *result =  (NSDictionary*)responseObject;
        successCallback(result);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failCallback(error);
    }];
    return operation;
}

+ (AFHTTPRequestOperationManager *)configureAFHTTPRequestManagerWithURL:(NSString *)url
{
    AFHTTPRequestOperationManager* manager = nil;
    
    if ([url isKindOfClass:[NSURL class]]) {
        // check NSURL 和 NSString
        manager = [[AFHTTPRequestOperationManager alloc]initWithBaseURL:(NSURL *)url];
    }
    else {
        manager = [[AFHTTPRequestOperationManager alloc]initWithBaseURL:[NSURL URLWithString:url]];
    }
    
    manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];
    manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/plain"];
    return manager;
}

@end
