//
//  WSDLParser.m
//  SOAP-IOS
//
//  Created by Elliott on 13-4-18.
//  Copyright (c) 2013年 Elliott. All rights reserved.
//

#import "WSDL2SOAP.h"
#import "DDXML.h"
@implementation WSDL2SOAP

-(id)init{
    if (self = [super init]) {
        self.SoapVer=@"1.0";
    }
    return self;
}

-(WSDL2SOAP *)GenerateSoap1:(NSString *)filename withMethod:(NSString *)method withParas:(NSDictionary *)paradic
{
    return [self GenerateSoap:filename withMethod:method withParas:paradic withVersion:@"1.0"];
}

-(WSDL2SOAP *)GenerateSoap12:(NSString *)filename withMethod:(NSString *)method withParas:(NSDictionary *)paradic
{
    return [self GenerateSoap:filename withMethod:method withParas:paradic withVersion:@"1.2"];
}

-(WSDL2SOAP *)GenerateSoap:(NSString *)filename withMethod:(NSString *)method withParas:(NSDictionary *)paradic withVersion:(NSString *)ver
{
    self.SoapVer=ver;
    self.Filename=filename;
    self.Method=method;
    self.ParaDic=paradic;
    
    NSString *path = [[NSBundle mainBundle] pathForResource:filename ofType:@"xml"];
    NSData *xmlData = [NSData dataWithContentsOfFile:path];
    DDXMLDocument *xmlDoc = [[DDXMLDocument alloc] initWithData:xmlData options:0 error:nil];
    DDXMLElement *rootElement=[xmlDoc rootElement];
    
    [self SetSoapName:filename withVer:ver];
    
    [self SetSoapAction:rootElement withMethod:method withVer:ver];
    [self SetServiceAddress:rootElement withVer:ver];
    
    if([ver isEqualToString:@"1.0"])
    {
        [self BuildSoapV1:rootElement withMethod:method withParas:paradic];
        self.wsdl2soap=self;
        return self.wsdl2soap;
    }
    else
    {
        return nil;
    }
}



-(NSString *)BuildSoapV1:(DDXMLElement *)rootelement withMethod:(NSString *)method withParas:(NSDictionary *)parasdic
{
    //根节点
    DDXMLElement *ddRoot = [DDXMLElement elementWithName:@"soapenv:Envelope"];
    //头
	DDXMLElement *ddHeader = [DDXMLElement elementWithName:@"soapenv:Header"];
    //body
    DDXMLElement *ddBody = [DDXMLElement elementWithName:@"soapenv:Body"];
    //根节点的命名空间
    DDXMLNode *ddRootNs0 = [DDXMLNode namespaceWithName:@"soapenv" stringValue:@"http://schemas.xmlsoap.org/soap/envelope/"];
    
    //消息体的命名空间
    DDXMLNode *ddmsgNS = [DDXMLNode namespaceWithName:@"" stringValue:[[rootelement attributeForName:@"targetNamespace"] stringValue]];
    DDXMLElement *msg=[DDXMLElement elementWithName:method];
    [msg addNamespace:ddmsgNS];
    
    //参数列表
    NSArray *types= [rootelement nodesForXPath:@"//wsdl:types/s:schema/s:element" error:nil];
    //给消息体添加参数列表，并赋值
    for(DDXMLElement *type in types){
        NSString *currentname=[[type attributeForName:@"name"] stringValue];
        if([currentname isEqualToString:method])
        {
            NSArray *paras=[type nodesForXPath:@"s:complexType/s:sequence/s:element" error:nil];
            for (DDXMLElement *para in paras) {
                NSString *paraname=[[para attributeForName:@"name"] stringValue];
                NSString *value=[parasdic objectForKey:paraname];
                DDXMLElement *paranode=[DDXMLElement elementWithName:paraname stringValue:value];
                [msg addChild:paranode];
            }
        }
    }
    [ddBody addChild:msg];
    [ddRoot addNamespace:ddRootNs0];
    [ddRoot addChild:ddHeader];
    [ddRoot addChild:ddBody];
    self.Soap=[self DecodedString:[ddRoot XMLString]];
    return self.Soap;
}

-(NSString *)SetSoapAction:(DDXMLElement *)rootelement withMethod:(NSString *)method withVer:(NSString *)ver
{
    NSArray *bindings = [rootelement nodesForXPath:@"//wsdl:binding" error:nil];
    for (DDXMLElement *binding in bindings) {
        NSString *currentname=[[binding attributeForName:@"name"] stringValue];
        if([currentname isEqualToString:self.SoapName])
        {
            NSArray *operations=[binding nodesForXPath:@"wsdl:operation" error:nil];
            for (DDXMLElement *operation in operations) {
                NSString *operationname=[[operation attributeForName:@"name"] stringValue];
                if([operationname isEqualToString:method])
                {
                    NSArray *soapaction=[operation elementsForName:@"soap:operation"];
                    self.SoapAction=[[[soapaction objectAtIndex:0] attributeForName:@"soapAction"] stringValue];
                }
            }
            
        }
    }
    return self.SoapAction;
}

-(NSString *)SetSoapName:(NSString *)filename withVer:(NSString *)ver
{
    if([ver isEqualToString:@"1.0"])
    {
        self.SoapName=[filename stringByAppendingString:@"Soap"];
    }
    else{
        self.SoapName=[filename stringByAppendingString:@"Soap12"];
    }
    return self.SoapName;
}

-(NSString *)SetServiceAddress:(DDXMLElement *)rootelement withVer:(NSString *)ver
{
    NSArray *services = [rootelement nodesForXPath:@"//wsdl:service/wsdl:port" error:nil];
    for(DDXMLElement *service in services){
        NSString *currentname=[[service attributeForName:@"name"] stringValue];
        NSString *soapname=nil;
        if([ver isEqualToString:@"1.0"]){
            soapname=[self.Filename stringByAppendingString:@"Soap"];
        }
        else{
            soapname=[self.Filename stringByAppendingString:@"Soap12"];
        }
        if([currentname isEqualToString:soapname]){
            self.SoapUrl=[[[[service elementsForName:@"soap:address"] objectAtIndex:0] attributeForName:@"location"] stringValue];
            break;
        }
    }
    return self.SoapUrl;
}

- (NSString *)DecodedString:(NSString*) input
{
	return [[[[input stringByReplacingOccurrencesOfString:@"&amp;" withString:@"&"]
			  stringByReplacingOccurrencesOfString:@"&lt;" withString:@"<"]
			 stringByReplacingOccurrencesOfString:@"&gt;" withString:@">"]
			stringByReplacingOccurrencesOfString:@"&quot;" withString:@"\""];
}

@end
