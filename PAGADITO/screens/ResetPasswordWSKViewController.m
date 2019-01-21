//
//  ResetPasswordWSKViewController.m
//  PAGADITO
//
//  Created by Water Flower on 2019/1/21.
//  Copyright © 2019 PAGADITO. All rights reserved.
//

#import "ResetPasswordWSKViewController.h"
#import "AFNetworking.h"
#import "ResetPasswordConfirmViewController.h"


@interface ResetPasswordWSKViewController ()
@property(strong, nonatomic)NSString *wskText;
@property(strong, nonatomic)NSString *idUser;

@property(strong, nonatomic)UIView *overlayView;
@property(strong, nonatomic)UIActivityIndicatorView * activityIndicator;

@end

@implementation ResetPasswordWSKViewController
@synthesize wskTextField, TransV, failAlertView;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.wskTextField.layer.borderColor = [[UIColor colorWithRed:35.0f/255.0f green:135.0f/255.0f blue:215.0f/255.0f alpha:1.0] CGColor];
    self.wskTextField.layer.borderWidth = 1.0;
    UIView *paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, 40)];
    self.wskTextField.leftView = paddingView;
    wskTextField.leftViewMode = UITextFieldViewModeAlways;
    
    self.overlayView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.overlayView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    self.activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    self.activityIndicator.center = self.overlayView.center;
    [self.overlayView addSubview:self.activityIndicator];
}

- (IBAction)continueButtonAction:(id)sender {
    self.wskText = self.wskTextField.text;
    if(self.wskText.length == 0) {
        [self displayAlertView:@"Warning!" :@"Please input WSK for your account"];
        return;
    }
    
    [self.activityIndicator startAnimating];
    [self.view addSubview:self.overlayView];
    
    NSDictionary *validWSK = @{@"validWSK": @{
                                         @"wsk": self.wskText
                                         }};
    NSError *error;
    NSData *postData = [NSJSONSerialization dataWithJSONObject:validWSK options:0 error:&error];
    NSString *string = [[NSString alloc]initWithData:postData encoding:NSUTF8StringEncoding];
    NSDictionary *parameters = @{
                                 @"method": @"readValidWSK",
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
        NSLog(@"%@", jsonResponse);
        BOOL status = [jsonResponse[@"status"] boolValue];
        if(status) {
            self.idUser = jsonResponse[@"idUser"];
            [self performSegueWithIdentifier:@"passwordwsktoconfirm_segue" sender:self];
        } else {
            [self.TransV setHidden:NO];
            [self.failAlertView setHidden:NO];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self.activityIndicator stopAnimating];
        [self.overlayView removeFromSuperview];
        [self displayAlertView:@"Warning!!" :@"Network error."];
    }];
}

- (IBAction)failOkButtonAction:(id)sender {
    [self.TransV setHidden:YES];
    [self.failAlertView setHidden:YES];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([segue.identifier isEqualToString:@"passwordwsktoconfirm_segue"]) {
        ResetPasswordConfirmViewController *ResetPasswordConfirm;
        ResetPasswordConfirm = [segue destinationViewController];
        ResetPasswordConfirm.idUser = self.idUser;
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
