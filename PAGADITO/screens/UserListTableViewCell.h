//
//  UserListTableViewCell.h
//  PAGADITO
//
//  Created by Water Flower on 2019/1/13.
//  Copyright © 2019 PAGADITO. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UserListTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *userFullNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *roleImageView;

@end

NS_ASSUME_NONNULL_END
