//
//  MessageTransmission.m
//  PostageKit
//
//  Created by Stephan Leroux on 2013-01-08.
//  Copyright (c) 2013 PostageApp. All rights reserved.
//

#import "MessageTransmission.h"

@implementation MessageTransmission

- (id)initWithJSON:(id)json
{
    if (self = [super initWithJSON:json]) {
        _status = [[json valueForKey:@"status"] nilForNull];
        _createdAt = [[json valueForKey:@"created_at"] nilForNull];
        _failedAt = [[json valueForKey:@"failed_at"] nilForNull];
        _openedAt = [[json valueForKey:@"opened_at"] nilForNull];
        _resultCode = [[json valueForKey:@"result_code"] nilForNull];
        _resultMessage = [[json valueForKey:@"result_message"] nilForNull];
    }
    
    return self;
}

@end
