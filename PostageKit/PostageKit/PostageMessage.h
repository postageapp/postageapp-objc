//
//  PostageMessage.h
//  PostageKit
//
//  Created by Stephan Leroux on 2013-01-08.
//  Copyright (c) 2013 The Working Group. All rights reserved.
//

#import "JSONObject.h"

@interface PostageMessage : JSONObject

@property (readonly, nonatomic, strong) NSString *UID;
@property (readonly, nonatomic, strong) NSString *projectID;
@property (readonly, nonatomic, strong) NSString *templateName;
@property (readonly, nonatomic, assign) NSUInteger transmissionsTotal;
@property (readonly, nonatomic, assign) NSUInteger transmissionsFailed;
@property (readonly, nonatomic, assign) NSUInteger transmissionsCompleted;
@property (readonly, nonatomic, strong) NSDate *createdAt;
@property (readonly, nonatomic, strong) NSDate *willPurgeAt;

- (id)initWithJSON:(id)json forUID:(NSString *)uid;

@end
