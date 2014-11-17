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

    if (![[UIAutomationBridge uiat] deactivateAppForDuration:seconds])
    {
        return [FranklyProtocolHelper generateErrorResponseWithReason:@"cannot deactivate app"
                                                           andDetails:@"PublicAutomation was not able to send app to background and return it back to foreground"];
    }

    return [FranklyProtocolHelper generateSuccessResponseWithoutResults];
}

@end
