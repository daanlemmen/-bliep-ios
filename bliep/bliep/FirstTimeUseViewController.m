//
//  FirstTimeUseViewController.m
//  bliep
//
//  Created by Daan Lemmen on 15-09-12.
//  Copyright (c) 2012 Daan Lemmen. All rights reserved.
//

#import "FirstTimeUseViewController.h"

#import "ViewController.h"
#import <QuartzCore/QuartzCore.h>
@interface FirstTimeUseViewController () {
    BliepAPI *api;
}
@property (nonatomic, strong) UIView *loadingView;
@end

@implementation FirstTimeUseViewController
-(void)showAndSetupLoadingView {
    self.loadingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 230, 230)];
    self.loadingView.center = self.view.center;
    self.loadingView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.7];
    self.loadingView.layer.cornerRadius = 20;
    self.loadingView.layer.masksToBounds = YES;
    UIActivityIndicatorView *activi = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    activi.frame = CGRectMake(97, 96, activi.frame.size.width, activi.frame.size.height);
    [activi startAnimating];
    [self.loadingView addSubview:activi];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20, 182, 190, 28)];
    [label setFont:[UIFont boldSystemFontOfSize:36]];
    label.backgroundColor = [UIColor clearColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.text = @"Laden...";
    label.textColor = [UIColor whiteColor];
    [self.loadingView addSubview:label];
    
    [self.view addSubview:self.loadingView];
}
-(void)hideLoadingView {
    [self.loadingView removeFromSuperview];
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    api = [[BliepAPI alloc] init];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(IBAction)login:(id)sender {
    NSString *email = [emailTextField text];
    NSString *wachtwoord = [passwordTextField text];
    [emailTextField resignFirstResponder];
    [passwordTextField resignFirstResponder];
    [self showAndSetupLoadingView];
    [api getTokenWithUsername:email andPassword:wachtwoord andCompletionBlock:^(NSDictionary *dict) {
        NSLog(@"%@", dict);
        BOOL succes = [[dict objectForKey:@"success"] boolValue];
        if (succes == YES){
            // Save token
            [BliepAPI setToken:[[dict objectForKey:@"result"] objectForKey:@"token"]];
            ViewController *vc = [[ViewController alloc] init];
            vc.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
            [self presentViewController:vc animated:YES completion:nil];
        }else {
            // Get errorcode
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                            message:[NSString stringWithFormat:@"%@", [dict objectForKey:@"error"]]
                                                           delegate:nil
                                                  cancelButtonTitle:@"Ok"
                                                  otherButtonTitles:nil, nil];
            [alert show];
        }
        [self hideLoadingView];
    }];
}
@end
