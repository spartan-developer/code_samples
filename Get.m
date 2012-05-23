//
//  Get.m
//  Fishr3
//
//  Created by Nicholas Yianilos on 4/18/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Get.h"
#import "ASIHTTPRequest.h"
#import "ASIFormDataRequest.h"
#import "JSONKit.h"

@implementation Get

+ (NSString *)basePath {
	return @"http://fishr.herokuapp.com/%@";
      //  return @"http://localhost:3000/%@";
}

+ (NSMutableArray *)arrayFromUrl:(NSString *)path, ... {
    va_list args;
    va_start(args, path);
    NSString *urlString = [[NSString alloc] initWithFormat:path arguments:args];
    NSString *completeUrl = [NSString stringWithFormat:[Get basePath], urlString];
    NSURL *url = [NSURL URLWithString:completeUrl];
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
    [request startSynchronous];
    JSONDecoder *decoder = [[JSONDecoder alloc] initWithParseOptions:JKParseOptionNone];
    NSMutableArray *result = [decoder mutableObjectWithData:request.responseData];
    va_end(args);
    return result;
}

+ (NSDictionary *)dictionaryFromUrl:(NSString *)path, ... {
    va_list args;
    va_start(args, path);
    NSString *urlString = [[NSString alloc] initWithFormat:path arguments:args];
    NSString *completeUrl = [NSString stringWithFormat:[Get basePath], urlString];
    NSURL *url = [NSURL URLWithString:completeUrl];
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
    [request startSynchronous];
    JSONDecoder *decoder = [[JSONDecoder alloc] initWithParseOptions:JKParseOptionNone];

    NSDictionary *result = [decoder objectWithData:request.responseData];
    va_end(args);
    return result;
}

+ (ASIFormDataRequest *)requestFromUrl:(NSString *)path, ... {
    va_list args;
    va_start(args, path);
    NSString *urlString = [[NSString alloc] initWithFormat:path arguments:args];
    va_end(args);
    
    NSString *completeUrl = [NSString stringWithFormat:[Get basePath], urlString];
    NSURL *url = [NSURL URLWithString:completeUrl];
    
    return [ASIFormDataRequest requestWithURL:url];
}

+ (UIImage *)imageFromPath:(NSString *)path {
    NSURL *imageUrl = [NSURL URLWithString:path];
    return [UIImage imageWithData:[NSData dataWithContentsOfURL:imageUrl]];
}

@end
