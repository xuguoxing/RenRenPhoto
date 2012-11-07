//
//  AFURLConnectionOperation+HTTPS.m
//  RenrenPhoto
//
//  Created by xuguoxing on 12-10-22.
//  Copyright (c) 2012年 winddisk.com. All rights reserved.
//

#import "AFURLConnectionOperation+HTTPS.h"

@implementation AFURLConnectionOperation (HTTPS)
-(void)setHttpsAuth
{
    [self setAuthenticationAgainstProtectionSpaceBlock:^ BOOL (NSURLConnection *connection,NSURLProtectionSpace *protectionSpace){
        return [protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust];
    } ];
    [self setAuthenticationChallengeBlock:^(NSURLConnection *connection,NSURLAuthenticationChallenge *challenge){
        [challenge.sender useCredential:[NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust] forAuthenticationChallenge:challenge];
    }];
}
@end
