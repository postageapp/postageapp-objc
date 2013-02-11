//
//  PostageClient.m
//  PostageKit
//
//  Created by Stephan Leroux on 2013-01-08.
//  Copyright (c) 2013 PostageApp. All rights reserved.
//

#import "PostageClient.h"

#import "AFJSONRequestOperation.h"
#import "MessageParams.h"
#import "AccountInfo.h"
#import "ProjectInfo.h"
#import "PostageMessage.h"
#import "MessageTransmission.h"
#import "RecipientInfo.h"
#import "MessageDeliveryStatus.h"

typedef void (^AFHTTPClientSuccess)(AFHTTPRequestOperation *, id);
typedef void (^AFHTTPClientError)(AFHTTPRequestOperation *, NSError *);

typedef void (^RailsParseSuccess)(id json);
typedef void (^RailsParseError)(NSError *error, id json);

static NSString * const kPostageAppBaseURL = @"https://api.postageapp.com/";

#define kAPIVersion @"v.1.0"
#define kVersion @"1.0.0"

#define kSendMessageEndpoint @"send_message.json"
#define kGetMessageReceiptEndpoint @"get_message_receipt.json"
#define kGetMethodListEndpoint @"get_method_list.json"
#define kGetAccountInfoEndpoint @"get_account_info.json"
#define kGetProjectInfoEndpoint @"get_project_info.json"
#define kGetMessagesEndpoint @"get_messages.json"
#define kGetMessageTransmissionsEndpoint @"get_message_transmissions.json"
#define kGetMetricsEndpoint @"get_metrics.json"
#define kMessageStatusEndpoint @"message_status.json"
#define kMessageDeliveryStatusEndpoint @"message_delivery_status.json"
#define kGetRecipientsListEndpoint @"get_recipients_list.json"

#define kNoProjectAPIKeySet 2

@interface PostageClient()

- (void)parseRailsPostPath:(NSString *)path
            withParameters:(NSDictionary *)parameters
                   success:(RailsParseSuccess)success
                     error:(RailsParseError)error;
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
        [self registerHTTPOperationClass:[AFHTTPRequestOperation class]];
    }
    
#if defined(__IPHONE_OS_VERSION_MIN_REQUIRED)
    // User-Agent Header; see http://www.w3.org/Protocols/rfc2616/rfc2616-sec14.html#sec14.43
    [self setDefaultHeader:@"User-Agent" value:[NSString stringWithFormat:@"POSTAGEAPP-OBJC %@ (%@; iOS %@; Scale/%0.2f)", kVersion, [[UIDevice currentDevice] model], [[UIDevice currentDevice] systemVersion], ([[UIScreen mainScreen] respondsToSelector:@selector(scale)] ? [[UIScreen mainScreen] scale] : 1.0f)]];
#elif defined(__MAC_OS_X_VERSION_MIN_REQUIRED)
    [self setDefaultHeader:@"User-Agent" value:[NSString stringWithFormat:@"POSTAGEAPP-OBJC %@ (Mac OS X %@)", kVersion, [[NSProcessInfo processInfo] operatingSystemVersionString]]];
#endif
    
    return self;
}

- (void)parseRailsPostPath:(NSString *)path
            withParameters:(NSDictionary *)parameters
                   success:(RailsParseSuccess)success
                     error:(RailsParseError)error
{
    // Wrap the original AFHTTPClient method to handle the rails response which comes as text/html from the API :(
    AFHTTPClientSuccess wrappedSuccess = ^(AFHTTPRequestOperation *operation, id responseData) {
        NSError *jsonError;
        NSDictionary *responseObject = [NSJSONSerialization JSONObjectWithData:responseData options:0 error:&jsonError];
        
        if (jsonError) {
            error(jsonError, nil);
            return;
        }
        
        if (success) {
            success([responseObject valueForKey:@"data"]);
        }
    };
    
    AFHTTPClientError wrappedError = ^(AFHTTPRequestOperation *operation, NSError *errorObj) {
        NSLog(@"%@", errorObj);
        
        if (error) {
            error(errorObj, [((AFJSONRequestOperation *)operation) responseString]);
        }
    };
    
    [self postPath:path parameters:parameters success:wrappedSuccess failure:wrappedError];
}

# pragma mark - API methods

- (void)sendMessage:(MessageParams *)messageParams
            success:(SendMessageBlock)success
              error:(PostageErrorBlock)error
{
    NSString *path = [NSString stringWithFormat:@"%@/%@", kAPIVersion, kSendMessageEndpoint];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:_projectAPIKey? _projectAPIKey : @"" forKey:@"api_key"];
    [params setValue:messageParams.UID forKey:@"uid"];
    [params setValue:[messageParams json] forKey:@"arguments"];
    
    [self parseRailsPostPath:path withParameters:params success:^(id json) {
        if (success) {
            success([[[json valueForKey:@"message"] valueForKey:@"id"] integerValue]);
        }
    } error:^(NSError *errorObj, id json) {
        if (error) {
            error(errorObj, json);
        }
    }];
}

- (void)messageReceiptForUID:(NSString *)uid
                     success:(MessageReceiptBlock)success
                       error:(PostageErrorBlock)error
{    
    NSString *path = [NSString stringWithFormat:@"%@/%@", kAPIVersion, kGetMessageReceiptEndpoint];
    NSDictionary *params = @{ @"api_key" : _projectAPIKey? _projectAPIKey : @"", @"uid" : uid };
    
    [self parseRailsPostPath:path withParameters:params success:^(id json) {
        if (success) {
            success([[[json valueForKey:@"message"] valueForKey:@"id"] integerValue]);
        }
    } error:^(NSError *errorObj, id json) {
        if (error) {
            error(errorObj, json);
        }
    }];
}

- (void)methodListWithSuccess:(MethodListBlock)success
                        error:(PostageErrorBlock)error
{   
    NSString *path = [NSString stringWithFormat:@"%@/%@", kAPIVersion, kGetMethodListEndpoint];
    NSDictionary *params = @{ @"api_key" : _projectAPIKey? _projectAPIKey : @"" };
    
    [self parseRailsPostPath:path withParameters:params success:^(id json) {
        if (success) {
            success([json valueForKey:@"methods"]);
        }
    } error:^(NSError *errorObj, id json) {
        if (error) {
            error(errorObj, json);
        }
    }];
}

- (void)accountInfoWithSuccess:(AccountInfoBlock)success
                         error:(PostageErrorBlock)error
{    
    NSString *path = [NSString stringWithFormat:@"%@/%@", kAPIVersion, kGetAccountInfoEndpoint];
    NSDictionary *params = @{ @"api_key" : _projectAPIKey? _projectAPIKey : @"" };
    
    [self parseRailsPostPath:path withParameters:params success:^(id json) {
        if (success) {
            success([[AccountInfo alloc] initWithJSON:json]);
        }
    } error:^(NSError *errorObj, id json) {
        if (error) {
            error(errorObj, json);
        }
    }];
}

- (void)projectInfoWithSuccess:(ProjectInfoBlock)success
                         error:(PostageErrorBlock)error
{    
    NSString *path = [NSString stringWithFormat:@"%@/%@", kAPIVersion, kGetProjectInfoEndpoint];
    NSDictionary *params = @{ @"api_key" : _projectAPIKey? _projectAPIKey : @"" };
    
    [self parseRailsPostPath:path withParameters:params success:^(id json) {
        if (success) {
            success([[ProjectInfo alloc] initWithJSON:json]);
        }
    } error:^(NSError *errorObj, id json) {
        if (error) {
            error(errorObj, json);
        }
    }];
}

- (void)messagesWithSuccess:(MessagesBlock)success
                      error:(PostageErrorBlock)error;
{
    NSString *path = [NSString stringWithFormat:@"%@/%@", kAPIVersion, kGetMessagesEndpoint];
    NSDictionary *params = @{ @"api_key" : _projectAPIKey? _projectAPIKey : @"" };
    
    [self parseRailsPostPath:path withParameters:params success:^(id json) {
        NSMutableDictionary *messages = [NSMutableDictionary dictionary];
        
        for (NSString *messageUID in json) {
            NSDictionary *messageJSON = [json valueForKey:messageUID];
            [messages setValue:[[PostageMessage alloc] initWithJSON:messageJSON forUID:messageUID] forKey:messageUID];
        }
        
        if (success) {
            success(messages);
        }
        
    } error:^(NSError *errorObj, id json) {
        if (error) {
            error(errorObj, json);
        }
    }];
}

- (void)messageTransmissionsForUID:(NSString *)uid
                           success:(MessageTransmissionsBlock)success
                             error:(PostageErrorBlock)error
{    
    NSString *path = [NSString stringWithFormat:@"%@/%@", kAPIVersion, kGetMessageTransmissionsEndpoint];
    NSDictionary *params = @{ @"api_key" : _projectAPIKey? _projectAPIKey : @"", @"uid" : uid };
    
    [self parseRailsPostPath:path withParameters:params success:^(id json) {
        NSMutableArray *transmissions = [NSMutableArray array];
        NSDictionary *transmissionsJSON = [json valueForKey:@"transmissions"];
        
        for (NSString *transmissionKey in transmissionsJSON) {
            [transmissions addObject:[[MessageTransmission alloc] initWithJSON:[transmissionsJSON valueForKey:transmissionKey]]];
        }
        
        if (success) {
            success(transmissions);
        }
    } error:^(NSError *errorObj, id json) {
        if (error) {
            error(errorObj, json);
        }
    }];
}

- (void)metricsWithSuccess:(MetricsBlock)success
                     error:(PostageErrorBlock)error
{    
    NSString *path = [NSString stringWithFormat:@"%@/%@", kAPIVersion, kGetMetricsEndpoint];
    NSDictionary *params = @{ @"api_key" : _projectAPIKey? _projectAPIKey : @"" };
    
    [self parseRailsPostPath:path withParameters:params success:^(id json) {
        if (success) {
            success([json valueForKey:@"metrics"]);
        }
    } error:^(NSError *errorObj, id json) {
        if (error) {
            error(errorObj, json);
        }
    }];
}

- (void)statusForMessageWithUID:(NSString *)uid
                        success:(MessageStatusBlock)success
                          error:(PostageErrorBlock)error
{
    NSString *path = [NSString stringWithFormat:@"%@/%@", kAPIVersion, kMessageStatusEndpoint];
    NSDictionary *params = @{ @"api_key" : _projectAPIKey? _projectAPIKey : @"", @"uid": uid };
    
    [self parseRailsPostPath:path withParameters:params success:^(id json) {
        if (success) {
            success([json valueForKey:@"message_status"]);
        }
    } error:^(NSError *errorObj, id json) {
        if (error) {
            error(errorObj, json);
        }
    }];
}

- (void)deliveryStatusForMessageWithUID:(NSString *)uid
                                success:(DeliveryStatusBlock)success
                                  error:(PostageErrorBlock)error
{
    NSString *path = [NSString stringWithFormat:@"%@/%@", kAPIVersion, kMessageDeliveryStatusEndpoint];
    NSDictionary *params = @{ @"api_key" : _projectAPIKey? _projectAPIKey : @"", @"uid": uid };
    
    [self parseRailsPostPath:path withParameters:params success:^(id json) {
        if (success) {
            NSArray *statuses = [json valueForKey:@"delivery_status"];
            
            __block NSMutableArray *statusesResult = [NSMutableArray array];
            [statuses enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                [statusesResult addObject:[[MessageDeliveryStatus alloc] initWithJSON:obj]];
            }];
            
            success(statuses);
        }
    } error:^(NSError *errorObj, id json) {
        if (error) {
            error(errorObj, json);
        }
    }];
}

- (void)recipientsListForMessageWithUID:(NSString *)uid
                                success:(RecipientsListBlock)success
                                  error:(PostageErrorBlock)error
{
    NSString *path = [NSString stringWithFormat:@"%@/%@", kAPIVersion, kGetRecipientsListEndpoint];
    NSDictionary *params = @{ @"api_key" : _projectAPIKey? _projectAPIKey : @"", @"uid": uid };
    
    [self parseRailsPostPath:path withParameters:params success:^(id json) {
        if (success) {
            NSDictionary *recipients = [json valueForKey:@"recipients"];
            
            __block NSMutableDictionary *resultsDict = [NSMutableDictionary dictionary];
            [recipients enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
                [resultsDict setValue:[[RecipientInfo alloc] initWithJSON:obj] forKey:key];
            }];
            
            success(resultsDict);
        }
    } error:^(NSError *errorObj, id json) {
        if (error) {
            error(errorObj, json);
        }
    }];
}

@end
