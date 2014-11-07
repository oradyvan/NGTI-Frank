//
//  DieCommandRoute.m
//  Frank
//
//  Created by Oleksiy Radyvanyuk on 07/11/14.
//
//

#import "DieCommandRoute.h"
#import "FrankServer.h"

@implementation DieCommandRoute

- (NSObject<HTTPResponse> *)handleRequestForPath:(NSArray *)path withConnection:(RoutingHTTPConnection *)connection
{
    if ([self canHandlePostForPath:path])
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:kStopFrankServerNotification object:self];
    }
    return nil;
}

- (BOOL)canHandlePostForPath:(NSArray *)path
{
    NSString *firstPathComponent = [path firstObject];
    return [firstPathComponent isEqualToString:@"die"];
}

@end
