//
//  WelcomeViewController.m
//  PAGADITO
//
//  Created by Water Flower on 2019/1/8.
//  Copyright © 2019 PAGADITO. All rights reserved.
//

#import "WelcomeViewController.h"
#import "Global.h"
#import "AFNetworking.h"

@interface WelcomeViewController ()

@property(strong, nonatomic)NSString *username;
@property(strong, nonatomic)NSString *password;

@property(strong, nonatomic)UIView *overlayView;
@property(strong, nonatomic)UIActivityIndicatorView * activityIndicator;

@end

@implementation WelcomeViewController

@synthesize logoImageView;
@synthesize usernameTextField, passwordTextField;



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    Global *globals = [Global sharedInstance];
    if(globals.logo_imagePath.length == 0 ) {
        logoImageView.image = [UIImage imageNamed:@"pagadito_0000_logo.png"];
    } else {
        NSFileManager *fileManager = [NSFileManager defaultManager];
        BOOL isFileExist = [fileManager fileExistsAtPath:globals.logo_imagePath];
        UIImage *logo_image;
        if(isFileExist) {
            logo_image = [[UIImage alloc] initWithContentsOfFile:globals.logo_imagePath];
            logoImageView.image = logo_image;
        } else {
            logoImageView.image = [UIImage imageNamed:@"pagadito_0000_logo.png"];
        }
    }
    self.username = @"";
    self.password = @"";
    
    self.overlayView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.overlayView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    self.activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    self.activityIndicator.center = self.overlayView.center;
    [self.overlayView addSubview:self.activityIndicator];
    
}

- (IBAction)SigninButtonAction:(id)sender {
    self.username = usernameTextField.text;
    self.password = passwordTextField.text;
    
    if(self.username.length == 0) {
        [self displayAlertView:@"Warning!" :@"Please input your username"];
        return;
    }
    if(self.password.length == 0) {
        [self displayAlertView:@"Warning!" :@"Please input your password"];
        return;
    }
    if(self.password.length < 6) {
        [self displayAlertView:@"Warning!" :@"Password have to be at least 5 characters"];
        return;
    }
    
    Global *globals = [Global sharedInstance];
    
    [self.activityIndicator startAnimating];
    [self.view addSubview:self.overlayView];
    
    NSDictionary *initLogin = @{@"initLogin": @{
                                          @"username": self.username,
                                          @"password": self.password,
                                          @"mac": globals.macAddress
                                          }};
    
    NSError *error;
    NSData *postData = [NSJSONSerialization dataWithJSONObject:initLogin options:0 error:&error];
    NSString *postString = [[NSString alloc]initWithData:postData encoding:NSUTF8StringEncoding];
    
    NSDictionary *parameters = @{
                                 @"method": @"initLogin",
                                 @"param": postString
                                 };
    
    AFHTTPSessionManager *sessionManager = [AFHTTPSessionManager manager];
    sessionManager.requestSerializer = [AFHTTPRequestSerializer serializer];
    sessionManager.responseSerializer = [AFHTTPResponseSerializer serializer];
    sessionManager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects: @"application/json", nil];
    [sessionManager POST: @"http://ninjahosting.us/web_api/service.php" parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        [self.activityIndicator stopAnimating];
        [self.overlayView removeFromSuperview];
        
        NSError *jsonError;
        NSDictionary *jsonResponse = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:&jsonError];
        
        BOOL status = [jsonResponse[@"status"] boolValue];
        if(status) {
            
        } else {
            [self displayAlertView:@"Warning" :@"Signin information is incorrect. Please input valid information"];
        }
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self.activityIndicator stopAnimating];
        [self.overlayView removeFromSuperview];
        [self displayAlertView:@"Warning" :@"Network error."];
    }];
}

-(void)displayAlertView: (NSString *)header :(NSString *)message {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:header message:message preferredStyle:UIAlertControllerStyleAlert];
    
    UIApplication *actionOK = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"");
    }];
    [alert addAction:actionOK];
    [self presentViewController:alert animated:YES completion:nil];
}

@end
