//
//  WelcomeViewController.h
//  PAGADITO
//
//  Created by Water Flower on 2019/1/8.
//  Copyright © 2019 PAGADITO. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface WelcomeViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIImageView *logoImageView;
@property (weak, nonatomic) IBOutlet UITextField *usernameTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;


- (IBAction)SigninButtonAction:(id)sender;

@end

NS_ASSUME_NONNULL_END
