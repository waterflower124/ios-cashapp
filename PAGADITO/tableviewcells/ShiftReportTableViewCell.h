//
//  ShiftReportTableViewCell.h
//  PAGADITO
//
//  Created by Water Flower on 2019/1/23.
//  Copyright © 2019 PAGADITO. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ShiftReportTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *codeShiftLabel;
@property (weak, nonatomic) IBOutlet UILabel *fechaInicioLabel;
@property (weak, nonatomic) IBOutlet UILabel *fechaFinLabel;
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;

@property (weak, nonatomic) IBOutlet UIButton *turnoCodButton;
@end

NS_ASSUME_NONNULL_END
