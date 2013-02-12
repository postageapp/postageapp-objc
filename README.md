PostageKit
==========

##Introduction

PostageKit is an Objective-C wrapper for the popular PostageApp transactional mail service and allows developers to access the PostageApp API from their iOS / Mac OSX applications.

##Quick Start

### Cocoapods

[Cocoapods](http://cocoapods.org/) is a great way to manage your iOS and Mac OSX dependencies. The easiest way to set up PostageKit is to install through Cocoapods. Add the following to your Podfile:

	platform :ios
	pod 'PostageKit'
	
…or for Mac OS X

	platform :mac
	pod 'PostageKit'
	
And install:

	pod install
	
### Manual Installation

You can also manually import the files from the `PostageKit/` folder into your project if you don't use Cocoapods. Note that PostageKit relies on [AFNetworking](https://github.com/AFNetworking/AFNetworking), so you will need to add those files manually as well.


## API Usage

The API provides an asynchronous client interface by using [blocks](http://developer.apple.com/library/ios/#documentation/cocoa/Conceptual/Blocks/Articles/00_Introduction.html). To start using the API, you will first need to setup the API client with your PostageApp project API key:

	PostageClient *client = [PostageApp sharedClient];
	client.projectAPIKey = @"Your API Key here";

For example, to grab the messages sent for your project:
	
	[client messagesWithSuccess:^(NSDictionary *messages) {
		NSLog(@"Messages sent: %@", messages);
	} error:^(NSError *error, id json) {
		NSLog(@"API Error occurred: %@, JSON: %@", error, json);
	}];
	
Some of the types have models that make it easier to traverse:
	
	[client accountInfoWithSuccess:^(AccountInfo *info) {
		NSLog(@"Account Name: %@", info.name);
	} error:^(NSError *error, id json) {
		// Error
	}];

You can also send messages as well!

	MessageParams *params = [MessageParams params];
    params.UID = @"12345678abcdefg";
    params.recipients = @[ @"fake@test.com" ];
    params.content = @{@"text/plain" : @"This is a test!"};
    
    [_client sendMessage:params success:^(NSUInteger messageID) {
        NSLog(@"Message ID: %d", messageID);
    } error:^(NSError *error, id json) {
		// Error
    }];
    
## Authors

[Stephan Leroux](https://github.com/sleroux/) - stephanleroux@gmail.com
