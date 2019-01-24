//
//  AssignShiftViewController.h
//  PAGADITO
//
//  Created by Water Flower on 2019/1/18.
//  Copyright © 2019 PAGADITO. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface AssignShiftViewController : UIViewController

@property(strong, nonatomic)NSMutableArray *shift_array;

@property (weak, nonatomic) IBOutlet UIView *TransV;
@property (weak, nonatomic) IBOutlet UITableView *shiftlistTableView;
@property (weak, nonatomic) IBOutlet UILabel *sessionInfoLabel;

- (IBAction)backButtonAction:(id)sender;
- (IBAction)menuButtonAction:(id)sender;
- (IBAction)mainmenuSearchShiftButtonAction:(id)sender;
- (IBAction)mainmenuAssignShiftButtonAction:(id)sender;
- (IBAction)mainmenuCloseShiftButtonAction:(id)sender;


/////  insert  shift alert view  /////////
@property (weak, nonatomic) IBOutlet UIView *assignturnoAlertView;
@property (weak, nonatomic) IBOutlet UIButton *selectcashierButton;
@property (weak, nonatomic) IBOutlet UISwitch *switchButton;
@property (weak, nonatomic) IBOutlet UITableView *cashierlistTableView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cashierlistTableViewHeightConstraint;

- (IBAction)selectcashierButtonAction:(id)sender;
- (IBAction)switchButtonAction:(id)sender;
- (IBAction)assignturnoCancelButtonAction:(id)sender;
- (IBAction)assignturnoOKButtonAction:(id)sender;


///////// complete insert alert view  ///////
@property (weak, nonatomic) IBOutlet UIView *completeInsertShiftAlertView;
- (IBAction)completeAlertViewContinueButtonAction:(id)sender;

////  side menu buttons  /////////
@property (weak, nonatomic) IBOutlet UIView *SidePanel;
@property (weak, nonatomic) IBOutlet UIButton *homeButton;
@property (weak, nonatomic) IBOutlet UIButton *reportButton;
@property (weak, nonatomic) IBOutlet UIButton *configButton;
@property (weak, nonatomic) IBOutlet UIButton *usuarioButton;
@property (weak, nonatomic) IBOutlet UIButton *turnoButton;
@property (weak, nonatomic) IBOutlet UIButton *canceltransactionButton;
@property (weak, nonatomic) IBOutlet UIButton *newtransactionButton;

- (IBAction)homeButtonAction:(id)sender;
- (IBAction)usuarioButtonAction:(id)sender;
- (IBAction)turnoButtonAction:(id)sender;
- (IBAction)signoutButtonAction:(id)sender;


@end

NS_ASSUME_NONNULL_END
