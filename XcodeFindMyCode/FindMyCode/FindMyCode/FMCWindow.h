//
//  FMCWindow.h
//  FindMyCode
//
//  Created by 张小刚 on 16/3/1.
//  Copyright © 2016年 lyeah company. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    FMCTriggerModeTwoFingerLongPress = 2,
    FMCTriggerModeThreeFingerLongPress = 3,
}FMCTriggerMode;

@interface FMCWindow : UIWindow

- (void)setTriggerMode: (FMCTriggerMode) triggerMode;

@end
