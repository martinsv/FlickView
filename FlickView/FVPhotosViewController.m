//
//  FVPhotosViewController.m
//  FlickView
//
//  Created by Armands Lazdiņš on 30/05/14.
//  Copyright (c) 2014 Armands Lazdiņš. All rights reserved.
//

#import "FVPhotosViewController.h"
#import "FVSideMenuViewController.h"
#import "FVLoginViewController.h"
#import "FVAppDelegate.h"
#import "FVMainCollectionView.h"
#import "FVPhotoCell.h"
#import "FVFooterView.h"
#import "FVFadePresentVC.h"
#import "FVFadeDismissVC.h"
#import "FVNavigationBarAnimation.h"
#import "FVViewAnimations.h"
#import "FVCredentials.h"
#import "FVFlickrDataDownloader.h"
#import "FVPhotoObject.h"
#import <MWPhotoBrowser.h>

//VC type keys - initWithType
NSString *const kPhotosVCTypeAllPhotos          = @"photosVCAllPhotos";
NSString *const kPhotosVCTypeAllPhotosetPhotos   = @"photosVCAllGelleryPhotos";

@interface FVPhotosViewController () <UICollectionViewDataSource, UICollectionViewDelegate, UIViewControllerTransitioningDelegate, MWPhotoBrowserDelegate, FVLoginViewControllerDelegate, FVSideMenuViewControllerDelegate>

@property (nonatomic) NSMutableArray *photos;
@property (nonatomic) FVMainCollectionView *mainView;
@property (nonatomic) FVFooterView *footerView;
@property (nonatomic) MWPhotoBrowser *photoBrowser;
@property (nonatomic) FVSideMenuViewController *sideMenu;
@property (nonatomic) BOOL navigationBarIsHidden;
@property (nonatomic) BOOL imageLoadingInProgress;
@property (nonatomic) BOOL userLoggedIn;
@property (nonatomic) BOOL firstControllerLoad;
@property (nonatomic) BOOL isPhotosViewController;
@property (nonatomic) int currentPage;
@property (nonatomic) int totalPages;

@property (nonatomic) NSString *requestType;
@property (nonatomic) NSIndexPath *firstVisibleCell;
@property (nonatomic) CGFloat lastContentOffset;

@end

@implementation FVPhotosViewController

//Lazy load
-(NSMutableArray *)photos
{
    if (!_photos) _photos = [[NSMutableArray alloc] init];
    return _photos;
}
-(MWPhotoBrowser *)photoBrowser
{
    if (!_photoBrowser) {
        _photoBrowser = [[MWPhotoBrowser alloc] initWithDelegate:self];
        [self photoBrowserSettings];
    }
    return _photoBrowser;
}
-(FVMainCollectionView *)mainView
{
    if (!_mainView) _mainView = [[FVMainCollectionView alloc] init];
    return _mainView;
}
-(FVFooterView *)footerView
{
    if (!_footerView) _footerView = [[FVFooterView alloc] init];
    return _footerView;
}
//
-(id)initWithType:(NSString *)type
{
    self = [super init];
    if (self) {
        if ([type isEqual:kPhotosVCTypeAllPhotos]) {
            //Style - Photos
            self.requestType = kFlickrAPIRequestAllPhotosKey;
            [self checkForLoggedUser]; //Check for logged user
            self.isPhotosViewController = YES;
            self.firstControllerLoad = YES;
        } else if ([type isEqual:kPhotosVCTypeAllPhotosetPhotos]) {
            //Style - Photoset
            self.requestType = kFlickrAPIRequestAllPhotosInPhotosetKey;
            self.isPhotosViewController = NO;
            self.userLoggedIn = YES;
            self.firstControllerLoad = NO;
        }
    }
    return self;
}
//Setup subclass
-(void)loadView
{
    //Add UIBarButtonItem
    [self addBarButtonItem];
    //Setup root view
    self.view = self.mainView;
}
//

- (void)viewDidLoad
{
    [super viewDidLoad];
    //Setup viewController
    [self setupVC];
    //Listen to changes in application state
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(applicationEnteredForeground:)
                                                 name:UIApplicationWillEnterForegroundNotification
                                               object:nil];
    
    //Start to load images if user is logged in
    if (self.userLoggedIn || [self.requestType isEqual:kFlickrAPIRequestAllPhotosInPhotosetKey])
        [self loadImagesFromFlickr]; //Load image list from Flickr
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //Show navigationBar
    if (self.navigationBarIsHidden) [self changeNavigationBarState:kNavigationBarShow];
    //Update collectionView Edge Insets
    if (![self.navigationController.navigationBar isHidden] && !self.navigationBarIsHidden) [self updateCollectionViewContentInsets];
    //Update layout
    [self.mainView.collectionView.collectionViewLayout invalidateLayout];
    //Hide navBar before view is visible, for first load
    if (self.firstControllerLoad) [self.navigationController setNavigationBarHidden:YES animated:NO];
}
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    //If no user is logged in, present loginVC from sideMenuVC.
    if (!self.userLoggedIn) [self presentViewController:self.sideMenu.loginVC animated:YES completion:^{
        //Reset VC data for new user
        [self resetController];
    }];
    //Disable panGestureRecognizer if not photosVC
    if (!self.isPhotosViewController) [[self sideMenuControllerFromAppDelegate] setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeNone];
    else [[self sideMenuControllerFromAppDelegate] setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeAll];
    //Show navigation bar - animated
    if ([self.navigationController.navigationBar isHidden] && self.userLoggedIn) [self.navigationController setNavigationBarHidden:NO animated:YES];
    //Update BOOL so navBar does not get hidden anymore
    self.firstControllerLoad = NO;
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    //Show navigationBar
    if (self.navigationBarIsHidden) [self changeNavigationBarState:kNavigationBarShow];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    NSLog(@"FVPhotosViewController received memory warning!");
}


#pragma mark - UICollectionView D/D

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self.photos count];
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    FVPhotoCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    //Get current object
    FVPhotoObject *photoObject = self.photos[indexPath.row];
    //Update cell class
    cell.photo = photoObject;
    //Load thumb image
    [cell loadPhoto];
    //Call load more at last row
    if (indexPath.row == [self.photos count]-1) {
        [self loadImagesFromFlickr];
    }
    return cell;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    //Set item size according to item count and interItem spacing
    CGFloat itemSize;
    CGFloat lineSpacingSize;
    //Check for device orientation
    if ([[UIApplication sharedApplication] statusBarOrientation] == UIInterfaceOrientationPortrait || ([[UIApplication sharedApplication] statusBarOrientation] == UIInterfaceOrientationPortraitUpsideDown)) {
        //Portrait Orientation
        itemSize = [self calculateItemSizeForCollectionViewAtOrientation:kDeviceOrientationPortrait];
        lineSpacingSize = [self calculateLineSpacingForCollectionViewAtOrientation:kDeviceOrientationPortrait andItemSize:itemSize];
    }
    else if ([[UIApplication sharedApplication] statusBarOrientation] == UIInterfaceOrientationLandscapeLeft|| ([[UIApplication sharedApplication] statusBarOrientation] == UIInterfaceOrientationLandscapeRight)){
        //Landscape Orientation
        itemSize = [self calculateItemSizeForCollectionViewAtOrientation:kDeviceOrientationLandscape];
        lineSpacingSize = [self calculateLineSpacingForCollectionViewAtOrientation:kDeviceOrientationLandscape andItemSize:itemSize];
    }
    self.mainView.flowLayout.minimumLineSpacing = lineSpacingSize; // Adjust line spacing to form a perfect grid
    return CGSizeMake(itemSize, itemSize);
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    //Create navigationController for photoBrowser - required.
    UINavigationController *browserController = [[UINavigationController alloc] initWithRootViewController:self.photoBrowser];
    //Set indexPath for photoBrowser
    [self.photoBrowser setCurrentPhotoIndex:indexPath.row];
    //Set transitionDelegate and presentationStyle
    //Having some probmes with CT in iOS 8. Disabling for now.
    browserController.modalPresentationStyle = UIModalTransitionStyleCrossDissolve;
    //browserController.transitioningDelegate = self;
    //Present
    [self presentViewController:browserController animated:YES completion:^{
        //Completion
    }];
}
-(UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    if (kind == UICollectionElementKindSectionFooter) {
        //Dequeue footerView
        self.footerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"Footer" forIndexPath:indexPath];
        return self.footerView;
    }
    return nil;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section
{
    return CGSizeMake(collectionView.frame.size.width, 50);
}

- (void)scrollViewDidScroll:(UIScrollView*)scrollView
{
    CGPoint velocity = [scrollView.panGestureRecognizer velocityInView:scrollView];
    CGPoint translate = [scrollView.panGestureRecognizer translationInView:scrollView];
    //Show or Hide navigationBar when scrolling
    if (translate.y < 0) self.lastContentOffset = scrollView.contentOffset.y;
    if (scrollView.contentOffset.y > 150 && velocity.y < 0 && translate.y <= 0 && self.navigationBarIsHidden == NO){
        [self changeNavigationBarState:kNavigationBarHide];
    }
    else if (self.lastContentOffset - 100 > scrollView.contentOffset.y && velocity.y > 0 && self.navigationBarIsHidden == YES) [self changeNavigationBarState:kNavigationBarShow];
}

#pragma mark - PhotoBrowser Delegates

- (NSUInteger)numberOfPhotosInPhotoBrowser:(MWPhotoBrowser *)photoBrowser {
    return [self.photos count];
}

- (id <MWPhoto>)photoBrowser:(MWPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index {
    if (index < [self.photos count]){
        if (index == [self.photos count] - 6) [self loadImagesFromFlickr]; // Call load more while browsing photos.
        return [self.photos objectAtIndex:index];
    }
    return nil;
}

#pragma mark - Helper Methods

- (void)resetController
{
    //Reset all keys
    self.currentPage = 0;
    self.totalPages = 1;
    self.userLoggedIn = NO;
    self.firstControllerLoad = YES;
    
    //Remove all user data
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:kFlickrUserID];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:kFlickrUserName];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    //Clear photos array and reload collectionvView
    [self.photos removeAllObjects];
    [self.mainView.collectionView reloadData];
}

- (void)setupVC
{
    //Main setup
    self.navigationBarIsHidden = NO;
    self.imageLoadingInProgress = NO;
    self.currentPage = 0; // Placeholder for first load
    self.totalPages = 1; // Placeholder for first load
    
    //CollectionView setup
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.mainView.collectionView.dataSource = self;
    self.mainView.collectionView.delegate = self;
    
    //Register classes for collectionView
    [self.mainView.collectionView registerClass:[FVPhotoCell class] forCellWithReuseIdentifier:@"Cell"]; // Cell class
    [self.mainView.collectionView registerClass:[FVFooterView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"Footer"]; // Footer class
    
    //Setup sideMenuViewController delegate from appDelegate
    FVAppDelegate *appDelegate = (FVAppDelegate *)[[UIApplication sharedApplication] delegate];
    self.sideMenu = appDelegate.sideMenuViewController;
    self.sideMenu.delegate = self;
    
}
- (void)checkForLoggedUser
{
    if ([[NSUserDefaults standardUserDefaults] objectForKey:kFlickrUserID]) {
        //User logged in
        self.title = [[NSUserDefaults standardUserDefaults] objectForKey:kFlickrUserName];
        self.taskID = [[NSUserDefaults standardUserDefaults] objectForKey:kFlickrUserID];
        self.userLoggedIn = YES;
    } else self.userLoggedIn = NO; // No user
}

- (void)addBarButtonItem
{
    //Add UIBarButtonItem - leftBarButton
    UIImage *barButtonItemImage = [[UIImage alloc] init];
    if (self.isPhotosViewController) {
        //Add barButtonItem - menuButtonItem
        barButtonItemImage = [UIImage imageNamed:@"menuButton"];
    } else {
        //Add backButtonItem
        barButtonItemImage = [UIImage imageNamed:@"backButton"];
        self.navigationController.interactivePopGestureRecognizer.delegate = (id)self;
    }
    UIBarButtonItem *leftBarButton = [[UIBarButtonItem alloc] initWithImage:barButtonItemImage style:UIBarButtonItemStylePlain target:self action:@selector(leftBarButtonPressed:)];
    self.navigationItem.leftBarButtonItem = leftBarButton;
}

- (void)leftBarButtonPressed:(UIBarButtonItem *)sender
{
    //Menu bar button pressed - allPhotos style
    if (self.isPhotosViewController) [[self sideMenuControllerFromAppDelegate] toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
    else [self.navigationController popViewControllerAnimated:YES];
}
- (MMDrawerController *)sideMenuControllerFromAppDelegate
{
    //Get app delegate
    FVAppDelegate *appDelegate = (FVAppDelegate *)[[UIApplication sharedApplication] delegate];
    //Return sideMenuDrawerController
    return appDelegate.sideMenuDrawer;
}
- (void)updateCollectionViewContentInsets
{
    //Add content insets for collectionView
    CGFloat topInset = self.navigationController.navigationBar.frame.size.height + self.navigationController.navigationBar.frame.origin.y;
    [self.mainView.collectionView setContentInset:UIEdgeInsetsMake(topInset, 0, 0, 0)];
}
- (void)loadImagesFromFlickr
{
    //Check if loading is in progress
    if (self.imageLoadingInProgress) return;
    self.imageLoadingInProgress = YES;
    
    //Load more increment
    if (self.currentPage < self.totalPages) self.currentPage += 1;
    else {
        //All content is loaded
        [self.footerView.doneLoadingLabel setHidden:NO];
        return;
    }
    
    //Check if it's the first load/not. Show activity indicator in footer.
    if (self.currentPage > 1) [self.footerView.activityIndicator startAnimating];
    else if (self.currentPage == 1) {
        // First load, clear array and reload collectionView
        [self.photos removeAllObjects];
        [self.mainView.collectionView reloadData];
    }
    
    //Get API Key from KeyChain
    NSDictionary *credentials = [[FVCredentials sharedCredentials] getCredentials];
    
    //Download image list from Flickr(JSON)
    [FVFlickrDataDownloader getImageListFromFlickerForRequestType:self.requestType forAPIKey:credentials[kAPIKey] forTaskID:self.taskID forPage:self.currentPage perPage:102 completion:^(NSArray *location, int currentPage, int totalPages, NSError *error) {
        if (!error) {
            self.currentPage = currentPage;
            self.totalPages = totalPages;
            [self updateCollectionViewAndPhotoBroweser:location];
        } else {
            NSLog(@"Error downloading image list from Flickr");
        }
    }];
}

- (void)updateCollectionViewAndPhotoBroweser:(NSArray *)location
{
    //Perform all neccessary tasks on background thread
    dispatch_queue_t backgroundQueue = dispatch_queue_create("BackgroundQueue", NULL);
    dispatch_async(backgroundQueue, ^{
        //Create FVPhoto objects
        NSMutableArray *FVPhotoObjects = [NSMutableArray array];
        for (NSDictionary *data in location) {
            FVPhotoObject *photoObject = [[FVPhotoObject alloc] initWithData:data andStyle:kFlickrThumbStylePhoto];
            [FVPhotoObjects addObject:photoObject];
        }
        //Create indexPaths for collectionView
        NSMutableArray *indexes = [NSMutableArray array];
        for (int x = 0; x < [location count]; x++) {
            NSIndexPath *index = [NSIndexPath indexPathForItem:[self.photos count] + x inSection:0];
            [indexes addObject:index];
        }
        //Update collectionView/photoBroweser. Main thread
        [self.photos addObjectsFromArray:FVPhotoObjects];
        dispatch_async(dispatch_get_main_queue(), ^{
            if ([self.footerView.activityIndicator isAnimating]) [self.footerView.activityIndicator stopAnimating];
            [self.mainView.collectionView insertItemsAtIndexPaths:indexes];
            [self.photoBrowser reloadData];
            self.imageLoadingInProgress = NO;
        });
    });
}

- (CGFloat)calculateItemSizeForCollectionViewAtOrientation:(NSString *)orientation
{
    //Calculate item size for photos VC
    CGFloat itemSize;
    if ([orientation isEqual:kDeviceOrientationPortrait]) {
        itemSize = (int)(self.mainView.collectionView.frame.size.width - kPhotoCollectionViewInterItemSpacing *(kPhotoCollectionViewNumberOfItemsInPortrait - 1)) / kPhotoCollectionViewNumberOfItemsInPortrait;
    }
    else if ([orientation isEqual:kDeviceOrientationLandscape]) {
        itemSize = (int)(self.mainView.collectionView.frame.size.width - kPhotoCollectionViewInterItemSpacing *(kPhotoCollectionViewNumberOfItemsInLandscape - 1)) / kPhotoCollectionViewNumberOfItemsInLandscape;
    }
    return itemSize;
}
- (CGFloat)calculateLineSpacingForCollectionViewAtOrientation:(NSString *)orientation andItemSize:(CGFloat)itemSize
{
    //Calculate lineSpacing offset to form a perfect grid.
    CGFloat lineSpacing;
    if ([orientation isEqual:kDeviceOrientationPortrait]) {
        lineSpacing = (self.mainView.collectionView.frame.size.width  - itemSize * kPhotoCollectionViewNumberOfItemsInPortrait) / (kPhotoCollectionViewNumberOfItemsInPortrait - 1);
    } else if ([orientation isEqual:kDeviceOrientationLandscape]) {
        lineSpacing = (self.mainView.collectionView.frame.size.width - itemSize * kPhotoCollectionViewNumberOfItemsInLandscape) / (kPhotoCollectionViewNumberOfItemsInLandscape - 1);
    }
    
    return lineSpacing;
}

- (void)photoBrowserSettings
{
    //Options
    self.photoBrowser.displayActionButton = YES; // Show action button to allow sharing, copying, etc (defaults to YES)
    self.photoBrowser.displayNavArrows = NO; // Whether to display left and right nav arrows on toolbar (defaults to NO)
    self.photoBrowser.displaySelectionButtons = NO; // Whether selection buttons are shown on each image (defaults to NO)
    self.photoBrowser.zoomPhotosToFill = YES; // Images that almost fill the screen will be initially zoomed to fill (defaults to YES)
    self.photoBrowser.alwaysShowControls = NO; // Allows to control whether the bars and controls are always visible or whether they fade away to show the photo full (defaults to NO)
    self.photoBrowser.enableGrid = NO; // Whether to allow the viewing of all the photo thumbnails on a grid (defaults to YES)
    self.photoBrowser.startOnGrid = NO; // Whether to start on the grid of thumbnails instead of the first photo (defaults to NO)
}

- (NSIndexPath *)getFirstIndexPathForVisibleCells
{
    //Get first indexPath for visible cells
    NSArray *indexPathsOfVisibleStories = [self.mainView.collectionView indexPathsForVisibleItems];
    NSArray *sortedIndexPaths = [indexPathsOfVisibleStories sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        NSIndexPath *path1 = (NSIndexPath *)obj1;
        NSIndexPath *path2 = (NSIndexPath *)obj2;
        return [path1 compare:path2];
    }];
    return [sortedIndexPaths firstObject];
}
- (void)changeNavigationBarState:(NSString *)state
{
    [FVNavigationBarAnimation changeNavigationBarState:self.navigationController changeTo:state completion:^(BOOL navigationBarIsHidden) {
        self.navigationBarIsHidden = navigationBarIsHidden;
    }];
}

#pragma mark - CTLoginViewController Delegate
//Called when user data is received
-(void)userLoginComplete
{
    //Update UI and taskID
    self.title = [[NSUserDefaults standardUserDefaults] objectForKey:kFlickrUserName];
    self.taskID = [[NSUserDefaults standardUserDefaults] objectForKey:kFlickrUserID];
    self.userLoggedIn = YES;
    
    //Dismiss loginVC and start loading images
    [self dismissViewControllerAnimated:YES completion:^{
        //Start to load images.
        [self loadImagesFromFlickr];
    }];
    
}

#pragma mark - CTSideMenuViewController Delegate
//Called when user selects logoutButton from sideMenuViewController
-(void)logoutButtonPressed
{
    //Rest controller for next login
    [self resetController];
    //Hide navBar for next login animation.
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}
//Called when sideMenu willAppear
-(void)sideMenuWillAppear
{
    //Show navigationBar
    if (self.navigationBarIsHidden) [self changeNavigationBarState:kNavigationBarShow];
}


#pragma mark - ViewController Delegates

- (void)applicationEnteredForeground:(NSNotification *)notification {
    if (self.navigationBarIsHidden) [self changeNavigationBarState:kNavigationBarShow];
}

-(void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    //Device will rotate - called before rotation
    if (self.navigationBarIsHidden == YES) self.navigationBarIsHidden = NO; //Reset navigationBar BOOL
    self.firstVisibleCell = [self getFirstIndexPathForVisibleCells]; // Get first visible cell
    [self.mainView.collectionView.collectionViewLayout invalidateLayout]; // Update collectionView layout
}
-(void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    //Device will rotate, animated - called while/after rotation
    [self updateCollectionViewContentInsets];
    //For some reasons this method is not working properly. Even when added to didRotateToInterfaceOrientation
    if ([self.photos count] !=0)[self.mainView.collectionView scrollToItemAtIndexPath:self.firstVisibleCell atScrollPosition:UICollectionViewScrollPositionTop animated:YES]; //Scroll to to first visible cell before rotation
}

#pragma mark - Transition Delegates

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source {
    return [[FVFadePresentVC alloc] init];
}
- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed {
    return [[FVFadeDismissVC alloc] init];
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
