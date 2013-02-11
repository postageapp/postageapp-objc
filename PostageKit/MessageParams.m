//
//  MessageParams.m
//  PostageKit
//
//  Created by Stephan Leroux on 2013-01-08.
//  Copyright (c) 2013 PostageApp. All rights reserved.
//

#import "MessageParams.h"

@implementation MessageParams

+ (id)params
{
    return [[MessageParams alloc] init];
}

- (NSDictionary *)json
{
    NSMutableDictionary *json = [NSMutableDictionary dictionary];
    
    [json setValue:_recipients forKey:@"recipients"];
    [json setValue:_headers forKey:@"headers"];
    [json setValue:_content forKey:@"content"];
    [json setValue:_attachments forKey:@"attachments"];
    [json setValue:_templateName forKey:@"template"];
    [json setValue:_variables forKey:@"variables"];
    [json setValue:_recipientOverrideAddress forKey:@"recipientOverride"];
    
    return json;
}

@end
