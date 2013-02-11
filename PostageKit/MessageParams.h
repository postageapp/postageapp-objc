//
//  MessageParams.h
//  PostageKit
//
//  Created by Stephan Leroux on 2013-01-08.
//  Copyright (c) 2013 PostageApp. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MessageParams : NSObject

@property (nonatomic, strong) NSString *UID;
@property (nonatomic, strong) NSArray *recipients;
@property (nonatomic, strong) NSDictionary *headers;
@property (nonatomic, strong) NSDictionary *content;
@property (nonatomic, strong) NSDictionary *attachments;
@property (nonatomic, strong) NSString *templateName;
@property (nonatomic, strong) NSDictionary *variables;
@property (nonatomic, strong) NSString *recipientOverrideAddress;

+ (id)params;

- (NSDictionary *)json;

@end
