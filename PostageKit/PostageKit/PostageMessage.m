//
//  PostageMessage.m
//  PostageKit
//
//  Created by Stephan Leroux on 2013-01-08.
//  Copyright (c) 2013 The Working Group. All rights reserved.
//

#import "PostageMessage.h"

@implementation PostageMessage

- (id)initWithJSON:(id)json forUID:(NSString *)uid
{
    if (self = [super initWithJSON:json]) {
        NSDictionary *message = [json valueForKey:uid];
        
        _UID = uid;
        _projectID = [[message valueForKey:@"project_id"] nilForNull];
        _templateName = [[message valueForKey:@"template"] nilForNull];
        _transmissionsTotal = [[message valueForKey:@"transmissionsTotal"] unsignedIntValue];
        _transmissionsFailed = [[message valueForKey:@"transmissionsFailed"] unsignedIntValue];
        _transmissionsCompleted = [[message valueForKey:@"transmissionsCompleted"] unsignedIntValue];
        _createdAt = [[message valueForKey:@"created_at"] nilForNull];
        _willPurgeAt = [[message valueForKey:@"will_purge_at"] nilForNull];
    }
    
    return self;
}

@end
