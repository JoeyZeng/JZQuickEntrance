//
//  JZQuickEntrance.m
//  JZQuickEntranceDemo
//
//  Created by Joey on 2018/7/26.
//  Copyright © 2018年 Dachen. All rights reserved.
//

#import "JZQuickEntrance.h"
#import "JZSuspendView.h"
#import <objc/runtime.h>

@implementation JZQuickEntrance

static JZSuspendView *s_suspendView;

+ (void)showInWindow {
#if DEBUG
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self hide];
        
        JZSuspendView *suspendView = [JZSuspendView instanceAtLastPosition];
        s_suspendView = suspendView;
        [[UIApplication sharedApplication].keyWindow addSubview:suspendView];
    });
    
#endif
}

+ (void)hide {
    if (s_suspendView) {
        [s_suspendView removeFromSuperview];
    }
}

@end


@implementation UIWindow (JZQuickEntrance)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Method fromMethod = class_getInstanceMethod(self, @selector(setRootViewController:));
        Method toMethod = class_getInstanceMethod(self, @selector(qe_setRootViewController:));
        method_exchangeImplementations(fromMethod, toMethod);
    });
}

- (void)qe_setRootViewController:(UIViewController *)rootViewController {
    [self qe_setRootViewController:rootViewController];
    [JZQuickEntrance showInWindow];
}

@end
