//
//  SoapUtility.h
//  SOAP-IOS
//
//  Created by Elliott on 13-7-26.
//  Copyright (c) 2013年 Elliott. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DDXML.h"
#import "DDXMLElement+WSDL.h"

@interface SoapUtility : NSObject

-(id)initFromFile:(NSString *)filename;

-(NSString *)BuildSoapwithMethodName:(NSString *)methodName withParas:(NSDictionary *)parasdic;

-(NSString *)BuildSoap12withMethodName:(NSString *)methodName withParas:(NSDictionary *)parasdic;

-(NSString *)GetSoapActionByMethodName:(NSString *)methodName SoapType:(SOAPTYPE)soapType;

@end
