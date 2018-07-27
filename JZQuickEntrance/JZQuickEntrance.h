//
//  JZQuickEntrance.h
//  JZQuickEntranceDemo
//
//  Created by Joey on 2018/7/26.
//  Copyright © 2018年 Dachen. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, JZEntranceType) {
    JZEntranceTypePush = 0,     // default
    JZEntranceTypePresent = 1,
    JZEntranceTypeNavPresent = 2,
};

@protocol JZQuickEntranceDelegate <NSObject>
@optional
+ (instancetype)instanceForQuickEntrance;
+ (NSUInteger)entranceTypeForQuickEntrance;
@end

@interface JZQuickEntrance : NSObject

+ (void)showInWindow;
+ (void)hide;

@end


@interface UIWindow (JZQuickEntrance)
@end

