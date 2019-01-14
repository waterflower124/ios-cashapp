//
//  DeleteUserViewController.h
//  PAGADITO
//
//  Created by Water Flower on 2019/1/13.
//  Copyright © 2019 PAGADITO. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface DeleteUserViewController : UIViewController{
    
    IBOutlet UIView *TransV;
    IBOutlet UIView *SidePanel;
    IBOutlet UIButton *MenuBtn;
    
}

@property(nonatomic)IBOutlet UIButton *MenuBtn;
@property(nonatomic)IBOutlet UIView *SidePanel;
@property(nonatomic)IBOutlet UIView *TransV;
@property (weak, nonatomic) IBOutlet UITableView *usersTableView;


@property(strong, nonatomic)NSMutableArray *user_array;

- (IBAction)createUserButtonAction:(id)sender;
- (IBAction)editUserButtonAction:(id)sender;
- (IBAction)searchUserButtonAction:(id)sender;

@end

NS_ASSUME_NONNULL_END
