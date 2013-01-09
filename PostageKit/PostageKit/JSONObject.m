//
//  JSONObject.m
//  PostageKit
//
//  Created by Stephan Leroux on 2013-01-08.
//  Copyright (c) 2013 The Working Group. All rights reserved.
//

#import "JSONObject.h"
#import <objc/runtime.h>

@implementation JSONObject

- (id)initWithJSON:(id)json
{
    if (self = [super init]) {
        // Stub
    }
    
    return self;
}

- (NSString *)description
{
    NSMutableArray *propertyList = [NSMutableArray array];
    
    unsigned int outCount, i;
    objc_property_t *properties = class_copyPropertyList([self class], &outCount);
    for(i = 0; i < outCount; i++) {
    	objc_property_t property = properties[i];
    	const char *propName = property_getName(property);
    	if(propName) {
    		NSString *propertyName = [NSString stringWithCString:propName encoding:NSUTF8StringEncoding];
            [propertyList addObject:propertyName];
    	}
    }
    free(properties);
    
    NSDictionary *propertyNames = [self dictionaryWithValuesForKeys:propertyList];
    NSError *jsonError;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:propertyNames options:0 error:&jsonError];

    if (jsonError) {
        return [super description];
    } else {
        return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
}

@end
