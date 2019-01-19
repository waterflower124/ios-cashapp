//
//  CloseShiftViewController.h
//  PAGADITO
//
//  Created by Water Flower on 2019/1/18.
//  Copyright © 2019 PAGADITO. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CloseShiftViewController : UIViewController

@property(strong, nonatomic)NSMutableArray *shift_array;

@property (weak, nonatomic) IBOutlet UIView *TransV;
@property (weak, nonatomic) IBOutlet UITableView *shiftlistTableView;
@property (weak, nonatomic) IBOutlet UIView *SidePanel;


- (IBAction)backButtonAction:(id)sender;
- (IBAction)menuButtonAction:(id)sender;
- (IBAction)mainmenuSearchShiftButtonAcUsution:(id)sender;
- (IBAction)mainmenuAssignShiftButtonAction:(id)sender;

@property (weak, nonatomic) IBOutlet UIView *closeshiftAlertView;
@property (weak, nonatomic) IBOutlet UILabel *alertMessageLabel;
- (IBAction)cancelCloseShiftButtonAction:(id)sender;
- (IBAction)okCloseShiftButtonAction:(id)sender;

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
