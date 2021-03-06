//
//  ToolbarHelperController.h
//  Señor Staff
//
//  Created by Konstantine Prevas on 11/19/06.
//
//  The source code in this file is available in the public domain.  Permission is granted to use,
//  modify, or distribute it; however, it is provided "as is" and without warranties as to performance or merchantability.

#import <Cocoa/Cocoa.h>


@interface ToolbarHelperController : NSWindowController {
	NSMutableDictionary *toolbarItems;
	NSMutableArray *idList, *defaultIdList;
	NSMutableArray *customViews;
	NSMutableDictionary *imageItemKeys;
}

- (void) addToolbarItemWithImage:(NSImage *)image
					  identifier:(NSString *)identifier
						   label:(NSString *)label
					paletteLabel:(NSString *)paletteLabel
						 toolTip:(NSString *)toolTip
						  target:(id)target
						  action:(SEL)action
						keyEquiv:(NSString *)keyEquiv
					   isDefault:(BOOL)isDefault;

- (void) addToolbarItemWithView:(NSView *)view
					 identifier:(NSString *)identifier
						  label:(NSString *)label
				   paletteLabel:(NSString *)paletteLabel
						toolTip:(NSString *)toolTip
						 target:(id)target
						 action:(SEL)action
					  isDefault:(BOOL)isDefault;

- (void) addToolbarSeparator;
- (void) addToolbarSpace;
- (void) addToolbarFlexibleSpace;

- (void) allowToolbarSeparator;
- (void) allowToolbarSpace;
- (void) allowToolbarFlexibleSpace;

- (NSToolbar *) initToolbarWithIdentifier:(NSString *)identifier customizable:(BOOL)customizable;

- (BOOL)handleToolbarKeystroke:(NSEvent *)event;

@end
