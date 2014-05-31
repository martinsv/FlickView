//
//  FVSideMenuViewController.m
//  FlickView
//
//  Created by Armands Lazdiņš on 30/05/14.
//  Copyright (c) 2014 Armands Lazdiņš. All rights reserved.
//

#import "FVSideMenuViewController.h"
#import "FVLoginViewController.h"
#import "FVAppDelegate.h"
#import "FVMainSideMenuView.h"
#import "FVSideMenuCell.h"
#import "FVMenuItem.h"

@interface FVSideMenuViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic) FVMainSideMenuView *mainView;
@property (nonatomic) NSMutableArray *menuItems;
@property (nonatomic) NSIndexPath *lastIndexPath;
@property (nonatomic) BOOL userLoggedIn;

@end

@implementation FVSideMenuViewController

//Lazy load
-(FVMainSideMenuView *)mainView
{
    if (!_mainView) _mainView = [[FVMainSideMenuView alloc] init];
    return _mainView;
}
-(NSMutableArray *)menuItems
{
    if (!_menuItems) _menuItems = [[NSMutableArray alloc] initWithCapacity:2];
    return _menuItems;
}
//
-(void)loadView
{
    //Setup root view
    self.view = self.mainView;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    //Setup VC
    [self setupVC];
    //Create menuItems
    [self createMenuItems];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //Update tableView edge insets
    [self updateTableViewContentInsets];
    //Select row at last known indexPath
    [self.mainView.tableView selectRowAtIndexPath:self.lastIndexPath animated:NO scrollPosition:0];
    //Notify photoVC when viewWillAppear - sideMenu will be pulled
    [self.delegate sideMenuWillAppear];
    
}
-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    //Deselect row
    [self.mainView.tableView deselectRowAtIndexPath:self.lastIndexPath animated:NO];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    NSLog(@"FVSideMenuView received memmory warning");
}

#pragma mark - UITableView D/D

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.menuItems count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FVSideMenuCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    FVMenuItem *menuItem = self.menuItems[indexPath.row];
    
    cell.iconImageView.image = menuItem.icon;
    cell.titleLabel.text = menuItem.name;
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //Get selectedItem and sideMenuController from appDelegate
    FVMenuItem *selectedItem = self.menuItems[indexPath.row];
    MMDrawerController *sideMenuController = [self sideMenuControllerFromAppDelegate];
    
    //Check for indexPath
    if ([self.lastIndexPath isEqual:indexPath]) {
        //Same indexPath as last, toggle sideMenu
        [sideMenuController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
    }
    else {
        //New indexPath, set new centerVC, fullCloseAnimation
        [sideMenuController setCenterViewController:selectedItem.navigationController withFullCloseAnimation:YES completion:nil];
        //Update indexPath
        self.lastIndexPath = indexPath;
    }
}

#pragma mark - Helper Methods

- (void)setupVC
{
    //setup tableView
    self.mainView.tableView.dataSource = self;
    self.mainView.tableView.delegate = self;
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    //Setup loginVC
    self.loginVC = [[FVLoginViewController alloc] init];
    self.loginVC.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    
    //Create default indexPath
    self.lastIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    
    //Register classes for tableView
    [self.mainView.tableView registerClass:[FVSideMenuCell class] forCellReuseIdentifier:@"Cell"];
    
    //Add target to logoutButton
    [self.mainView.logoutButton addTarget:self action:@selector(didSelectLogoutButton:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)updateTableViewContentInsets
{
    //Add content insets for tableView
    CGFloat topInset = self.view.bounds.size.height *(kSideMenuTableViewHeightInsetPercent/100) ;
    [self.mainView.tableView setContentInset:UIEdgeInsetsMake(topInset, 0, 0, 0)];
}

- (void)createMenuItems
{
    //Get all menuItems from CTMenuItemList
    for (NSDictionary *itemList in [FVMenuItemList allMenuItems]) {
        FVMenuItem *item = [[FVMenuItem alloc] initWithMenuItem:itemList];
        [self.menuItems addObject:item];
    }
}

- (MMDrawerController *)sideMenuControllerFromAppDelegate
{
    //Get app delegate
    FVAppDelegate *appDelegate = (FVAppDelegate *)[[UIApplication sharedApplication] delegate];
    //Return sideMenuDrawerController
    return appDelegate.sideMenuDrawer;
}

#pragma mark - CTSideMenuViewController Delegates

- (void)didSelectLogoutButton:(UIButton *)sender
{
    [[self sideMenuControllerFromAppDelegate] toggleDrawerSide:MMDrawerSideLeft animated:YES completion:^(BOOL finished) {
        //Done
        if (finished) {
            //Present VC
            [self presentViewController:self.loginVC animated:YES completion:^{
                //Clean up collectionView for new content
                FVMenuItem *currentItem = self.menuItems[0];
                [[self sideMenuControllerFromAppDelegate] setCenterViewController:currentItem.navigationController];
                self.lastIndexPath = [NSIndexPath indexPathForItem:0 inSection:0];
                [self.delegate logoutButtonPressed];
            }];
        }
    }];
}

#pragma mark - Delegates

-(void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    //Device will rotate, animated - called while/after rotation
    [self updateTableViewContentInsets];
}

-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
