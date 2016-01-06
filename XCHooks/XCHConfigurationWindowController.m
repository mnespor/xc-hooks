//
//  XCHConfigurationWindowController.m
//  XCHooks
//
//  Created by Matthew Nespor on 1/5/16.
//  Copyright © 2016 Matthew Nespor. All rights reserved.
//

#import "XCHConfigurationWindowController.h"
#import "XCHUserDefaultsKeys.h"

@interface XCHConfigurationWindowController ()
@property (weak) IBOutlet NSPopUpButton *hookNamePopUpButton;
@property (weak) IBOutlet NSPopUpButton *shellPopUpButton;
@property (weak) IBOutlet NSButton *hookSwitch;
@property (weak) IBOutlet NSTextField *scriptField;

@end

@implementation XCHConfigurationWindowController
- (IBAction)hookNameSelectionDidChange:(NSPopUpButton *)sender {

}

- (IBAction)hookDidToggle:(NSButton *)sender {
    BOOL checked = sender.state == NSOnState;
    [[NSUserDefaults standardUserDefaults] setBool:checked forKey:kXCHUserDefaultsKeyHookEnabled];
}

- (IBAction)shellSelectionDidChange:(NSPopUpButton *)sender {

}

- (void)windowDidLoad {
    [super windowDidLoad];
    self.hookSwitch.state = [[NSUserDefaults standardUserDefaults] boolForKey:kXCHUserDefaultsKeyHookEnabled] ? NSOnState : NSOffState;
    NSString* script = [[NSUserDefaults standardUserDefaults] stringForKey:kXCHUserDefaultsKeyScript];
    self.scriptField.stringValue = script == nil ? @"" : script;
    self.scriptField.delegate = self;
}

#pragma mark - NSTextDelegate

- (BOOL)control:(NSControl*)control textView:(NSTextView*)textView doCommandBySelector:(SEL)commandSelector
{
    BOOL result = NO;

    if (commandSelector == @selector(insertNewline:))
    {
        // new line action:
        // always insert a line-break character and don’t cause the receiver to end editing
        [textView insertNewlineIgnoringFieldEditor:self];
        result = YES;
    }
    else if (commandSelector == @selector(insertTab:))
    {
        // tab action:
        // always insert a tab character and don’t cause the receiver to end editing
        [textView insertTabIgnoringFieldEditor:self];
        result = YES;
    }

    return result;
}

- (void)controlTextDidChange:(NSNotification *)obj {
    if ([obj.object respondsToSelector:@selector(stringValue)]) {
        NSString* script = [obj.object stringValue];
        [[NSUserDefaults standardUserDefaults] setValue:script forKey:kXCHUserDefaultsKeyScript];
    }
}

@end
