//
//  DBCommonController.m
//  DropboxFramework
//
//  Created by Jørgen P. Tjernø on 1/16/11.
//  Copyright 2011 devSoft. All rights reserved.
//

#import "DBCommonController.h"

@implementation DBCommonController

@synthesize restClient;
@synthesize delegate;

@synthesize window;

- (DBRestClient *) restClient
{
    // TODO: Make threadsafe?
    if (restClient == nil)
    {
        [self setRestClient:[[[DBRestClient alloc] initWithSession:[DBSession sharedSession]] autorelease]];
        [restClient setDelegate:self];
    }
    return restClient;
}

- (void) dealloc
{
    [self setRestClient:nil];
    
    [super dealloc];
}

- (void) presentFrom:(id)sender
{
    [window makeKeyAndOrderFront:sender];
}

- (void) errorWithTitle:(NSString *)title
                message:(NSString *)message
{
    NSAlert *alert = [NSAlert alertWithMessageText:title
                                     defaultButton:nil
                                   alternateButton:nil
                                       otherButton:nil
                         informativeTextWithFormat:message];
    [alert beginSheetModalForWindow:window
                      modalDelegate:self
                     didEndSelector:@selector(dismissedError:)
                        contextInfo:nil];
    
}

@end
