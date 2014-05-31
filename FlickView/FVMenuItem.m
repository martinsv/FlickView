//
//  FVMenuItem.m
//  FlickView
//
//  Created by Armands Lazdiņš on 30/05/14.
//  Copyright (c) 2014 Armands Lazdiņš. All rights reserved.
//

#import "FVMenuItem.h"

@implementation FVMenuItem

-(id)init
{
    return [self initWithMenuItem:nil];
}

-(id)initWithMenuItem:(NSDictionary *)item
{
    self = [super init];
    
    //Init with data from CTMenuItemList
    self.navigationController = item[kMenuItemNavigationController];
    self.name = item[kMenuItemName];
    self.icon = item[kMenuItemIcon];
    
    return self;
}

@end
