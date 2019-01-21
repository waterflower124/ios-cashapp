//
//  ResetPasswordConfirmViewController.m
//  PAGADITO
//
//  Created by Water Flower on 2019/1/21.
//  Copyright © 2019 PAGADITO. All rights reserved.
//

#import "ResetPasswordConfirmViewController.h"
#import "AFNetworking.h"
#import "WelcomeViewController.h"

@interface ResetPasswordConfirmViewController ()
@property(strong, nonatomic)UIView *overlayView;
@property(strong, nonatomic)UIActivityIndicatorView * activityIndicator;

@property(strong, nonatomic)NSString *passwordText;
@property(strong, nonatomic)NSString *confirmText;

@end

@implementation ResetPasswordConfirmViewController
@synthesize idUser;
@synthesize passwordTextField, confirmTextField, TransV, successAlertView;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.passwordTextField.layer.borderColor = [[UIColor colorWithRed:35.0f/255.0f green:135.0f/255.0f blue:215.0f/255.0f alpha:1.0] CGColor];
    self.passwordTextField.layer.borderWidth = 1.0;
    UIView *paddingPasswordView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, 40)];
    self.passwordTextField.leftView = paddingPasswordView;
    self.passwordTextField.leftViewMode = UITextFieldViewModeAlways;
    
    self.confirmTextField.layer.borderColor = [[UIColor colorWithRed:35.0f/255.0f green:135.0f/255.0f blue:215.0f/255.0f alpha:1.0] CGColor];
    self.confirmTextField.layer.borderWidth = 1.0;
    UIView *paddingConfirmView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, 40)];
    self.confirmTextField.leftView = paddingConfirmView;
    self.confirmTextField.leftViewMode = UITextFieldViewModeAlways;
    
    self.overlayView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.overlayView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    self.activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    self.activityIndicator.center = self.overlayView.center;
    [self.overlayView addSubview:self.activityIndicator];
    
}

- (IBAction)saveButtonAction:(id)sender {
    self.passwordText = self.passwordTextField.text;
    self.confirmText = self.confirmTextField.text;
    
    if(self.passwordText.length == 0) {
        [self displayAlertView:@"Warning!" :@"Please input new password."];
        return;
    }
    if(self.passwordText.length < 6) {
        [self displayAlertView:@"Warning!" :@"Password have to be at least 6 characters."];
        return;
    }
    if(![self.passwordText isEqualToString:self.confirmText]) {
        [self displayAlertView:@"Warning!" :@"Password does not match."];
        return;
    }
    
    [self.activityIndicator startAnimating];
    [self.view addSubview:self.overlayView];
    
    NSDictionary *restorePswd = @{@"restorePswd": @{
                                       @"newpassword": self.passwordText,
                                       @"idUser": self.idUser
                                       }};
    NSError *error;
    NSData *postData = [NSJSONSerialization dataWithJSONObject:restorePswd options:0 error:&error];
    NSString *string = [[NSString alloc]initWithData:postData encoding:NSUTF8StringEncoding];
    NSDictionary *parameters = @{
                                 @"method": @"restoreAdminPwd",
                                 @"param": string
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
            [self.TransV setHidden:NO];
            [self.successAlertView setHidden:NO];
        } else {
            [self displayAlertView:@"Warning!" :@"An error occured. Please contact support."];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self.activityIndicator stopAnimating];
        [self.overlayView removeFromSuperview];
        [self displayAlertView:@"Warning!!" :@"Network error."];
    }];
    
}

- (IBAction)successAlertViewOKButtonAction:(id)sender {
    [self.TransV setHidden:YES];
    [self.successAlertView setHidden:YES];
    [self performSegueWithIdentifier:@"confirmpasswordtowelcome_segue" sender:self];
}

- (IBAction)backButtonAction:(id)sender {
    [self performSegueWithIdentifier:@"confirmpasswordtowelcome_segue" sender:self];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([segue.identifier isEqualToString:@"confirmpasswordtowelcome_segue"]) {
        WelcomeViewController *WelcomeVC;
        WelcomeVC = segue.destinationViewController;
    }
}

-(void)displayAlertView: (NSString *)header :(NSString *)message {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:header message:message preferredStyle:UIAlertControllerStyleAlert];
    
    UIApplication *actionOK = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"OK");
    }];
    [alert addAction:actionOK];
    [self presentViewController:alert animated:YES completion:nil];
}
@end
