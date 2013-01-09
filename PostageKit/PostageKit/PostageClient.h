//
//  PostageClient.h
//  PostageKit
//
//  Created by Stephan Leroux on 2013-01-08.
//  Copyright (c) 2013 The Working Group. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "AFHTTPClient.h"

@class ProjectInfo, AccountInfo;

typedef void (^PostageErrorBlock)(NSError *error, id json);

typedef void (^ProjectInfoBlock)(ProjectInfo *info);
typedef void (^AccountInfoBlock)(AccountInfo *info);
typedef void (^MessagesBlock)(NSDictionary *messages);
typedef void (^MessageTransmissionsBlock)(NSArray *messageTransmissions);
typedef void (^MessageReceiptBlock)(NSUInteger messageID);
typedef void (^MethodListBlock)(NSArray *methods);
typedef void (^SendMessageBlock)(NSUInteger messageID);
typedef void (^MetricsBlock)(NSDictionary *metrics);

@class MessageParams, MessageReceipt, AccountInfo, ProjectInfo;

@interface PostageClient : AFHTTPClient

@property (nonatomic, strong) NSString *projectAPIKey;

+ (PostageClient *)sharedClient;

# pragma mark - API methods

- (void)sendMessage:(MessageParams *)params
            success:(SendMessageBlock)successBlock
              error:(PostageErrorBlock)errorBlock;

- (void)messageReceiptForUID:(NSString *)uid
                     success:(MessageReceiptBlock)success
                       error:(PostageErrorBlock)error;

- (void)methodListWithSuccess:(MethodListBlock)success
                        error:(PostageErrorBlock)error;

- (void)accountInfoWithSuccess:(AccountInfoBlock)success
                         error:(PostageErrorBlock)error;

- (void)projectInfoWithSuccess:(ProjectInfoBlock)success
                         error:(PostageErrorBlock)error;

- (void)messagesWithSuccess:(MessagesBlock)success
                      error:(PostageErrorBlock)error;

- (void)messageTransmissionsForUID:(NSString *)uid
                           success:(MessageTransmissionsBlock)success
                             error:(PostageErrorBlock)error;

- (void)metricsWithSuccess:(MetricsBlock)success
                     error:(PostageErrorBlock)error;

@end
