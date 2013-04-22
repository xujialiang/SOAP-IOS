//
//  ViewController.h
//  SOAP-IOS
//
//  Created by Elliott on 13-4-18.
//  Copyright (c) 2013年 Elliott. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController
@property (strong, nonatomic) IBOutlet UITextField *cityname;
- (IBAction)btnsearch:(id)sender;
@property (strong, nonatomic) IBOutlet UITextView *result;

@end
