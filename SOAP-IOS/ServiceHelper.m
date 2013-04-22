//
//  ServiceHelper.m
//  SOAP-IOS
//
//  Created by Elliott on 13-4-20.
//  Copyright (c) 2013年 Elliott. All rights reserved.
//

#import "ServiceHelper.h"
#import "WSDL2SOAP.h"
#import "AFNetworking.h"
#import "DDXML.h"
@implementation ServiceHelper



-(id)initWithRequest:(NSString *)filename Method:(NSString *)method ParasDic:(NSDictionary *)paras
{
    self = [super init];
    if (!self) {
		return nil;
    }
    WSDL2SOAP *soapevenlop=[[WSDL2SOAP alloc] init];
    WSDL2SOAP *result2= [soapevenlop GenerateSoap1:filename withMethod:method withParas:paras];
    
    NSURL *baseURL=[[NSURL alloc]initWithString:result2.SoapUrl];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:baseURL];
    [request setHTTPBody:[result2.Soap dataUsingEncoding:NSUTF8StringEncoding]];
    
    [request addValue:result2.SoapAction forHTTPHeaderField:@"SOAPAction"];
    [request addValue:@"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPMethod:@"POST"];
    
    self.request=request;
    return self;
}

-(void)setCompletionBlockWithSuccess:(SuccessBlock)success
                              falure:(FailureBlock)falure
{
    self.success=success;
    self.failure=falure;
}

-(void)invoke
{
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:self.request];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         DDXMLElement *ddBody = [[DDXMLElement alloc] initWithXMLString:operation.responseString error:nil];
         self.success([ddBody XMLString]);
     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         self.failure(error);
     }];
    [operation start];
}

@end
