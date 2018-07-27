//
//  JZDataCache.m
//  JZQuickEntranceDemo
//
//  Created by Joey on 2018/7/26.
//  Copyright © 2018年 Dachen. All rights reserved.
//

#import "JZHelper.h"
#import "JZQuickEntrance.h"
#import "JZEntranceTableViewController.h"

#define JZCacheKey_LastSuspendPosition @"JZCacheKey_LastSuspendPosition"
#define JZCacheKey_LastEntranceClassName @"JZCacheKey_LastEntranceClassName"
#define JZCacheKey_HistoryClassArray @"JZCacheKey_HistoryClassArray"

@implementation JZHelper
@synthesize lastSuspendPosition = _lastSuspendPosition;
@synthesize lastEntranceClassName = _lastEntranceClassName;
@synthesize historyClassArray = _historyClassArray;

+ (instancetype)shared {
    static JZHelper *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [JZHelper new];
    });
    return instance;
}

#pragma mark - Getter & Setter

- (CGRect)lastSuspendPosition {
    
    if (CGRectIsEmpty(_lastSuspendPosition)) {
        NSString *rectStr = [[NSUserDefaults standardUserDefaults] objectForKey:JZCacheKey_LastSuspendPosition];
        if (!rectStr) {
            // default value
            CGSize screenSize = [UIScreen mainScreen].bounds.size;
            CGRect defaultRect = CGRectMake(screenSize.width-kSuspendLength, screenSize.height/2, kSuspendLength, kSuspendLength);
            self.lastSuspendPosition = defaultRect;
        } else {
            _lastSuspendPosition = CGRectFromString(rectStr);
        }
    }
    return _lastSuspendPosition;
}

- (void)setLastSuspendPosition:(CGRect)lastSuspendPosition {
    _lastSuspendPosition = lastSuspendPosition;
    NSString *rectStr = NSStringFromCGRect(lastSuspendPosition);
    [[NSUserDefaults standardUserDefaults] setObject:rectStr forKey:JZCacheKey_LastSuspendPosition];
}

- (NSString *)lastEntranceClassName {
    if (!_lastEntranceClassName) {
        _lastEntranceClassName = [[NSUserDefaults standardUserDefaults] objectForKey:JZCacheKey_LastEntranceClassName];
    }
    return _lastEntranceClassName;
}

- (void)setLastEntranceClassName:(NSString *)lastEntranceClassName {
    _lastEntranceClassName = lastEntranceClassName;
    [[NSUserDefaults standardUserDefaults] setObject:lastEntranceClassName forKey:JZCacheKey_LastEntranceClassName];
}

- (NSArray<NSString *> *)historyClassArray {
    if (!_historyClassArray) {
        _historyClassArray = [[NSUserDefaults standardUserDefaults] objectForKey:JZCacheKey_HistoryClassArray];
        if (!_historyClassArray) {
            _historyClassArray = @[];
        }
    }
    return _historyClassArray;
}

- (void)setHistoryClassArray:(NSArray<NSString *> *)historyClassArray {
    _historyClassArray = historyClassArray;
    [[NSUserDefaults standardUserDefaults] setObject:historyClassArray forKey:JZCacheKey_HistoryClassArray];
}

- (void)saveHistoryClass:(NSString *)className {
    NSMutableArray *array = [JZHelper shared].historyClassArray.mutableCopy;
    if ([array containsObject:className]) {
        [array removeObject:className];
    }
    if (array.count > kHistoryLimit - 1) {
        [array removeLastObject];
    }
    [array insertObject:className atIndex:0];
    self.historyClassArray = array.copy;
}

- (void)removeHistoryClass:(NSString *)className {
    NSMutableArray *array = [JZHelper shared].historyClassArray.mutableCopy;
    if ([array containsObject:className]) {
        [array removeObject:className];
        self.historyClassArray = array.copy;
    }
}

#pragma mark - Tools

+ (void)quickEnterViewControllerWithClassName:(NSString *)className navigationController:(UINavigationController *)nc {
    if (className.length == 0 || !nc) {
        return;
    }
    
    // new vc
    Class class = NSClassFromString(className);
    UIViewController *vc = nil;
    if ([class respondsToSelector:@selector(instanceForQuickEntrance)]) {
        vc = [class instanceForQuickEntrance];
    } else {
        vc = [class new];
    }
    if (vc) {
        // save
        [JZHelper shared].lastEntranceClassName = className;
        [[JZHelper shared] saveHistoryClass:className];
    } else {
        // class not exist
        if ([[JZHelper shared].lastEntranceClassName isEqualToString:className]) {
            [JZHelper shared].lastEntranceClassName = nil;
        }
        [[JZHelper shared] removeHistoryClass:className];
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Class is not exist!" message:nil preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"I see" style:UIAlertActionStyleCancel handler:nil]];
        [nc presentViewController:alert animated:YES completion:nil];
    }
    
    // enter
    JZEntranceType entranceType = JZEntranceTypePush;
    if ([class respondsToSelector:@selector(entranceTypeForQuickEntrance)]) {
        entranceType = [class entranceTypeForQuickEntrance];
    }
    if (entranceType == JZEntranceTypeNavPresent) {
        UINavigationController *newNc = [[UINavigationController alloc] initWithRootViewController:vc];
        [nc presentViewController:newNc animated:YES completion:nil];
    } else if (entranceType == JZEntranceTypePresent) {
        [nc presentViewController:vc animated:YES completion:nil];
    } else {
        [nc pushViewController:vc animated:YES];
    }
    
}

+ (void)quickEnterViewControllerWithClassName:(NSString *)className {
    UINavigationController *nc = [[UINavigationController alloc] initWithRootViewController:[JZEntranceTableViewController new]];
    UIViewController *rootVC = [UIApplication sharedApplication].keyWindow.rootViewController;
    [rootVC presentViewController:nc animated:NO completion:^{
        [self quickEnterViewControllerWithClassName:className navigationController:nc];
    }];
}


@end
