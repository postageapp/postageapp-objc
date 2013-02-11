//
//  PostageClient.h
//  PostageKit
//
//  Created by Stephan Leroux on 2013-01-08.
//  Copyright (c) 2013 PostageApp. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "AFHTTPClient.h"

@class MessageParams, MessageReceipt, AccountInfo,
ProjectInfo, RecipientInfo, MessageDeliveryStatus;

typedef void (^ProjectInfoBlock)(ProjectInfo *info);
typedef void (^AccountInfoBlock)(AccountInfo *info);
typedef void (^MessagesBlock)(NSDictionary *messages);
typedef void (^MessageTransmissionsBlock)(NSArray *messageTransmissions);
typedef void (^MessageReceiptBlock)(NSUInteger messageID);
typedef void (^MethodListBlock)(NSArray *methods);
typedef void (^SendMessageBlock)(NSUInteger messageID);
typedef void (^MetricsBlock)(NSDictionary *metrics);
typedef void (^MessageStatusBlock)(NSDictionary *status);
typedef void (^DeliveryStatusBlock)(NSArray *deliveryStatuses);
typedef void (^RecipientsListBlock)(NSDictionary *recipients);

typedef void (^PostageErrorBlock)(NSError *error, id json);

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

- (void)statusForMessageWithUID:(NSString *)uid
                        success:(MessageStatusBlock)success
                          error:(PostageErrorBlock)error;

- (void)deliveryStatusForMessageWithUID:(NSString *)uid
                                success:(DeliveryStatusBlock)success
                                  error:(PostageErrorBlock)error;

- (void)recipientsListForMessageWithUID:(NSString *)uid
                                success:(RecipientsListBlock)success
                                  error:(PostageErrorBlock)error;
@end
