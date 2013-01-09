//
//  PostageClient.h
//  PostageKit
//
//  Created by Stephan Leroux on 2013-01-08.
//  Copyright (c) 2013 The Working Group. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "AFHTTPClient.h"

typedef void (^PostageSuccessBlock)(id);
typedef void (^PostageErrorBlock)(NSError *error, id json);

@class MessageParams, MessageReceipt, AccountInfo, ProjectInfo;

@interface PostageClient : AFHTTPClient

@property (nonatomic, strong) NSString *projectAPIKey;

+ (PostageClient *)sharedClient;

# pragma mark - API methods

- (void)sendMessage:(MessageParams *)params
            success:(PostageSuccessBlock)successBlock
              error:(PostageErrorBlock)errorBlock;

- (void)messageReceiptForUID:(NSString *)uid
                     success:(PostageSuccessBlock)success
                       error:(PostageErrorBlock)error;

- (void)methodListWithSuccess:(PostageSuccessBlock)success
                        error:(PostageErrorBlock)error;

- (void)accountInfoWithSuccess:(PostageSuccessBlock)success
                         error:(PostageErrorBlock)error;

- (void)projectInfoWithSuccess:(PostageSuccessBlock)success
                         error:(PostageErrorBlock)error;

- (void)messagesWithSuccess:(PostageSuccessBlock)success
                      error:(PostageErrorBlock)error;

- (void)messageTransmissionsForUID:(NSString *)uid
                           success:(PostageSuccessBlock)success
                             error:(PostageErrorBlock)error;

- (void)metricsWithSuccess:(PostageSuccessBlock)success
                     error:(PostageErrorBlock)error;

@end
