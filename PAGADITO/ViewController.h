//
//  ViewController.h
//  PAGADITO
//
//  Created by Adriana Roldán on 12/7/18.
//  Copyright © 2018 PAGADITO. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController <UIPickerViewDataSource, UIPickerViewDelegate>

@property (weak, nonatomic) IBOutlet UIPickerView *pickerView_language;
@property (weak, nonatomic) IBOutlet UILabel *pv_txt;

@end

