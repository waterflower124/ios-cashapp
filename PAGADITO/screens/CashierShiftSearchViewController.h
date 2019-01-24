//
//  CashierShiftSearchViewController.h
//  PAGADITO
//
//  Created by Water Flower on 2019/1/23.
//  Copyright © 2019 PAGADITO. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CashierShiftSearchViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIView *TransV;
@property (weak, nonatomic) IBOutlet UIView *SidePanel;
@property (weak, nonatomic) IBOutlet UILabel *sessionInfoLabel;
@property (weak, nonatomic) IBOutlet UITableView *cashierTableView;
@property (weak, nonatomic) IBOutlet UIButton *selectcashierButton;
@property (weak, nonatomic) IBOutlet UITextField *codigoTextView;
@property (weak, nonatomic) IBOutlet UIDatePicker *startDatePicker;
@property (weak, nonatomic) IBOutlet UIDatePicker *closeDatePicker;

- (IBAction)menuButtonAction:(id)sender;
- (IBAction)selectcashierButtonAction:(id)sender;

@property (weak, nonatomic) IBOutlet UIButton *homeButton;
@property (weak, nonatomic) IBOutlet UIButton *reportButton;
@property (weak, nonatomic) IBOutlet UIButton *configButton;
@property (weak, nonatomic) IBOutlet UIButton *usuarioButton;
@property (weak, nonatomic) IBOutlet UIButton *turnoButton;
@property (weak, nonatomic) IBOutlet UIButton *canceltransactionButton;
@property (weak, nonatomic) IBOutlet UIButton *newtransactionButton;

- (IBAction)signoutButtonAction:(id)sender;


- (IBAction)searchButtonAction:(id)sender;

@end

NS_ASSUME_NONNULL_END
