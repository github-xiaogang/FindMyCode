//
//  XcodeFindMyCode.m
//  XcodeFindMyCode
//
//  Created by 张小刚 on 16/3/1.
//  Copyright © 2016年 lyeah company. All rights reserved.
//

#import "XcodeFindMyCode.h"
#import "NSView+MCLog.h"
#import "XToDoModel.h"

static NSString * const kTargetRegexPattern = @"XcodeFindMyCode\\[\\d+\\] request open file (\\w+).m";
static NSString * const kTimeRegexPattern = @"\\[\\d+\\]";
static NSString * const kFilenameRegexPattern = @"(\\w+).m";

static NSTimeInterval const kMinEventHandleInterval = 1.0f;
static NSTimeInterval const kMaxPhoneXcodeDeltaInterval = 1.0f;

@interface XcodeFindMyCode()

@property (nonatomic, strong, readwrite) NSBundle *bundle;
@property (nonatomic, strong) NSTextView * consoleTextView;
//last handle time
@property (nonatomic, assign) NSTimeInterval lastTimeInterval;

@end

@implementation XcodeFindMyCode

+ (instancetype)sharedPlugin
{
    return sharedPlugin;
}

- (id)initWithBundle:(NSBundle *)plugin
{
    if (self = [super init]) {
        // reference to plugin's bundle, for resource access
        self.bundle = plugin;
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(didApplicationFinishLaunchingNotification:)
                                                     name:NSApplicationDidFinishLaunchingNotification
                                                   object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(activate:)
                                                     name:@"IDEControlGroupDidChangeNotificationName"
                                                   object:nil];
    }
    return self;
}

- (void)didApplicationFinishLaunchingNotification:(NSNotification*)noti
{
    //removeObserver
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NSApplicationDidFinishLaunchingNotification object:nil];
}

- (void)activate:(NSNotification *)notification {
    NSView *contentView         = [[NSApp mainWindow] contentView];
    NSTextView *consoleTextView = [contentView descendantViewByClassName:@"IDEConsoleTextView"];
    if (!consoleTextView) {
        return;
    }
    self.consoleTextView = consoleTextView;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(consoleTextViewTextChanged:) name:NSTextDidChangeNotification object:self.consoleTextView];
}

- (void)consoleTextViewTextChanged: (NSNotification *)notification
{
    NSTimeInterval now = [[NSDate date] timeIntervalSince1970];
    if((now - self.lastTimeInterval) < kMinEventHandleInterval){
        return;
    }
    NSString * content = self.consoleTextView.string;

    if(content.length == 0) return;
    NSError * error = nil;
    NSRegularExpression * regExpression = [NSRegularExpression regularExpressionWithPattern:kTargetRegexPattern options:0 error:&error];
    NSArray<NSTextCheckingResult *> * matches = [regExpression matchesInString:content options:0 range:NSMakeRange(0, content.length)];
    if(matches.count == 0) return;
    NSTextCheckingResult * possibleMatch = [matches lastObject];
    NSString * matchText = [content substringWithRange:possibleMatch.range];
    // XcodeFindMyCode[2748237487284] request open file HHH_XXX.m
    NSRegularExpression * timeRegExpression = [NSRegularExpression regularExpressionWithPattern:kTimeRegexPattern options:0 error:&error];
    NSTextCheckingResult * timeMatch = [timeRegExpression firstMatchInString:matchText options:0 range:NSMakeRange(0, matchText.length)];
    if(!timeMatch) return;
    NSString * timeMatchText = [matchText substringWithRange:timeMatch.range];
    NSString * timeText = [timeMatchText stringByReplacingOccurrencesOfString:@"[" withString:@""];
    timeText = [timeText stringByReplacingOccurrencesOfString:@"]" withString:@""];
    NSTimeInterval timeInterval = [timeText doubleValue];
    
    NSRegularExpression * nameRegExpression = [NSRegularExpression regularExpressionWithPattern:kFilenameRegexPattern options:0 error:&error];
    NSTextCheckingResult * nameMatch = [nameRegExpression firstMatchInString:matchText options:0 range:NSMakeRange(0, matchText.length)];
    if(!nameMatch) return;
    NSString * filename = [matchText substringWithRange:nameMatch.range];
    
    if((now - timeInterval) > kMaxPhoneXcodeDeltaInterval){
        return;
    }
//    NSLog(@"XcodeFindMyCode: request open file %@ at time %.f",filename,timeInterval);
    NSString * filePath = [self getFilePath:filename];
    if(filePath){
        [[NSApp delegate] application:NSApp openFile:filePath];
    }
    self.lastTimeInterval = now;
}

- (NSString *)getFilePath: (NSString *)filename
{
    NSString * filePath = nil;
    NSString * workPath = [[[XToDoModel currentWorkspaceDocument].workspace.representingFilePath.fileURL
                              path]
                             stringByDeletingLastPathComponent];
    //check from .xcodeproj`s parent directory
    NSFileManager * fileManager = [NSFileManager defaultManager];
    NSDirectoryEnumerator<NSString *> * enumerator = [fileManager enumeratorAtPath:workPath];
    for (NSString * fileItem in enumerator) {
        NSString * name = [fileItem lastPathComponent];
        if([name isEqualToString:filename]){
            filePath = fileItem;
            break;
        }
    }
    if(filePath){
        filePath = [workPath stringByAppendingPathComponent:filePath];
    }
    return filePath;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end















