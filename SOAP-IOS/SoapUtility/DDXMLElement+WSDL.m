//
//  DDXMLElement+WSDL.m
//  SOAP-IOS
//
//  Created by Elliott on 13-7-25.
//  Copyright (c) 2013年 Elliott. All rights reserved.
//

#import "DDXMLElement+WSDL.h"
#import "DDXML.h"



@implementation DDXMLElement (WSDL)

+(DDXMLElement *)LoadWSDL:(NSString *)filename{
    NSString *path = [[NSBundle mainBundle] pathForResource:filename ofType:@"xml"];
    NSData *xmlData = [NSData dataWithContentsOfFile:path];
    DDXMLDocument *xmlDoc = [[DDXMLDocument alloc] initWithData:xmlData options:0 error:nil];
    DDXMLElement *rootElement=[xmlDoc rootElement];
    return rootElement;
}

-(DDXMLElement *)GetChildNodeByNodeName:(NSString *)NodeName ParentNode:(DDXMLElement *)parentNode{
    NSArray *children=[parentNode elementsForName:NodeName];
    if(children.count>0){
        return [children objectAtIndex:0];
    }else{
        return nil;
    }
}
-(NSArray *)GetChildrenNodeByNodeName:(NSString *)NodeName ParentNode:(DDXMLElement *)parentNode{
    NSArray *children=[parentNode elementsForName:NodeName];
    if(children.count>0){
        return children;
    }else{
        return nil;
    }
}

//definitions->types
-(DDXMLElement *)Types{
    return [self GetChildNodeByNodeName:@"types" ParentNode:self];
}

//definitions->types->schema
-(DDXMLElement *)Types_Schema{
    return [self GetChildNodeByNodeName:@"schema" ParentNode:[self Types]];
}

//definitions->types->schema(targetNamespace)
-(NSString *)TargetNamespace{
    DDXMLElement *schema=[self Types_Schema];
    if(schema){
        return [[schema attributeForName:@"targetNamespace"] stringValue];
    }else{
        return nil;
    }
}

//definitions->types->schema->element
-(NSArray *)Types_Schema_Elements{
    return [self GetChildrenNodeByNodeName:@"element" ParentNode:[self Types_Schema]];
}

//definitions->types->schema->element name="***"
-(DDXMLElement *)Get_Types_Schema_Element_ByMethodName:(NSString *)methodName{
    NSArray *children =[self Types_Schema_Elements];
    for (DDXMLElement *child in children) {
        NSString *attrvalue=[[child attributeForName:@"name"] stringValue];
        if([attrvalue isEqualToString:methodName]){
            return child;
        }
    }
    return nil;
}

//definitions->types->schema->element->complextype
-(DDXMLElement *)Types_Schema_Element_ComplexType:(NSString *)methodName{
    DDXMLElement *element=[self Get_Types_Schema_Element_ByMethodName:methodName];
    return [self GetChildNodeByNodeName:@"complexType" ParentNode:element];
}

//definitions->types->schema->element->complextype->sequence
-(DDXMLElement *)Types_Schema_Element_ComplexType_Sequence:(NSString *)methodName{
    DDXMLElement *element=[self Types_Schema_Element_ComplexType:methodName];
    return [self GetChildNodeByNodeName:@"sequence" ParentNode:element];
}

//definitions->types->schema->element->complextype->sequence->element
-(NSArray *)Types_Schema_Element_ComplexType_Sequence_Element:(NSString *)methodName{
    NSArray *paramselements=[[self Types_Schema_Element_ComplexType_Sequence:methodName] children];
    return paramselements;
}

-(NSArray *)GetMethodParamsByMethodName:(NSString *)methodName{
    NSMutableArray *params=[[NSMutableArray alloc] init];
    NSArray *paramElements=[self Types_Schema_Element_ComplexType_Sequence_Element:methodName];
    for (DDXMLElement *paramelement in paramElements) {
        NSString *paramName=[[paramelement attributeForName:@"name"] stringValue];
        [params addObject:paramName];
    }
    return params;
}

//definitions->binding 有多个binding
-(NSArray *)Bindings{
    return [self GetChildrenNodeByNodeName:@"binding" ParentNode:self];
}

//definitions->binding soap/soap12
-(DDXMLElement *)SOAPBinding:(SOAPTYPE)SoapType{
    NSArray *bindings=[self Bindings];
    for (DDXMLElement *binding in bindings) {
        BOOL result=NO;
        NSString *attrnameValue=[[binding attributeForName:@"name"] stringValue];
        NSString *soapRegex;
        if(SoapType==SOAP){
            soapRegex = @".*Soap$";
        }else{
            soapRegex = @".*Soap12$";
        }
        NSPredicate *soapTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", soapRegex];
        result= [soapTest evaluateWithObject:attrnameValue];
        if(result){
            return binding;
        }
    }
    return nil;
}

//definitions->binding(soap/soap12)->operation 有多个operation
-(NSArray *)Bindings_Operations:(SOAPTYPE)SoapType{
    DDXMLElement *soapbinding=[self SOAPBinding:SoapType];
    if(soapbinding){
        return [self GetChildrenNodeByNodeName:@"operation" ParentNode:soapbinding];
    }else{
        return nil;
    }
}

-(DDXMLElement *)Bindings_Operation:(NSString *)methodName SoapType:(SOAPTYPE)soapType{
    NSArray *operations=[self Bindings_Operations:soapType];
    if(operations){
        for (DDXMLElement *operation in operations) {
            NSString *attrNameValue=[[operation attributeForName:@"name"] stringValue];
            if([attrNameValue isEqualToString:methodName]){
                return operation;
            }
        }
        return nil;
    }else{
        return nil;
    }
}

//definitions->binding(soap/soap12)->operation->operation
-(NSString *)GetSoapActionByMethodName:(NSString *)methodName SoapType:(SOAPTYPE)soapType{
    DDXMLElement *operation=[self Bindings_Operation:methodName SoapType:soapType];
    DDXMLElement *soapoperationNode=[self GetChildNodeByNodeName:@"operation" ParentNode:operation];
    NSString *soapAction=[[soapoperationNode attributeForName:@"soapAction"] stringValue];
    return soapAction;
}

-(NSArray *)Messages{
    return [self GetChildrenNodeByNodeName:@"message" ParentNode:self];
}

-(DDXMLElement *)Message_Name:(NSString *)methodName{
    NSArray *messages=[self Messages];
    if(messages){
        for (DDXMLElement *message in [self Messages]) {
            NSString *attrnameValue=[[message attributeForName:@"name"] stringValue];
            NSString * messageName=[NSString stringWithFormat:@"%@%@",methodName,@"SoapIn"];
            if([attrnameValue isEqualToString:messageName]){
                return message;
            }
        }
        return nil;
    }else{
        return nil;
    }
}

-(DDXMLElement *)Message_Part:(NSString *)methodName{
    DDXMLElement *message=[self Message_Name:methodName];
    if(message){
        return [self GetChildNodeByNodeName:@"part" ParentNode:message];
    }else{
        return nil;
    }
}

-(NSString *)GetMessageParametersByMethodName:(NSString *)methodName{
    DDXMLElement *message_part=[self Message_Part:methodName];
    if(message_part){
        NSString *parameters= [[message_part attributeForName:@"element"] stringValue];
        NSArray *paraArray = [parameters componentsSeparatedByString:@":"];
        return [paraArray lastObject];
    }else{
        return nil;
    }
}


@end
