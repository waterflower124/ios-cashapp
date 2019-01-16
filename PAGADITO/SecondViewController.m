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

@interface SecondViewController ()
@property(strong, nonatomic)NSString *userFullNameText;
@property(strong, nonatomic)NSString *dateTimeLabelText;
@property(strong, nonatomic)NSString *sessionInfoLabelText;

@end

@implementation SecondViewController
@synthesize SidePanel,MenuBtn,TransV, userFullNameLabel, dateTimeLabel, sessionInfoLabel;
@synthesize DashboardButton1, DashboardButton2, DashboardButton3, DashboardButton4;

@synthesize privilidgeID3DashboardView;
@synthesize priv3logoImageView, priv3FullNameLabel, priv3CurrentTimeLabel, priv3ShiftCodeLabel;

@synthesize homeButton, reportButton, configButton, usuarioButton, turnoButton, canceltransactionButton, newtransactionButton;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UITapGestureRecognizer *tapper = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideSidePanel:)];
    tapper.numberOfTapsRequired = 1;
    [TransV addGestureRecognizer:tapper];
    
    Global *globals = [Global sharedInstance];
    // user full name label setting
    self.userFullNameText = [NSString stringWithFormat:@"¡Bienvenido, %@!", globals.nombreCompleto];
    userFullNameLabel.text = self.userFullNameText;
    
    //current date and time setting
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd MMMM yyyy - HH:mm a"];
    self.dateTimeLabelText = [dateFormatter stringFromDate:[NSDate date]];
    dateTimeLabel.text = self.dateTimeLabelText;
    
    //session info label
    self.sessionInfoLabelText = [NSString stringWithFormat:@"%@ / %@", globals.username, globals.nombreComercio];
    sessionInfoLabel.text = self.sessionInfoLabelText;
    
    //set dashborad buttons background image according to priviledge ID
    
    if([globals.idPrivilegio isEqualToString:@"1"]) {
        [DashboardButton2 setImage:[UIImage imageNamed: @"system_config"] forState:UIControlStateNormal];
        [DashboardButton4 setImage:[UIImage imageNamed: @"Pagadito_0000_Capa-4"] forState:UIControlStateNormal];
        
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
        
        ////////////////////////////////////////////
    } else if([globals.idPrivilegio isEqualToString:@"2"]) {
        [DashboardButton2 setImage:[UIImage imageNamed: @"assign_shift"] forState:UIControlStateNormal];
        [DashboardButton4 setImage:[UIImage imageNamed: @"Pagadito_0000_Capa-4"] forState:UIControlStateNormal];
        
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
        UIView *tcanceltransactionlineView = [[UIView alloc] initWithFrame:CGRectMake(0, 59, canceltransactionButton.frame.size.width, 1)];
        turnolineView.backgroundColor = [UIColor lightGrayColor];
        [self.canceltransactionButton addSubview:tcanceltransactionlineView];
        
        [self.configButton setHidden:YES];
        [self.newtransactionButton setHidden:YES];
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
        UIView *tcanceltransactionlineView = [[UIView alloc] initWithFrame:CGRectMake(0, 59, canceltransactionButton.frame.size.width, 1)];
        turnolineView.backgroundColor = [UIColor lightGrayColor];
        [self.canceltransactionButton addSubview:tcanceltransactionlineView];
        
        CGRect newtransactionButtonFrame = self.newtransactionButton.frame;
        newtransactionButtonFrame.origin.x = 0;
        newtransactionButtonFrame.origin.y = 300;
        self.newtransactionButton.frame = newtransactionButtonFrame;
        UIView *newtransactiolineView = [[UIView alloc] initWithFrame:CGRectMake(0, 59, newtransactionButton.frame.size.width, 1)];
        turnolineView.backgroundColor = [UIColor lightGrayColor];
        [self.newtransactionButton addSubview:newtransactiolineView];
        
        [self.usuarioButton setHidden:YES];
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
        
    } else if([globals.idPrivilegio isEqualToString:@"2"]) {
        
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
    }
}


- (IBAction)signoutButtonAction:(id)sender {
    [self performSegueWithIdentifier:@"hometowelcome_segue" sender:self];
}
@end
