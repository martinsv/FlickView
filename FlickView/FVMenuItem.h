//
//  FVMenuItem.h
//  FlickView
//
//  Created by Armands Lazdiņš on 30/05/14.
//  Copyright (c) 2014 Armands Lazdiņš. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FVMenuItemList.h"

@interface FVMenuItem : NSObject

//Properties for sideMenuController items
@property (nonatomic) UINavigationController *navigationController;
@property (nonatomic) NSString *name;
@property (nonatomic) UIImage *icon;

- (id)initWithMenuItem:(NSDictionary *)item;

@end
