//
//  MessageDeliveryStatus.h
//  PostageKit
//
//  Created by Stephan Leroux on 2013-01-08.
//  Copyright (c) 2013 PostageApp. All rights reserved.
//

#import "JSONObject.h"

@interface MessageDeliveryStatus : JSONObject

@property (nonatomic, readonly, strong) NSString *status;
@property (nonatomic, readonly, strong) NSString *recipient;
@property (nonatomic, readonly, strong) NSString *uniqueId;

@end