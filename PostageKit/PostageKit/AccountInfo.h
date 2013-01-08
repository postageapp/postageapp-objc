//
//  AccountInfo.h
//  PostageKit
//
//  Created by Stephan Leroux on 2013-01-08.
//  Copyright (c) 2013 The Working Group. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSONObject.h"

@interface AccountInfo : JSONObject

@property (readonly, nonatomic, strong) NSString *name;
@property (readonly, nonatomic, strong) NSString *url;
@property (readonly, nonatomic, strong) NSDictionary *transmissions;
@property (readonly, nonatomic, strong) NSDictionary *users;

@end
