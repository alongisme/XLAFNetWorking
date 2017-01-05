//
//  UIView+HUD.m
//  MVVNBaseProject
//
//  Created by along on 2016/12/15.
//  Copyright © 2016年 along. All rights reserved.
//

#import "UIView+HUD.h"
#import "MBProgressHUD.h"
#import <objc/runtime.h>

@interface UIView ()
@property (nonatomic,strong) MBProgressHUD *hud;
@end

static const void *indieBandHudKey = &indieBandHudKey;

@implementation UIView (UIView_HUD)

- (MBProgressHUD *)hud {
    return objc_getAssociatedObject(self, indieBandHudKey);
}

- (void)setHud:(MBProgressHUD *)hud {
    objc_setAssociatedObject(self, indieBandHudKey, hud, OBJC_ASSOCIATION_RETAIN);
}

- (void)showHud {
    self.hud = [MBProgressHUD showHUDAddedTo:self animated:YES];
    [self.hud showAnimated:YES];
}

- (void)hideHud {
    [self.hud hideAnimated:YES];
}

- (void)showHudInWindow {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].windows.lastObject animated:YES];
    [hud showAnimated:YES];
}

- (void)hideHudInWindow {
    [MBProgressHUD hideHUDForView:[UIApplication sharedApplication].windows.lastObject animated:YES];
}

- (void)showHudError:(NSString *)error {
    [self showHudError:error delay:1.5];
}

- (void)showHudSuccess:(NSString *)success {
    [self showHudSuccess:success delay:1.5];
}

- (void)showHudInWindowError:(NSString *)error {
    [self showHudInWindowError:error delay:1.5];
}

- (void)showHudInWindowSuccess:(NSString *)success {
    [self showHudInWindowSuccess:success delay:1.5];
}

- (void)showHudError:(NSString *)error delay:(float)delay {
    [self showIcon:@"MBProgressHUD.bundle/error@2x.png" message:error delay:delay view:self];
}

- (void)showHudSuccess:(NSString *)success delay:(float)delay {
    [self showIcon:@"MBProgressHUD.bundle/success@2x.png" message:success delay:delay view:self];
}

- (void)showHudInWindowError:(NSString *)error delay:(float)delay {
    [self showIcon:@"MBProgressHUD.bundle/error@2x.png" message:error delay:delay view:[UIApplication sharedApplication].windows.lastObject];
}

- (void)showHudInWindowSuccess:(NSString *)success delay:(float)delay {
    [self showIcon:@"MBProgressHUD.bundle/success@2x.png" message:success delay:delay view:[UIApplication sharedApplication].windows.lastObject];
}

- (void)showIcon:(NSString *)icon message:(NSString *)message delay:(float)delay view:(UIView *)view{
    if (delay <= 0) {
        NSLog(@"delay <= 0");
        return;
    }
    MBProgressHUD *Hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    Hud.label.text = message;
    Hud.customView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:icon]];
    Hud.mode = MBProgressHUDModeCustomView;
    Hud.removeFromSuperViewOnHide = YES;
    [Hud hideAnimated:YES afterDelay:delay];
}
@end
