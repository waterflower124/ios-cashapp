//
//  FileViewViewController.h
//  PAGADITO
//
//  Created by Javier Calderon  on 2019/3/22.
//  Copyright © 2019 PAGADITO. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface FileViewViewController : UIViewController

@property(strong, nonatomic) NSString *file_url;
@property(strong, nonatomic) NSString *file_local;
@property(strong, nonatomic) NSData *fileData;

@property (weak, nonatomic) IBOutlet UIWebView *webView;

- (IBAction)backButtonAction:(id)sender;
- (IBAction)shareButtonAction:(id)sender;

@property(strong, nonatomic)NSString *sourceVC;
@property(strong, nonatomic)NSString *shift_code;
@property(strong, nonatomic)NSString *start_datetime;
@property(strong, nonatomic)NSString *finish_datetime;
@property(strong, nonatomic)NSString *userCajero;
@property(strong, nonatomic)NSString *selectedTurnoCode;


@end

NS_ASSUME_NONNULL_END
