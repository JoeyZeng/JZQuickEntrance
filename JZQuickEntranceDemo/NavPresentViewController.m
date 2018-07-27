//
//  NavPresentViewController.m
//  JZQuickEntranceDemo
//
//  Created by Joey on 2018/7/27.
//  Copyright © 2018年 Dachen. All rights reserved.
//

#import "NavPresentViewController.h"

@interface NavPresentViewController ()

@end

@implementation NavPresentViewController

+ (instancetype)instanceForQuickEntrance {
    NavPresentViewController *vc = [NavPresentViewController new];
    vc.title = @"From-QuickEntrance";
    return vc;
}

+ (NSUInteger)entranceTypeForQuickEntrance {
    return 2;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Dismiss" style:UIBarButtonItemStylePlain target:self action:@selector(dismissAction)];
    
    self.view.backgroundColor = [UIColor orangeColor];
}

- (void)dismissAction {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
