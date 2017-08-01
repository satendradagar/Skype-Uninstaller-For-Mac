//
//  TaskManager.m
//  Bizon
//
//  Created by Satendra Singh on 11/09/16.
//  Copyright © 2016 Satendra Singh. All rights reserved.
//

#import "TaskManager.h"
#import "STPrivilegedTask.h"
//#import "BizonSecurityManager.h"

@implementation TaskManager


+ (void ) runScript:(NSString *) scriptName withArgs:(NSArray *)args ResponseHandling:(void (^)(NSString *message)) responseBlock termination: (void (^)(STPrivilegedTask *)) terminate{

//    __block NSPipe *outPipe = [NSPipe pipe];
    NSString  * scriptPath = [TaskManager resouceURLForScript:scriptName];
    
    STPrivilegedTask * hiddenTask = [STPrivilegedTask new];
    [hiddenTask setLaunchPath:@"/bin/sh"];
    [hiddenTask setCurrentDirectoryPath:[[NSBundle bundleForClass:[self class]] resourcePath]];
    
    NSMutableArray *totalArgs = [NSMutableArray arrayWithObjects:scriptPath, nil];
    if (nil != args) {
        
        [totalArgs addObjectsFromArray:args];

    }
    [hiddenTask setTerminationHandler:terminate];
    [hiddenTask setArguments:totalArgs];
        //set it off
    OSStatus err = [hiddenTask launchWithResponseHandling:responseBlock];
    if (err != errAuthorizationSuccess) {
        if (err == errAuthorizationCanceled) {
            responseBlock(@"3019");
            terminate(hiddenTask);

            NSLog(@"User cancelled");
            return;
        }  else {
            responseBlock([NSString stringWithFormat:@"Something went wrong: %d", (int)err]);
            terminate(hiddenTask);
            NSLog(@"Something went wrong: %d", (int)err);
                // For error codes, see http://www.opensource.apple.com/source/libsecurity_authorization/libsecurity_authorization-36329/lib/Authorization.h
        }
    }
    
        // Success!  Now, start monitoring output file handle for data
//    NSFileHandle *readHandle = [hiddenTask outputFileHandle];
//    NSData *outputData = [readHandle readDataToEndOfFile];
//    NSString *outputString = [[NSString alloc] initWithData:outputData encoding:NSUTF8StringEncoding];
//    
//    NSLog(@"%@",outputString);
    
    
    
//    [hiddenTask setStandardOutput:outPipe];
    
//    [hiddenTask setTerminationHandler:^(NSTask * task) {
//        
//        if (NSTaskTerminationReasonExit == [task terminationReason]) {
//            NSData *output = [[hiddenTask outputFileHandle] readDataToEndOfFile];
//            NSString *outputString = [[NSString alloc] initWithData:output encoding:NSUTF8StringEncoding];
//            
//            NSLog(@"response:%@",outputString);
////            NSDictionary *formattedResponse = [RegistrationPane formattedResponseFromResponse:outputString];
////            BOOL isValid = [RegistrationPane isValidResponse:formattedResponse];
////            if (isValid) {
////                
////                NSError *saveError = nil;
////                BOOL isSaved = [RegistrationPane saveResponseToApplicationReadablePath:formattedResponse error:&saveError];
////                NSLog(@"isSaved = %d, Error = %@",isSaved,saveError);
////                if (isSaved) {
////                    
////                    dispatch_async(dispatch_get_main_queue(), ^{
////                        [self setNextEnabled:YES];
////                            //Activate successfully
////                        [self gotoNextPane];
////                        
////                    });
////                }
////                else{
////                        //Show Error
////                    [self showErrorMessage:@"Failed to save response, Please try again."];
////                }
////            }
////            else{
////                    //Show Error
////                NSLog(@"%@",outputString);
////                [self showErrorMessage:outputString];
////                
////            }
//        }
//        else{
//            
////            [self showErrorMessage:@"Installer terminated unexpecdetly, Pelase try installing again."];
//            
//                //Show error termination
//        }
//    }];
//    [hiddenTask launch];
    
}

+ (BOOL) runScript:(NSString*)scriptName
                     withArguments:(NSArray *)arguments
                            output:(NSString **)output
                  errorDescription:(NSString **)errorDescription {
    
    NSString  * scriptPath = [TaskManager resouceURLForScript:scriptName];


    NSString * fullScript = scriptPath;
    if (arguments.count) {
     
        NSString * allArgs = [arguments componentsJoinedByString:@" "];
        fullScript = [NSString stringWithFormat:@"'%@' %@", scriptPath, allArgs?allArgs:@""];
        
    }
    NSDictionary *errorInfo = [NSDictionary new];
    NSString *script =  [NSString stringWithFormat:@"do shell script \"'%@'\" ", fullScript];
    
    NSAppleScript *appleScript = [[NSAppleScript new] initWithSource:script];
    NSAppleEventDescriptor * eventResult = [appleScript executeAndReturnError:&errorInfo];
    
        // Check errorInfo
    if (! eventResult)
        {
            // Describe common errors
        errorDescription = nil;
        if ([errorInfo valueForKey:NSAppleScriptErrorNumber])
            {
            NSNumber * errorNumber = (NSNumber *)[errorInfo valueForKey:NSAppleScriptErrorNumber];
            if ([errorNumber intValue] == -128)
                *errorDescription = @"The administrator password is required to do this.";
            }
        
            // Set error message from provided message
        if (*errorDescription == nil)
            {
            if ([errorInfo valueForKey:NSAppleScriptErrorMessage])
                *errorDescription =  (NSString *)[errorInfo valueForKey:NSAppleScriptErrorMessage];
            }
        
        return NO;
        }
    else
        {
            // Set output to the AppleScript's output
        *output = [eventResult stringValue];
        
        return YES;
        }
}


+(NSString *)resouceURLForScript:(NSString *)scriptName{
    
    NSString  * scriptPath = [[NSBundle bundleForClass:[self class]] pathForResource:scriptName ofType:@"sh"];
    return scriptPath;
}

@end
