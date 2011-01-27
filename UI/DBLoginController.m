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
        [self errorWithTitle:DBLocalizedString(@"Email Required", @"Error panel title in login window when user does not input an e-mail")
                     message:DBLocalizedString(@"Please enter your email.", @"Error panel message in login window when user does not input a username")];
        return;
    }
    
    if ([[password stringValue] length] == 0)
    {
        [self errorWithTitle:DBLocalizedString(@"Password Required", @"Error panel title in login window when user does not input a password")
                     message:DBLocalizedString(@"Please enter you password.", @"Error panel message in login window when user does not input a username")];
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
    NSString* message = DBLocalizedString(@"An unknown error occured.", @"Error panel message in login window when the server returns an error we do not understand");
    if ([error.domain isEqual:NSURLErrorDomain])
    {
        message = DBLocalizedString(@"There was an error connecting to Dropbox.", @"Error panel message in login window when we cannot connect to the server");
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
    }

    [self errorWithTitle:DBLocalizedString(@"Unable to Login", @"Error panel title in signup window when the server returns an error for the login")
                 message:message];
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
