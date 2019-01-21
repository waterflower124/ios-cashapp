//
//  InformationComercialViewController.h
//  PAGADITO
//
//  Created by Water Flower on 2019/1/21.
//  Copyright © 2019 PAGADITO. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface InformationComercialViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIImageView *logoImageView;
@property (weak, nonatomic) IBOutlet UIView *TransV;
@property (weak, nonatomic) IBOutlet UILabel *sessionInfoLabel;

- (IBAction)backButtonAction:(id)sender;
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
- (IBAction)configButtonAction:(id)sender;
- (IBAction)usuarioButtonAction:(id)sender;
- (IBAction)signoutButtonAction:(id)sender;

@end

NS_ASSUME_NONNULL_END
