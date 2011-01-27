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
        [self errorWithTitle:DBLocalizedString(@"First Name Required", @"Error panel title in signup window when the user does not input a first name")
                     message:DBLocalizedString(@"Please enter your first name.", @"Error panel message in signup window when the user does not input a first name")];
        return;
    }
    else if ([[lastname stringValue] length] == 0)
    {
        [self errorWithTitle:DBLocalizedString(@"Last Name Required", @"Error panel title in signup window when the user does not input a last name")
                     message:DBLocalizedString(@"Please enter your last name.", @"Error panel message in signup window when the user does not input a first name")];
        return;
    }
    else if ([[email stringValue] length] == 0)
    {
        [self errorWithTitle:DBLocalizedString(@"Email Address Required", @"Error panel title in signup window when the user does not input an e-mail")
                     message:DBLocalizedString(@"Please enter your email address.", @"Error panel message in signup window when the user does not input an e-mail")];
        return;
    }
    else if ([[password stringValue] length] == 0)
    {
        [self errorWithTitle:DBLocalizedString(@"Password Required", @"Error panel title in signup window when the user does not input a password")
                     message:DBLocalizedString(@"Please enter your desired password", @"Error panel message in signup window when the user does not input a password")];
        return;
    }
    else if (![[password stringValue] isEqualToString:[passwordVerify stringValue]])
    {
        [self errorWithTitle:DBLocalizedString(@"Password Mismatch", @"Error panel title in signup window when the user enters two different passwords")
                     message:DBLocalizedString(@"Your password does not match the verification", @"Error panel message in signup window when the user enters two different passwords")];
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
    NSString* message = DBLocalizedString(@"An unknown error occured.", @"Error panel message in signup window when the server returns an error we do not understand");
    if ([error.domain isEqual:NSURLErrorDomain]) {
        message = DBLocalizedString(@"There was an error connecting to Dropbox.", @"Error panel message in signup window when we cannot connect to the server");
    } else {
        NSObject* errorResponse = [[error userInfo] objectForKey:@"error"];
        if ([errorResponse isKindOfClass:[NSString class]]) {
            message = (NSString*)errorResponse;
        } else if ([errorResponse isKindOfClass:[NSDictionary class]]) {
            NSDictionary* errorDict = (NSDictionary*)errorResponse;
            message = [errorDict objectForKey:[[errorDict allKeys] objectAtIndex:0]];
        }
    }
    [self errorWithTitle:DBLocalizedString(@"Create Account Failed", @"Error panel title in signup window when the server returns an error for the account creation")
                 message:message];
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
