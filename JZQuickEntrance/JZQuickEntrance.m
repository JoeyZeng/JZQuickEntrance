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
#import "JZHelper.h"

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

+ (void)addLoadImageClassName:(NSArray <NSString *>*)imageClassNames {
    [JZHelper shared].additionImageClassNameArray = imageClassNames;
}

@end


@implementation UIWindow (JZQuickEntrance)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Method fromMethod = class_getInstanceMethod(self, @selector(makeKeyAndVisible));
        Method toMethod = class_getInstanceMethod(self, @selector(qe_makeKeyAndVisible));
        method_exchangeImplementations(fromMethod, toMethod);
    });
}

- (void)qe_makeKeyAndVisible {
    [self qe_makeKeyAndVisible];
    [JZQuickEntrance showInWindow];
}

@end
