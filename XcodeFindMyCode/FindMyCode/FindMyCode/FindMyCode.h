//
//  FindMyCode.h
//  XcodeFindMyCode
//
//  Created by 张小刚 on 16/3/6.
//  Copyright © 2016年 lyeah company. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    FMCTriggerModeTwoFingerLongPress = 2,
    FMCTriggerModeThreeFingerLongPress = 3,
}FMCTriggerMode;

@interface FindMyCode : NSObject

+ (FindMyCode *)sharedInstance;
@property (nonatomic, assign) FMCTriggerMode triggerMode;

@end
