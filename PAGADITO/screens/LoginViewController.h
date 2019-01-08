//
//  LoginViewController.h
//  PAGADITO
//
//  Created by Water Flower on 2019/1/5.
//  Copyright © 2019 PAGADITO. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface LoginViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITextField *emailTextFiled;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;

- (IBAction)LoginButtonAction:(id)sender;


@end

NS_ASSUME_NONNULL_END
