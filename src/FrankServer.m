//
//  FrankServer.m
//  Frank
//
//  Created by phodgson on 5/24/10.
//  Copyright 2010 ThoughtWorks. See NOTICE file for details.
//

#import "FrankServer.h"

#import "HTTPServer.h"
#import "RoutingHTTPConnection.h"
#import "StaticResourcesRoute.h"
#import "DieCommandRoute.h"
#import "DumpCommandRoute.h"
#import "ImageCaptureRoute.h"
#import "FrankCommandRoute.h"
#import "DeviceCommand.h"
#import "ExitCommand.h"
#import "AppCommand.h"
#import "AccessibilityCheckCommand.h"
#import "EnginesCommand.h"
#import "VersionCommand.h"
#import "SuccessCommand.h"
#import "MapOperationCommand.h"
#import "ResolutionCommand.h"
#import "DeactivateForDurationCommand.h"

#if TARGET_OS_IPHONE
#import "OrientationCommand.h"
#import "LocationCommand.h"
#import "IOSKeyboardCommand.h"
#else
#import "OSXKeyboardCommand.h"
#endif

#ifndef FRANK_PRODUCT_VERSION
#define FRANK_PRODUCT_VERSION UNKNOWN
#endif

#define xstr(s) str(s)
#define str(s) #s
#define VERSIONED_NAME "Frank iOS Server " xstr(FRANK_PRODUCT_VERSION)
const unsigned char frank_what_string[] = "@(#)" VERSIONED_NAME "\n";

static NSUInteger __defaultPort = FRANK_SERVER_PORT;
NSString *const kStopFrankServerNotification = @"StopFrankServerNotification";

@implementation FrankServer

+ (void)setDefaultHttpPort:(NSUInteger)port
{
    __defaultPort = port;
}
- (id) initWithDefaultBundle {
	return [self initWithStaticFrankBundleNamed: @"frank_static_resources"];
}

- (id) initWithStaticFrankBundleNamed:(NSString *)bundleName
{    
	self = [super init];
	if (self != nil) {
		if( ![bundleName hasSuffix:@".bundle"] )
			bundleName = [bundleName stringByAppendingString:@".bundle"];
		
		FrankCommandRoute *frankCommandRoute = [FrankCommandRoute singleton];
        [frankCommandRoute registerCommand:[[[ResolutionCommand alloc] init] autorelease] withName:@"resolution"];
        [frankCommandRoute registerCommand:[[[DeviceCommand alloc] init] autorelease] withName:@"device"];
		[frankCommandRoute registerCommand:[[[AccessibilityCheckCommand alloc] init]autorelease] withName:@"accessibility_check"];
		[frankCommandRoute registerCommand:[[[AppCommand alloc] init]autorelease] withName:@"app_exec"];
        [frankCommandRoute registerCommand:[[[EnginesCommand alloc] init]autorelease] withName:@"engines"];
        [frankCommandRoute registerCommand:[[[VersionCommand alloc] initWithVersion:[NSString stringWithFormat:@"%s",xstr(FRANK_PRODUCT_VERSION)]]autorelease] withName:@"version"];
        [frankCommandRoute registerCommand:[[[ExitCommand alloc] init] autorelease] withName:@"exit"];
        [frankCommandRoute registerCommand:[[[MapOperationCommand alloc]init]autorelease] withName:@"map"];
        [frankCommandRoute registerCommand:[[[DeactivateForDurationCommand alloc] init] autorelease] withName:@"deactivate_for_duration"];

#if TARGET_OS_IPHONE
        [frankCommandRoute registerCommand:[[[OrientationCommand alloc]init]autorelease] withName:@"orientation"];
        [frankCommandRoute registerCommand:[[[LocationCommand alloc]init]autorelease] withName:@"location"];
        [frankCommandRoute registerCommand:[[[IOSKeyboardCommand alloc] init]autorelease] withName:@"type_into_keyboard"];
#else
        [frankCommandRoute registerCommand:[[[SuccessCommand alloc]init]autorelease] withName:@"orientation"];
        [frankCommandRoute registerCommand:[[[SuccessCommand alloc]init]autorelease] withName:@"location"];
        [frankCommandRoute registerCommand:[[[OSXKeyboardCommand alloc] init]autorelease] withName:@"type_into_keyboard"];
#endif
        
		[[RequestRouter singleton] registerRoute:frankCommandRoute];
		
		StaticResourcesRoute *staticRoute = [[[StaticResourcesRoute alloc] initWithStaticResourceSubDir:bundleName] autorelease];
		[[RequestRouter singleton] registerRoute:staticRoute];
        
        DieCommandRoute *dieCaptureCommand = [[[DieCommandRoute alloc] init] autorelease];
        [[RequestRouter singleton] registerRoute:dieCaptureCommand];

        DumpCommandRoute *dumpCaptureCommand = [[[DumpCommandRoute alloc] init] autorelease];
		[[RequestRouter singleton] registerRoute:dumpCaptureCommand];        
        
        ImageCaptureRoute *imageCaptureCommand = [[[ImageCaptureRoute alloc] init] autorelease];
		[[RequestRouter singleton] registerRoute:imageCaptureCommand];
		
		_httpServer = [[[HTTPServer alloc]init] retain];
		
		[_httpServer setName:@"Frank UISpec server"];
		[_httpServer setType:@"_http._tcp."];
		[_httpServer setConnectionClass:[RoutingHTTPConnection class]];
		[_httpServer setPort:__defaultPort];

        // subscribing to notification that stops Frank server
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(stopServer) name:kStopFrankServerNotification object:nil];
		NSLog( @"Creating the server: %@", _httpServer );
	}
	return self;
}

- (BOOL) startServer
{
    NSLog( @"Starting server %s", VERSIONED_NAME );
	NSError *error;
	if( ![_httpServer start:&error] ) {
		NSLog(@"Error starting HTTP Server:");// %@", error);
		return NO;
	}
	return YES;
}

- (void) stopServer
{
    NSLog( @"Stopping server %s", VERSIONED_NAME );
    [_httpServer stop];
}

- (void) dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kStopFrankServerNotification object:nil];
	[_httpServer release];
	[super dealloc];
}

@end
