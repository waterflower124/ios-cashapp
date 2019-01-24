//
//  TransactionsTableViewCell.h
//  PAGADITO
//
//  Created by Water Flower on 2019/1/24.
//  Copyright © 2019 PAGADITO. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface TransactionsTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *transaction_amountLabel;
@property (weak, nonatomic) IBOutlet UILabel *transaction_ernLabel;
@property (weak, nonatomic) IBOutlet UILabel *transaction_datetimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *transaction_referenceLabel;
@property (weak, nonatomic) IBOutlet UILabel *transaction_statusLabel;


@end

NS_ASSUME_NONNULL_END
