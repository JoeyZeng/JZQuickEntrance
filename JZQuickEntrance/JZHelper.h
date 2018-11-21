//
//  JZDataCache.h
//  JZQuickEntranceDemo
//
//  Created by Joey on 2018/7/26.
//  Copyright © 2018年 Dachen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

static const CGFloat kSuspendLength = 60.f;
static const int kHistoryLimit = 5;

@interface JZHelper : NSObject
@property (nonatomic) CGRect lastSuspendPosition;
@property (nonatomic, strong) NSString *lastEntranceClassName;

@property (nonatomic, strong) NSArray <NSString *>*historyClassArray;   // count limit is 5

@property (nonatomic, strong) NSArray <NSString *>*additionImageClassNameArray; // default load main bundle vcs, addition for other framework

+ (instancetype)shared;

+ (void)quickEnterViewControllerWithClassName:(NSString *)className navigationController:(UINavigationController *)nc;
+ (void)quickEnterViewControllerWithClassName:(NSString *)className;

@end
