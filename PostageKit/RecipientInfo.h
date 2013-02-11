//
//  RecipientInfo.h
//  PostageKit
//
//  Created by Stephan Leroux on 2013-01-08.
//  Copyright (c) 2013 PostageApp. All rights reserved.
//

#import "JSONObject.h"

@interface RecipientInfo : JSONObject

@property (nonatomic, readonly, strong) NSString *status;
@property (nonatomic, readonly, strong) NSString *message;
@property (nonatomic, readonly, assign) NSUInteger score;
@property (nonatomic, readonly, assign) NSUInteger openedCount;
@property (nonatomic, readonly, assign) NSUInteger clickedCount;
@property (nonatomic, readonly, assign) NSUInteger softBounceCount;
@property (nonatomic, readonly, assign) NSUInteger hardBounceCount;
@property (nonatomic, readonly, assign) NSUInteger optOutCount;
@property (nonatomic, readonly, assign) NSUInteger spamReportCount;

@end