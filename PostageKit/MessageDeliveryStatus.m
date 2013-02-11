//
//  MessageDeliveryStatus.m
//  PostageKit
//
//  Created by Stephan Leroux on 2013-01-08.
//  Copyright (c) 2013 PostageApp. All rights reserved.
//

#import "MessageDeliveryStatus.h"

@implementation MessageDeliveryStatus

- (id)initWithJSON:(id)json
{
    if (self = [super initWithJSON:json]) {      	
      	_status = [[json valueForKey:@"status"] nilForNull];
      	_recipient = [[json valueForKey:@"recipient"] nilForNull];
      	_uniqueId = [[json valueForKey:@"unique_id"] nilForNull];
    }
    
    return self;
}

@end