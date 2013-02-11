//
//  ProjectInfo.h
//  PostageKit
//
//  Created by Stephan Leroux on 2013-01-08.
//  Copyright (c) 2013 PostageApp. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSONObject.h"

@interface ProjectInfo : JSONObject

@property (readonly, nonatomic, strong) NSString *name;
@property (readonly, nonatomic, strong) NSString *url;
@property (readonly, nonatomic, strong) NSDictionary *transmissions;
@property (readonly, nonatomic, strong) NSDictionary *users;

@end
