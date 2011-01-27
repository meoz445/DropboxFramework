//
//  DBLoginController.m
//  DropboxFramework
//
//  Created by Jørgen P. Tjernø on 1/16/11.
//  Copyright 2011 devSoft. All rights reserved.
//

#import "DBLoginController.h"

@interface  DBLoginController () <DBRestClientDelegate>

@property (nonatomic, assign) BOOL loggingIn;

@end

@implementation DBLoginController

#pragma mark Accessors
@synthesize username, password;

@synthesize loggingIn;
@synthesize accountCreation;

#pragma mark Object management

- (id) init
{
    if (self = [super init])
    {
        [self setLoggingIn:NO];
        if (![NSBundle loadNibNamed:@"DBLogin" owner:self])
        {
            [self release];
            self = nil;
        }
    }
    
    return self;
}

- (void) dealloc
{
    [self setAccountCreation:nil];
    
    [super dealloc];
}

#pragma mark Window and panel delegate methods

- (void) dismissedError:(id)contextInfo
{
    [window setStyleMask:([window styleMask] | NSClosableWindowMask)];
    [self setLoggingIn:NO];
}

- (void) windowWillClose:(NSNotification *)notification
{
    if (![self loggingIn])
    {
        [[self retain] autorelease];
        [delegate controllerDidCancel:self];
    }
}

#pragma mark Received actions

- (IBAction) createAccount:(id)sender
{
    [self setAccountCreation:[[[DBAccountCreationController alloc] init] autorelease]];
    [accountCreation setDelegate:self];
    [accountCreation presentFrom:window];
    
    [window orderOut:self];
}

- (IBAction) linkAccount:(id)sender
{
    if ([[username stringValue] length] == 0)
    {
        [self errorWithTitle:@"Email Required" message:@"Please enter your email."];
        return;
    }
    
    if ([[password stringValue] length] == 0)
    {
        [self errorWithTitle:@"Password Required" message:@"Please enter you password."];
        return;
    }
    
    [window setStyleMask:([window styleMask] & ~NSClosableWindowMask)];
    [self setLoggingIn:YES];
    
    [[self restClient] loginWithEmail:[username stringValue]
                             password:[password stringValue]];
}

#pragma mark DBRestClientDelegate methods

- (void) restClientDidLogin:(DBRestClient *)client
{
    [[self retain] autorelease];
    [delegate controllerDidComplete:self];
    [window close];
}

- (void) restClient:(DBRestClient *)client loginFailedWithError:(NSError *)error
{
    NSString* message;
    if ([error.domain isEqual:NSURLErrorDomain])
    {
        message = @"There was an error connecting to Dropbox.";
    }
    else
    {
        NSObject* errorResponse = [[error userInfo] objectForKey:@"error"];
        if ([errorResponse isKindOfClass:[NSString class]])
        {
            message = (NSString*)errorResponse;
        }
        else if ([errorResponse isKindOfClass:[NSDictionary class]])
        {
            NSDictionary* errorDict = (NSDictionary*)errorResponse;
            message = [errorDict objectForKey:[[errorDict allKeys] objectAtIndex:0]];
        }
        else
        {
            message = @"An unknown error has occurred.";
        }
    }

    [self errorWithTitle:@"Unable to Login" message:message];
}

#pragma mark DBAccountCreationControllerDelegate methods

- (void) controllerDidComplete:(DBCommonController *)creation
{
    [self setAccountCreation:nil];
    [[self retain] autorelease];

    [delegate controllerDidComplete:self];
    [window close];
}

- (void) controllerDidCancel:(DBCommonController *)creation
{
    [window makeKeyAndOrderFront:[creation window]];
}

@end
