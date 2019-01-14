//
//  NewTransactionViewController.h
//  PAGADITO
//
//  Created by Water Flower on 2019/1/14.
//  Copyright © 2019 PAGADITO. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface NewTransactionViewController : UIViewController{
    
    IBOutlet UIView *TransV;
    IBOutlet UIView *SidePanel;
    IBOutlet UIButton *MenuBtn;
    
}

@property(nonatomic)IBOutlet UIButton *MenuBtn;
@property(nonatomic)IBOutlet UIView *SidePanel;
@property(nonatomic)IBOutlet UIView *TransV;

@end

NS_ASSUME_NONNULL_END
