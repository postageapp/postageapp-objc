//
//  MessageParams.h
//  PostageKit
//
//  Created by Stephan Leroux on 2013-01-08.
//  Copyright (c) 2013 The Working Group. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MessageParams : NSObject

@property (nonatomic, strong) NSString *UID;
@property (nonatomic, strong) NSMutableArray *recipients;
@property (nonatomic, strong) NSMutableDictionary *headers;
@property (nonatomic, strong) NSMutableDictionary *content;
@property (nonatomic, strong) NSMutableDictionary *attachments;
@property (nonatomic, strong) NSString *templateName;
@property (nonatomic, strong) NSMutableDictionary *variables;
@property (nonatomic, strong) NSString *recipientOverrideAddress;

@end
