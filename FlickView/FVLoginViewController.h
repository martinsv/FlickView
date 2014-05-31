//
//  FVLoginViewController.h
//  FlickView
//
//  Created by Armands Lazdiņš on 30/05/14.
//  Copyright (c) 2014 Armands Lazdiņš. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol FVLoginViewControllerDelegate <NSObject>

@required

//This method will be called when Flickr userID is retrieved. Executed on main thread.
- (void)userLoginComplete;

@end

@interface FVLoginViewController : UIViewController

@property (nonatomic, weak) id <FVLoginViewControllerDelegate> delegate;

@end
