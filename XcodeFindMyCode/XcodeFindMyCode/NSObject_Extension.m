//
//  NSObject_Extension.m
//  XcodeFindMyCode
//
//  Created by 张小刚 on 16/3/1.
//  Copyright © 2016年 lyeah company. All rights reserved.
//


#import "NSObject_Extension.h"
#import "XcodeFindMyCode.h"

@implementation NSObject (Xcode_Plugin_Template_Extension)

+ (void)pluginDidLoad:(NSBundle *)plugin
{
    static dispatch_once_t onceToken;
    NSString *currentApplicationName = [[NSBundle mainBundle] infoDictionary][@"CFBundleName"];
    if ([currentApplicationName isEqual:@"Xcode"]) {
        dispatch_once(&onceToken, ^{
            sharedPlugin = [[XcodeFindMyCode alloc] initWithBundle:plugin];
        });
    }
}
@end
