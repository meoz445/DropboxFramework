//
//  DBAccountCreationController.m
//  DropboxFramework
//
//  Created by Jørgen P. Tjernø on 1/16/11.
//  Copyright 2011 devSoft. All rights reserved.
//

#import "DBAccountCreationController.h"


@interface DBAccountCreationController () <DBRestClientDelegate>

@property (nonatomic, assign) BOOL creating;

@end

@implementation DBAccountCreationController

@synthesize firstname, lastname;
@synthesize email;
@synthesize password, passwordVerify;

@synthesize creating;

#pragma mark Object management

- (id) init
{
    if (self = [super init])
    {
        [self setCreating:NO];
        if (![NSBundle loadNibNamed:@"DBAccountCreation" owner:self])
        {
            [self release];
            self = nil;
        }
    }
    
    return self;
}

- (void) dealloc
{
    
    [super dealloc];
}

- (IBAction) createAccount:(id)sender
{    
    if ([[firstname stringValue] length] == 0)
    {
        [self errorWithTitle:@"First Name Required" message:@"Please enter your first name."];
        return;
    }
    else if ([[lastname stringValue] length] == 0)
    {
        [self errorWithTitle:@"Last Name Required" message:@"Please enter your last name."];
        return;
    }
    else if ([[email stringValue] length] == 0)
    {
        [self errorWithTitle:@"Email Address Required" message:@"Please enter your email address."];
        return;
    }
    else if ([[password stringValue] length] == 0)
    {
        [self errorWithTitle:@"Password Required" message:@"Please enter your desired password"];
        return;
    }
    else if (![[password stringValue] isEqualToString:[passwordVerify stringValue]])
    {
        [self errorWithTitle:@"Password Mismatch" message:@"Your password does not match the verification"];
        return;
    }

    [window setStyleMask:([window styleMask] & ~NSClosableWindowMask)];
    [self setCreating:YES];

    [[self restClient] createAccount:[email stringValue] password:[password stringValue] 
                           firstName:[firstname stringValue] lastName:[lastname stringValue]];
}



#pragma mark Window and panel delegate methods


- (void) dismissedError:(id)contextInfo
{
    [window setStyleMask:([window styleMask] | NSClosableWindowMask)];
    [self setCreating:NO];
}

- (void) windowWillClose:(NSNotification *)notification
{
    if (![self creating])
    {
        [[self retain] autorelease];
        [delegate controllerDidCancel:self];
    }
}

#pragma mark DBRestClientDelegate methods

- (void) restClientCreatedAccount:(DBRestClient *)client
{
    [[self restClient] loginWithEmail:[email stringValue]
                             password:[password stringValue]];
}

- (void) restClient:(DBRestClient *)client createAccountFailedWithError:(NSError *)error
{
    NSString* message = @"An unknown error occured.";
    if ([error.domain isEqual:NSURLErrorDomain]) {
        message = @"There was an error connecting to Dropbox.";
    } else {
        NSObject* errorResponse = [[error userInfo] objectForKey:@"error"];
        if ([errorResponse isKindOfClass:[NSString class]]) {
            message = (NSString*)errorResponse;
        } else if ([errorResponse isKindOfClass:[NSDictionary class]]) {
            NSDictionary* errorDict = (NSDictionary*)errorResponse;
            message = [errorDict objectForKey:[[errorDict allKeys] objectAtIndex:0]];
        }
    }
    [self errorWithTitle:@"Create Account Failed" message:message];
}


- (void) restClientDidLogin:(DBRestClient *)client
{
    [[self retain] autorelease];

    [self setCreating:NO];
    [delegate controllerDidComplete:self];
    [window close];
}

- (void) restClient:(DBRestClient *)client loginFailedWithError:(NSError *)error
{
    [[self retain] autorelease];

    // We'll pretend the user cancelled, prompting the login window to be displayed.
    // This way, the normal login process can deal with the error when the user tries to log in.
    [delegate controllerDidCancel:self];
    [window close];
}
     
@end
