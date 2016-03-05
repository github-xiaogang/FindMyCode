//
//  XcodeFindMyCode.h
//  XcodeFindMyCode
//
//  Created by 张小刚 on 16/3/1.
//  Copyright © 2016年 lyeah company. All rights reserved.
//

#import <AppKit/AppKit.h>

@class XcodeFindMyCode;

static XcodeFindMyCode *sharedPlugin;

@interface XcodeFindMyCode : NSObject

+ (instancetype)sharedPlugin;
- (id)initWithBundle:(NSBundle *)plugin;

@property (nonatomic, strong, readonly) NSBundle* bundle;
@end