//
//  ViewController.h
//  bliep
//
//  Created by Daan Lemmen on 14-09-12.
//  Copyright (c) 2012 Daan Lemmen. All rights reserved.
//

#import <UIKit/UIKit.h>
@class BliepAPI;
@interface ViewController : UIViewController <NSURLConnectionDataDelegate> {
    IBOutlet UITextField *emailTextField;
    IBOutlet UITextField *passwordTextField;
    IBOutlet UIWebView *web;
    
    IBOutlet UILabel *stateLabel;
    IBOutlet UILabel *balanceLabel;
    IBOutlet UILabel *calltimeLabel;
    
    IBOutlet UIButton *pauseButton;
    IBOutlet UIButton *bliepButton;
    IBOutlet UIButton *bliepplusButton;
    
    BliepAPI *api;
}
@property (nonatomic) int connectionType;
@property (nonatomic, strong) NSMutableData *connectionData;
-(IBAction)getAccountInfo:(id)sender;
-(IBAction)pause:(id)sender;
-(IBAction)bliep:(id)sender;
-(IBAction)bliepplus:(id)sender;
@end
