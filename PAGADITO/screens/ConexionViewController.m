//
//  ConexionViewController.m
//  PAGADITO
//
//  Created by Javier Calderon  on 2019/1/22.
//  Copyright © 2019 PAGADITO. All rights reserved.
//

#import "ConexionViewController.h"
#import "Global.h"
#import "AFNetworking.h"
#import "WelcomeViewController.h"

@interface ConexionViewController ()

@property(strong, nonatomic)NSString *sessionInfoLabelText;
@property(strong, nonatomic)NSString *uidText;
@property(strong, nonatomic)NSString *wskText;
@property(strong, nonatomic)NSString *idSecursalText;
@property(strong, nonatomic)NSString *idTerminalText;
@property(strong, nonatomic)NSString *LlaveprivadaText;
@property(strong, nonatomic)NSString *vectorText;

@property(strong, nonatomic)UIView *overlayView;
@property(strong, nonatomic)UIActivityIndicatorView * activityIndicator;

@end

@implementation ConexionViewController
@synthesize textScrollView, homeButton, reportButton, configButton, usuarioButton, turnoButton, canceltransactionButton, newtransactionButton, logoutButton, cerraturnoButton;
@synthesize SidePanel, TransV, sessionInfoLabel, uidTextField, wskTextField, idSecursalTextField, idTerminalTextField, LlaveprivadaTextField, vectorTextField;
@synthesize titleLabel, warningcommentLabel, conexioncredentialcommentLabel, dataencryptioncommentLabel, keycommentLabel, vectorcommentLabel, saveButton, cancelchangeButton, sessioncommentLabel;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    Global *globals = [Global sharedInstance];
    if(globals.selected_language == 0) {
        self.titleLabel.text = @"Conexión";
        self.warningcommentLabel.text = @"Advertencia: Datos erroneos causarán el mal funcionamiento de la aplicación.";
        self.conexioncredentialcommentLabel.text = @"Credenciales de Conexión";
        self.dataencryptioncommentLabel.text = @"Información de Encriptación de Datos";
        self.keycommentLabel.text = @"Llave privada";
        self.vectorcommentLabel.text = @"Vector de Inicialización";
        [self.saveButton setTitle:@"Guardar" forState:UIControlStateNormal];
        [self.cancelchangeButton setTitle:@"Descartar cambios" forState:UIControlStateNormal];
        self.sessioncommentLabel.text = @"Sesión iniciada:";
    } else {
        self.titleLabel.text = @"Connection";
        self.warningcommentLabel.text = @"Warning: Wrong data will cause the application to malfunction";
        self.conexioncredentialcommentLabel.text = @"Connection credentials";
        self.dataencryptioncommentLabel.text = @"Data encryption information";
        self.keycommentLabel.text = @"Private key";
        self.vectorcommentLabel.text = @"Vector initialization";
        [self.saveButton setTitle:@"Save" forState:UIControlStateNormal];
        [self.cancelchangeButton setTitle:@"Discard changes" forState:UIControlStateNormal];
        self.sessioncommentLabel.text = @"Session started:";
    }
    
    [self setMenuButtonsicon];
    
    ///////// initialize   //////////
    self.uidTextField.text = globals.login_uid;
    self.uidText = globals.login_uid;
    self.wskTextField.text = globals.login_wsk;
    self.wskText = globals.login_wsk;
    self.idSecursalTextField.text = globals.branchid;
    self.idSecursalText = globals.branchid;
    self.idTerminalTextField.text = globals.terminalid;
    self.idTerminalText = globals.terminalid;
    self.LlaveprivadaTextField.text = globals.llaveCifrado;
    self.LlaveprivadaText = globals.llaveCifrado;
    self.vectorTextField.text = globals.cifradoIV;
    self.vectorText = globals.cifradoIV;
    
    ///  keyboard avoid
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:self.view.window];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:self.view.window];
    
    /////  dismiss keyboard  ///////////
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer:tap];
    tap.cancelsTouchesInView = NO;
    
    ////////////////  TransV tapp event     ///////////////
    UITapGestureRecognizer *tapper = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideSidePanel:)];
    tapper.numberOfTapsRequired = 1;
    [TransV addGestureRecognizer:tapper];
    
    //session info label
    self.sessionInfoLabelText = [NSString stringWithFormat:@"%@ / %@", globals.username, globals.nombreComercio];
    sessionInfoLabel.text = self.sessionInfoLabelText;
    
    /////  init for activity indicator
    self.overlayView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.overlayView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    self.activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    self.activityIndicator.center = self.overlayView.center;
    [self.overlayView addSubview:self.activityIndicator];
    
    //set dashborad buttons background image according to priviledge ID
    if([globals.idPrivilegio isEqualToString:@"1"]) {
        CGRect homeButtonFrame = self.homeButton.frame;
        homeButtonFrame.origin.x = 0;
        homeButtonFrame.origin.y = 0;
        self.homeButton.frame = homeButtonFrame;
        UIView *homelineView = [[UIView alloc] initWithFrame:CGRectMake(0, 59, homeButton.frame.size.width, 1)];
        homelineView.backgroundColor = [UIColor lightGrayColor];
        [self.homeButton addSubview:homelineView];
        
        CGRect reportButtonFrame = self.reportButton.frame;
        reportButtonFrame.origin.x = 0;
        reportButtonFrame.origin.y = 60;
        self.reportButton.frame = reportButtonFrame;
        UIView *reportlineView = [[UIView alloc] initWithFrame:CGRectMake(0, 59, reportButton.frame.size.width, 1)];
        reportlineView.backgroundColor = [UIColor lightGrayColor];
        [self.reportButton addSubview:reportlineView];
        
        CGRect configureButtonFrame = self.configButton.frame;
        configureButtonFrame.origin.x = 0;
        configureButtonFrame.origin.y = 120;
        self.configButton.frame = configureButtonFrame;
        UIView *configurelineView = [[UIView alloc] initWithFrame:CGRectMake(0, 59, configButton.frame.size.width, 1)];
        configurelineView.backgroundColor = [UIColor lightGrayColor];
        [self.configButton addSubview:configurelineView];
        
        CGRect usuarioButtonFrame = self.usuarioButton.frame;
        usuarioButtonFrame.origin.x = 0;
        usuarioButtonFrame.origin.y = 180;
        self.usuarioButton.frame = usuarioButtonFrame;
        UIView *usuariolineView = [[UIView alloc] initWithFrame:CGRectMake(0, 59, usuarioButton.frame.size.width, 1)];
        usuariolineView.backgroundColor = [UIColor lightGrayColor];
        [self.usuarioButton addSubview:usuariolineView];
        
        [self.turnoButton setHidden:YES];
        [self.canceltransactionButton setHidden:YES];
        [self.newtransactionButton setHidden:YES];
        [self.cerraturnoButton setHidden:YES];
        ////////////////////////////////////////////
    } else if([globals.idPrivilegio isEqualToString:@"4"]) {
        
        ///////  side menu button config   ////////////
        CGRect homeButtonFrame = self.homeButton.frame;
        homeButtonFrame.origin.x = 0;
        homeButtonFrame.origin.y = 0;
        self.homeButton.frame = homeButtonFrame;
        UIView *homelineView = [[UIView alloc] initWithFrame:CGRectMake(0, 59, homeButton.frame.size.width, 1)];
        homelineView.backgroundColor = [UIColor lightGrayColor];
        [self.homeButton addSubview:homelineView];
        
        CGRect reportButtonFrame = self.reportButton.frame;
        reportButtonFrame.origin.x = 0;
        reportButtonFrame.origin.y = 60;
        self.reportButton.frame = reportButtonFrame;
        UIView *reportlineView = [[UIView alloc] initWithFrame:CGRectMake(0, 59, reportButton.frame.size.width, 1)];
        reportlineView.backgroundColor = [UIColor lightGrayColor];
        [self.reportButton addSubview:reportlineView];
        
        CGRect configureButtonFrame = self.configButton.frame;
        configureButtonFrame.origin.x = 0;
        configureButtonFrame.origin.y = 120;
        self.configButton.frame = configureButtonFrame;
        UIView *configurelineView = [[UIView alloc] initWithFrame:CGRectMake(0, 59, configButton.frame.size.width, 1)];
        configurelineView.backgroundColor = [UIColor lightGrayColor];
        [self.configButton addSubview:configurelineView];
        
        CGRect usuarioButtonFrame = self.usuarioButton.frame;
        usuarioButtonFrame.origin.x = 0;
        usuarioButtonFrame.origin.y = 180;
        self.usuarioButton.frame = usuarioButtonFrame;
        UIView *usuariolineView = [[UIView alloc] initWithFrame:CGRectMake(0, 59, usuarioButton.frame.size.width, 1)];
        usuariolineView.backgroundColor = [UIColor lightGrayColor];
        [self.usuarioButton addSubview:usuariolineView];
        
        CGRect turnoButtonFrame = self.turnoButton.frame;
        turnoButtonFrame.origin.x = 0;
        turnoButtonFrame.origin.y = 240;
        self.turnoButton.frame = turnoButtonFrame;
        UIView *turnolineView = [[UIView alloc] initWithFrame:CGRectMake(0, 59, turnoButton.frame.size.width, 1)];
        turnolineView.backgroundColor = [UIColor lightGrayColor];
        [self.turnoButton addSubview:turnolineView];
        
        CGRect newtransactionButtonFrame = self.newtransactionButton.frame;
        newtransactionButtonFrame.origin.x = 0;
        newtransactionButtonFrame.origin.y = 300;
        self.newtransactionButton.frame = newtransactionButtonFrame;
        UIView *newtransactiolineView = [[UIView alloc] initWithFrame:CGRectMake(0, 59, newtransactionButton.frame.size.width, 1)];
        newtransactiolineView.backgroundColor = [UIColor lightGrayColor];
        [self.newtransactionButton addSubview:newtransactiolineView];
        
        CGRect canceltransactionButtonFrame = self.canceltransactionButton.frame;
        canceltransactionButtonFrame.origin.x = 0;
        canceltransactionButtonFrame.origin.y = 360;
        self.canceltransactionButton.frame = canceltransactionButtonFrame;
        UIView *canceltransactionlineView = [[UIView alloc] initWithFrame:CGRectMake(0, 59, canceltransactionButton.frame.size.width, 1)];
        canceltransactionlineView.backgroundColor = [UIColor lightGrayColor];
        [self.canceltransactionButton addSubview:canceltransactionlineView];
        
        
//        CGRect cerraturnoButtonFrame = self.cerraturnoButton.frame;
//        cerraturnoButtonFrame.origin.x = 0;
//        cerraturnoButtonFrame.origin.y = 420;
//        self.cerraturnoButton.frame = cerraturnoButtonFrame;
//        UIView *cerraturnolineView = [[UIView alloc] initWithFrame:CGRectMake(0, 59, cerraturnoButton.frame.size.width, 1)];
//        cerraturnolineView.backgroundColor = [UIColor lightGrayColor];
//        [self.cerraturnoButton addSubview:cerraturnolineView];
        [self.cerraturnoButton setHidden:YES];
        
    }
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

-(void)setMenuButtonsicon {
    Global *globals = [Global sharedInstance];
    if(globals.selected_language == 0) {
        [self.homeButton setImage:[UIImage imageNamed: @"menu_home_sp"] forState:UIControlStateNormal];
        [self.reportButton setImage:[UIImage imageNamed: @"menu_reports_sp"] forState:UIControlStateNormal];
        [self.configButton setImage:[UIImage imageNamed: @"menu_configuration_sp"] forState:UIControlStateNormal];
        [self.usuarioButton setImage:[UIImage imageNamed: @"menu_users_sp"] forState:UIControlStateNormal];
        [self.turnoButton setImage:[UIImage imageNamed: @"menu_shift_sp"] forState:UIControlStateNormal];
        [self.canceltransactionButton setImage:[UIImage imageNamed: @"menu_canceltransaction_sp"] forState:UIControlStateNormal];
        [self.newtransactionButton setImage:[UIImage imageNamed: @"menu_newtransaction_sp"] forState:UIControlStateNormal];
        [self.logoutButton setImage:[UIImage imageNamed: @"menu_signout_sp"] forState:UIControlStateNormal];
        [self.cerraturnoButton setImage:[UIImage imageNamed: @"menu_close_shift_sp"] forState:UIControlStateNormal];
    } else {
        [self.homeButton setImage:[UIImage imageNamed: @"menu_home_en"] forState:UIControlStateNormal];
        [self.reportButton setImage:[UIImage imageNamed: @"menu_reports_en"] forState:UIControlStateNormal];
        [self.configButton setImage:[UIImage imageNamed: @"menu_configuration_en"] forState:UIControlStateNormal];
        [self.usuarioButton setImage:[UIImage imageNamed: @"menu_users_en"] forState:UIControlStateNormal];
        [self.turnoButton setImage:[UIImage imageNamed: @"menu_shift_en"] forState:UIControlStateNormal];
        [self.canceltransactionButton setImage:[UIImage imageNamed: @"menu_canceltransaction_en"] forState:UIControlStateNormal];
        [self.newtransactionButton setImage:[UIImage imageNamed: @"menu_newtransaction_en"] forState:UIControlStateNormal];
        [self.logoutButton setImage:[UIImage imageNamed: @"menu_signout_en"] forState:UIControlStateNormal];
        [self.cerraturnoButton setImage:[UIImage imageNamed: @"menu_close_shift_en"] forState:UIControlStateNormal];
    }
}

-(void)dismissKeyboard
{
    [self.view endEditing:YES];
}

-(void)hideSidePanel:(UIGestureRecognizer *)gesture{
    if (gesture.state == UIGestureRecognizerStateEnded) {
        [TransV setHidden:YES];
        [UIView transitionWithView:SidePanel duration:0.2 options:UIViewAnimationOptionCurveEaseIn animations:^{
            
            CGRect frame = self->SidePanel.frame;
            frame.origin.x = -self->SidePanel.frame.size.width;
            self->SidePanel.frame = frame;
            
        } completion:nil];
    }
}

- (IBAction)menuButtonAction:(id)sender {
    if([TransV isHidden]) {
        [TransV setHidden:NO];
        [UIView transitionWithView:SidePanel duration:0.2 options:UIViewAnimationOptionCurveEaseIn animations:^{
            
            CGRect frame = self->SidePanel.frame;
            frame.origin.x = 0;
            self->SidePanel.frame = frame;
            
        } completion:nil];
    } else {
        [TransV setHidden:YES];
        [UIView transitionWithView:SidePanel duration:0.2 options:UIViewAnimationOptionCurveEaseIn animations:^{
            
            CGRect frame = self->SidePanel.frame;
            frame.origin.x = -self->SidePanel.frame.size.width;
            self->SidePanel.frame = frame;
            
        } completion:nil];
    }
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([segue.identifier isEqualToString:@"conexiontowelcome_segue"]) {
        WelcomeViewController *WelcomeVC;
        WelcomeVC = [segue destinationViewController];
    }
}

- (IBAction)signoutButtonAction:(id)sender {
    [self performSegueWithIdentifier:@"conexiontowelcome_segue" sender:self];
}

- (IBAction)saveButtonAction:(id)sender {
    self.uidText = self.uidTextField.text;
    self.wskText = self.wskTextField.text;
    self.idSecursalText = self.idSecursalTextField.text;
    self.idTerminalText = self.idTerminalTextField.text;
    self.LlaveprivadaText = self.LlaveprivadaTextField.text;
    self.vectorText = self.vectorTextField.text;
    
    Global *globals = [Global sharedInstance];
    
    if(self.uidText.length == 0) {
        if(globals.selected_language == 0) {
            [self displayAlertView:@"¡Advertencia!" :@"Ingresa el  UID asignado a tu terminal. Si tienes dudas, contacta a soporte"];
        } else {
            [self displayAlertView:@"Warning!" :@"Enter the UID assigned to your POS Terminal."];
        }
        return;
    }
    if(self.wskText.length == 0) {
        if(globals.selected_language == 0) {
            [self displayAlertView:@"¡Advertencia!" :@"Ingresa el WSK asignado a tu terminal. Si tienes dudas, contacta a soporte."];
        } else {
            [self displayAlertView:@"Warning!" :@"Enter the WSK assigned to your POS Terminal. "];
        }
        return;
    }
    if(self.idSecursalText.length == 0) {
        if(globals.selected_language == 0) {
            [self displayAlertView:@"¡Advertencia!" :@"Ingresa una ID de Sucursal válida para guardar los ajustes."];
        } else {
            [self displayAlertView:@"Warning!" :@"Please enter a valid Branch ID to save your changes. If you have any doubts, please contact support."];
        }
        return;
    }
    if(self.idTerminalText.length == 0) {
        if(globals.selected_language == 0) {
            [self displayAlertView:@"¡Advertencia!" :@"Ingresa una ID de Terminal válida para guardar los ajustes."];
        } else {
            [self displayAlertView:@"Warning!" :@"Please enter a valid Terminal ID to save your changes. If you have any doubts, please contact support."];
        }
        return;
    }
    if(self.LlaveprivadaText.length == 0) {
        if(globals.selected_language == 0) {
            [self displayAlertView:@"¡Advertencia!" :@"Por favor ingrese una Llave privada válida."];
        } else {
            [self displayAlertView:@"Warning!" :@"Please insert a valid private key."];
        }
        return;
    }
    if(self.vectorText.length == 0) {
        if(globals.selected_language == 0) {
            [self displayAlertView:@"¡Advertencia!" :@"Por favor ingrese un Vector de Inicialización válido."];
        } else {
            [self displayAlertView:@"Warning!" :@"Please insert a valid Initialization Vector."];
        }
        return;
    }
    
    [self.activityIndicator startAnimating];
    [self.view addSubview:self.overlayView];
    
    NSDictionary *comercio = @{
                               @"uid": self.uidText,
                               @"wsk": self.wskText,
                               @"llaveCifrado": self.LlaveprivadaText,
                               @"cifradoIV": self.vectorText,
                               @"idComercio": globals.idComercio
                               };
    NSDictionary *dispositivo = @{
                                  @"branchid": self.idSecursalText,
                                  @"terminalid": self.idTerminalText,
                                  @"userModification": globals.username,
                                  @"idDispositivo": globals.idDispositivo
                                  };
    NSDictionary *param = @{
                            @"comercio": comercio,
                            @"dispositivo": dispositivo,
                            };
    NSError *error;
    NSData *paramData = [NSJSONSerialization dataWithJSONObject:param options:0 error:&error];
    NSString *paramString = [[NSString alloc]initWithData:paramData encoding:NSUTF8StringEncoding];
    
    NSDictionary *parameters = @{
                                 @"method": @"updateSetCommerceConnection",
                                 @"param": paramString,
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
        NSLog(@"%@", jsonResponse);
        BOOL status = [jsonResponse[@"status"] boolValue];
        if(status) {
            /////   modify global variables  ////////
            globals.login_uid = self.uidText;
            globals.login_wsk = self.wskText;
            globals.branchid = self.idSecursalText;
            globals.terminalid = self.idTerminalText;
            globals.llaveCifrado = self.LlaveprivadaText;
            globals.cifradoIV = self.vectorText;
            /////////////////////////////
            if(globals.selected_language == 0) {
                [self displayAlertView:@"¡ÉXITO!" :@"La información fue actualizada con éxito."];
            } else {
                [self displayAlertView:@"Congratulations!" :@"Your information was saved successfully."];
            }
        } else {
            if(globals.selected_language == 0) {
                [self displayAlertView:@"¡Advertencia!" :@"FAILED UPDATE, CONTACT SUPPORT!"];
            } else {
                [self displayAlertView:@"Warning!" :@"ACTUALIZACIÓN FALLIDA, POR FAVOR CONTACTE A SOPORTE!"];
            }
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self.activityIndicator stopAnimating];
        [self.overlayView removeFromSuperview];
        if(globals.selected_language == 0) {
            [self displayAlertView:@"¡Advertencia!" :@"Por favor asegurate que estás conectado a internet."];
        } else {
            [self displayAlertView:@"Warning!" :@"Please check your internet connection to continue."];
        }
    }];
    
}

- (IBAction)cancelChangeButtonAction:(id)sender {
    Global *globals = [Global sharedInstance];
    self.uidTextField.text = globals.login_uid;
    self.uidText = globals.login_uid;
    self.wskTextField.text = globals.login_wsk;
    self.wskText = globals.login_wsk;
    self.idSecursalTextField.text = globals.branchid;
    self.idSecursalText = globals.branchid;
    self.idTerminalTextField.text = globals.terminalid;
    self.idTerminalText = globals.terminalid;
    self.LlaveprivadaTextField.text = globals.llaveCifrado;
    self.LlaveprivadaText = globals.llaveCifrado;
    self.vectorTextField.text = globals.cifradoIV;
    self.vectorText = globals.cifradoIV;
}

- (IBAction)cerraturnoButtonAction:(id)sender {
    Global *globals = [Global sharedInstance];
    
    [self.activityIndicator startAnimating];
    [self.view addSubview:self.overlayView];
    
    NSDictionary *param = @{@"param": @{
                                    @"idUser": globals.idUser,
                                    @"turnoCod": globals.turnoCod,
                                    }};
    
    NSError *error;
    NSData *postData = [NSJSONSerialization dataWithJSONObject:param options:0 error:&error];
    NSString *string = [[NSString alloc]initWithData:postData encoding:NSUTF8StringEncoding];
    
    NSDictionary *parameters = @{
                                 @"method": @"closeShift",
                                 @"param": string,
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
        BOOL status = [jsonResponse[@"status"] boolValue];
        if(status) {
            [self performSegueWithIdentifier:@"conexiontowelcome_segue" sender:self];
        } else {
            if(globals.selected_language == 0) {
                [self displayAlertView:@"¡Advertencia!" :@"Ocurrió un error. Por favor contacte a soporte."];
            } else {
                [self displayAlertView:@"Warning!" :@"An error has occurred. Please contact support."];
            }
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self.activityIndicator stopAnimating];
        [self.overlayView removeFromSuperview];
        if(globals.selected_language == 0) {
            [self displayAlertView:@"¡Advertencia!" :@"Por favor asegurate que estás conectado a internet."];
        } else {
            [self displayAlertView:@"Warning!" :@"Please check your internet connection to continue."];
        }
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
