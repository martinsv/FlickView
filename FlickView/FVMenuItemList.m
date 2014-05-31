//
//  FVMenuItemList.m
//  FlickView
//
//  Created by Armands Lazdiņš on 30/05/14.
//  Copyright (c) 2014 Armands Lazdiņš. All rights reserved.
//

#import "FVMenuItemList.h"
#import "FVAppDelegate.h"

//MenuItem Keys
NSString *const kMenuItemNavigationController = @"itemNavigationController";
NSString *const kMenuItemName = @"itemName";
NSString *const kMenuItemIcon = @"itemIcon";

@implementation FVMenuItemList

+ (NSArray *)allMenuItems
{
    NSMutableArray *allMenuItems = [@[] mutableCopy];
    FVAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    
    //Photos Navigation Controller
    NSDictionary *photosNC = @{kMenuItemNavigationController : appDelegate.photosNavigationController, kMenuItemName : @"Photos", kMenuItemIcon : [UIImage imageNamed:@"photosIcon"]};
    [allMenuItems addObject:photosNC];
    
    //Albums Navigation Controller
    NSDictionary *albumsNC = @{kMenuItemNavigationController : appDelegate.albumsNavigationController, kMenuItemName : @"Albums", kMenuItemIcon : [UIImage imageNamed:@"albumsIcon"]};
    [allMenuItems addObject:albumsNC];
    
    return [allMenuItems copy];
}

@end
