//
//  SearchUserViewController.h
//  PAGADITO
//
//  Created by Water Flower on 2019/1/14.
//  Copyright © 2019 PAGADITO. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SearchUserViewController : UIViewController{
    
    IBOutlet UIView *TransV;
    IBOutlet UIView *SidePanel;
    IBOutlet UIButton *MenuBtn;
    
}

@property(nonatomic)IBOutlet UIButton *MenuBtn;
@property(nonatomic)IBOutlet UIView *SidePanel;
@property(nonatomic)IBOutlet UIView *TransV;

@property(strong, nonatomic)NSMutableArray *user_array;

- (IBAction)createUserButtonAction:(id)sender;
- (IBAction)deleteUserButtonAction:(id)sender;
- (IBAction)editUserButtonAction:(id)sender;

@property (weak, nonatomic) IBOutlet UITableView *usersTableView;
@property (weak, nonatomic) IBOutlet UITextField *searchWordTextView;

@end

NS_ASSUME_NONNULL_END
