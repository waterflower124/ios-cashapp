//
//  InsertUserViewController.m
//  PAGADITO
//
//  Created by Water Flower on 2019/1/13.
//  Copyright © 2019 PAGADITO. All rights reserved.
//

#import "InsertUserViewController.h"
#import "Global.h"
#import "AFNetworking.h"
#import "UserAdminViewController.h"

@interface InsertUserViewController () <UITableViewDelegate, UITableViewDataSource>

@property(strong, nonatomic)NSMutableArray *roleTableArray;
@property(strong, nonatomic)NSMutableArray *roleTableValueArray;
@property(strong, nonatomic)NSString *selectedRole;
@property(strong, nonatomic)NSString *checkStatus;

@property(strong, nonatomic)NSString *firstname;
@property(strong, nonatomic)NSString *lastname ;
@property(strong, nonatomic)NSString *username;
@property(strong, nonatomic)NSString *password;
@property(strong, nonatomic)NSString *confirmpwd;
@property(strong, nonatomic)NSString *pincode;

@property(strong, nonatomic)UIView *overlayView;
@property(strong, nonatomic)UIActivityIndicatorView * activityIndicator;


@end

@implementation InsertUserViewController
@synthesize user_role;
@synthesize roleSelectButton, checkBoxUIView, pincodeUIView, roleTableVIew, roleTableViewHeightConstraint, checkSwitchView;
@synthesize firstnameTextView, lastnameTextView, usernameTextView, passwordTextView, confirmTextView, pincodeTextView;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer:tap];
    tap.cancelsTouchesInView = NO;
    
    self.overlayView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.overlayView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    self.activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    self.activityIndicator.center = self.overlayView.center;
    [self.overlayView addSubview:self.activityIndicator];
    
    if([user_role isEqualToString:@"1"] || [user_role isEqualToString:@"4"]) {
        self.roleTableArray = [[NSMutableArray alloc] initWithObjects:@"Supervisor", @"Cajero", nil];
        self.roleTableValueArray = [[NSMutableArray alloc] initWithObjects:@"2", @"3", nil];
        [pincodeUIView setHidden:NO];
        [checkBoxUIView setHidden:YES];
    } else if([user_role isEqualToString:@"2"]) {
        self.roleTableArray = [[NSMutableArray alloc] initWithObjects:@"Cajero", nil];
        self.roleTableValueArray = [[NSMutableArray alloc] initWithObjects:@"3", nil];
        [pincodeUIView setHidden:YES];
        [checkBoxUIView setHidden:NO];
    }
    
    [roleSelectButton setTitle:self.roleTableArray[0] forState:UIControlStateNormal];
    roleTableViewHeightConstraint.constant = 40 * self.roleTableArray.count;
    
    self.selectedRole = self.roleTableValueArray[0];
    self.checkStatus = @"0";
    
    self.firstname = @"";
    self.lastname = @"";
    self.username = @"";
    self.password = @"";
    self.confirmpwd = @"";
    self.pincode = @"";
}

-(void)dismissKeyboard
{
    [self.view endEditing:YES];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.roleTableArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if(cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    cell.textLabel.text = self.roleTableArray[indexPath.row];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 40;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [roleSelectButton setTitle:self.roleTableArray[indexPath.row] forState:UIControlStateNormal];
    self.selectedRole = self.roleTableValueArray[indexPath.row];
    [roleTableVIew setHidden:YES ];
    if([self.selectedRole isEqualToString:@"2"]) {
        [pincodeUIView setHidden:NO];
        [checkBoxUIView setHidden:YES];
        self.checkStatus = @"0";
        [self.checkSwitchView setOn:NO animated:YES];
    } else if([self.selectedRole isEqualToString:@"3"]) {
        [pincodeUIView setHidden:YES];
        [checkBoxUIView setHidden:NO];
        [self.checkSwitchView setOn:YES animated:YES];
        self.checkStatus = @"1";

    }
}
- (IBAction)backButtonAction:(id)sender {
    [self performSegueWithIdentifier:@"createtoadmisuser_seque" sender:self];
}

- (IBAction)roleSelectButtonAction:(id)sender {
    if([roleTableVIew isHidden]) {
        [roleTableVIew setHidden:NO ];
    } else {
        [roleTableVIew setHidden:YES ];
    }
}

- (IBAction)switchViewAction:(id)sender {
    if(checkSwitchView.on) {
        self.checkStatus = @"1";
    } else {
        self.checkStatus = @"0";
    }
}

- (IBAction)createuserButtonAction:(id)sender {
    self.firstname = firstnameTextView.text;
    self.lastname = lastnameTextView.text;
    self.username = usernameTextView.text;
    self.password = passwordTextView.text;
    self.confirmpwd = confirmTextView.text;
    self.pincode = pincodeTextView.text;
    
    if(self.firstname.length == 0) {
        [self displayAlertView:@"Warning!" :@"Please input First Name."];
        return;
    }
    if(self.lastname.length == 0) {
        [self displayAlertView:@"Warning!" :@"Please input Last Name."];
        return;
    }
    if(self.username.length == 0) {
        [self displayAlertView:@"Warning!" :@"Please input UserName."];
        return;
    }
    if(self.password.length == 0) {
        [self displayAlertView:@"Warning!" :@"Please input Password."];
        return;
    }
    if(self.password.length < 6) {
        [self displayAlertView:@"Warning!" :@"Password have to be at least 6 characters."];
        return;
    }
    if(![self.password isEqualToString:self.confirmpwd]) {
        [self displayAlertView:@"Warning!" :@"Password doesn't match."];
        return;
    }
    
    [self.activityIndicator startAnimating];
    [self.view addSubview:self.overlayView];
    
    Global *globals = [Global sharedInstance];
    
    NSDictionary *infoUsuario = @{@"infoUsuario": @{
                                          @"nombres": self.firstname,
                                          @"apellidos": self.lastname,
                                          @"idPrivilegio": self.selectedRole,
                                          @"username": self.username,
                                          @"password": self.password,
                                          @"shiftEveryday": self.checkStatus,
                                          @"codigoAprocobacion": self.pincode,
                                          @"idDispositivo": globals.idDispositivo,
                                          }};
    NSError *error;
    NSData *postData = [NSJSONSerialization dataWithJSONObject:infoUsuario options:0 error:&error];
    NSString *string = [[NSString alloc]initWithData:postData encoding:NSUTF8StringEncoding];
    NSDictionary *parameters = @{
                                 @"method": @"insertSystemUsers",
                                 @"param": string
                                 };
//    NSLog(@"%@", parameters);
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
            [self displayAlertView:@"Congratulations!" :@"The user was succesfully created"];
        } else {
            [self displayAlertView:@"Warning!." :@"There has been an error creating this user."];
            self.firstnameTextView.text = @"";
            self.lastnameTextView.text = @"";
            self.usernameTextView.text = @"";
            self.passwordTextView.text = @"";
            self.confirmTextView.text = @"";
            self.pincodeTextView.text = @"";
            [self.checkSwitchView setOn:YES animated:YES];
            self.checkStatus = @"1";
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self.activityIndicator stopAnimating];
        [self.overlayView removeFromSuperview];
        [self displayAlertView:@"Warning!." :@"Network error."];
    }];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    UserAdminViewController *userAdminVC;
    userAdminVC = [segue destinationViewController];
}

-(void)displayAlertView: (NSString *)header :(NSString *)message {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:header message:message preferredStyle:UIAlertControllerStyleAlert];
    UIApplication *actionOK = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if([header isEqualToString:@"Congratulations!"]) {
            [self performSegueWithIdentifier:@"createtoadmisuser_seque" sender:self];
        }
    }];
    [alert addAction:actionOK];
    [self presentViewController:alert animated:YES completion:nil];
}
@end
