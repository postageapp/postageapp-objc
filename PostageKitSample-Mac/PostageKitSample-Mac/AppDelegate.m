//
//  AppDelegate.m
//  PostageKitSample-Mac
//
//  Created by Stephan Leroux on 2013-02-12.
//  Copyright (c) 2013 PostageApp. All rights reserved.
//

#import "AppDelegate.h"
#import "ControlsViewController.h"

@interface AppDelegate()

@property (nonatomic, strong) IBOutlet ControlsViewController *controlsVC;

@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    self.controlsVC = [[ControlsViewController alloc] initWithNibName:@"ControlsViewController" bundle:nil];
    [self.window.contentView addSubview:self.controlsVC.view];
    self.controlsVC.view.frame = ((NSView *)self.window.contentView).bounds;
}

@end
