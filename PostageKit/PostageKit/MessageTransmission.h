//
//  MessageTransmission.h
//  PostageKit
//
//  Created by Stephan Leroux on 2013-01-08.
//  Copyright (c) 2013 The Working Group. All rights reserved.
//

#import "JSONObject.h"

@interface MessageTransmission : JSONObject

@property (readonly, nonatomic, strong) NSString *status;
@property (readonly, nonatomic, strong) NSDate *createdAt;
@property (readonly, nonatomic, strong) NSDate *failedAt;
@property (readonly, nonatomic, strong) NSDate *openedAt;
@property (readonly, nonatomic, strong) NSString *resultCode;
@property (readonly, nonatomic, strong) NSString *resultMessage;

@end
