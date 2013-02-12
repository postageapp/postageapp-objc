//
//  RootViewController.m
//  PostageKitSample
//
//  Created by Stephan Leroux on 2013-01-08.
//  Copyright (c) 2013 PostageApp. All rights reserved.
//

#import "RootViewController.h"
#import "PostageKit.h"

@interface RootViewController ()
@property (nonatomic, strong) PostageClient *client;
@end

#define YOUR_PROJECT_API_KEY @"Your Key!"
#define DUMMY_UID @"1234567890abcdefg@fake.com"

@implementation RootViewController

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

- (IBAction)sendMessage:(id)sender
{
    MessageParams *params = [MessageParams params];
    params.UID = DUMMY_UID;
    params.recipients = @[@"fake@test.com"];
    params.content = @{@"text/plain" : @"Test Content!"};
    
    [_client sendMessage:params success:^(NSUInteger messageID) {
        NSLog(@"Message ID: %d", messageID);
    } error:nil];
}

- (IBAction)getMetrics:(id)sender
{
    [_client metricsWithSuccess:^(NSDictionary *metrics) {
        NSLog(@"Got Metrics: %@", metrics);
    } error:nil];
}

- (IBAction)getMessageReceipt:(id)sender
{
    [_client messageReceiptForUID:DUMMY_UID success:^(NSUInteger messageID) {
        NSLog(@"Message ID: %d", messageID);
    } error:nil];
}

- (IBAction)getMethodList:(id)sender
{
    [_client methodListWithSuccess:^(NSArray *methodList) {
        NSLog(@"Methods Available: %@", methodList);
    } error:nil];
}

- (IBAction)getAccountInfo:(id)sender
{
    [_client accountInfoWithSuccess:^(AccountInfo *accountInfo) {
        NSLog(@"Account Info: %@", accountInfo);
    } error:nil];
}

- (IBAction)getProjectInfo:(id)sender
{
    [_client projectInfoWithSuccess:^(ProjectInfo *projectInfo) {
        NSLog(@"Project Info: %@", projectInfo);
    } error:nil];
}

- (IBAction)getMessages:(id)sender
{
    [_client messagesWithSuccess:^(NSDictionary *messages) {
        NSLog(@"Messages Sent: %@", messages);
    } error:nil];
}

- (IBAction)getMessageTransmissions:(id)sender
{
    [_client messageTransmissionsForUID:DUMMY_UID success:^(NSArray *transmissions) {
        NSLog(@"Message Transmissions for %@: %@", DUMMY_UID, transmissions);
    } error:nil];
}

- (IBAction)getMessageDeliveryStatus:(id)sender
{
    [_client deliveryStatusForMessageWithUID:DUMMY_UID success:^(NSArray *deliveryStatuses) {
        NSLog(@"Delivery Statuses: %@", deliveryStatuses);
    } error:nil];
}

- (IBAction)getMessageStatus:(id)sender
{
    [_client statusForMessageWithUID:DUMMY_UID success:^(NSDictionary *status) {
        NSLog(@"Message Status for %@: %@", DUMMY_UID, status);
    } error:nil];
}

- (IBAction)getRecipientsList:(id)sender
{
    [_client recipientsListForMessageWithUID:DUMMY_UID success:^(NSDictionary *recipients) {
        NSLog(@"Recipients List: %@", recipients);
    } error:nil];
}

@end
