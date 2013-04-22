//
//  WSDLParser.h
//  SOAP-IOS
//
//  Created by Elliott on 13-4-18.
//  Copyright (c) 2013年 Elliott. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WSDL2SOAP : NSObject

@property (nonatomic,strong) NSString *SoapVer;
@property (nonatomic,strong) NSString *Filename;
@property (nonatomic,strong) NSString *Method;
@property (nonatomic,strong) NSDictionary *ParaDic;
@property (nonatomic,strong) NSString *SoapUrl;
@property (nonatomic,strong) NSString *SoapAction;
@property (nonatomic,strong) NSString *Soap;
@property (nonatomic,strong) NSString *SoapName;
@property (nonatomic,strong) WSDL2SOAP *wsdl2soap;

-(WSDL2SOAP *)GenerateSoap1:(NSString *)filename withMethod:(NSString *)method withParas:(NSDictionary *)paras;
-(WSDL2SOAP *)GenerateSoap12:(NSString *)filename withMethod:(NSString *)method withParas:(NSDictionary *)paras;

@end
