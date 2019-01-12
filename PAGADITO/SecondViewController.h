//
//  SecondViewController.h
//  PAGADITO
//
//  Created by Adriana Roldán on 12/13/18.
//  Copyright © 2018 PAGADITO. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SecondViewController : UIViewController{
    
    IBOutlet UIView *TransV;
    IBOutlet UIView *SidePanel;
    IBOutlet UIButton *MenuBtn;
    
}

@property(nonatomic)IBOutlet UIButton *MenuBtn;
@property(nonatomic)IBOutlet UIView *SidePanel;
@property(nonatomic)IBOutlet UIView *TransV;
@property (weak, nonatomic) IBOutlet UILabel *userFullNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *sessionInfoLabel;

@property (weak, nonatomic) IBOutlet UIButton *DashboardButton1;
@property (weak, nonatomic) IBOutlet UIButton *DashboardButton2;
@property (weak, nonatomic) IBOutlet UIButton *DashboardButton3;
@property (weak, nonatomic) IBOutlet UIButton *DashboardButton4;

@end
