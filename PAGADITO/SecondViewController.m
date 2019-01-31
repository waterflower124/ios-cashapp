//
//  SecondViewController.m
//  PAGADITO
//
//  Created by Adriana Roldán on 12/13/18.
//  Copyright © 2018 PAGADITO. All rights reserved.
//

#import "SecondViewController.h"
#import "screens/Global.h"
#import "screens/UserAdminViewController.h"
#import "screens/NewTransactionViewController.h"
#import "screens/WelcomeViewController.h"
#import "screens/ShiftListViewController.h"
#import "AFNetworking.h"
#import "screens/SystemConfigurationViewController.h"

@interface SecondViewController ()
@property(strong, nonatomic)NSString *userFullNameText;
@property(strong, nonatomic)NSString *dateTimeLabelText;
@property(strong, nonatomic)NSString *sessionInfoLabelText;

@property(strong, nonatomic)UIView *overlayView;
@property(strong, nonatomic)UIActivityIndicatorView * activityIndicator;

@end

@implementation SecondViewController
@synthesize SidePanel,MenuBtn,TransV, userFullNameLabel, dateTimeLabel, sessionInfoLabel;
@synthesize DashboardButton1, DashboardButton2, DashboardButton3, DashboardButton4;

@synthesize privilidgeID3DashboardView;
@synthesize priv3logoImageView, priv3FullNameLabel, priv3CurrentTimeLabel, priv3ShiftCodeLabel;

@synthesize homeButton, reportButton, configButton, usuarioButton, turnoButton, canceltransactionButton, newtransactionButton, cerraturnoButton;
@synthesize shorcutLabel, sessioncommentLabel, contactsupportButton, signoutButton;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UITapGestureRecognizer *tapper = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideSidePanel:)];
    tapper.numberOfTapsRequired = 1;
    [TransV addGestureRecognizer:tapper];
    
    Global *globals = [Global sharedInstance];
    // user full name label setting
    if(globals.selected_language == 0) {
        self.userFullNameText = [NSString stringWithFormat:@"¡Bienvenido, %@!", globals.nombreCompleto];
        self.shorcutLabel.text = @"Atajos";
        self.sessioncommentLabel.text = @"Sesión iniciada:";
        [self.contactsupportButton setTitle:@"Contactar a soporte" forState:UIControlStateNormal];
        [self.signoutButton setTitle:@"Cerrar Sesión" forState:UIControlStateNormal];
    } else {
        self.userFullNameText = [NSString stringWithFormat:@"Welcome, %@!", globals.nombreCompleto];
         self.shorcutLabel.text = @"Shortcuts";
        self.sessioncommentLabel.text = @"Session started:";
        [self.contactsupportButton setTitle:@"Contact support" forState:UIControlStateNormal];
        [self.signoutButton setTitle:@"Log out" forState:UIControlStateNormal];
    }
    userFullNameLabel.text = self.userFullNameText;
    
    //current date and time setting
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    if(globals.selected_language == 0) {
        NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:@"es_SV"];
        [dateFormatter setLocale:locale];
    } else {
        NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en"];
        [dateFormatter setLocale:locale];
    }
    [dateFormatter setDateFormat:@"dd MMMM yyyy - HH:mm a"];
    self.dateTimeLabelText = [dateFormatter stringFromDate:[NSDate date]];
    dateTimeLabel.text = self.dateTimeLabelText;
    
    //session info label
    self.sessionInfoLabelText = [NSString stringWithFormat:@"%@ / %@", globals.username, globals.nombreComercio];
    sessionInfoLabel.text = self.sessionInfoLabelText;
    
    //////////// init for activity indicator  /////////
    self.overlayView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.overlayView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    self.activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    self.activityIndicator.center = self.overlayView.center;
    [self.overlayView addSubview:self.activityIndicator];
    
    //set dashborad buttons background image according to priviledge ID
    if([globals.idPrivilegio isEqualToString:@"1"]) {
        if(globals.selected_language == 0) {
            [DashboardButton1 setImage:[UIImage imageNamed: @"dashboard_report_sp"] forState:UIControlStateNormal];
            [DashboardButton2 setImage:[UIImage imageNamed: @"dashboard_systemconfig_sp"] forState:UIControlStateNormal];
            [DashboardButton3 setImage:[UIImage imageNamed: @"dashboard_voidtransaction_sp"] forState:UIControlStateNormal];
            [DashboardButton4 setImage:[UIImage imageNamed: @"dashboard_user_sp"] forState:UIControlStateNormal];
        } else {
            [DashboardButton1 setImage:[UIImage imageNamed: @"dashboard_report_en"] forState:UIControlStateNormal];
            [DashboardButton2 setImage:[UIImage imageNamed: @"dashboard_systemconfig_en"] forState:UIControlStateNormal];
            [DashboardButton3 setImage:[UIImage imageNamed: @"dashboard_voidtransaction_en"] forState:UIControlStateNormal];
            [DashboardButton4 setImage:[UIImage imageNamed: @"dashboard_user_en"] forState:UIControlStateNormal];
        }
        
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
        
        [self.turnoButton setHidden:YES];
        [self.canceltransactionButton setHidden:YES];
        [self.newtransactionButton setHidden:YES];
        [self.cerraturnoButton setHidden:YES];
        ////////////////////////////////////////////
    } else if([globals.idPrivilegio isEqualToString:@"2"]) {
        
        if(globals.selected_language == 0) {
            [DashboardButton1 setImage:[UIImage imageNamed: @"dashboard_report_sp"] forState:UIControlStateNormal];
            [DashboardButton2 setImage:[UIImage imageNamed: @"dashboard_assignshift_sp"] forState:UIControlStateNormal];
            [DashboardButton3 setImage:[UIImage imageNamed: @"dashboard_voidtransaction_sp"] forState:UIControlStateNormal];
            [DashboardButton4 setImage:[UIImage imageNamed: @"dashboard_user_sp"] forState:UIControlStateNormal];
        } else {
            [DashboardButton1 setImage:[UIImage imageNamed: @"dashboard_report_en"] forState:UIControlStateNormal];
            [DashboardButton2 setImage:[UIImage imageNamed: @"dashboard_assignshift_sp"] forState:UIControlStateNormal];
            [DashboardButton3 setImage:[UIImage imageNamed: @"dashboard_voidtransaction_en"] forState:UIControlStateNormal];
            [DashboardButton4 setImage:[UIImage imageNamed: @"dashboard_user_en"] forState:UIControlStateNormal];
        }
        
        
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
        
        CGRect usuarioButtonFrame = self.usuarioButton.frame;
        usuarioButtonFrame.origin.x = 0;
        usuarioButtonFrame.origin.y = 120;
        self.usuarioButton.frame = usuarioButtonFrame;
        UIView *usuariolineView = [[UIView alloc] initWithFrame:CGRectMake(0, 59, usuarioButton.frame.size.width, 1)];
        usuariolineView.backgroundColor = [UIColor lightGrayColor];
        [self.usuarioButton addSubview:usuariolineView];
        
        CGRect turnoButtonFrame = self.turnoButton.frame;
        turnoButtonFrame.origin.x = 0;
        turnoButtonFrame.origin.y = 180;
        self.turnoButton.frame = turnoButtonFrame;
        UIView *turnolineView = [[UIView alloc] initWithFrame:CGRectMake(0, 59, turnoButton.frame.size.width, 1)];
        turnolineView.backgroundColor = [UIColor lightGrayColor];
        [self.turnoButton addSubview:turnolineView];
        
        CGRect canceltransactionButtonFrame = self.canceltransactionButton.frame;
        canceltransactionButtonFrame.origin.x = 0;
        canceltransactionButtonFrame.origin.y = 240;
        self.canceltransactionButton.frame = canceltransactionButtonFrame;
        UIView *canceltransactionlineView = [[UIView alloc] initWithFrame:CGRectMake(0, 59, canceltransactionButton.frame.size.width, 1)];
        canceltransactionlineView.backgroundColor = [UIColor lightGrayColor];
        [self.canceltransactionButton addSubview:canceltransactionlineView];
        
        [self.configButton setHidden:YES];
        [self.newtransactionButton setHidden:YES];
        [self.cerraturnoButton setHidden:YES];
        ///////////////////////////////
        
    } else if([globals.idPrivilegio isEqualToString:@"3"]) {
        NSFileManager *fileManager = [NSFileManager defaultManager];
        BOOL isFileExist = [fileManager fileExistsAtPath:globals.logo_imagePath];
        UIImage *logo_image;
        if(isFileExist) {
            logo_image = [[UIImage alloc] initWithContentsOfFile:globals.logo_imagePath];
            priv3logoImageView.image = logo_image;
        } else {
            priv3logoImageView.image = [UIImage imageNamed:@"pagadito_0000_logo.png"];
        }
        priv3FullNameLabel.text = [NSString stringWithFormat:@"Welcome, %@!", globals.nombreCompleto];
        priv3CurrentTimeLabel.text = self.dateTimeLabelText;
        priv3ShiftCodeLabel.text = [NSString stringWithFormat:@"Shift Code: %@", globals.codeShift];
        [privilidgeID3DashboardView setHidden:NO];
        
        ///////  side menu button config   ////////////
        CGRect homeButtonFrame = self.homeButton.frame;
        homeButtonFrame.origin.x = 0;
        homeButtonFrame.origin.y = 0;
        self.homeButton.frame = homeButtonFrame;
        UIView *homelineView = [[UIView alloc] initWithFrame:CGRectMake(0, 59, homeButton.frame.size.width, 1)];
        homelineView.backgroundColor = [UIColor lightGrayColor];
        [self.homeButton addSubview:homelineView];
        
        CGRect cerraturnoButtonFrame = self.cerraturnoButton.frame;
        cerraturnoButtonFrame.origin.x = 0;
        cerraturnoButtonFrame.origin.y = 60;
        self.cerraturnoButton.frame = cerraturnoButtonFrame;
        UIView *cerrarturnolineView = [[UIView alloc] initWithFrame:CGRectMake(0, 59, canceltransactionButton.frame.size.width, 1)];
        cerrarturnolineView.backgroundColor = [UIColor lightGrayColor];
        [self.cerraturnoButton addSubview:cerrarturnolineView];
        
        CGRect canceltransactionButtonFrame = self.canceltransactionButton.frame;
        canceltransactionButtonFrame.origin.x = 0;
        canceltransactionButtonFrame.origin.y = 120;
        self.canceltransactionButton.frame = canceltransactionButtonFrame;
        UIView *canceltransactionlineView = [[UIView alloc] initWithFrame:CGRectMake(0, 59, canceltransactionButton.frame.size.width, 1)];
        canceltransactionlineView.backgroundColor = [UIColor lightGrayColor];
        [self.canceltransactionButton addSubview:canceltransactionlineView];
        
        CGRect newtransactionButtonFrame = self.newtransactionButton.frame;
        newtransactionButtonFrame.origin.x = 0;
        newtransactionButtonFrame.origin.y = 180;
        self.newtransactionButton.frame = newtransactionButtonFrame;
        UIView *newtransactiolineView = [[UIView alloc] initWithFrame:CGRectMake(0, 59, newtransactionButton.frame.size.width, 1)];
        newtransactiolineView.backgroundColor = [UIColor lightGrayColor];
        [self.newtransactionButton addSubview:newtransactiolineView];
        
        [self.reportButton setHidden:YES];
        [self.configButton setHidden:YES];
        [self.usuarioButton setHidden:YES];
        [self.turnoButton setHidden:YES];
        
    } else if([globals.idPrivilegio isEqualToString:@"4"]) {
        
        if(globals.selected_language == 0) {
            [DashboardButton1 setImage:[UIImage imageNamed: @"dashboard_report_sp"] forState:UIControlStateNormal];
            [DashboardButton2 setImage:[UIImage imageNamed: @"dashboard_user_sp"] forState:UIControlStateNormal];
            [DashboardButton3 setImage:[UIImage imageNamed: @"dashboard_voidtransaction_sp"] forState:UIControlStateNormal];
            [DashboardButton4 setImage:[UIImage imageNamed: @"dashboard_newtransaction_sp"] forState:UIControlStateNormal];
        } else {
            [DashboardButton1 setImage:[UIImage imageNamed: @"dashboard_report_en"] forState:UIControlStateNormal];
            [DashboardButton2 setImage:[UIImage imageNamed: @"dashboard_user_en"] forState:UIControlStateNormal];
            [DashboardButton3 setImage:[UIImage imageNamed: @"dashboard_voidtransaction_en"] forState:UIControlStateNormal];
            [DashboardButton4 setImage:[UIImage imageNamed: @"dashboard_newtransaction_en"] forState:UIControlStateNormal];
        }
        
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
        
        [self.cerraturnoButton setHidden:YES];
        ///////////////////////////////
 
    }
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

-(IBAction)buttonPressed:(id)sender{
//    Global *globals = [Global sharedInstance];
    if (sender == MenuBtn) {
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
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)DashboardButton1Action:(id)sender {
    Global *globals = [Global sharedInstance];
    if([globals.idPrivilegio isEqualToString:@"1"]) {
        
    } else if([globals.idPrivilegio isEqualToString:@"2"]) {
        
    } else if([globals.idPrivilegio isEqualToString:@"4"]) {
        
    }
}

- (IBAction)DashboardButton2Action:(id)sender {
    Global *globals = [Global sharedInstance];
    if([globals.idPrivilegio isEqualToString:@"1"]) {
        [self performSegueWithIdentifier:@"hometoconfigure_segue" sender:self];
    } else if([globals.idPrivilegio isEqualToString:@"2"]) {
        [self performSegueWithIdentifier:@"hometoshiftlist_segue" sender:self];
    } else if([globals.idPrivilegio isEqualToString:@"4"]) {
        [self performSegueWithIdentifier:@"hometouseradmin_segue" sender:self];
    }
}

- (IBAction)DashboardButton3Action:(id)sender {
    Global *globals = [Global sharedInstance];
    if([globals.idPrivilegio isEqualToString:@"1"]) {
        
    } else if([globals.idPrivilegio isEqualToString:@"2"]) {
        
    } else if([globals.idPrivilegio isEqualToString:@"4"]) {
        
    }
}

- (IBAction)DashboardButton4Action:(id)sender {
    Global *globals = [Global sharedInstance];
    NSLog(@"ddddd");
    if([globals.idPrivilegio isEqualToString:@"1"]) {
        [self performSegueWithIdentifier:@"hometouseradmin_segue" sender:self];
    } else if([globals.idPrivilegio isEqualToString:@"2"]) {
        [self performSegueWithIdentifier:@"hometouseradmin_segue" sender:self];
    } else if([globals.idPrivilegio isEqualToString:@"4"]) {
        [self performSegueWithIdentifier:@"hometonewtransaction_segue" sender:self];
    }
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([segue.identifier isEqualToString:@"hometouseradmin_segue"]) {
        UserAdminViewController *UserAdimnVC;
        UserAdimnVC = [segue destinationViewController];
    } else if([segue.identifier isEqualToString:@"hometonewtransaction_segue"]) {
        NewTransactionViewController *NewTransactionVC;
        NewTransactionVC = [segue destinationViewController];
    } else if([segue.identifier isEqualToString:@"hometowelcome_segue"]) {
        WelcomeViewController *WelcomeVC;
        WelcomeVC = [segue destinationViewController];
    } else if([segue.identifier isEqualToString:@"hometoshiftlist_segue"]) {
        ShiftListViewController *ShiftListVC;
        ShiftListVC = [segue destinationViewController];
    } else if([segue.identifier isEqualToString:@"hometoconfigure_segue"]) {
        SystemConfigurationViewController *SystemConfigurationVC;
        SystemConfigurationVC = [segue destinationViewController];
    }
}


- (IBAction)signoutButtonAction:(id)sender {
    [self performSegueWithIdentifier:@"hometowelcome_segue" sender:self];
}

- (IBAction)closeShiftButtonAction:(id)sender {
    NSLog(@"33333");
    [self closeShiftCode];
}
- (IBAction)homeButtonAction:(id)sender {
    [TransV setHidden:YES];
    [UIView transitionWithView:SidePanel duration:0.2 options:UIViewAnimationOptionCurveEaseIn animations:^{
        
        CGRect frame = self->SidePanel.frame;
        frame.origin.x = -self->SidePanel.frame.size.width;
        self->SidePanel.frame = frame;
        
    } completion:nil];
}

- (IBAction)turnoButtonAction:(id)sender {
    [self performSegueWithIdentifier:@"hometoshiftlist_segue" sender:self];
}

- (IBAction)cerraturnoButtonAction:(id)sender {
    [self closeShiftCode];
}

- (IBAction)configButtonAction:(id)sender {
    [self performSegueWithIdentifier:@"hometoconfigure_segue" sender:self];
}

-(void)closeShiftCode {
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
            [self performSegueWithIdentifier:@"hometowelcome_segue" sender:self];
        } else {
            [self displayAlertView:@"Notice!" :@"An error has occurred. Please contact support" :@"fail"];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self.activityIndicator stopAnimating];
        [self.overlayView removeFromSuperview];
        [self displayAlertView:@"Warning!" :@"Network error." :@"network error"];
    }];
}

-(void)displayAlertView: (NSString *)header :(NSString *)message :(NSString *)status{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:header message:message preferredStyle:UIAlertControllerStyleAlert];
    
    UIApplication *actionOK = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//        if([status isEqualToString:@"closeShift"]) {
//
//        } else {
//
//        }
    }];
    [alert addAction:actionOK];
    [self presentViewController:alert animated:YES completion:nil];
}
@end
