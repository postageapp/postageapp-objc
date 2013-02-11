//
//  NSObject+TWG.m
//  PostageKit
//
//  Created by Stephan Leroux on 2013-01-08.
//  Copyright (c) 2013 PostageApp. All rights reserved.
//

#import "NSObject+PostageKit.h"

@implementation NSObject (PostageKit)

- (id)nilForNull
{
    if ([self isKindOfClass:[NSNull class]]) {
        return nil;
    }
    
    return self;
}

@end
