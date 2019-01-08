//
//  LastCommercialInfoViewController.h
//  PAGADITO
//
//  Created by Water Flower on 2019/1/7.
//  Copyright © 2019 PAGADITO. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface LastCommercialInfoViewController : UIViewController

@property(strong, nonatomic)NSDictionary *infoUsuario;

@property (weak, nonatomic) IBOutlet UIImageView *logoImageView;

@property (weak, nonatomic) IBOutlet UITextField *commercialNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *terminalNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *commercialNumberTextField;
@property (weak, nonatomic) IBOutlet UITextField *commercialEmailTextField;

@property (weak, nonatomic) IBOutlet UITableView *currencyTableView;
@property (weak, nonatomic) IBOutlet UIButton *selectCurrencyButton;

- (IBAction)selectCurrencyButtonAction:(id)sender;
- (IBAction)continueButtonAction:(id)sender;


@end

NS_ASSUME_NONNULL_END
