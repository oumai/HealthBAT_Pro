 //
//  main.m
//  HealthBAT_Pro
//
//  Created by Skyrim on 16/7/7.
//  Copyright © 2016年 KMHealthCloud. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BATAppDelegate.h"

//声明函数
void confingTingYunAppKey();

int main(int argc, char * argv[]) {
    @autoreleasepool {
        
        //配置不同环境的听云 AppKey
        confingTingYunAppKey();
        return UIApplicationMain(argc, argv, nil, NSStringFromClass([BATAppDelegate class]));
    }
}


void confingTingYunAppKey() {
    
#ifdef DEBUG
#elif TESTING
    [NBSAppAgent startWithAppID:@"695641aa2ec84ad5aaa1d985198db07c"];
#elif PUBLICRELEASE
#elif PRERELEASE
#elif ENTERPRISERELEASE
#elif RELEASE
    [NBSAppAgent startWithAppID:@"3cb2792a993a4cd7bf2523a61a4a02a0"];
#endif

    
}
