//
//  XCHooks.m
//  XCHooks
//
//  Created by Matthew Nespor on 1/4/16.
//  Copyright © 2016 Matthew Nespor. All rights reserved.
//

#import "XCHooks.h"
#import "XCHScript.h"

const NSString* kXCHEnvironmentVariableNameFilePath = @"FILE_PATH";

@interface XCHooks()

@property (nonatomic, strong, readwrite) NSBundle *bundle;
@property (nonatomic, strong) NSOperationQueue* taskQueue;

@end

@implementation XCHooks

+ (instancetype)sharedPlugin
{
    return sharedPlugin;
}

- (id)initWithBundle:(NSBundle *)plugin
{
    if (self = [super init]) {
        // reference to plugin's bundle, for resource access
        self.bundle = plugin;
        _taskQueue = [[NSOperationQueue alloc] init];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(didApplicationFinishLaunchingNotification:)
                                                     name:NSApplicationDidFinishLaunchingNotification
                                                   object:nil];

        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(documentDidSave:)
                                                     name:@"IDEEditorDocumentDidSaveNotification"
                                                   object:nil];

//        IDEEditorDocumentDidSaveNotification

    }
    return self;
}


- (void)didApplicationFinishLaunchingNotification:(NSNotification*)note
{
    //removeObserver
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NSApplicationDidFinishLaunchingNotification object:nil];
    
    // Create menu items, initialize UI, etc.
    // Sample Menu Item:
    NSMenuItem *menuItem = [[NSApp mainMenu] itemWithTitle:@"Edit"];
    if (menuItem) {
        [[menuItem submenu] addItem:[NSMenuItem separatorItem]];
        NSMenuItem *actionMenuItem = [[NSMenuItem alloc] initWithTitle:@"Do Action" action:@selector(doMenuAction) keyEquivalent:@""];
        //[actionMenuItem setKeyEquivalentModifierMask:NSAlphaShiftKeyMask | NSControlKeyMask];
        [actionMenuItem setTarget:self];
        [[menuItem submenu] addItem:actionMenuItem];
    }
}

- (void)doMenuAction
{
}

- (void)documentDidSave:(NSNotification*)note {
    NSLog(@"%@", note.object);
    if ([note.object isKindOfClass:[NSDocument class]]) {
        NSMutableDictionary* environment = [NSMutableDictionary dictionary];
        NSDocument* document = (NSDocument*)note.object;
        if ([document.fileURL isFileURL]) {
            environment[kXCHEnvironmentVariableNameFilePath] = document.fileURL.path;
        }

        NSDictionary* frozenEnvironment = [environment copy];

        // TODO: XCHTasks have a launch path and a body.
        XCHScript* s = [[XCHScript alloc] init];
        s.shellPath = @"/bin/bash";
        s.body = @"echo 'hello $FILE_PATH'";
        NSArray* scripts = @[s];

        [scripts enumerateObjectsUsingBlock:^(XCHScript*  _Nonnull script, NSUInteger idx, BOOL * _Nonnull stop) {
            [self.taskQueue addOperationWithBlock:^{
                NSTask* task = [[NSTask alloc] init];
                // TODO: Create a dropdown menu that provides only the default installations of bash, sh, and zsh for now (sorry, bash4 and Planck users!)
                task.launchPath = script.shellPath;
                task.arguments = @[@"-c", script.body];
                task.environment = frozenEnvironment;
                [task launch];
                [task waitUntilExit];
            }];
        }];
    }
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
