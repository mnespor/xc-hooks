//
//  XCHooks.h
//  XCHooks
//
//  Created by Matthew Nespor on 1/4/16.
//  Copyright © 2016 Matthew Nespor. All rights reserved.
//

#import <AppKit/AppKit.h>

@class XCHooks;

static XCHooks *sharedPlugin;

@interface XCHooks : NSObject

+ (instancetype)sharedPlugin;
- (id)initWithBundle:(NSBundle *)plugin;

@property (nonatomic, strong, readonly) NSBundle* bundle;
@end