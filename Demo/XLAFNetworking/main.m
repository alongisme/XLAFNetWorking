//
//  main.m
//  XLAFNetworking
//
//  Created by admin on 16/7/26.
//  Copyright © 2016年 along. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import <FBAllocationTracker/FBAllocationTracker.h>
#import <FBRetainCycleDetector/FBRetainCycleDetector.h>

int main(int argc, char * argv[]) {
    [[FBAllocationTrackerManager sharedManager] startTrackingAllocations];
    [[FBAllocationTrackerManager sharedManager] enableGenerations];
    @autoreleasepool {
        return UIApplicationMain(argc, argv, nil, NSStringFromClass([AppDelegate class]));
    }
}
