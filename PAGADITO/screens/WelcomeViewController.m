//
//  WelcomeViewController.m
//  PAGADITO
//
//  Created by Water Flower on 2019/1/8.
//  Copyright © 2019 PAGADITO. All rights reserved.
//

#import "WelcomeViewController.h"
#import "Global.h"

@interface WelcomeViewController ()

@end

@implementation WelcomeViewController

@synthesize logoImageView;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    Global *globals = [Global sharedInstance];
    if(globals.logo_imagePath.length == 0 ) {
        logoImageView.image = [UIImage imageNamed:@"pagadito_0000_logo.png"];
    } else {
        NSFileManager *fileManager = [NSFileManager defaultManager];
        BOOL isFileExist = [fileManager fileExistsAtPath:globals.logo_imagePath];
        UIImage *logo_image;
        if(isFileExist) {
            logo_image = [[UIImage alloc] initWithContentsOfFile:globals.logo_imagePath];
            logoImageView.image = logo_image;
        } else {
            logoImageView.image = [UIImage imageNamed:@"pagadito_0000_logo.png"];
        }
//        logoImageView.image = globals.logo_image;
    }
    
}



@end
