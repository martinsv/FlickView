//
//  FVMenuItemList.h
//  FlickView
//
//  Created by Armands Lazdiņš on 30/05/14.
//  Copyright (c) 2014 Armands Lazdiņš. All rights reserved.
//

#import <Foundation/Foundation.h>

//MenuItem keys
extern NSString *const kMenuItemNavigationController;
extern NSString *const kMenuItemName;
extern NSString *const kMenuItemIcon;

@interface FVMenuItemList : NSObject

//This method return a list with all navigationControllers for sideMenu to display. Includes name and icon.
+ (NSArray *)allMenuItems;


@end
