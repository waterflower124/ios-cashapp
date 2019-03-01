//
//  VoucherConfigViewController.m
//  PAGADITO
//
//  Created by Water Flower on 2019/1/23.
//  Copyright © 2019 PAGADITO. All rights reserved.
//

#import "VoucherConfigViewController.h"
#import "Global.h"
#import "AFNetworking.h"
#import "WelcomeViewController.h"

@interface VoucherConfigViewController ()<UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property(strong, nonatomic)NSString *sessionInfoLabelText;
@property(strong, nonatomic)NSString *mensajeVoucherText;

@property(strong, nonatomic)UIView *overlayView;
@property(strong, nonatomic)UIActivityIndicatorView * activityIndicator;

@end

@implementation VoucherConfigViewController
@synthesize TransV, SidePanel, sessionInfoLabel, logoImageView, mensajeVoucherTextField;
@synthesize homeButton, reportButton, configButton, usuarioButton, turnoButton, canceltransactionButton, newtransactionButton, cerraturnoButton, logoutButton;
@synthesize titleLabel, customemessagecommentLabel, saveButton, charcountcommentLabel, sessioncommentLabel;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    Global *globals = [Global sharedInstance];
    if(globals.selected_language == 0) {
        self.titleLabel.text = @"Configurar Voucher";
        self.customemessagecommentLabel.text = @"Mensaje Personalizado";
        self.charcountcommentLabel.text = @"(150 carácteres)";
        [self.saveButton setTitle:@"Guardar" forState:UIControlStateNormal];
        sessioncommentLabel.text = @"Sesión iniciada:";
    } else {
        self.titleLabel.text = @"Voucher Configuration";
        self.customemessagecommentLabel.text = @"Personalize Message";
        self.charcountcommentLabel.text = @"(150 characters)";
        [self.saveButton setTitle:@"Save" forState:UIControlStateNormal];
        sessioncommentLabel.text = @"Session started:";
    }
    
    [self setMenuButtonsicon];
    
    ////////// initialization  ///////////
    if(globals.mensajeVoucher == (NSString *)[NSNull null]) {
        self.mensajeVoucherTextField.text = @"";
        self.mensajeVoucherText = @"";
        if(globals.selected_language == 0) {
            self.mensajeVoucherTextField.placeholder = @"Inserte un mensaje personalizado";
        } else {
            self.mensajeVoucherTextField.placeholder = @"Insert a personalized message";
        }
    } else {
        self.mensajeVoucherTextField.text = globals.mensajeVoucher;
        self.mensajeVoucherText = globals.mensajeVoucher;
    }
    
    /////  dismiss keyboard  ///////////
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer:tap];
    tap.cancelsTouchesInView = NO;
    
    ////////////////  TransV tapp event     ///////////////
    UITapGestureRecognizer *tapper = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideSidePanel:)];
    tapper.numberOfTapsRequired = 1;
    [TransV addGestureRecognizer:tapper];
    
    /////////   logo image view tap event ////////
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(logoImageViewTapDetected)];
    singleTap.numberOfTapsRequired = 1;
    [logoImageView setUserInteractionEnabled:YES];
    [logoImageView addGestureRecognizer:singleTap];
    
    ///////////// logo image load   ///////////
//    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
//                                                         NSUserDomainMask, YES);
//    NSString *documentsDirectory = [paths objectAtIndex:0];
//    NSString *imagePath = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.png", @"pagadito/pagadito_logo"]];
//    BOOL fileExists=[[NSFileManager defaultManager] fileExistsAtPath:imagePath];
//
//    if(fileExists) {
//        UIImage *fetchImage = [UIImage imageWithContentsOfFile:imagePath];
//        logoImageView.image = fetchImage;
//    }else {
//        NSLog(@"121212121:  %@",imagePath);
//    }
    
    if(globals.logo_imagePath.length != 0 ) {
        NSFileManager *fileManager = [NSFileManager defaultManager];
        BOOL isFileExist = [fileManager fileExistsAtPath:globals.logo_imagePath];
        UIImage *logo_image;
        if(isFileExist) {
            logo_image = [[UIImage alloc] initWithContentsOfFile:globals.logo_imagePath];
            logoImageView.image = logo_image;
        }
    }
    
    //session info label
    self.sessionInfoLabelText = [NSString stringWithFormat:@"%@ / %@", globals.username, globals.nombreComercio];
    sessionInfoLabel.text = self.sessionInfoLabelText;
    
    /////  init for activity indicator
    self.overlayView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.overlayView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    self.activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    self.activityIndicator.center = self.overlayView.center;
    [self.overlayView addSubview:self.activityIndicator];
    
    //set dashborad buttons background image according to priviledge ID
    if([globals.idPrivilegio isEqualToString:@"1"]) {
        CGRect homeButtonFrame = self.homeButton.frame;
        homeButtonFrame.origin.x = 0;
        homeButtonFrame.origin.y = 0;
        self.homeButton.frame = homeButtonFrame;
        UIView *homelineView = [[UIView alloc] initWithFrame:CGRectMake(0, 59, homeButton.frame.size.width, 1)];
        homelineView.backgroundColor = [UIColor lightGrayColor];
        [self.homeButton addSubview:homelineView];
        
        CGRect reportButtonFrame = self.reportButton.frame;
        reportButtonFrame.origin.x = 0;
        reportButtonFrame.origin.y = 60;
        self.reportButton.frame = reportButtonFrame;
        UIView *reportlineView = [[UIView alloc] initWithFrame:CGRectMake(0, 59, reportButton.frame.size.width, 1)];
        reportlineView.backgroundColor = [UIColor lightGrayColor];
        [self.reportButton addSubview:reportlineView];
        
        CGRect configureButtonFrame = self.configButton.frame;
        configureButtonFrame.origin.x = 0;
        configureButtonFrame.origin.y = 120;
        self.configButton.frame = configureButtonFrame;
        UIView *configurelineView = [[UIView alloc] initWithFrame:CGRectMake(0, 59, configButton.frame.size.width, 1)];
        configurelineView.backgroundColor = [UIColor lightGrayColor];
        [self.configButton addSubview:configurelineView];
        
        CGRect usuarioButtonFrame = self.usuarioButton.frame;
        usuarioButtonFrame.origin.x = 0;
        usuarioButtonFrame.origin.y = 180;
        self.usuarioButton.frame = usuarioButtonFrame;
        UIView *usuariolineView = [[UIView alloc] initWithFrame:CGRectMake(0, 59, usuarioButton.frame.size.width, 1)];
        usuariolineView.backgroundColor = [UIColor lightGrayColor];
        [self.usuarioButton addSubview:usuariolineView];
        
        [self.turnoButton setHidden:YES];
        [self.canceltransactionButton setHidden:YES];
        [self.newtransactionButton setHidden:YES];
        [self.cerraturnoButton setHidden:YES];
        ////////////////////////////////////////////
    } else if([globals.idPrivilegio isEqualToString:@"4"]) {
        
        ///////  side menu button config   ////////////
        CGRect homeButtonFrame = self.homeButton.frame;
        homeButtonFrame.origin.x = 0;
        homeButtonFrame.origin.y = 0;
        self.homeButton.frame = homeButtonFrame;
        UIView *homelineView = [[UIView alloc] initWithFrame:CGRectMake(0, 59, homeButton.frame.size.width, 1)];
        homelineView.backgroundColor = [UIColor lightGrayColor];
        [self.homeButton addSubview:homelineView];
        
        CGRect reportButtonFrame = self.reportButton.frame;
        reportButtonFrame.origin.x = 0;
        reportButtonFrame.origin.y = 60;
        self.reportButton.frame = reportButtonFrame;
        UIView *reportlineView = [[UIView alloc] initWithFrame:CGRectMake(0, 59, reportButton.frame.size.width, 1)];
        reportlineView.backgroundColor = [UIColor lightGrayColor];
        [self.reportButton addSubview:reportlineView];
        
        CGRect configureButtonFrame = self.configButton.frame;
        configureButtonFrame.origin.x = 0;
        configureButtonFrame.origin.y = 120;
        self.configButton.frame = configureButtonFrame;
        UIView *configurelineView = [[UIView alloc] initWithFrame:CGRectMake(0, 59, configButton.frame.size.width, 1)];
        configurelineView.backgroundColor = [UIColor lightGrayColor];
        [self.configButton addSubview:configurelineView];
        
        CGRect usuarioButtonFrame = self.usuarioButton.frame;
        usuarioButtonFrame.origin.x = 0;
        usuarioButtonFrame.origin.y = 180;
        self.usuarioButton.frame = usuarioButtonFrame;
        UIView *usuariolineView = [[UIView alloc] initWithFrame:CGRectMake(0, 59, usuarioButton.frame.size.width, 1)];
        usuariolineView.backgroundColor = [UIColor lightGrayColor];
        [self.usuarioButton addSubview:usuariolineView];
        
        CGRect turnoButtonFrame = self.turnoButton.frame;
        turnoButtonFrame.origin.x = 0;
        turnoButtonFrame.origin.y = 240;
        self.turnoButton.frame = turnoButtonFrame;
        UIView *turnolineView = [[UIView alloc] initWithFrame:CGRectMake(0, 59, turnoButton.frame.size.width, 1)];
        turnolineView.backgroundColor = [UIColor lightGrayColor];
        [self.turnoButton addSubview:turnolineView];
        
        CGRect newtransactionButtonFrame = self.newtransactionButton.frame;
        newtransactionButtonFrame.origin.x = 0;
        newtransactionButtonFrame.origin.y = 300;
        self.newtransactionButton.frame = newtransactionButtonFrame;
        UIView *newtransactiolineView = [[UIView alloc] initWithFrame:CGRectMake(0, 59, newtransactionButton.frame.size.width, 1)];
        newtransactiolineView.backgroundColor = [UIColor lightGrayColor];
        
        CGRect canceltransactionButtonFrame = self.canceltransactionButton.frame;
        canceltransactionButtonFrame.origin.x = 0;
        canceltransactionButtonFrame.origin.y = 360;
        self.canceltransactionButton.frame = canceltransactionButtonFrame;
        UIView *canceltransactionlineView = [[UIView alloc] initWithFrame:CGRectMake(0, 59, canceltransactionButton.frame.size.width, 1)];
        canceltransactionlineView.backgroundColor = [UIColor lightGrayColor];
        [self.canceltransactionButton addSubview:canceltransactionlineView];
        
        CGRect cerraturnoButtonFrame = self.cerraturnoButton.frame;
        cerraturnoButtonFrame.origin.x = 0;
        cerraturnoButtonFrame.origin.y = 420;
        self.cerraturnoButton.frame = cerraturnoButtonFrame;
        UIView *cerraturnolineView = [[UIView alloc] initWithFrame:CGRectMake(0, 59, cerraturnoButton.frame.size.width, 1)];
        cerraturnolineView.backgroundColor = [UIColor lightGrayColor];
        [self.cerraturnoButton addSubview:cerraturnolineView];
        
        [self.newtransactionButton addSubview:newtransactiolineView];
    }
}

-(void)setMenuButtonsicon {
    Global *globals = [Global sharedInstance];
    if(globals.selected_language == 0) {
        [self.homeButton setImage:[UIImage imageNamed: @"menu_home_sp"] forState:UIControlStateNormal];
        [self.reportButton setImage:[UIImage imageNamed: @"menu_reports_sp"] forState:UIControlStateNormal];
        [self.configButton setImage:[UIImage imageNamed: @"menu_configuration_sp"] forState:UIControlStateNormal];
        [self.usuarioButton setImage:[UIImage imageNamed: @"menu_users_sp"] forState:UIControlStateNormal];
        [self.turnoButton setImage:[UIImage imageNamed: @"menu_shift_sp"] forState:UIControlStateNormal];
        [self.canceltransactionButton setImage:[UIImage imageNamed: @"menu_canceltransaction_sp"] forState:UIControlStateNormal];
        [self.newtransactionButton setImage:[UIImage imageNamed: @"menu_newtransaction_sp"] forState:UIControlStateNormal];
        [self.logoutButton setImage:[UIImage imageNamed: @"menu_signout_sp"] forState:UIControlStateNormal];
        [self.cerraturnoButton setImage:[UIImage imageNamed: @"menu_close_shift_sp"] forState:UIControlStateNormal];
    } else {
        [self.homeButton setImage:[UIImage imageNamed: @"menu_home_en"] forState:UIControlStateNormal];
        [self.reportButton setImage:[UIImage imageNamed: @"menu_reports_en"] forState:UIControlStateNormal];
        [self.configButton setImage:[UIImage imageNamed: @"menu_configuration_en"] forState:UIControlStateNormal];
        [self.usuarioButton setImage:[UIImage imageNamed: @"menu_users_en"] forState:UIControlStateNormal];
        [self.turnoButton setImage:[UIImage imageNamed: @"menu_shift_en"] forState:UIControlStateNormal];
        [self.canceltransactionButton setImage:[UIImage imageNamed: @"menu_canceltransaction_en"] forState:UIControlStateNormal];
        [self.newtransactionButton setImage:[UIImage imageNamed: @"menu_newtransaction_en"] forState:UIControlStateNormal];
        [self.logoutButton setImage:[UIImage imageNamed: @"menu_signout_en"] forState:UIControlStateNormal];
        [self.cerraturnoButton setImage:[UIImage imageNamed: @"menu_close_shift_en"] forState:UIControlStateNormal];
    }
}

-(void)dismissKeyboard
{
    [self.view endEditing:YES];
}

-(void)hideSidePanel:(UIGestureRecognizer *)gesture{
    if (gesture.state == UIGestureRecognizerStateEnded) {
        [TransV setHidden:YES];
        [UIView transitionWithView:SidePanel duration:0.2 options:UIViewAnimationOptionCurveEaseIn animations:^{
            
            CGRect frame = self->SidePanel.frame;
            frame.origin.x = -self->SidePanel.frame.size.width;
            self->SidePanel.frame = frame;
            
        } completion:nil];
    }
}

-(void)logoImageViewTapDetected {
    
    UIAlertController *logoImageAlertView = [UIAlertController alertControllerWithTitle:@"Choose Image" message:@"Pick Image from:" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction* gallery = [UIAlertAction
                              actionWithTitle:@"Gallery"
                              style:UIAlertActionStyleDefault
                              handler:^(UIAlertAction * action)
                              {
                                  UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
                                  imagePicker.delegate = self;
                                  imagePicker.allowsEditing = YES;
                                  imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                                  [self presentViewController:imagePicker animated:YES completion:nil];
                              }];
    
    UIAlertAction* camera = [UIAlertAction
                             actionWithTitle:@"Camera"
                             style:UIAlertActionStyleDefault
                             handler:^(UIAlertAction * action)
                             {
                                 UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
                                 imagePicker.delegate = self;
                                 imagePicker.allowsEditing = YES;
                                 imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
                                 [self presentViewController:imagePicker animated:YES completion:nil];
                             }];
    
    UIAlertAction* cancel = [UIAlertAction
                             actionWithTitle:@"Cancel"
                             style:UIAlertActionStyleDefault
                             handler:^(UIAlertAction * action)
                             {
                                 NSLog(@"Cancel     ");
                             }];
    
    [logoImageAlertView addAction:gallery] ;
    [logoImageAlertView addAction:camera];
    [logoImageAlertView addAction:cancel];
    [self presentViewController:logoImageAlertView animated:YES completion:nil];
    
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<UIImagePickerControllerInfoKey,id> *)info {
    
    Global *globals = [Global sharedInstance];
    
    UIImage *selectedImage = info[UIImagePickerControllerEditedImage];
    self.logoImageView.image = selectedImage;
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    
    NSString *stringPath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)objectAtIndex:0]stringByAppendingPathComponent:@"pagadito"];
    // New Folder is your folder name
    NSError *error = nil;
    if (![[NSFileManager defaultManager] fileExistsAtPath:stringPath])
        [[NSFileManager defaultManager] createDirectoryAtPath:stringPath withIntermediateDirectories:NO attributes:nil error:&error];
    
    NSString *fileName = [stringPath stringByAppendingFormat:@"/pagadito_logo.png"];
    NSData *imageData = UIImagePNGRepresentation(selectedImage);
    //    NSLog(@"Image size:: %lu::", (unsigned long)[imageData length]);
    if([imageData length] < 2 * 1024 * 1024) {
        [imageData writeToFile:fileName atomically:YES];
        Global *globals = [Global sharedInstance];
        globals.logo_imagePath = fileName;
        NSLog(@"qwqwqwqw:  %@", globals.logo_imagePath);
    } else {
        if(globals.selected_language == 0) {
            [self displayAlertView:@"¡Advertencia!" :@"El tamaño de la imagen de logo debe ser menor a 2MB. Por favor seleccione otra imagen."];
        } else {
            [self displayAlertView:@"Warning!" :@"Logo Image have to be less than 2MB. Please select another image."];
        }
    }
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([segue.identifier isEqualToString:@"voucherconfigtowelcome_segue"]) {
        WelcomeViewController *WelcomeVC;
        WelcomeVC = [segue destinationViewController];
    }
}

- (IBAction)menuButtonAction:(id)sender {
    if([TransV isHidden]) {
        [TransV setHidden:NO];
        [UIView transitionWithView:SidePanel duration:0.2 options:UIViewAnimationOptionCurveEaseIn animations:^{
            
            CGRect frame = self->SidePanel.frame;
            frame.origin.x = 0;
            self->SidePanel.frame = frame;
            
        } completion:nil];
    } else {
        [TransV setHidden:YES];
        [UIView transitionWithView:SidePanel duration:0.2 options:UIViewAnimationOptionCurveEaseIn animations:^{
            
            CGRect frame = self->SidePanel.frame;
            frame.origin.x = -self->SidePanel.frame.size.width;
            self->SidePanel.frame = frame;
            
        } completion:nil];
    }
}

- (IBAction)signoutButtonAction:(id)sender {
    [self performSegueWithIdentifier:@"voucherconfigtowelcome_segue" sender:self];
}

- (IBAction)saveButtonAction:(id)sender {
    self.mensajeVoucherText = self.mensajeVoucherTextField.text;
    
    Global *globals = [Global sharedInstance];
    
    if(self.mensajeVoucherText.length == 0) {
        if(globals.selected_language == 0) {
            [self displayAlertView:@"¡Advertencia!" :@"Por favor ingrese un mensaje."];
        } else {
            [self displayAlertView:@"Warning!" :@"Please input message."];
        }
        return;
    }
    if(self.mensajeVoucherText.length > 150) {
        if(globals.selected_language == 0) {
            [self displayAlertView:@"¡Advertencia!" :@"El mensaje debe ser inferior a 150 caracteres."];
        } else {
            [self displayAlertView:@"Warning!" :@"Message have to be less than 150 characters."];
        }
    }
    
    [self.activityIndicator startAnimating];
    [self.view addSubview:self.overlayView];
    
    NSDictionary *mensajeVoucher = @{
                                  @"mensajeVoucher": self.mensajeVoucherText,
                                  @"userModification": globals.username,
                                  @"idDispositivo": globals.idDispositivo
                                  };

    NSError *error;
    NSData *paramData = [NSJSONSerialization dataWithJSONObject:mensajeVoucher options:0 error:&error];
    NSString *paramString = [[NSString alloc]initWithData:paramData encoding:NSUTF8StringEncoding];
    
    NSDictionary *parameters = @{
                                 @"method": @"updateSetVoucherMessage",
                                 @"param": paramString
                                 };
    AFHTTPSessionManager *sessionManager = [AFHTTPSessionManager manager];
    sessionManager.requestSerializer = [AFHTTPRequestSerializer serializer];
    sessionManager.responseSerializer = [AFHTTPResponseSerializer serializer];
    sessionManager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects: @"application/json", nil];
    [sessionManager POST: globals.server_url parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        [self.activityIndicator stopAnimating];
        [self.overlayView removeFromSuperview];
        
        NSError *jsonError;
        NSDictionary *jsonResponse = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:&jsonError];
        BOOL status = [jsonResponse[@"status"] boolValue];
        if(status) {
            globals.mensajeVoucher = self.mensajeVoucherText;
            if(globals.selected_language == 0) {
                [self displayAlertView:@"¡Éxito!" :@"¡ACTUALIZACIÓN EXITOSA!"];
            } else {
                [self displayAlertView:@"Success!" :@"UPDATE SUCCESSFUL!"];
            }
        } else {
            if(globals.selected_language == 0) {
                [self displayAlertView:@"¡Advertencia!" :@"No se pudo guardar. Por favor contacte  a soporte"];
            } else {
                [self displayAlertView:@"Warning!" :@"FAILED UPDATE. PLEASE CONTACT SUPPORT!"];
            }
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self.activityIndicator stopAnimating];
        [self.overlayView removeFromSuperview];
        if(globals.selected_language == 0) {
            [self displayAlertView:@"¡Advertencia!" :@"Error de red."];
        } else {
            [self displayAlertView:@"Warning!" :@"Network error."];
        }
    }];
}

- (IBAction)cerraturnoButtonAction:(id)sender {
    Global *globals = [Global sharedInstance];
    
    [self.activityIndicator startAnimating];
    [self.view addSubview:self.overlayView];
    
    NSDictionary *param = @{@"param": @{
                                    @"idUser": globals.idUser,
                                    @"turnoCod": globals.turnoCod,
                                    }};
    
    NSError *error;
    NSData *postData = [NSJSONSerialization dataWithJSONObject:param options:0 error:&error];
    NSString *string = [[NSString alloc]initWithData:postData encoding:NSUTF8StringEncoding];
    
    NSDictionary *parameters = @{
                                 @"method": @"closeShift",
                                 @"param": string
                                 };
    AFHTTPSessionManager *sessionManager = [AFHTTPSessionManager manager];
    sessionManager.requestSerializer = [AFHTTPRequestSerializer serializer];
    sessionManager.responseSerializer = [AFHTTPResponseSerializer serializer];
    sessionManager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects: @"application/json", nil];
    [sessionManager POST: globals.server_url parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        [self.activityIndicator stopAnimating];
        [self.overlayView removeFromSuperview];
        
        NSError *jsonError;
        NSDictionary *jsonResponse = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:&jsonError];
        BOOL status = [jsonResponse[@"status"] boolValue];
        if(status) {
            [self performSegueWithIdentifier:@"voucherconfigtowelcome_segue" sender:self];
        } else {
            if(globals.selected_language == 0) {
                [self displayAlertView:@"¡Advertencia!" :@"Ocurrió un error. Por favor contacte a soporte."];
            } else {
                [self displayAlertView:@"Warning!" :@"An error has occurred. Please contact support."];
            }
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self.activityIndicator stopAnimating];
        [self.overlayView removeFromSuperview];
        if(globals.selected_language == 0) {
            [self displayAlertView:@"¡Advertencia!" :@"Error de red."];
        } else {
            [self displayAlertView:@"Warning!" :@"Network error."];
        }
    }];
}


-(void)displayAlertView: (NSString *)header :(NSString *)message {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:header message:message preferredStyle:UIAlertControllerStyleAlert];
    
    UIApplication *actionOK = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"");
    }];
    [alert addAction:actionOK];
    [self presentViewController:alert animated:YES completion:nil];
}

@end
