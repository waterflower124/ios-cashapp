//
//  SecondViewController.m
//  PAGADITO
//
//  Created by Adriana Roldán on 12/13/18.
//  Copyright © 2018 PAGADITO. All rights reserved.
//

#import "SecondViewController.h"
#import "screens/Global.h"

@interface SecondViewController ()
@property(strong, nonatomic)NSString *userFullNameText;
@property(strong, nonatomic)NSString *dateTimeLabelText;
@property(strong, nonatomic)NSString *sessionInfoLabelText;

@end

@implementation SecondViewController
@synthesize SidePanel,MenuBtn,TransV, userFullNameLabel, dateTimeLabel, sessionInfoLabel;
@synthesize DashboardButton1, DashboardButton2, DashboardButton3, DashboardButton4;

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
        
    } else if([globals.idPrivilegio isEqualToString:@"2"]) {
        
    } else if([globals.idPrivilegio isEqualToString:@"3"]) {
        // re-draw dashboardbutton
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
    Global *globals = [Global sharedInstance];
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
    if(sender == DashboardButton1) {
        if([globals.idPrivilegio isEqualToString:@"1"]) {
            
        } else if([globals.idPrivilegio isEqualToString:@"2"]) {
            
        } else if([globals.idPrivilegio isEqualToString:@"4"]) {
            
        }
    }
    if(sender == DashboardButton2) {
        if([globals.idPrivilegio isEqualToString:@"1"]) {
            
        } else if([globals.idPrivilegio isEqualToString:@"2"]) {
            
        } else if([globals.idPrivilegio isEqualToString:@"4"]) {
            
        }
    }
    if(sender == DashboardButton3) {
        if([globals.idPrivilegio isEqualToString:@"1"]) {
            
        } else if([globals.idPrivilegio isEqualToString:@"2"]) {
            
        } else if([globals.idPrivilegio isEqualToString:@"4"]) {
            
        }
    }
    if(sender == DashboardButton4) {
        if([globals.idPrivilegio isEqualToString:@"1"]) {
            
        } else if([globals.idPrivilegio isEqualToString:@"2"]) {
            
        } else if([globals.idPrivilegio isEqualToString:@"4"]) {
            
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
