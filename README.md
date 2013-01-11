PostageKit
==========

##Introduction

PostageKit is an Objective-C wrapper for the popular PostageApp transactional mail service and allows developers to access the PostageApp API from their iOS / Mac OSX applications.


##Quick Start

To get started, first clone the repo:

	git clone https://github.com/twg/PostageKit.git
	
Then, copy over the PostageKit project into your application. Drag the .project file into XCode under your project's 'Frameworks' folder. Next, add the following to your target's 'Build Settings':

	other linker flags: -ObjC -all_load
	
Next, add the following to your 'Build Phases'

* Target Dependencies
	* PostageKit
* Link Binary With Libraries
	* libPostageKit.a
	* MobileCoreServices.framework
	* SystemConfiguration.framework
		
		
Finally, add the PostageKit Framework header to your project's .pch file

	#import <PostageKit/PostageKit.h>
	
Now you're able to use the PostageApp API!

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

