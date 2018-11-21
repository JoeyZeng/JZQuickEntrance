# JZQuickEntrance
A tool for prject developing. An Entrance for any viewcontroller in project.

# Usage
**Import nothing, it just works**
- It will run in **DEBUG** model(develop env). A suspend button appear in the edge of window.
![shortcut1](https://github.com/JoeyZeng/JZQuickEntrance/blob/master/shortcut/QQ20180727-141800.png)
- Showing up a list of all viewcontrollers when clicking the suspend button.
![shortcut2](https://github.com/JoeyZeng/JZQuickEntrance/blob/master/shortcut/QQ20180727-141859.png)
- Now, you can find the viewcontroller you want to enter by searching or in hostory. Default initializion is `new` and enter by `push`. Otherwise, config by adding:
```objc
@protocol JZQuickEntranceDelegate <NSObject>
@optional
+ (instancetype)instanceForQuickEntrance;
+ (NSUInteger)entranceTypeForQuickEntrance;
@end

+ (instancetype)instanceForQuickEntrance {
    ViewController *vc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:NSStringFromClass([ViewController class])];
    vc.title = @"From-QuickEntrance";
    return vc;
}

+ (NSUInteger)entranceTypeForQuickEntrance {
    return 2;
}

+ (void)customEnterActionForQuickEntrance:(UINavigationController *)nc {
    UIViewController *vc = [UIViewController new];
    nc.definesPresentationContext = YES;
    vc.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    [nc presentViewController:vc animated:NO completion:nil];
}
```
- There is a quick way to enter last viewcontroller by double click the suspend button.

