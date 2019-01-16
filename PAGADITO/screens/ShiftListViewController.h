//
//  ShiftListViewController.h
//  PAGADITO
//
//  Created by Water Flower on 2019/1/16.
//  Copyright © 2019 PAGADITO. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ShiftListViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITableView *shiftlistTableView;
@property (weak, nonatomic) IBOutlet UILabel *sessionInfoLabel;


@end

NS_ASSUME_NONNULL_END
