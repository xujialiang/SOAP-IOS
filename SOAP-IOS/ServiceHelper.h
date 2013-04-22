//
//  ServiceHelper.h
//  SOAP-IOS
//
//  Created by Elliott on 13-4-20.
//  Copyright (c) 2013年 Elliott. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ServiceHelper : NSObject

typedef void (^SuccessBlock) (NSString *response);
typedef void (^FailureBlock) (NSError *response);
@property (nonatomic,strong) SuccessBlock success;
@property (nonatomic,strong) FailureBlock failure;
@property (nonatomic,strong) NSMutableURLRequest *request;

-(id)initWithRequest:(NSString *)filename Method:(NSString *)name ParasDic:(NSDictionary *)paras;

-(void)setCompletionBlockWithSuccess:(SuccessBlock)success
                               falure:(FailureBlock)falure;
-(void)invoke;
@end
