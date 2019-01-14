//
//  UserAdminViewController.h
//  PAGADITO
//
//  Created by Water Flower on 2019/1/12.
//  Copyright © 2019 PAGADITO. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UserAdminViewController : UIViewController{
    
    IBOutlet UIView *TransV;
    IBOutlet UIView *SidePanel;
    IBOutlet UIButton *MenuBtn;
    
}

@property(nonatomic)IBOutlet UIButton *MenuBtn;
@property(nonatomic)IBOutlet UIView *SidePanel;
@property(nonatomic)IBOutlet UIView *TransV;

@property (weak, nonatomic) IBOutlet UILabel *sessionInfoLabel;
@property (weak, nonatomic) IBOutlet UITableView *usersTableView;

@property (weak, nonatomic) IBOutlet UIButton *createuserbutton;
@property (weak, nonatomic) IBOutlet UIButton *deleteuserButton;
@property (weak, nonatomic) IBOutlet UIButton *edituserButton;
@property (weak, nonatomic) IBOutlet UIButton *searchuserButton;

- (IBAction)createuserButtonAction:(id)sender;
- (IBAction)deleteuserButtonAction:(id)sender;
- (IBAction)edituserButtonAction:(id)sender;
- (IBAction)searchuserButtonAction:(id)sender;

@end

NS_ASSUME_NONNULL_END
