//
//  ProjectInfo.m
//  PostageKit
//
//  Created by Stephan Leroux on 2013-01-08.
//  Copyright (c) 2013 The Working Group. All rights reserved.
//

#import "ProjectInfo.h"

@implementation ProjectInfo

- (id)initWithJSON:(id)json
{
    if (self = [super initWithJSON:json]) {
        NSDictionary *project = [json valueForKey:@"project"];
        
        _name = [[project valueForKey:@"name"] nilForNull];
        _url = [[project valueForKey:@"url"] nilForNull];
        _transmissions = [[project valueForKey:@"transmissions"] nilForNull];
        _users = [[project valueForKey:@"users"] nilForNull];
    }
    
    return self;
}

@end
