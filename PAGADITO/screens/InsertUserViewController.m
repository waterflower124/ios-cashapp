//
//  InsertUserViewController.m
//  PAGADITO
//
//  Created by Javier Calderon  on 2019/1/13.
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
@synthesize textScrollView, roleSelectButton, checkBoxUIView, pincodeUIView, roleTableVIew, roleTableViewHeightConstraint, checkSwitchView;
@synthesize firstnameTextView, lastnameTextView, usernameTextView, passwordTextView, confirmTextView, pincodeTextView;
@synthesize titleLabel, pincodecommentLabel, checkboxcommentLabel, continuButton;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    ///  keyboard avoid
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:self.view.window];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:self.view.window];
    
    Global *globals = [Global sharedInstance];
    user_role = globals.idPrivilegio;
    
    if(globals.selected_language == 0) {
        self.titleLabel.text = @"Nuevo Usuario";
        [self.roleSelectButton setTitle:@"Selecciona un rol de usuario" forState:UIControlStateNormal];
        self.pincodecommentLabel.text = @"PIN de autorización:";
        self.checkboxcommentLabel.text = @"Asignar nuevo turno automaticamente todos los días.";
        self.firstnameTextView.placeholder = @"Nombres";
        self.lastnameTextView.placeholder = @"Apellidos";
        self.usernameTextView.placeholder = @"Usuario";
        self.passwordTextView.placeholder = @"Contraseña";
        self.confirmTextView.placeholder = @"Confirmar Contraseña";
        [self.continuButton setTitle:@"Continuar" forState:UIControlStateNormal];
    } else {
        self.titleLabel.text = @"New User";
        [self.roleSelectButton setTitle:@"Select User Priviledges" forState:UIControlStateNormal];
        self.pincodecommentLabel.text = @"Authorization PIN:";
        self.checkboxcommentLabel.text = @"Assign new shift automatically every day.";
        self.firstnameTextView.placeholder = @"First Name";
        self.lastnameTextView.placeholder = @"Last Name";
        self.usernameTextView.placeholder = @"Username";
        self.passwordTextView.placeholder = @"Password";
        self.confirmTextView.placeholder = @"Confirm Password";
        [self.continuButton setTitle:@"Continue" forState:UIControlStateNormal];
    }
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer:tap];
    tap.cancelsTouchesInView = NO;
    
    self.overlayView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.overlayView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    self.activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    self.activityIndicator.center = self.overlayView.center;
    [self.overlayView addSubview:self.activityIndicator];
    
    if([user_role isEqualToString:@"1"] || [user_role isEqualToString:@"4"]) {
        if(globals.selected_language == 0) {
            self.roleTableArray = [[NSMutableArray alloc] initWithObjects:@"Supervisor", @"Cajero", nil];
        } else {
            self.roleTableArray = [[NSMutableArray alloc] initWithObjects:@"Supervisor", @"Cashier", nil];
        }
        self.roleTableValueArray = [[NSMutableArray alloc] initWithObjects:@"2", @"3", nil];
        [pincodeUIView setHidden:NO];
        [checkBoxUIView setHidden:YES];
    } else if([user_role isEqualToString:@"2"]) {
        if(globals.selected_language == 0) {
            self.roleTableArray = [[NSMutableArray alloc] initWithObjects:@"Cajero", nil];
        } else {
             self.roleTableArray = [[NSMutableArray alloc] initWithObjects:@"Cashier", nil];
        }
        self.roleTableValueArray = [[NSMutableArray alloc] initWithObjects:@"3", nil];
        [pincodeUIView setHidden:YES];
        [checkBoxUIView setHidden:YES];
    }
    
    [roleSelectButton setTitle:self.roleTableArray[0] forState:UIControlStateNormal];
    roleTableViewHeightConstraint.constant = 40 * self.roleTableArray.count;
    
    self.pincodeTextView.delegate = self;
    self.usernameTextView.delegate = self;
    self.firstnameTextView.delegate = self;
    self.lastnameTextView.delegate = self;
    
    self.selectedRole = self.roleTableValueArray[0];
    self.checkStatus = @"0";
    
    self.firstname = @"";
    self.lastname = @"";
    self.username = @"";
    self.password = @"";
    self.confirmpwd = @"";
    self.pincode = @"";
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if(textField == self.pincodeTextView){
        if (textField.text.length < 4  || string.length == 0){
            return YES;
        }
        else{
            return NO;
        }
    }
    else if(textField == self.usernameTextView){
        if (textField.text.length < 25  || string.length == 0){
            return YES;
        }
        else{
            return NO;
        }
    }
    else if(textField == self.firstnameTextView){
        if (textField.text.length < 45  || string.length == 0){
            return YES;
        }
        else{
            return NO;
        }
    }
    else if(textField == self.lastnameTextView){
        if (textField.text.length < 45  || string.length == 0){
            return YES;
        }
        else{
            return NO;
        }
    }
    return NO;
}

- (void) keyboardWillShow:(NSNotification *) n
{
    NSDictionary* userInfo = [n userInfo];
    // get the size of the keyboard
    CGSize keyboardSize = [[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    // resize the noteView
    
    UIEdgeInsets contentInset = self.textScrollView.contentInset;
    contentInset.bottom = keyboardSize.height - 50;
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
        if([user_role isEqualToString:@"1"] || [user_role isEqualToString:@"4"]) {
            [pincodeUIView setHidden:YES];
            [checkBoxUIView setHidden:YES];
            [self.checkSwitchView setOn:YES animated:YES];
            self.checkStatus = @"1";
        } else {
            [pincodeUIView setHidden:YES];
            [checkBoxUIView setHidden:YES];
            [self.checkSwitchView setOn:YES animated:YES];
            self.checkStatus = @"0";
        }

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

-(void) createUser {
    Global *globals = [Global sharedInstance];
    
    [self.activityIndicator startAnimating];
    [self.view addSubview:self.overlayView];
    
    NSDictionary *infoUsuario = @{@"infoUsuario": @{
                                          @"nombres": self.firstname,
                                          @"apellidos": self.lastname,
                                          @"idPrivilegio": self.selectedRole,
                                          @"username": self.username,
                                          @"password": self.password,
                                          @"shiftEveryday": @"0",
                                          @"codigoAprocobacion": self.pincode,
                                          @"idDispositivo": globals.idDispositivo,
                                          }};
    NSError *error;
    NSData *postData = [NSJSONSerialization dataWithJSONObject:infoUsuario options:0 error:&error];
    NSString *string = [[NSString alloc]initWithData:postData encoding:NSUTF8StringEncoding];
    NSDictionary *parameters = @{
                                 @"method": @"insertSystemUsers",
                                 @"param": string,
                                 @"TOKEN": globals.server_token
                                 };
    NSLog(@"%@", parameters);
    AFHTTPSessionManager *sessionManager = [AFHTTPSessionManager manager];
    sessionManager.requestSerializer = [AFHTTPRequestSerializer serializer];
    sessionManager.responseSerializer = [AFHTTPResponseSerializer serializer];
    sessionManager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects: @"application/json", nil];
    [sessionManager POST: globals.server_url parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        [self.activityIndicator stopAnimating];
        [self.overlayView removeFromSuperview];
        
        NSError *jsonError;
        NSDictionary *jsonResponse = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:&jsonError];
        BOOL status = [jsonResponse[@"status"] boolValue];
        if(status) {
            if(globals.selected_language == 0) {
                [self displayAlertView:@"¡Éxito!" :[NSString stringWithFormat:@"Creaste al usuario %@ con éxito.", self.username] :@"user_admin"];
            } else {
                [self displayAlertView:@"Congratulations!" :[NSString stringWithFormat:@"New user %@ created successfully", self.username] :@"user_admin"];
            }
        } else {
            if(globals.selected_language == 0) {
                [self displayAlertView:@"¡Advertencia!." :@"Ha ocurrido un error al crear el usuario." :@"nil"];
            } else {
                [self displayAlertView:@"Warning!." :@"There has been an error creating this user." :@"nil"];
            }
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
        if(globals.selected_language == 0) {
            [self displayAlertView:@"¡Advertencia!." :@"Por favor asegurate que estás conectado a internet." :@"nil"];
        } else {
            [self displayAlertView:@"Warning!." :@"Please check your internet connection to continue." :@"nil"];
        }
    }];
}

- (IBAction)createuserButtonAction:(id)sender {
    self.firstname = firstnameTextView.text;
    self.lastname = lastnameTextView.text;
    self.username = usernameTextView.text;
    self.password = passwordTextView.text;
    self.confirmpwd = confirmTextView.text;
    self.pincode = pincodeTextView.text;
    
    Global *globals = [Global sharedInstance];
    
    if(self.firstname.length == 0) {
        if(globals.selected_language == 0) {
            [self displayAlertView:@"¡Advertencia!" :@"Por favor ingrese un nombre." :@"nil"];
        } else {
            [self displayAlertView:@"Warning!" :@"Please enter a name." :@"nil"];
        }
        return;
    }
    if(self.lastname.length == 0) {
        if(globals.selected_language == 0) {
            [self displayAlertView:@"¡Advertencia!" :@"Por favor ingrese un apellido." :@"nil"];
        } else {
            [self displayAlertView:@"Warning!" :@"Please enter a LastName." :@"nil"];
        }
        return;
    }
    if(self.username.length == 0) {
        if(globals.selected_language == 0) {
            [self displayAlertView:@"¡Advertencia!" :@"Por favor ingrese un nombre de usuario." :@"nil"];
        } else {
            [self displayAlertView:@"Warning!" :@"Please enter a UserName." :@"nil"];
        }
        return;
    }
    
    NSString *someRegexp = @"^[a-zA-Z0-9]+$";
    NSPredicate *myTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", someRegexp];
    
    if (![myTest evaluateWithObject: self.username]){
        if(globals.selected_language == 0) {
            [self displayAlertView:@"¡Advertencia!" :@"Utiliza únicamente letras de la A-Z y números del 0-9, sin espacios." :@"nil"];
        } else {
            [self displayAlertView:@"Warning!" :@"Only characters from A-Z, and numbers 0-9 are allowed, with no spaces." :@"nil"];
        }
        return;
    }
    
    if(self.password.length == 0) {
        if(globals.selected_language == 0) {
            [self displayAlertView:@"¡Advertencia!" :@"Por favor ingrese una contraseña." :@"nil"];
        } else {
            [self displayAlertView:@"Warning!" :@"Please enter a Password." :@"nil"];
        }
        return;
    }
    if(self.password.length < 6) {
        if(globals.selected_language == 0) {
            [self displayAlertView:@"¡Advertencia!" :@"La contraseña debe tener al menos 6 caracteres." :@"nil"];
        } else {
            [self displayAlertView:@"Warning!" :@"Password have to be at least 6 characters." :@"nil"];
        }
        return;
    }
    if(self.confirmpwd.length == 0) {
        if(globals.selected_language == 0) {
            [self displayAlertView:@"¡Advertencia!" :@"Por favor ingrese la confirmación de la contraseña." :@"nil"];
        } else {
            [self displayAlertView:@"Warning!" :@"Please enter the confirmation password." :@"nil"];
        }
        return;
    }
    if(![self.password isEqualToString:self.confirmpwd]) {
        if(globals.selected_language == 0) {
            [self displayAlertView:@"¡Advertencia!" :@"Ambas contraseñas deben ser iguales. Usuario no guardado" :@"nil"];
        } else {
            [self displayAlertView:@"Warning!" :@"The password confirmation does not match the original. Changes not saved." :@"nil"];
        }
        return;
    }
    if([self.selectedRole isEqualToString: @"2"]) {
        if(self.pincode.length == 0) {
            if(globals.selected_language == 0) {
                [self displayAlertView:@"¡Advertencia!" :@"Por favor ingrese un PIN" :@"nil"];
            } else {
                [self displayAlertView:@"Warning!" :@"Please enter a valid PIN" :@"nil"];
            }
            return;
        }
        if(self.pincode.length != 4) {
            if(globals.selected_language == 0) {
                [self displayAlertView:@"¡Advertencia!" :@"El código pin debe tener 4 dígitos." :@"nil"];
            } else {
                [self displayAlertView:@"Warning!" :@"Pin code have to be 4 digits." :@"nil"];
            }
            return;
        }
    }
    
    [self.activityIndicator startAnimating];
    [self.view addSubview:self.overlayView];
    
    NSDictionary *parameters = @{
                                 @"method": @"checkUserName",
                                 @"username": self.username,
                                 @"TOKEN": globals.server_token
                                 };
    
    AFHTTPSessionManager *sessionManager = [AFHTTPSessionManager manager];
    sessionManager.requestSerializer = [AFHTTPRequestSerializer serializer];
    sessionManager.responseSerializer = [AFHTTPResponseSerializer serializer];
    sessionManager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects: @"application/json", nil];
    [sessionManager POST: globals.server_url parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
     {
         NSError *jsonError;
         NSDictionary *jsonResponse = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:&jsonError];
         
         [self.activityIndicator stopAnimating];
         [self.overlayView removeFromSuperview];
         
         BOOL status = [jsonResponse[@"status"] boolValue];
         
         if(status) {
             if(globals.selected_language == 0) {
                 [self displayAlertView:@"¡Advertencia!" :@"Este nombre de usuario no está disponible. Por favor intente de nuevo con un nombre de usuario diferente." :@"nil"];
             } else {
                 [self displayAlertView:@"Warning!" :@"Username is not available. Please try again with another username." :@"nil"];
             }
         } else {
             [self.activityIndicator stopAnimating];
             [self.overlayView removeFromSuperview];
             
             [self createUser];
         }
     } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
         [self.activityIndicator stopAnimating];
         [self.overlayView removeFromSuperview];
         if(globals.selected_language == 0) {
             [self displayAlertView:@"¡Advertencia!" :@"Por favor asegurate que estás conectado a internet." :@"nil"];
         } else {
             [self displayAlertView:@"Warning!" :@"Please check your internet connection to continue." :@"nil"];
         }
         
     }];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    UserAdminViewController *userAdminVC;
    userAdminVC = [segue destinationViewController];
}

-(void)displayAlertView: (NSString *)header :(NSString *)message :(NSString *)nextScreen {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:header message:message preferredStyle:UIAlertControllerStyleAlert];
    UIApplication *actionOK = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if([nextScreen isEqualToString:@"user_admin"]) {
            [self performSegueWithIdentifier:@"createtoadmisuser_seque" sender:self];
        }
    }];
    [alert addAction:actionOK];
    [self presentViewController:alert animated:YES completion:nil];
}
@end
