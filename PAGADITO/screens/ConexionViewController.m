//
//  ConexionViewController.m
//  PAGADITO
//
//  Created by Water Flower on 2019/1/22.
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
@synthesize homeButton, reportButton, configButton, usuarioButton, turnoButton, canceltransactionButton, newtransactionButton;
@synthesize SidePanel, TransV, sessionInfoLabel, uidTextField, wskTextField, idSecursalTextField, idTerminalTextField, LlaveprivadaTextField, vectorTextField;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    Global *globals = [Global sharedInstance];
    
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
        
        CGRect canceltransactionButtonFrame = self.canceltransactionButton.frame;
        canceltransactionButtonFrame.origin.x = 0;
        canceltransactionButtonFrame.origin.y = 300;
        self.canceltransactionButton.frame = canceltransactionButtonFrame;
        UIView *canceltransactionlineView = [[UIView alloc] initWithFrame:CGRectMake(0, 59, canceltransactionButton.frame.size.width, 1)];
        canceltransactionlineView.backgroundColor = [UIColor lightGrayColor];
        [self.canceltransactionButton addSubview:canceltransactionlineView];
        
        CGRect newtransactionButtonFrame = self.newtransactionButton.frame;
        newtransactionButtonFrame.origin.x = 0;
        newtransactionButtonFrame.origin.y = 360;
        self.newtransactionButton.frame = newtransactionButtonFrame;
        UIView *newtransactiolineView = [[UIView alloc] initWithFrame:CGRectMake(0, 59, newtransactionButton.frame.size.width, 1)];
        newtransactiolineView.backgroundColor = [UIColor lightGrayColor];
        [self.newtransactionButton addSubview:newtransactiolineView];
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
    
    if(self.uidText.length == 0) {
        [self displayAlertView:@"Warning!" :@"Please input uid."];
        return;
    }
    if(self.wskText.length == 0) {
        [self displayAlertView:@"Warning!" :@"Please input wsk."];
        return;
    }
    if(self.idSecursalText.length == 0) {
        [self displayAlertView:@"Warning!" :@"Please input uid."];
        return;
    }
    if(self.idTerminalText.length == 0) {
        [self displayAlertView:@"Warning!" :@"Please input uid."];
        return;
    }
    if(self.LlaveprivadaText.length == 0) {
        [self displayAlertView:@"Warning!" :@"Please input uid."];
        return;
    }
    if(self.vectorText.length == 0) {
        [self displayAlertView:@"Warning!" :@"Please input uid."];
        return;
    }
    
    [self.activityIndicator startAnimating];
    [self.view addSubview:self.overlayView];
    
    Global *globals = [Global sharedInstance];
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
                                 @"method": @"updateSetCommerceInformation",
                                 @"param": paramString
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
            /////   modify global variables  ////////
            globals.login_uid = self.uidText;
            globals.login_wsk = self.wskText;
            globals.branchid = self.idSecursalText;
            globals.terminalid = self.idTerminalText;
            globals.llaveCifrado = self.LlaveprivadaText;
            globals.cifradoIV = self.vectorText;
            /////////////////////////////
            [self displayAlertView:@"Congratulations!" :@"UPDATE SUCCESSFUL!"];
        } else {
            [self displayAlertView:@"Warning!" :@"FAILED UPDATE, CONTACT SUPPORT!"];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self.activityIndicator stopAnimating];
        [self.overlayView removeFromSuperview];
        [self displayAlertView:@"Warning!" :@"Network error!"];
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

-(void)displayAlertView: (NSString *)header :(NSString *)message {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:header message:message preferredStyle:UIAlertControllerStyleAlert];
    
    UIApplication *actionOK = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"");
    }];
    [alert addAction:actionOK];
    [self presentViewController:alert animated:YES completion:nil];
}

@end
