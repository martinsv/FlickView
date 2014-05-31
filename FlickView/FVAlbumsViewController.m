//
//  FVAlbumsViewController.m
//  FlickView
//
//  Created by Armands Lazdiņš on 30/05/14.
//  Copyright (c) 2014 Armands Lazdiņš. All rights reserved.
//

#import "FVAlbumsViewController.h"
#import "FVAlbumsViewController.h"
#import "FVPhotosViewController.h"
#import "FVAppDelegate.h"
#import "FVMainCollectionView.h"
#import "FVAlbumCell.h"
#import "FVFooterView.h"
#import "FVCredentials.h"
#import "FVFlickrDataDownloader.h"
#import "FVPhotoObject.h"

@interface FVAlbumsViewController () <UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic) FVMainCollectionView *mainView;
@property (nonatomic) FVFooterView *footerView;
@property (nonatomic) NSString *taskID;
@property (nonatomic) NSMutableArray *albums;
@property (nonatomic) NSIndexPath *firstVisibleCell;
@property (nonatomic) int currentPage;
@property (nonatomic) int totalPages;
@property (nonatomic) BOOL imageLoadingInProgress;

@end

@implementation FVAlbumsViewController

//Lazy load
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
-(NSMutableArray *)albums
{
    if (!_albums) _albums = [[NSMutableArray alloc] init];
    return _albums;
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
    //Load image list from Flickr
    [self loadImagesFromFlickr];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //Update collectionView edgeInsets
    [self updateCollectionViewContentInsets];
    //Enable panGestureRecognizer
    [[self sideMenuControllerFromAppDelegate] setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeAll];
    //Update layout
    [self.mainView.collectionView.collectionViewLayout invalidateLayout];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    NSLog(@"FVAlbumsViewController received memmory warning");
}

#pragma mark - UICollectionView D/D

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self.albums count];
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    FVAlbumCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    //Get current object
    FVPhotoObject *photoObject = self.albums[indexPath.row];
    //Update cell class
    cell.photo = photoObject;
    //Load thumb image
    [cell loadPhoto];
    
    //Perform load more at last row
    if (indexPath.row == [self.albums count]-1) {
        [self loadImagesFromFlickr];
    }
    
    return cell;
}
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    //Create border around collectionView
    return UIEdgeInsetsMake(kAlbumCollectionViewItemSpacing, kAlbumCollectionViewItemSpacing, 0, kAlbumCollectionViewItemSpacing);
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
    //Adjust line spacing to form a perfect grid
    self.mainView.flowLayout.minimumLineSpacing = lineSpacingSize;
    return CGSizeMake(itemSize, itemSize);
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    //Allocate new instance of photosVC, with type - AllPhotosetPhotos
    FVPhotosViewController *photosVC = [[FVPhotosViewController alloc] initWithType:kPhotosVCTypeAllPhotosetPhotos];
    //Get selected object - photoset
    FVPhotoObject *currentObject = self.albums[indexPath.row];
    //Set targetVC title and taskID - photosetID
    photosVC.title = currentObject.photoTitle;
    photosVC.taskID = currentObject.photosetID;
    
    //Push to photosVC
    [self.navigationController pushViewController:photosVC animated:YES];
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

#pragma mark - Helper Methods

- (void)setupVC
{
    //Main setup
    self.imageLoadingInProgress = NO;
    self.currentPage = 0; // Placeholder for first load
    self.totalPages = 1; // Placeholder for first load
    self.title = @"Albums";
    self.taskID = [[NSUserDefaults standardUserDefaults] objectForKey:kFlickrUserID];
    
    //CollectionView setup
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.mainView.collectionView.dataSource = self;
    self.mainView.collectionView.delegate = self;
    
    //Register classes for collectionView
    [self.mainView.collectionView registerClass:[FVAlbumCell class] forCellWithReuseIdentifier:@"Cell"]; // Cell class
    [self.mainView.collectionView registerClass:[FVFooterView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"Footer"]; // Footer class
    
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
        [self.albums removeAllObjects];
        [self.mainView.collectionView reloadData];
    }
    
    //Get API Key from KeyChain
    NSDictionary *credentials = [[FVCredentials sharedCredentials] getCredentials];
    
    //Download image list from Flickr(JSON)
    [FVFlickrDataDownloader getImageListFromFlickerForRequestType:kFlickrAPIRequestAllPhotosetsKey forAPIKey:credentials[kAPIKey] forTaskID:self.taskID forPage:self.currentPage perPage:102 completion:^(NSArray *location, int currentPage, int totalPages, NSError *error) {
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
            FVPhotoObject *photoObject = [[FVPhotoObject alloc] initWithData:data andStyle:kFlickrThumbStylePhotoset];
            [FVPhotoObjects addObject:photoObject];
        }
        //Create indexPaths for collectionView
        NSMutableArray *indexes = [NSMutableArray array];
        for (int x = 0; x < [location count]; x++) {
            NSIndexPath *index = [NSIndexPath indexPathForItem:[self.albums count] + x inSection:0];
            [indexes addObject:index];
        }
        //Update collectionView/photoBroweser. Main thread
        [self.albums addObjectsFromArray:FVPhotoObjects];
        dispatch_async(dispatch_get_main_queue(), ^{
            if ([self.footerView.activityIndicator isAnimating]) [self.footerView.activityIndicator stopAnimating];
            [self.mainView.collectionView insertItemsAtIndexPaths:indexes];
            self.imageLoadingInProgress = NO;
        });
    });
}

- (void)updateCollectionViewContentInsets
{
    //Add edge insets for collectionView
    CGFloat topInset = self.navigationController.navigationBar.frame.size.height + self.navigationController.navigationBar.frame.origin.y;
    [self.mainView.collectionView setContentInset:UIEdgeInsetsMake(topInset, 0, 0, 0)];
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

- (CGFloat)calculateItemSizeForCollectionViewAtOrientation:(NSString *)orientation
{
    //Calculate item size for collectionView
    CGFloat itemSize;
    if ([orientation isEqual:kDeviceOrientationPortrait]) {
        itemSize = (int)((self.mainView.collectionView.frame.size.width - kAlbumCollectionViewItemSpacing * 2) - kAlbumCollectionViewItemSpacing *(kAlbumCollectionViewNumberOfItemsInPortrait - 1)) / kAlbumCollectionViewNumberOfItemsInPortrait;
    }
    else if ([orientation isEqual:kDeviceOrientationLandscape]) {
        itemSize = (int)((self.mainView.collectionView.frame.size.width - kAlbumCollectionViewItemSpacing * 2) - kAlbumCollectionViewItemSpacing *(kAlbumCollectionViewNumberOfItemsInLandscape - 1)) / kAlbumCollectionViewNumberOfItemsInLandscape;
    }
    return itemSize;
}
- (CGFloat)calculateLineSpacingForCollectionViewAtOrientation:(NSString *)orientation andItemSize:(CGFloat)itemSize
{
    //Calculate lineSpacing for collectionView
    CGFloat lineSpacing;
    if ([orientation isEqual:kDeviceOrientationPortrait]) {
        lineSpacing = ((self.mainView.collectionView.frame.size.width - kAlbumCollectionViewItemSpacing * 2)  - itemSize * kAlbumCollectionViewNumberOfItemsInPortrait) / (kAlbumCollectionViewNumberOfItemsInPortrait - 1);
    } else if ([orientation isEqual:kDeviceOrientationLandscape]) {
        lineSpacing = ((self.mainView.collectionView.frame.size.width - kAlbumCollectionViewItemSpacing * 2)  - itemSize * kAlbumCollectionViewNumberOfItemsInLandscape) / (kAlbumCollectionViewNumberOfItemsInLandscape - 1);
    }
    
    return lineSpacing;
}

- (void)addBarButtonItem
{
    //Add barButtonItem - menuButtonItem
    UIBarButtonItem *menuButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"menuButton"] style:UIBarButtonItemStylePlain target:self action:@selector(menuBarButtonPressed:)];
    self.navigationItem.leftBarButtonItem = menuButtonItem;
}

- (void)menuBarButtonPressed:(UIBarButtonItem *)sender
{
    [[self sideMenuControllerFromAppDelegate] toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
}

- (MMDrawerController *)sideMenuControllerFromAppDelegate
{
    //Get app delegate
    FVAppDelegate *appDelegate = (FVAppDelegate *)[[UIApplication sharedApplication] delegate];
    //Return sideMenuDrawerController
    return appDelegate.sideMenuDrawer;
}
#pragma mark - Delegates

-(void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    //Device will rotate - called before rotation
    self.firstVisibleCell = [self getFirstIndexPathForVisibleCells]; //Get first visible cell
    [self.mainView.collectionView.collectionViewLayout invalidateLayout]; //Update collectionView layout
}
-(void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    //Device will rotate, animated - called while/after rotation
    [self updateCollectionViewContentInsets];
    //For some reasons this method is not working properly. Even when added to didRotateToInterfaceOrientation
    if ([self.albums count] !=0)[self.mainView.collectionView scrollToItemAtIndexPath:self.firstVisibleCell atScrollPosition:UICollectionViewScrollPositionTop animated:YES]; //Scroll to to first visible cell before rotation
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
