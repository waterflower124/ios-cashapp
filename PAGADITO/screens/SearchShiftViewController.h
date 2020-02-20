//
//  SearchShiftViewController.h
//  PAGADITO
//
//  Created by Javier Calderon  on 2019/1/18.
//  Copyright © 2019 PAGADITO. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SearchShiftViewController : UIViewController

@property(strong, nonatomic)NSMutableArray *shift_array;

@property (weak, nonatomic) IBOutlet UITableView *shiftlistTableView;

- (IBAction)backButtonAction:(id)sender;
- (IBAction)menuButtonAction:(id)sender;
- (IBAction)mainmenuAssignShiftButtonAction:(id)sender;
- (IBAction)mainmenuCloseShiftButtonAction:(id)sender;

@property (weak, nonatomic) IBOutlet UITextField *searchwordTextView;

@property (weak, nonatomic) IBOutlet UIView *TransV;
@property (weak, nonatomic) IBOutlet UILabel *sessionInfoLabel;


/////////  side menu buttons   ////////////
@property (weak, nonatomic) IBOutlet UIView *SidePanel;
@property (weak, nonatomic) IBOutlet UIButton *homeButton;
@property (weak, nonatomic) IBOutlet UIButton *reportButton;
@property (weak, nonatomic) IBOutlet UIButton *configButton;
@property (weak, nonatomic) IBOutlet UIButton *usuarioButton;
@property (weak, nonatomic) IBOutlet UIButton *turnoButton;
@property (weak, nonatomic) IBOutlet UIButton *canceltransactionButton;
@property (weak, nonatomic) IBOutlet UIButton *newtransactionButton;
@property (weak, nonatomic) IBOutlet UIButton *logoutButton;
@property (weak, nonatomic) IBOutlet UIButton *cerraturnoButton;

- (IBAction)homeButtonAction:(id)sender;
- (IBAction)usuarionButtonAction:(id)sender;
- (IBAction)turnoButtonAction:(id)sender;
- (IBAction)signoutButtonAction:(id)sender;
- (IBAction)cerraturnoButtonAction:(id)sender;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *searchshiftButtonLabel;
@property (weak, nonatomic) IBOutlet UILabel *assignshiftButtonLabel;
@property (weak, nonatomic) IBOutlet UILabel *closeshiftButtonLabel;
@property (weak, nonatomic) IBOutlet UILabel *codeheadLabel;
@property (weak, nonatomic) IBOutlet UILabel *timedateheadLabel;
@property (weak, nonatomic) IBOutlet UILabel *usernameheadLabel;
@property (weak, nonatomic) IBOutlet UILabel *sessioncommentLabel;



@end

NS_ASSUME_NONNULL_END
