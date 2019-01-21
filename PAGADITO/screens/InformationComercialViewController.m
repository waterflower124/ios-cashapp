//
//  InformationComercialViewController.m
//  PAGADITO
//
//  Created by Water Flower on 2019/1/21.
//  Copyright © 2019 PAGADITO. All rights reserved.
//

#import "InformationComercialViewController.h"
#import "AFNetworking.h"
#import "Global.h"
#import "SystemConfigurationViewController.h"
#import "../SecondViewController.h"
#import "WelcomeViewController.h"
#import "UserAdminViewController.h"

@interface InformationComercialViewController ()<UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property(strong, nonatomic)NSString *sessionInfoLabelText;
@property(strong, nonatomic)NSMutableArray *currencyNameArray;
@property(strong, nonatomic)NSMutableArray *currencyUnitArray;

@end

@implementation InformationComercialViewController
@synthesize logoImageView, TransV, SidePanel, sessionInfoLabel;
@synthesize homeButton, reportButton, configButton, usuarioButton, turnoButton, canceltransactionButton, newtransactionButton;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    /////  initialization ////
    self.currencyNameArray = [[NSMutableArray alloc] initWithObjects:@"($) Dólares Americanos", @"(Q) Quetzales", @"(L) Lempiras", @"(C$) Córdobas", @"(₡) Colones Costarricenses", @"(B/.) Balboas", @"(RD$) Pesos Dominicanos", nil];
    self.currencyUnitArray = [[NSMutableArray alloc] initWithObjects:@"USD", @"GTQ", @"HNL", @"NIO", @"CRC", @"PAB", @"DOP", nil];
    
    ///////////// logo image load   ///////////
    Global *globals = [Global sharedInstance];
    if(globals.logo_imagePath.length != 0 ) {
        NSFileManager *fileManager = [NSFileManager defaultManager];
        BOOL isFileExist = [fileManager fileExistsAtPath:globals.logo_imagePath];
        UIImage *logo_image;
        if(isFileExist) {
            logo_image = [[UIImage alloc] initWithContentsOfFile:globals.logo_imagePath];
            logoImageView.image = logo_image;
        }
    }
    
    /////  dismiss keyboard  ///////////
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer:tap];
    tap.cancelsTouchesInView = NO;
    
    /////////   logo image view tap event ////////
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(logoImageViewTapDetected)];
    singleTap.numberOfTapsRequired = 1;
    [logoImageView setUserInteractionEnabled:YES];
    [logoImageView addGestureRecognizer:singleTap];
    
    ////////////////  TransV tapp event     ///////////////
    UITapGestureRecognizer *tapper = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideSidePanel:)];
    tapper.numberOfTapsRequired = 1;
    [TransV addGestureRecognizer:tapper];
    
    //session info label
    self.sessionInfoLabelText = [NSString stringWithFormat:@"%@ / %@", globals.username, globals.nombreComercio];
    sessionInfoLabel.text = self.sessionInfoLabelText;
    
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
        
        CGRect canceltransactionButtonFrame = self.canceltransactionButton.frame;
        canceltransactionButtonFrame.origin.x = 0;
        canceltransactionButtonFrame.origin.y = 300;
        self.canceltransactionButton.frame = canceltransactionButtonFrame;
        UIView *canceltransactionlineView = [[UIView alloc] initWithFrame:CGRectMake(0, 59, canceltransactionButton.frame.size.width, 1)];
        canceltransactionlineView.backgroundColor = [UIColor lightGrayColor];
        [self.canceltransactionButton addSubview:canceltransactionlineView];
        
        CGRect newtransactionButtonFrame = self.newtransactionButton.frame;
        newtransactionButtonFrame.origin.x = 0;
        newtransactionButtonFrame.origin.y = 360;
        self.newtransactionButton.frame = newtransactionButtonFrame;
        UIView *newtransactiolineView = [[UIView alloc] initWithFrame:CGRectMake(0, 59, newtransactionButton.frame.size.width, 1)];
        newtransactiolineView.backgroundColor = [UIColor lightGrayColor];
        [self.newtransactionButton addSubview:newtransactiolineView];
    }
}

-(void)dismissKeyboard
{
    [self.view endEditing:YES];
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
    } else {
        [self displayAlertView:@"Warning!" :@"Logo Image have to be less than 2MB. Please select another image"];
    }
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

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([segue.identifier isEqualToString:@"informationcomercialtowelcome_segue"]) {
        WelcomeViewController *WelcomeVC;
        WelcomeVC = [segue destinationViewController];
    } else if([segue.identifier isEqualToString:@"informationcomercialtohome_segue"]) {
        SecondViewController *SecondVC;
        SecondVC = [segue destinationViewController];
    } else if([segue.identifier isEqualToString:@"informationcomercialtosystemconfig_segue"]) {
        SystemConfigurationViewController *SystemConfigureVC;
        SystemConfigureVC = [segue destinationViewController];
    } else if([segue.identifier isEqualToString:@"informationcomercialtouseradmin_segue"]) {
        UserAdminViewController *UserAdminVC;
        UserAdminVC = [segue destinationViewController];
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

- (IBAction)backButtonAction:(id)sender {
    [self performSegueWithIdentifier:@"informationcomercialtosystemconfig_segue" sender:self];
}

- (IBAction)homeButtonAction:(id)sender {
    [self performSegueWithIdentifier:@"informationcomercialtohome_segue" sender:self];
}

- (IBAction)configButtonAction:(id)sender {
    [self performSegueWithIdentifier:@"informationcomercialtosystemconfig_segue" sender:self];
}

- (IBAction)usuarioButtonAction:(id)sender {
    [self performSegueWithIdentifier:@"informationcomercialtouseradmin_segue" sender:self];
}

- (IBAction)signoutButtonAction:(id)sender {
    [self performSegueWithIdentifier:@"informationcomercialtowelcome_segue" sender:self];
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
