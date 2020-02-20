//
//  LoginViewController.m
//  PAGADITO
//
//  Created by Javier Calderon  on 2019/1/5.
//  Copyright © 2019 PAGADITO. All rights reserved.
//

#import "LoginViewController.h"
#import "AFNetworking.h"
#import "Global.h"
#import "MultiLanguage.h"
#import "SelectStoreTerminalViewController.h"

@interface LoginViewController ()

@property(strong, nonatomic)UIView *overlayView;
@property(strong, nonatomic)UIActivityIndicatorView * activityIndicator;

@end

//Global *globals;

@implementation LoginViewController
@synthesize textScrollView, emailTextFiled, passwordTextField, comment1Label, comment2Label, signinButton, forgotpasswordButton, explainLabel;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    ///  keyboard avoid
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:self.view.window];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:self.view.window];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer:tap];
    
    self.overlayView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.overlayView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    self.activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    self.activityIndicator.center = self.overlayView.center;
    [self.overlayView addSubview:self.activityIndicator];
    
    /////  multi language configure  ////
    Global *globals = [Global sharedInstance];
    MultiLanguage *multiLanguage = [MultiLanguage sharedInstance];
    
    self.emailTextFiled.placeholder = multiLanguage.signinVC_username[globals.selected_language];
    self.passwordTextField.placeholder = multiLanguage.signinVC_password[globals.selected_language];
    self.comment1Label.text = multiLanguage.signinVC_comment1LabelText[globals.selected_language];
    self.comment2Label.text = multiLanguage.signinVC_comment2LabelText[globals.selected_language];
    [self.signinButton setTitle:multiLanguage.signinVC_signinButtonText[globals.selected_language] forState:UIControlStateNormal];
    [self.forgotpasswordButton setTitle:multiLanguage.signinVC_forgotpasswordText[globals.selected_language] forState:UIControlStateNormal];
    self.explainLabel.text = multiLanguage.signinVC_explain[globals.selected_language];
}

- (IBAction)forgotPass:(id)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://www.pagadito.com/index.php?mod=recuperar"] options:@{} completionHandler:nil];
}

- (void) keyboardWillShow:(NSNotification *) n
{
    NSDictionary* userInfo = [n userInfo];
    // get the size of the keyboard
    CGSize keyboardSize = [[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    // resize the noteView
    
    UIEdgeInsets contentInset = self.textScrollView.contentInset;
    contentInset.bottom = keyboardSize.height;
    self.textScrollView.contentInset = contentInset;
}

- (void) keyboardWillHide:(NSNotification *) n
{
    UIEdgeInsets contentInset = UIEdgeInsetsZero;
    self.textScrollView.contentInset = contentInset;
}

-(void)dismissKeyboard
{
    [self.view endEditing:YES];
}

- (BOOL)validateEmailWithString:(NSString*)email
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}

- (IBAction)LoginButtonAction:(id)sender {
    Global *globals = [Global sharedInstance];

    NSString *emailText = emailTextFiled.text;
    NSString *passwordText = passwordTextField.text;
    
//    emailText = @"jescobar@ninjawebcorporation.com";
//    passwordText = @"12345678a";
    
    if((emailText.length == 0)) {
        if(globals.selected_language == 0) {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"¡Advertencia!" message:@"Ingresa un correo electrónico válido para continuar." preferredStyle:UIAlertControllerStyleAlert];
            UIApplication *actionOK = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                NSLog(@"OK action");
            }];
            [alert addAction:actionOK];
            [self presentViewController:alert animated:YES completion:nil];
        } else {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Warning!" message:@"Enter a valid email to continue." preferredStyle:UIAlertControllerStyleAlert];
            UIApplication *actionOK = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                NSLog(@"OK action");
            }];
            [alert addAction:actionOK];
            [self presentViewController:alert animated:YES completion:nil];
        }
        return;
    }else if((passwordText.length == 0)) {
        if(globals.selected_language == 0) {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"¡Advertencia!" message:@"Ingresa la contraseña de tu cuenta pagadito para continuar." preferredStyle:UIAlertControllerStyleAlert];
            UIApplication *actionOK = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                NSLog(@"OK action");
            }];
            [alert addAction:actionOK];
            [self presentViewController:alert animated:YES completion:nil];
        } else {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Warning!" message:@"Enter the password of your pagadito account to continue." preferredStyle:UIAlertControllerStyleAlert];
            UIApplication *actionOK = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                NSLog(@"OK action");
            }];
            [alert addAction:actionOK];
            [self presentViewController:alert animated:YES completion:nil];
        }
        return;
    }
    
    if(![self validateEmailWithString:emailText]) {
        if(globals.selected_language == 0) {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"¡Advertencia!" message:@"Por favor ingrese una dirección de correo electrónico válida." preferredStyle:UIAlertControllerStyleAlert];
            UIApplication *actionOK = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                NSLog(@"OK action");
            }];
            [alert addAction:actionOK];
            [self presentViewController:alert animated:YES completion:nil];
        } else {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Warning!" message:@"Please input valid email address." preferredStyle:UIAlertControllerStyleAlert];
            UIApplication *actionOK = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                NSLog(@"OK action");
            }];
            [alert addAction:actionOK];
            [self presentViewController:alert animated:YES completion:nil];
        }
        return;
    }
    
    [self.activityIndicator startAnimating];
    [self.view addSubview:self.overlayView];
    
//    NSDictionary *credentials = @{@"credentials": @{
//                                                  @"email": @"jescobar@ninjawebcorporation.com",
//                                                  @"pwd": @"12345678a",
//                                                  @"ambiente": @"0"
//                                                  }};
    NSDictionary *credentials = @{@"credentials": @{
                                          @"email": emailText,
                                          @"pwd": passwordText,
                                          @"ambiente": @"0"
                                          }};
    
    NSError *error;
    NSData *postData = [NSJSONSerialization dataWithJSONObject:credentials options:0 error:&error];
    NSString *string = [[NSString alloc]initWithData:postData encoding:NSUTF8StringEncoding];

    NSDictionary *parameters = @{
                                     @"method": @"initLoginWSPG",
                                     @"credentials": string,
                                     @"TOKEN": globals.server_token
                                };
    
    AFHTTPSessionManager *sessionManager = [AFHTTPSessionManager manager];
    sessionManager.requestSerializer = [AFHTTPRequestSerializer serializer];
    sessionManager.responseSerializer = [AFHTTPResponseSerializer serializer];
    sessionManager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects: @"application/json", nil];
    [sessionManager POST: globals.server_url parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
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
            if(globals.selected_language == 0) {
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"¡Advertencia!" message:@"Los datos ingresados son incorrectos." preferredStyle:UIAlertControllerStyleAlert];
                UIApplication *actionOK = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    NSLog(@"OK action");
                }];
                [alert addAction:actionOK];
                [self presentViewController:alert animated:YES completion:nil];
            } else {
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Warning!" message:@"Data is incorrect." preferredStyle:UIAlertControllerStyleAlert];
                UIApplication *actionOK = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    NSLog(@"OK action");
                }];
                [alert addAction:actionOK];
                [self presentViewController:alert animated:YES completion:nil];
            }
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self.activityIndicator stopAnimating];
        [self.overlayView removeFromSuperview];
        if(globals.selected_language == 0) {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"¡Advertencia!" message:@"Por favor asegurate que estás conectado a internet." preferredStyle:UIAlertControllerStyleAlert];
            UIApplication *actionOK = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                NSLog(@"OK action");
            }];
            [alert addAction:actionOK];
            [self presentViewController:alert animated:YES completion:nil];
        } else {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Warning!" message:@"Networking error." preferredStyle:UIAlertControllerStyleAlert];
            UIApplication *actionOK = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                NSLog(@"OK action");
            }];
            [alert addAction:actionOK];
            [self presentViewController:alert animated:YES completion:nil];
        }
    }];
    
}

-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([segue.identifier isEqualToString:@"logintoselect_segue"]) {
        SelectStoreTerminalViewController *SelectStoreTerminalVC;
        SelectStoreTerminalVC = [segue destinationViewController];
    }
}


@end
