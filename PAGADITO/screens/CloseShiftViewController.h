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


- (IBAction)backButtonAction:(id)sender;
- (IBAction)mainmenuSearchShiftButtonAction:(id)sender;
- (IBAction)mainmenuAssignShiftButtonAction:(id)sender;

@property (weak, nonatomic) IBOutlet UIView *closeshiftAlertView;
@property (weak, nonatomic) IBOutlet UILabel *alertMessageLabel;
- (IBAction)cancelCloseShiftButtonAction:(id)sender;
- (IBAction)okCloseShiftButtonAction:(id)sender;


@end

NS_ASSUME_NONNULL_END
