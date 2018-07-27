//
//  JZEntranceTableViewController.m
//  JZQuickEntranceDemo
//
//  Created by Joey on 2018/7/26.
//  Copyright © 2018年 Dachen. All rights reserved.
//

#import "JZEntranceTableViewController.h"
#import <objc/runtime.h>
#import <dlfcn.h>
#import <mach-o/ldsyms.h>
#import "JZHelper.h"
#import "JZQuickEntrance.h"

@interface JZEntranceTableViewController () <UISearchBarDelegate>
@property (nonatomic, strong) NSMutableArray *allDataArray;
@property (nonatomic, strong) NSMutableArray *searchDataArray;
@property (nonatomic, strong) NSArray *historyDataArray;
@property (nonatomic) BOOL isSearching;
@end

@implementation JZEntranceTableViewController

- (void)dealloc {
    [JZQuickEntrance showInWindow];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    [self initUI];
    [self initData];
}

- (void)initUI {
    self.title = @"Quick Entrance";
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain target:self action:@selector(dismiss)];
    
    // search bar
    UISearchBar *searchBar = [UISearchBar new];
    searchBar.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 50);
    searchBar.searchBarStyle = UISearchBarStyleMinimal;
    searchBar.delegate = self;
    self.tableView.tableHeaderView = searchBar;
}

- (void)dismiss {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)initData {
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        unsigned int count;
        const char **classes;
        Dl_info info;
        
        dladdr(&_mh_execute_header, &info);
        classes = objc_copyClassNamesForImage(info.dli_fname, &count);
        
        NSMutableArray *vcs = [NSMutableArray new];
        // reverse traversal, so as the newest class arrange at first
        for (int i = count-1; i >= 0; i--) {
            //        NSLog(@"Class Name: %s", classes[i]);
            NSString *className = [NSString stringWithCString:classes[i] encoding:NSUTF8StringEncoding];
            Class class = NSClassFromString (className);
            if ([class isSubclassOfClass:[UIViewController class]]) {
                if (![className isEqualToString:NSStringFromClass([JZEntranceTableViewController class])]) {
                    [vcs addObject:className];
                }
            }
        }
        NSLog(@"Class Count: %ld", vcs.count);
        self.allDataArray = vcs;
        self.searchDataArray = vcs;
        
        self.historyDataArray = [JZHelper shared].historyClassArray;
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
    });
    
}

- (void)refreshHistory {
    self.historyDataArray = [JZHelper shared].historyClassArray;
    [self.tableView reloadData];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        if (self.isSearching) {
            return 0;
        } else {
            return self.historyDataArray.count;
        }
    } else {
        return self.searchDataArray.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellId = @"cellId";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    
    // Configure the cell...
    if (indexPath.section == 0) {
        cell.textLabel.text = self.historyDataArray[indexPath.row];
    } else {
        cell.textLabel.text = self.searchDataArray[indexPath.row];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSString *className = nil;
    if (indexPath.section == 0) {
        className = self.historyDataArray[indexPath.row];
    } else {
       className = self.searchDataArray[indexPath.row];
    }
    [JZHelper quickEnterViewControllerWithClassName:className navigationController:self.navigationController];
    
    [self refreshHistory];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        if (self.isSearching) {
            return nil;
        }
        return @"History";
    } else {
        if (self.isSearching) {
            return @"Search";
        }
        return @"All";
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return nil;
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self.view endEditing:YES];
}

#pragma mark - UISearchBarDelegate

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    if (searchText.length > 0) {
        self.isSearching = YES;
        self.searchDataArray = [self.allDataArray filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"SELF CONTAINS[cd] %@", searchText]].mutableCopy;
        [self.tableView reloadData];
    } else {
        self.isSearching = NO;
        self.searchDataArray = self.allDataArray;
        [self.tableView reloadData];
    }
}

@end
