//
//  ViewController.m
//  SOAP-IOS
//
//  Created by Elliott on 13-4-18.
//  Copyright (c) 2013年 Elliott. All rights reserved.
//

#import "ViewController.h"
#import "ServiceHelper.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
}

-(void)WeatherTest:(NSString *)cityname
{
    NSDictionary *dic=@{@"theCityName": @"上海"};
    ServiceHelper *helper=[[ServiceHelper alloc] initWithRequest:@"WeatherWebService" Method:@"getWeatherbyCityName" ParasDic:dic];
    [helper setCompletionBlockWithSuccess:^(NSString *response) {
        [self.result setText:response];
        NSLog(@"%@",response);
    } falure:^(NSError *response) {
        [self.result setText:response.localizedDescription];
        NSLog(@"%@",response);
    }];
    [helper invoke];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (IBAction)btnsearch:(id)sender
{
    NSString *cityname=[self.cityname text];
    [self WeatherTest:cityname];
}

@end
