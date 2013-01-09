//
//  RootViewController.m
//  PostageKitSample
//
//  Created by Stephan Leroux on 2013-01-08.
//  Copyright (c) 2013 The Working Group. All rights reserved.
//

#import "RootViewController.h"

@interface RootViewController ()
@property (nonatomic, strong) PostageClient *client;
@end

#define YOUR_PROJECT_API_KEY @"Your Key!"

@implementation RootViewController

- (UIButton *)setupButtonAt:(CGPoint)center
                       size:(CGSize)size
                      title:(NSString *)title
                     action:(SEL)action
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [button addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
    button.frame = CGRectMake(center.x - (size.width / 2), center.y - (size.height / 2), size.width, size.height);
    [button setTitle:title forState:UIControlStateNormal];
    return button;
}

- (void)loadView
{
    [super loadView];
    
    CGSize buttonSize = CGSizeMake(250, 40);
    
    [self.view addSubview:[self setupButtonAt:CGPointMake(self.view.frame.size.width / 2, 50) size:buttonSize title:@"Get Metrics" action:@selector(getMetrics:)]];
    [self.view addSubview:[self setupButtonAt:CGPointMake(self.view.frame.size.width / 2, 100) size:buttonSize title:@"Send Message" action:@selector(sendMessage:)]];
    [self.view addSubview:[self setupButtonAt:CGPointMake(self.view.frame.size.width / 2, 150) size:buttonSize title:@"Get Message Receipt" action:@selector(getMessageReceipt:)]];
    [self.view addSubview:[self setupButtonAt:CGPointMake(self.view.frame.size.width / 2, 200) size:buttonSize title:@"Get Method List" action:@selector(getMethodList:)]];
    [self.view addSubview:[self setupButtonAt:CGPointMake(self.view.frame.size.width / 2, 250) size:buttonSize title:@"Get Account Info" action:@selector(getAccountInfo:)]];
    [self.view addSubview:[self setupButtonAt:CGPointMake(self.view.frame.size.width / 2, 300) size:buttonSize title:@"Get Project Info" action:@selector(getProjectInfo:)]];
    [self.view addSubview:[self setupButtonAt:CGPointMake(self.view.frame.size.width / 2, 350) size:buttonSize title:@"Get Messages" action:@selector(getMessages:)]];
    [self.view addSubview:[self setupButtonAt:CGPointMake(self.view.frame.size.width / 2, 400) size:buttonSize title:@"Get Message Transmissions" action:@selector(getMessageTransmissions:)]];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _client = [PostageClient sharedClient];
    _client.projectAPIKey = YOUR_PROJECT_API_KEY;
}

- (void)dealloc
{
    _client = nil;
}

# pragma mark - Actions

- (void)sendMessage:(id)sender
{
    MessageParams *params = [MessageParams params];
    params.UID = @"1234567890abced";
    params.recipients = @[@"fake@test.com"];
    params.content = @{@"text/plain" : @"Test Content!"};
    
    [_client sendMessage:params success:^(NSUInteger messageID) {
        NSLog(@"Message ID: %d", messageID);
    } error:^(NSError *error, id json) {
        NSLog(@"API Error occurred: %@, JSON: %@", error, json);
    }];
}

- (void)getMetrics:(id)sender
{
    [_client metricsWithSuccess:^(NSDictionary *metrics) {
        NSLog(@"Got Metrics: %@", metrics);
    } error:^(NSError *error, id json) {
        NSLog(@"API Error occurred: %@, JSON: %@", error, json);
    }];
}

- (void)getMessageReceipt:(id)sender
{
    [_client messageReceiptForUID:@"1234567890abced" success:^(NSUInteger messageID) {
        NSLog(@"Message ID: %d", messageID);
    } error:^(NSError *error, id json) {
        NSLog(@"API Error occurred: %@, JSON: %@", error, json);
    }];
}

- (void)getMethodList:(id)sender
{
    [_client methodListWithSuccess:^(NSArray *methodList) {
        NSLog(@"Methods Available: %@", methodList);
    } error:^(NSError *error, id json) {
        NSLog(@"API Error occurred: %@, JSON: %@", error, json);
    }];
}

- (void)getAccountInfo:(id)sender
{
    [_client accountInfoWithSuccess:^(AccountInfo *accountInfo) {
        NSLog(@"Account Info: %@", accountInfo);
    } error:^(NSError *error, id json) {
        NSLog(@"API Error occurred: %@, JSON: %@", error, json);
    }];
}

- (void)getProjectInfo:(id)sender
{
    [_client projectInfoWithSuccess:^(ProjectInfo *projectInfo) {
        NSLog(@"Project Info: %@", projectInfo);
    } error:^(NSError *error, id json) {
        NSLog(@"API Error occurred: %@, JSON: %@", error, json);
    }];
}

- (void)getMessages:(id)sender
{
    [_client messagesWithSuccess:^(NSDictionary *messages) {
        NSLog(@"Messages Sent: %@", messages);
    } error:^(NSError *error, id json) {
        NSLog(@"API Error occurred: %@, JSON: %@", error, json);
    }];
}

- (void)getMessageTransmissions:(id)sender
{
    [_client messageTransmissionsForUID:@"1234567890abced" success:^(NSArray *transmissions) {
        NSLog(@"Message Transmissions for 1234567890abced: %@", transmissions);
    } error:^(NSError *error, id json) {
        NSLog(@"API Error occurred: %@, JSON: %@", error, json);
    }];
}

@end
