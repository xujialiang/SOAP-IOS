//
//  SoapUtility.m
//  SOAP-IOS
//
//  Created by Elliott on 13-7-26.
//  Copyright (c) 2013年 Elliott. All rights reserved.
//

#import "SoapUtility.h"


@interface SoapUtility(){
    DDXMLElement *rootelement;
}

@end

@implementation SoapUtility

-(id)initFromFile:(NSString *)filename{
    self=[super init];
    if(self){
        rootelement=[DDXMLElement LoadWSDL:filename];
    }
    return self;
}


-(NSString *)BuildSoapwithMethodName:(NSString *)methodName withParas:(NSDictionary *)parasdic
{
    // <soap:Envelope xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/">
	//     <soap:Header/>
	//     <soap:Body>
	//     <parameters xmlns="http://xxxx.com"/>
    //          <param1></param1>
    //          <param2></param2>
    //          <param3></param3>
	//     </parameters/>
	//     </soap:Body>
	// </soap:Envelope>
    
    //根节点
    DDXMLElement *ddRoot = [DDXMLElement elementWithName:@"soap:Envelope"];
    //根节点的命名空间
    [ddRoot addNamespace:[DDXMLNode namespaceWithName:@"soap" stringValue:@"http://schemas.xmlsoap.org/soap/envelope/"]];
    //头
	DDXMLElement *ddHeader = [DDXMLElement elementWithName:@"soap:Header"];
    //body
    DDXMLElement *ddBody = [DDXMLElement elementWithName:@"soap:Body"];
    
    //消息体的命名空间
    DDXMLNode *ddmsgNS = [DDXMLNode namespaceWithName:@"" stringValue:[rootelement TargetNamespace]];
    DDXMLElement *msg=[DDXMLElement elementWithName:[rootelement GetMessageParametersByMethodName:methodName]];
    [msg addNamespace:ddmsgNS];
    
    //参数列表
    NSArray *params= [rootelement GetMethodParamsByMethodName:methodName];
    
    //给消息体添加参数列表，并赋值
    for(NSString *param in params){
        NSString *paramValue=[parasdic objectForKey:param];
        DDXMLElement *paranode=[DDXMLElement elementWithName:param stringValue:paramValue];
        [msg addChild:paranode];
    }
    [ddBody addChild:msg];
    [ddRoot addChild:ddHeader];
    [ddRoot addChild:ddBody];
    return [ddRoot XMLString];
}

-(NSString *)BuildSoap12withMethodName:(NSString *)methodName withParas:(NSDictionary *)parasdic
{
    // <soap12:Envelope xmlns:soap12="http://www.w3.org/2003/05/soap-envelope">
	//     <soap12:Header/>
	//     <soap12:Body>
	//     <parameters xmlns="http://xxxx.com"/>
    //          <param1></param1>
    //          <param2></param2>
    //          <param3></param3>
	//     </parameters/>
	//     </soap12:Body>
	// </soap12:Envelope>
    
    //根节点
    DDXMLElement *ddRoot = [DDXMLElement elementWithName:@"soap:Envelope"];
    //根节点的命名空间
    [ddRoot addNamespace:[DDXMLNode namespaceWithName:@"soap" stringValue:@"http://www.w3.org/2003/05/soap-envelope"]];
    //头
	DDXMLElement *ddHeader = [DDXMLElement elementWithName:@"soap:Header"];
    //body
    DDXMLElement *ddBody = [DDXMLElement elementWithName:@"soap:Body"];
    
    //消息体的命名空间
    DDXMLNode *ddmsgNS = [DDXMLNode namespaceWithName:@"" stringValue:[rootelement TargetNamespace]];
    DDXMLElement *msg=[DDXMLElement elementWithName:[rootelement GetMessageParametersByMethodName:methodName]];
    [msg addNamespace:ddmsgNS];
    
    //参数列表
    NSArray *params= [rootelement GetMethodParamsByMethodName:methodName];
    
    //给消息体添加参数列表，并赋值
    for(NSString *param in params){
        NSString *paramValue=[parasdic objectForKey:param];
        DDXMLElement *paranode=[DDXMLElement elementWithName:param stringValue:paramValue];
        [msg addChild:paranode];
    }
    [ddBody addChild:msg];
    [ddRoot addChild:ddHeader];
    [ddRoot addChild:ddBody];
    return [ddRoot XMLString];
}



-(NSString *)GetSoapActionByMethodName:(NSString *)methodName SoapType:(SOAPTYPE)soapType{
    return [rootelement GetSoapActionByMethodName:methodName SoapType:soapType];
}
@end
