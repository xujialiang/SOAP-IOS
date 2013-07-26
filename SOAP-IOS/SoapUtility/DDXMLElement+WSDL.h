//
//  DDXMLElement+WSDL.h
//  SOAP-IOS
//
//  Created by Elliott on 13-7-25.
//  Copyright (c) 2013年 Elliott. All rights reserved.
//

#import "DDXMLElement.h"

typedef enum _SOAPTYPE{
    //SOAP 1.1
    SOAP,
    //SOAP 1.2
    SOAP12
}SOAPTYPE;

@interface DDXMLElement (WSDL)

+(DDXMLElement *)LoadWSDL:(NSString *)filename;

-(NSArray *)GetMethodParamsByMethodName:(NSString *)methodName;

-(NSString *)GetSoapActionByMethodName:(NSString *)methodName SoapType:(SOAPTYPE)soapType;

-(NSString *)TargetNamespace;

-(NSString *)GetMessageParametersByMethodName:(NSString *)methodName;
@end
