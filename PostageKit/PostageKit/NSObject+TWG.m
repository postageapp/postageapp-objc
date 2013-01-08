//
//  NSObject+TWG.m
//  PostageKit
//
//  Created by Stephan Leroux on 2013-01-08.
//  Copyright (c) 2013 The Working Group. All rights reserved.
//

#import "NSObject+TWG.h"

@implementation NSObject (TWG)

- (id)nilForNull
{
    if ([self isKindOfClass:[NSNull class]]) {
        return nil;
    }
    
    return self;
}

@end
