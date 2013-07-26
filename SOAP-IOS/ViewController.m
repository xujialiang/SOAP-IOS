//
//  ViewController.m
//  SOAP-IOS
//
//  Created by Elliott on 13-4-18.
//  Copyright (c) 2013年 Elliott. All rights reserved.
//

#import "ViewController.h"
#import "Soap.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
}

-(void)WeatherTest:(NSString *)cityname isSync:(BOOL)isSync
{
    NSDictionary *dic=@{@"theCityName": cityname};
    NSString *methodName=@"getWeatherbyCityName";
    
    SoapUtility *soaputility=[[SoapUtility alloc] initFromFile:@"WeatherWebService"];
    NSString *postData=[soaputility BuildSoapwithMethodName:@"getWeatherbyCityName" withParas:dic];
    
    SoapService *soaprequest=[[SoapService alloc] init];
    soaprequest.PostUrl=@"http://www.webxml.com.cn/WebServices/WeatherWebService.asmx";
    soaprequest.SoapAction=[soaputility GetSoapActionByMethodName:methodName SoapType:SOAP];
    
    if (isSync) {
        //同步方法
        ResponseData *result= [soaprequest PostSync:postData];
        [self.result setText:result.Content];
    }
    else{
        //异步请求
        [soaprequest PostAsync:postData Success:^(NSString *response) {
            [self.result setText:response];
        } falure:^(NSError *response) {
            [self.result setText:response.description];
        }];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (IBAction)btnsearch:(id)sender
{
    NSString *cityname=[self.cityname text];
    [self WeatherTest:cityname isSync:YES];
}

- (IBAction)btnSearchAsync:(id)sender {
    NSString *cityname=[self.cityname text];
    [self WeatherTest:cityname isSync:NO];
}

- (IBAction)clearresult:(id)sender {
    [self.result setText:@""];
}


@end
