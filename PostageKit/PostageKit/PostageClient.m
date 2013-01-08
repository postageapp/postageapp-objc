//
//  PostageClient.m
//  PostageKit
//
//  Created by Stephan Leroux on 2013-01-08.
//  Copyright (c) 2013 The Working Group. All rights reserved.
//

#import "PostageClient.h"

#import "AFJSONRequestOperation.h"
#import "MessageReceipt.h"
#import "MessageParams.h"
#import "AccountInfo.h"
#import "ProjectInfo.h"
#import "PostageMessage.h"
#import "MessageTransmission.h"

static NSString * const kPostageAppBaseURL = @"https://api.postageapp.com/";

#define kAPIVersion @"v.1.0"

#define kSendMessageEndpoint @"send_message.json"
#define kGetMessageReceiptEndpoint @"get_message_receipt.json"
#define kGetMethodListEndpoint @"get_method_list.json"
#define kGetAccountInfoEndpoint @"get_account_info.json"
#define kGetProjectInfoEndpoint @"get_project_info.json"
#define kGetMessagesEndpoint @"get_messages.json"
#define kGetMessageTransmissionsEndpoint @"get_message_transmissions.json"
#define kGetMetricsEndpoint @"get_metrics.json"

#define kStatusFail 1
#define kNoProjectAPIKeySet 2

@interface PostageClient()

@end

@implementation PostageClient

+ (PostageClient *)sharedClient
{
    static PostageClient *sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedClient = [[PostageClient alloc] initWithBaseURL:[NSURL URLWithString:kPostageAppBaseURL]];
    });
    
    return sharedClient;
}

- (id)initWithBaseURL:(NSURL *)url
{
    if (self = [super initWithBaseURL:url]) {
        [self registerHTTPOperationClass:[AFJSONRequestOperation class]];
        
        [self setDefaultHeader:@"Accept" value:@"application/json"];
    }
    
    return self;
}

- (NSError *)checkForProjectAPIKey
{
    if (!_projectAPIKey) {
        // Error
        NSError *error = [[NSError alloc] initWithDomain:@"api.postageapp.com" code:kNoProjectAPIKeySet userInfo:nil];
        return error;
    } else {
        return nil;
    }
}

- (NSError *)checkResponseForError:(NSDictionary *)responseObject
{
    NSDictionary *response = [responseObject valueForKey:@"response"];
    
    if (![[response valueForKey:@"status"] isEqual:@"ok"]) {
        // Error
        NSError *error = [[NSError alloc] initWithDomain:@"api.postageapp.com" code:kStatusFail userInfo:nil];
        return error;
    } else {
        return nil;
    }
}

# pragma mark - API methods

- (void)sendMessage:(MessageParams *)messageParams
            success:(PostageSuccessBlock)success
              error:(PostageErrorBlock)error
{
    NSError *errorObj = nil;
    if ((errorObj = [self checkForProjectAPIKey])) {
        if (error) {
            error(errorObj, nil);
            return;
        }
    }
    
    NSString *path = [NSString stringWithFormat:@"%@/%@", kAPIVersion, kSendMessageEndpoint];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:_projectAPIKey forKey:@"api_key"];
    [params setValue:messageParams.UID forKey:@"uid"];
    NSDictionary *arguments = @{
        @"recipients" : messageParams.recipients,
        @"headers" : messageParams.headers,
        @"content" : messageParams.content,
        @"attachments" : messageParams.attachments,
        @"template" : messageParams.templateName,
        @"variables" : messageParams.variables,
        @"recipient_override" : messageParams.recipientOverrideAddress
    };
    
    [params setValue:arguments forKey:@"arguments"];
    
    [self postPath:path parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSError *errorObj;
        if ((errorObj = [self checkResponseForError:responseObject])) {
            if (error) {
                error(errorObj, responseObject);
            }
        } else {
            if (success) {
                success([[[responseObject valueForKey:@"data"] valueForKey:@"message"] valueForKey:@"id"]);
            }
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *errorObj) {
        if (error) {
            error(errorObj, [((AFJSONRequestOperation *)operation) responseJSON]);
        }
    }];
}

- (void)messageReceiptForUID:(NSString *)uid
                                 success:(PostageSuccessBlock)success
                                   error:(PostageErrorBlock)error
{
    NSError *errorObj = nil;
    if ((errorObj = [self checkForProjectAPIKey])) {
        if (error) {
            error(errorObj, nil);
            return;
        }
    }
    
    NSString *path = [NSString stringWithFormat:@"%@/%@", kAPIVersion, kGetMessageReceiptEndpoint];
    NSDictionary *params = @{
        @"api_key" : _projectAPIKey,
        @"uid" : uid
    };
    
    [self getPath:path parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSError *errorObj;
        if ((errorObj = [self checkResponseForError:responseObject])) {
            if (error) {
                error(errorObj, responseObject);
            }
        } else {
            MessageReceipt *messageReceipt = [[MessageReceipt alloc] initWithJSON:[responseObject valueForKey:@"data"]];
            
            if (success) {
                success(messageReceipt);
            }
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *errorObj) {
        if (error) {
            error(errorObj, [((AFJSONRequestOperation *)operation) responseJSON]);
        }
    }];
}

- (void)methodListWithSuccess:(PostageSuccessBlock)success
                        error:(PostageErrorBlock)error
{
    NSError *errorObj = nil;
    if ((errorObj = [self checkForProjectAPIKey])) {
        if (error) {
            error(errorObj, nil);
            return;
        }
    }
    
    NSString *path = [NSString stringWithFormat:@"%@/%@", kAPIVersion, kGetMethodListEndpoint];
    NSDictionary *params = @{ @"api_key" : _projectAPIKey };
    
    [self postPath:path parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSError *errorObj;
        if ((errorObj = [self checkResponseForError:responseObject])) {
            if (error) {
                error(errorObj, responseObject);
            }
        } else {
            if (success) {
                success([[responseObject valueForKey:@"data"] valueForKey:@"methods"]);
            }
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *errorObj) {
        if (error) {
            error(errorObj, [((AFJSONRequestOperation *)operation) responseJSON]);
        }
    }];
}

- (void)accountInfoWithSuccess:(PostageSuccessBlock)success
                         error:(PostageErrorBlock)error
{
    NSError *errorObj = nil;
    if ((errorObj = [self checkForProjectAPIKey])) {
        if (error) {
            error(errorObj, nil);
            return;
        }
    }
    
    NSString *path = [NSString stringWithFormat:@"%@/%@", kAPIVersion, kGetAccountInfoEndpoint];
    NSDictionary *params = @{ @"api_key" : _projectAPIKey };
    
    [self postPath:path parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSError *errorObj;
        if ((errorObj = [self checkResponseForError:responseObject])) {
            if (error) {
                error(errorObj, responseObject);
            }
        } else {
            if (success) {
                success([[AccountInfo alloc] initWithJSON:[responseObject valueForKey:@"data"]]);
            }
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *errorObj) {
        if (error) {
            error(errorObj, [((AFJSONRequestOperation *)operation) responseJSON]);
        }
    }];
}

- (void)projectInfoWithSuccess:(PostageSuccessBlock)success
                         error:(PostageErrorBlock)error
{
    NSError *errorObj = nil;
    if ((errorObj = [self checkForProjectAPIKey])) {
        if (error) {
            error(errorObj, nil);
            return;
        }
    }
    
    NSString *path = [NSString stringWithFormat:@"%@/%@", kAPIVersion, kGetProjectInfoEndpoint];
    NSDictionary *params = @{ @"api_key" : _projectAPIKey };
    
    [self postPath:path parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSError *errorObj;
        if ((errorObj = [self checkResponseForError:responseObject])) {
            if (error) {
                error(errorObj, responseObject);
            }
        } else {
            if (success) {
                success([[ProjectInfo alloc] initWithJSON:[responseObject valueForKey:@"data"]]);
            }
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *errorObj) {
        if (error) {
            error(errorObj, [((AFJSONRequestOperation *)operation) responseJSON]);
        }
    }];
}

- (void)messagesWithSuccess:(PostageSuccessBlock)success
                      error:(PostageErrorBlock)error;
{
    NSError *errorObj = nil;
    if ((errorObj = [self checkForProjectAPIKey])) {
        if (error) {
            error(errorObj, nil);
            return;
        }
    }
    
    NSString *path = [NSString stringWithFormat:@"%@/%@", kAPIVersion, kGetMessagesEndpoint];
    NSDictionary *params = @{ @"api_key" : _projectAPIKey };
    
    [self postPath:path parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSError *errorObj;
        if ((errorObj = [self checkResponseForError:responseObject])) {
            if (error) {
                error(errorObj, responseObject);
            }
        } else {
            NSMutableDictionary *messages = [NSMutableDictionary dictionary];
            NSDictionary *data = [responseObject valueForKey:@"data"];
            NSString *messageUID = nil;
            
            while (messageUID = [[data keyEnumerator] nextObject]) {
                NSDictionary *messageJSON = [data valueForKey:messageUID];
                [messages setValue:[[PostageMessage alloc] initWithJSON:messageJSON] forKey:messageUID];
            }
            
            if (success) {
                success(messages);
            }
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *errorObj) {
        if (error) {
            error(errorObj, [((AFJSONRequestOperation *)operation) responseJSON]);
        }
    }];
}

- (void)messageTransmissionsForUID:(NSString *)uid
                           success:(PostageSuccessBlock)success
                             error:(PostageErrorBlock)error
{
    NSError *errorObj = nil;
    if ((errorObj = [self checkForProjectAPIKey])) {
        if (error) {
            error(errorObj, nil);
            return;
        }
    }
    
    NSString *path = [NSString stringWithFormat:@"%@/%@", kAPIVersion, kGetMessageTransmissionsEndpoint];
    NSDictionary *params = @{ @"api_key" : _projectAPIKey, @"uid" : uid };
    
    [self postPath:path parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSError *errorObj;
        if ((errorObj = [self checkResponseForError:responseObject])) {
            if (error) {
                error(errorObj, responseObject);
            }
        } else {
            NSMutableArray *transmissions = [NSMutableArray array];
            NSDictionary *transmissionsJSON = [[responseObject valueForKey:@"data"] valueForKey:@"transmissions"];
            NSString *transmissionKey = nil;
            
            while (transmissionKey = [[transmissionsJSON keyEnumerator] nextObject]) {
                [transmissions addObject:[[MessageTransmission alloc] initWithJSON:[transmissionsJSON valueForKey:transmissionKey]]];
            }
        
            if (success) {
                success(transmissions);
            }
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *errorObj) {
        if (error) {
            error(errorObj, [((AFJSONRequestOperation *)operation) responseJSON]);
        }
    }];
}

- (void)metricsWithSuccess:(PostageSuccessBlock)success
                     error:(PostageErrorBlock)error
{
    NSError *errorObj = nil;
    if ((errorObj = [self checkForProjectAPIKey])) {
        if (error) {
            error(errorObj, nil);
            return;
        }
    }
    
    NSString *path = [NSString stringWithFormat:@"%@/%@", kAPIVersion, kGetMetricsEndpoint];
    NSDictionary *params = @{ @"api_key" : _projectAPIKey };
    
    [self postPath:path parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSError *errorObj;
        if ((errorObj = [self checkResponseForError:responseObject])) {
            if (error) {
                error(errorObj, responseObject);
            }
        } else {
            if (success) {
                success([[responseObject valueForKey:@"data"] valueForKey:@"metrics"]);
            }
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *errorObj) {
        if (error) {
            error(errorObj, [((AFJSONRequestOperation *)operation) responseJSON]);
        }
    }]; 
}

@end
