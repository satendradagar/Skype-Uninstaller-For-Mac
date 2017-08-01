//
//  ViewController.h
//  Skype Uninstaller
//
//  Created by Satendra Singh on 27/07/17.
//  Copyright © 2017 DomaiNYC. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface ViewController : NSViewController

@property (weak) IBOutlet NSTextField *details;
@property (weak) IBOutlet NSButton *uninstallButton;
@property (weak) IBOutlet NSTextField *messages;

@property (weak) IBOutlet NSProgressIndicator *progress;

- (IBAction)didClickUninstall:(NSButton *)sender;

@end

