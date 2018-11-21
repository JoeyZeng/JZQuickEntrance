//
//  JZSuspendView.m
//  JZQuickEntranceDemo
//
//  Created by Joey on 2018/7/26.
//  Copyright © 2018年 Dachen. All rights reserved.
//

#import "JZSuspendView.h"
#import "JZHelper.h"
#import "JZEntranceTableViewController.h"
#import "JZQuickEntrance.h"

@implementation JZSuspendView

+ (instancetype)instanceAtLastPosition {
    CGRect lastPositionRect = [JZHelper shared].lastSuspendPosition;
    JZSuspendView *instance = [[JZSuspendView alloc] initWithFrame:lastPositionRect];
    return instance;
}

- (instancetype)initWithFrame:(CGRect)frame {
    CGRect f = CGRectMake(frame.origin.x, frame.origin.y, kSuspendLength, kSuspendLength);
    self = [super initWithFrame:f];
    if (self) {
        [self initUI];
    }
    return self;
}

- (void)initUI {
    UIColor *bgColor = [[UIColor greenColor] colorWithAlphaComponent:.5];
    self.backgroundColor = bgColor;
    self.layer.cornerRadius = kSuspendLength/2.f;
    self.layer.masksToBounds = YES;
    
    UIView *centerView = [[UIView alloc] initWithFrame:CGRectInset(self.bounds, 4, 4)];
    centerView.backgroundColor = bgColor;
    centerView.layer.cornerRadius = (kSuspendLength-8)/2.f;
    centerView.layer.masksToBounds = YES;
    centerView.userInteractionEnabled = NO;
    [self addSubview:centerView];
    
    // add gesture
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction)];
    [self addGestureRecognizer:tap];
    
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panAction:)];
    [self addGestureRecognizer:pan];
    
    UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doubleTapAction)];
    [tap requireGestureRecognizerToFail:doubleTap];
    doubleTap.numberOfTapsRequired = 2;
    [self addGestureRecognizer:doubleTap];
}

- (void)didMoveToSuperview {
    [UIView animateWithDuration:.5 animations:^{
        self.backgroundColor = [[UIColor greenColor] colorWithAlphaComponent:.1];
    }];
}

- (void)tapAction {
    [JZQuickEntrance hide];
    JZEntranceTableViewController *vc = [JZEntranceTableViewController new];
    UINavigationController *nc = [[UINavigationController alloc] initWithRootViewController:vc];
    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:nc animated:YES completion:nil];
}

- (void)doubleTapAction {
    // quick enter last vc
    [JZQuickEntrance hide];
    [JZHelper quickEnterViewControllerWithClassName:[JZHelper shared].lastEntranceClassName];
}

- (void)panAction:(UIGestureRecognizer *)sender {
    CGPoint p = [sender locationInView:sender.view.superview];
    if (sender.state == UIGestureRecognizerStateBegan) {
        [UIView animateWithDuration:.2 animations:^{
            self.center = p;
        }];
    } else if (sender.state == UIGestureRecognizerStateChanged) {
        self.center = p;
    } else {
        CGSize screenSize = [UIScreen mainScreen].bounds.size;
        if (p.x < screenSize.width/2) {
            p.x = kSuspendLength/2;
        } else {
            p.x = screenSize.width - kSuspendLength/2;
        }
        if (p.y-kSuspendLength/2 < [UIApplication sharedApplication].statusBarFrame.size.height) {
            p.y = [UIApplication sharedApplication].statusBarFrame.size.height+kSuspendLength/2;
        }
        if (p.y+kSuspendLength/2 > screenSize.height) {
            p.y = screenSize.height-kSuspendLength/2;
        }
        [UIView animateWithDuration:.3 animations:^{
            self.center = p;
        } completion:^(BOOL finished) {
            [JZHelper shared].lastSuspendPosition = self.frame;
        }];
    }
    
}

@end
