//
//  DeactivateForDurationCommand.m
//  Frank
//
//  Created by Oleksiy Radyvanyuk on 17/11/14.
//
//

#import "DeactivateForDurationCommand.h"
#import <PublicAutomation/UIAutomationBridge.h>
#import <PublicAutomation/UIAutomation.h>
#import "JSON.h"
#import "FranklyProtocolHelper.h"

@implementation DeactivateForDurationCommand

- (NSString *)handleCommandWithRequestBody:(NSString *)requestBody
{
    NSDictionary *requestCommand = FROM_JSON(requestBody);
    NSNumber *seconds = [requestCommand objectForKey:@"seconds"];

    // make the call asyncronous so that Frank scripts could do something else while the app is in background
    UIATarget *localTarget = [UIAutomationBridge uiat];
    [localTarget performSelectorOnMainThread:@selector(deactivateAppForDuration:) withObject:seconds waitUntilDone:NO];

    return [FranklyProtocolHelper generateSuccessResponseWithoutResults];
}

@end
