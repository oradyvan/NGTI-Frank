//
//  UIView+Frank.m
//  Frank
//
//  Created by Thoughtworks on 7/7/12.
//  Copyright (c) 2012 ThoughtWorks. All rights reserved.
//

#import <AddressBook/AddressBook.h>
#import "LoadableCategory.h"


MAKE_CATEGORIES_LOADABLE(UIView_Frank)

@implementation UIView (Frank)

- (void)FEX_addressBookRequestAccess
{
    ABAddressBookRef addressBook = ABAddressBookCreate();

    // initiates accessing address book so that Contacts access alert may appear
    ABAddressBookRequestAccessWithCompletion(addressBook, ^(bool granted, CFErrorRef error)
    {
        NSError *nsError = (__bridge NSError *)error;
        NSLog(@"Access to contacts granted = %@, error = %@", granted ? @"YES" : @"NO", nsError);
        
        if (granted)
        {
            ABAddressBookRef book = ABAddressBookCreate();
            ABRecordRef defaultSource = ABAddressBookCopyDefaultSource(book);
            NSLog(@"defaultSource = %@", defaultSource);
            CFRelease(defaultSource);
        }
    });
}

// Based on UISpec's flash method
- (void)FEX_flash {
	UIColor *originalBackgroundColor = [self.backgroundColor retain];
    
    CGFloat orginalAlpha = self.alpha;
    
    for (NSUInteger i = 0; i < 5; i++) {
        self.backgroundColor = [UIColor yellowColor];
        CFRunLoopRunInMode(kCFRunLoopDefaultMode, 0.05, false);
        
        self.alpha = 0.0f;
        CFRunLoopRunInMode(kCFRunLoopDefaultMode, 0.05, false);
        
        self.backgroundColor = [UIColor blueColor];
        CFRunLoopRunInMode(kCFRunLoopDefaultMode, 0.05, false);
        
        self.alpha = 1.0f;
        CFRunLoopRunInMode(kCFRunLoopDefaultMode, 0.05, false);
    }
    
    self.alpha = orginalAlpha;
    self.backgroundColor = originalBackgroundColor;
    
    [originalBackgroundColor release];
}

- (BOOL)FEX_isVisible {
    if (self.hidden || self.alpha < 0.01f) {
        return NO;
    }
    
    if (self.superview != nil) {
        return [self.superview FEX_isVisible];
    } else {
        return YES;
    }
}

- (BOOL)FEX_isFullyWithinWindow {
    CGRect myFrameInWindowCoords = [self.window convertRect:self.bounds fromView:self];
    return CGRectContainsRect(self.window.bounds, myFrameInWindowCoords);
}

// checking if the view is fully visible in its superviews. We don't check if the view is overlapped by other views.
- (BOOL)FEX_isFullyVisible {
    if (![self FEX_isVisible] || ![self FEX_isFullyWithinWindow]) {
        return NO;
    }
    
    UIView* superview = self.superview;
    
    while (superview != nil) {
        CGRect viewRect = [self convertRect:self.bounds toView:superview];
        
        if (superview.clipsToBounds && !CGRectContainsRect(superview.bounds, viewRect)) {
            return NO;
        }
        
        superview = superview.superview;
    }
    
    return YES;
}

@end
