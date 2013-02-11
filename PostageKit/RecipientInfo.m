//
//  RecipientInfo.m
//  PostageKit
//
//  Created by Stephan Leroux on 2013-01-08.
//  Copyright (c) 2013 PostageApp. All rights reserved.
//

#import "RecipientInfo.h"

@implementation RecipientInfo

- (id)initWithJSON:(id)json
{
    if (self = [super initWithJSON:json]) {        
        _status = [[json valueForKey:@"status"] nilForNull];
        _message = [[json valueForKey:@"message"] nilForNull];
        _score = [[json valueForKey:@"score"] unsignedIntValue];
        _openedCount = [[json valueForKey:@"opened_count"] unsignedIntValue];
        _clickedCount = [[json valueForKey:@"clicked_count"] unsignedIntValue];
        _softBounceCount = [[json valueForKey:@"soft_bounce_count"] unsignedIntValue];
        _hardBounceCount = [[json valueForKey:@"hard_bounce_count"] unsignedIntValue];
        _optOutCount = [[json valueForKey:@"opt_out_count"] unsignedIntValue];
        _spamReportCount = [[json valueForKey:@"spam_report_count"] unsignedIntValue];
    }
    
    return self;
}

@end