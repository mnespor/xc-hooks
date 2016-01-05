//
//  XCHScript.h
//  XCHooks
//
//  Created by Matthew Nespor on 1/4/16.
//  Copyright © 2016 Matthew Nespor. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XCHScript : NSObject

@property (copy, nonatomic) NSString* shellPath;
@property (copy, nonatomic) NSString* body;

@end
