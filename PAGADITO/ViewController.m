//
//  ViewController.m
//  PAGADITO
//
//  Created by Adriana Roldán on 12/7/18.
//  Copyright © 2018 PAGADITO. All rights reserved.
//

#import "ViewController.h"
#import "screens/Global.h"

@interface ViewController ()
{
NSArray *language;
}
@end

Global *globals;

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    globals = [Global sharedInstance];
    /////   initalization for global variables
    globals.selected_language = 0;
    globals.uid = @"";
    globals.wsk = @"";
    globals.private_key = @"";
    globals.initialization_vector = @"";
    globals.office_id = @"";
    globals.terminal_id = @"";
    globals.logo_image = nil;
    globals.logo_imagePath = @"";
    
    language = @[@"Español",@"English"];
    self.pickerView_language.dataSource = self;
    self.pickerView_language.delegate = self;
    
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return language.count;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    return language[row];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    self.pv_txt.text = language[row];
    
    globals.selected_language = row;
}

@end
