//
//  FVCredentials.h
//  FlickView
//
//  Created by Armands Lazdiņš on 30/05/14.
//  Copyright (c) 2014 Armands Lazdiņš. All rights reserved.
//

#import <Foundation/Foundation.h>

//FVCredentials keys
extern NSString *const kNameKey;
extern NSString *const kAPIKey;

@interface FVCredentials : NSObject

@property (nonatomic) NSURLProtectionSpace *loginProtectionSpace;

+ (FVCredentials *)sharedCredentials;

- (void)setName:(NSString *)name andAPIKey:(NSString *)key;

- (NSDictionary *)getCredentials;

- (void)deleteCredentials;

@end
