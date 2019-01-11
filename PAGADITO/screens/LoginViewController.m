//
//  LoginViewController.m
//  PAGADITO
//
//  Created by Water Flower on 2019/1/5.
//  Copyright © 2019 PAGADITO. All rights reserved.
//

#import "LoginViewController.h"
#import "AFNetworking.h"
#import "Global.h"
#import "SelectStoreTerminalViewController.h"

@interface LoginViewController ()

@property(strong, nonatomic)UIView *overlayView;
@property(strong, nonatomic)UIActivityIndicatorView * activityIndicator;

@end

//Global *globals;

@implementation LoginViewController
@synthesize emailTextFiled, passwordTextField;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
//    globals = [Global sharedInstance];
    
    self.overlayView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.overlayView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    self.activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    self.activityIndicator.center = self.overlayView.center;
    [self.overlayView addSubview:self.activityIndicator];
    
    
    
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)LoginButtonAction:(id)sender {
    Global *globals = [Global sharedInstance];

    NSString *emailText = emailTextFiled.text;
    NSString *passwordText = passwordTextField.text;
    if((emailText.length == 0) || (passwordText.length == 0)) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Warning!" message:@"Please insert email and password." preferredStyle:UIAlertControllerStyleAlert];
        UIApplication *actionOK = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            NSLog(@"OK action");
        }];
        [alert addAction:actionOK];
        [self presentViewController:alert animated:YES completion:nil];
        return;
    }
    
    [self.activityIndicator startAnimating];
    [self.view addSubview:self.overlayView];
    
    NSDictionary *credentials = @{@"credentials": @{
                                                  @"email": @"jescobar@ninjawebcorporation.com",
                                                  @"pwd": @"12345678a",
                                                  @"ambiente": @"0"
                                                  }};
//    NSDictionary *credentials = @{@"credentials": @{
//                                          @"email": emailText,
//                                          @"pwd": passwordText,
//                                          @"ambiente": @"0"
//                                          }};
    
    NSError *error;
    NSData *postData = [NSJSONSerialization dataWithJSONObject:credentials options:0 error:&error];
    NSString *string = [[NSString alloc]initWithData:postData encoding:NSUTF8StringEncoding];

    NSDictionary *parameters = @{
                                     @"method": @"initLoginWSPG",
                                     @"credentials": string
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
        if([jsonResponse[@"code"] isEqualToString: @"PG1023"]) {
            NSDictionary *credentialsResponse = jsonResponse[@"value"][@"credentials"];
            NSString *uid = credentialsResponse[@"uid"];
            globals.uid = uid;
            NSString *wsk = credentialsResponse[@"wsk"];
            globals.wsk = wsk;
            
            NSDictionary *cypherResponse = jsonResponse[@"value"][@"cypher"];
            NSString *private_key = cypherResponse[@"private_key"];
            globals.private_key = private_key;
            NSString *initialization_vector = cypherResponse[@"initialization_vector"];
            globals.initialization_vector = initialization_vector;
            
            [self performSegueWithIdentifier:@"logintoselect_segue" sender:self];
            
//            SelectStoreTerminalViewController *dvc = [self.storyboard instantiateViewControllerWithIdentifier:@"selectstoreterminalVC_ID"];
//            [dvc setModalTransitionStyle:UIModalTransitionStyleCoverVertical];
//            [self presentViewController:dvc animated:YES completion:nil];
            
        } else {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Warning!" message:@"Incorrect email or password" preferredStyle:UIAlertControllerStyleAlert];
            UIApplication *actionOK = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                NSLog(@"OK action");
            }];
            [alert addAction:actionOK];
            [self presentViewController:alert animated:YES completion:nil];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self.activityIndicator stopAnimating];
        [self.overlayView removeFromSuperview];
        NSLog(@"bbbb %@", error);
    }];
    
}

-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([segue.identifier isEqualToString:@"logintoselect_segue"]) {
        SelectStoreTerminalViewController *SelectStoreTerminalVC;
        SelectStoreTerminalVC = [segue destinationViewController];
    }
}


@end
