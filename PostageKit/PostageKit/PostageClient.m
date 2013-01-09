//
//  PostageClient.m
//  PostageKit
//
//  Created by Stephan Leroux on 2013-01-08.
//  Copyright (c) 2013 The Working Group. All rights reserved.
//

#import "PostageClient.h"

#import "AFJSONRequestOperation.h"
#import "MessageParams.h"
#import "AccountInfo.h"
#import "ProjectInfo.h"
#import "PostageMessage.h"
#import "MessageTransmission.h"

typedef void (^AFHTTPClientSuccess)(AFHTTPRequestOperation *, id);
typedef void (^AFHTTPClientError)(AFHTTPRequestOperation *, NSError *);

typedef void (^RailsParseSuccess)(id json);
typedef void (^RailsParseError)(NSError *error, id json);

static NSString * const kPostageAppBaseURL = @"https://api.postageapp.com/";

#define kAPIVersion @"v.1.0"
#define kVersion @"1.0.1"

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
        [self registerHTTPOperationClass:[AFHTTPRequestOperation class]];
    }
    
    
#if defined(__IPHONE_OS_VERSION_MIN_REQUIRED)
    // User-Agent Header; see http://www.w3.org/Protocols/rfc2616/rfc2616-sec14.html#sec14.43
    [self setDefaultHeader:@"User-Agent" value:[NSString stringWithFormat:@"POSTAGEKIT %@ (%@; iOS %@; Scale/%0.2f)", kVersion, [[UIDevice currentDevice] model], [[UIDevice currentDevice] systemVersion], ([[UIScreen mainScreen] respondsToSelector:@selector(scale)] ? [[UIScreen mainScreen] scale] : 1.0f)]];
#elif defined(__MAC_OS_X_VERSION_MIN_REQUIRED)
    [self setDefaultHeader:@"User-Agent" value:[NSString stringWithFormat:@"POSTAGEKIT %@ (Mac OS X %@)", kVersion, [[NSProcessInfo processInfo] operatingSystemVersionString]]];
#endif
    
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
        
        NSError *errorObj;
        if ((errorObj = [self checkResponseForError:responseObject])) {
            if (error) {
                error(errorObj, responseObject);
            }
        } else {
            if (success) {
                success([responseObject valueForKey:@"data"]);
            }
        }
    };
    
    AFHTTPClientError wrappedError = ^(AFHTTPRequestOperation *operation, NSError *errorObj) {
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
    [params setValue:[messageParams json] forKey:@"arguments"];
    
    [self parseRailsPostPath:path withParameters:params success:^(id json) {
        if (success) {
            success([[[json valueForKey:@"message"] valueForKey:@"id"] integerValue]);
        }
    } error:nil];
}

- (void)messageReceiptForUID:(NSString *)uid
                                 success:(MessageReceiptBlock)success
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
    
    [self parseRailsPostPath:path withParameters:params success:^(id json) {
        if (success) {
            success([[[json valueForKey:@"message"] valueForKey:@"id"] integerValue]);
        }
    } error:nil];
}

- (void)methodListWithSuccess:(MethodListBlock)success
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
    
    [self parseRailsPostPath:path withParameters:params success:^(id json) {
        if (success) {
            success([json valueForKey:@"methods"]);
        }
    } error:nil];
}

- (void)accountInfoWithSuccess:(AccountInfoBlock)success
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
    
    [self parseRailsPostPath:path withParameters:params success:^(id json) {
        if (success) {
            success([[AccountInfo alloc] initWithJSON:json]);
        }
    } error:nil];
}

- (void)projectInfoWithSuccess:(ProjectInfoBlock)success
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
    
    [self parseRailsPostPath:path withParameters:params success:^(id json) {
        if (success) {
            success([[ProjectInfo alloc] initWithJSON:json]);
        }
    } error:nil];
}

- (void)messagesWithSuccess:(MessagesBlock)success
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
    
    [self parseRailsPostPath:path withParameters:params success:^(id json) {
        NSMutableDictionary *messages = [NSMutableDictionary dictionary];
        
        for (NSString *messageUID in json) {
            NSDictionary *messageJSON = [json valueForKey:messageUID];
            [messages setValue:[[PostageMessage alloc] initWithJSON:messageJSON forUID:messageUID] forKey:messageUID];
        }
        
        if (success) {
            success(messages);
        }

    } error:nil];
}

- (void)messageTransmissionsForUID:(NSString *)uid
                           success:(MessageTransmissionsBlock)success
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
    
    [self parseRailsPostPath:path withParameters:params success:^(id json) {
        NSMutableArray *transmissions = [NSMutableArray array];
        NSDictionary *transmissionsJSON = [json valueForKey:@"transmissions"];
        
        for (NSString *transmissionKey in transmissionsJSON) {
            [transmissions addObject:[[MessageTransmission alloc] initWithJSON:[transmissionsJSON valueForKey:transmissionKey]]];
        }
        
        if (success) {
            success(transmissions);
        }
    } error:nil];
}

- (void)metricsWithSuccess:(MetricsBlock)success
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
    
    [self parseRailsPostPath:path withParameters:params success:^(id json) {
        if (success) {
            success([json valueForKey:@"metrics"]);
        }
    } error:nil];
}

@end
