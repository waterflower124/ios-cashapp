//
//  ShiftListViewController.h
//  PAGADITO
//
//  Created by Water Flower on 2019/1/16.
//  Copyright © 2019 PAGADITO. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ShiftListViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITableView *shiftlistTableView;
@property (weak, nonatomic) IBOutlet UILabel *sessionInfoLabel;


- (IBAction)backButtonAction:(id)sender;
///////  declare for main menu buttons   ////////
@property (weak, nonatomic) IBOutlet UIButton *mainmenuAssignShiftButton;
@property (weak, nonatomic) IBOutlet UIButton *mainmenuCloseShiftButton;
@property (weak, nonatomic) IBOutlet UIButton *mainmenuSearchButton;
- (IBAction)mainmenuCloseShiftButtonAction:(id)sender;
- (IBAction)mainmenuAssignShiftButtonAction:(id)sender;
- (IBAction)mainmenuSearchButtonAction:(id)sender;
///////////////////////////////////////////////////

@property (weak, nonatomic) IBOutlet UIView *TransV;
- (IBAction)menuButtonAction:(id)sender;
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
