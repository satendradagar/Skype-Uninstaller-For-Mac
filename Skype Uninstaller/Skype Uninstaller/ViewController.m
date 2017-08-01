//
//  ViewController.m
//  Skype Uninstaller
//
//  Created by Satendra Singh on 27/07/17.
//  Copyright © 2017 DomaiNYC. All rights reserved.
//

#import "ViewController.h"
#import "TaskManager.h"

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view.window setTitle:@"Skype Uninstaller"];
    _progress.hidden = YES;
    [self.messages setStringValue:@""];
    [_details setStringValue:@"Skype Uninstaller will remove all folders and files belonging to the Skype installation, including files created by skype in the Mac Machine.\n\nClick Uninstall to Uninstall the Skype."];
    // Do any additional setup after loading the view.
}


- (void)setRepresentedObject:(id)representedObject {
    [super setRepresentedObject:representedObject];

    // Update the view, if already loaded.
}


- (IBAction)didClickUninstall:(NSButton *)sender {
    __weak typeof(self)weakSelf = self;
    _progress.hidden = NO;
    [_uninstallButton setEnabled:NO];
    [_progress startAnimation:nil];
    [_messages setStringValue:@""];
    [TaskManager runScript:@"SkypeBusiness" withArgs:nil ResponseHandling:^(NSString *message) {
        NSLog(@"message:%@",message);
        dispatch_async(dispatch_get_main_queue(), ^{

        [weakSelf.messages setStringValue:message];
            
        });
        //        progressController.label.stringValue = [NSString stringWithFormat:@"%@:%@",message,[self messageForServerMessage:message]];
//        [weakSelf handleCriticalActions:message];
        
        
    } termination:^(STPrivilegedTask * task) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            weakSelf.progress.hidden = YES;
            [weakSelf.uninstallButton setEnabled:YES];
            [weakSelf.progress stopAnimation:nil];
            [weakSelf.messages setStringValue:@""];
            NSAlert *alert = [[NSAlert alloc] init];
            alert.messageText = @"Completed";
            alert.informativeText = @"Skype was uninstalled successfully.";
            [alert addButtonWithTitle:@"OK"];
            [alert runModal];
 
        });
        
//        [weakSelf closeSheet];
        //        [weakSelf LogMessage:[NSString stringWithFormat:@"\n%@  %@",[dateFormatter stringFromDate:[NSDate date]],@"Activation finished."]];
        
    }] ;

}
@end
