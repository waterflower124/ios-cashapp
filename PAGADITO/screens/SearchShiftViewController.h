//
//  SearchShiftViewController.h
//  PAGADITO
//
//  Created by Water Flower on 2019/1/18.
//  Copyright © 2019 PAGADITO. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SearchShiftViewController : UIViewController

@property(strong, nonatomic)NSMutableArray *shift_array;

@property (weak, nonatomic) IBOutlet UITableView *shiftlistTableView;

- (IBAction)backButtonAction:(id)sender;
- (IBAction)mainmenuAssignShiftButtonAction:(id)sender;
- (IBAction)mainmenuCloseShiftButtonAction:(id)sender;

@property (weak, nonatomic) IBOutlet UITextField *searchwordTextView;


@end

NS_ASSUME_NONNULL_END
