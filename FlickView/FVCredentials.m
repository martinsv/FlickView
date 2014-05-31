//
//  FVCredentials.m
//  FlickView
//
//  Created by Armands Lazdiņš on 30/05/14.
//  Copyright (c) 2014 Armands Lazdiņš. All rights reserved.
//

#import "FVCredentials.h"

//FVCredentials keys
NSString *const kNameKey   = @"name";
NSString *const kAPIKey    = @"APIKey";

@implementation FVCredentials

static NSString *const sharedURL = @"http://com.armandslazdins.FlickView";
static FVCredentials *sharedCredentials = nil;

+(FVCredentials *)sharedCredentials
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedCredentials = [[self alloc] init];
    });
    return sharedCredentials;
}

-(id)init
{
    if (self = [super init]) {
        NSURL *urlFromString = [NSURL URLWithString:sharedURL];
        self.loginProtectionSpace = [[NSURLProtectionSpace alloc] initWithHost:urlFromString.host
                                                                          port:[urlFromString.port integerValue]
                                                                      protocol:urlFromString.scheme
                                                                         realm:nil
                                                          authenticationMethod:NSURLAuthenticationMethodHTTPDigest];
    }
    return self;
}


-(void)setName:(NSString *)name andAPIKey:(NSString *)key
{
    NSURLCredential *credential;
    credential = [NSURLCredential credentialWithUser:name password:key persistence:NSURLCredentialPersistencePermanent];
    [[NSURLCredentialStorage sharedCredentialStorage] setCredential:credential forProtectionSpace:self.loginProtectionSpace];
}

-(NSDictionary *)getCredentials
{
    NSURLCredential *credential;
    NSDictionary *credentials;
    
    credentials = [[NSURLCredentialStorage sharedCredentialStorage] credentialsForProtectionSpace:self.loginProtectionSpace];
    credential = [credentials.objectEnumerator nextObject];
    
    NSDictionary *allCredentials = [NSDictionary dictionaryWithObjectsAndKeys:credential.user, kNameKey, credential.password, kAPIKey, nil];
    return allCredentials;
}

-(void)deleteCredentials
{
    NSURLCredential *credential;
    NSDictionary *credentials;
    
    credentials = [[NSURLCredentialStorage sharedCredentialStorage] credentialsForProtectionSpace:self.loginProtectionSpace];
    credential = [credentials.objectEnumerator nextObject];
    [[NSURLCredentialStorage sharedCredentialStorage] removeCredential:credential forProtectionSpace:self.loginProtectionSpace];
}


@end
