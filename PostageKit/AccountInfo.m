//
//  AccountInfo.m
//  PostageKit
//
//  Created by Stephan Leroux on 2013-01-08.
//  Copyright (c) 2013 PostageApp. All rights reserved.
//

#import "AccountInfo.h"

@implementation AccountInfo

- (id)initWithJSON:(id)json
{
    if (self = [super initWithJSON:json]) {
        NSDictionary *account = [json valueForKey:@"account"];
        
        _name = [[account valueForKey:@"name"] nilForNull];
        _url = [[account valueForKey:@"url"] nilForNull];
        _transmissions = [[account valueForKey:@"transmissions"] nilForNull];
        _users = [[account valueForKey:@"users"] nilForNull];
    }
    
    return self;
}

@end
