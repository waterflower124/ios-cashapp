//
//  ProcessTransactionViewController.m
//  PAGADITO
//
//  Created by Javier Calderon  on 2019/2/4.
//  Copyright © 2019 PAGADITO. All rights reserved.
//

#import "ProcessTransactionViewController.h"
#import "Global.h"
#import "WelcomeViewController.h"
#import "AFNetworking.h"
#import "TransactionResultViewController.h"
#import "BBDeviceController.h"
#import "BBDeviceOTAController.h"

#define kTimeout_ScanBT 60

@interface ProcessTransactionViewController ()<UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource>

@property(strong, nonatomic) NSMutableArray *month_array;
@property(strong, nonatomic) NSMutableArray *year_array;
@property(strong, nonatomic) NSString *selected_month;
@property(strong, nonatomic) NSString *selected_year;
@property(strong, nonatomic) NSString *checkTax;
@property(strong, nonatomic) NSString *cardNumber;
@property(strong, nonatomic) NSString *cardHolderName;
@property(strong, nonatomic) NSString *CVV;
@property(strong, nonatomic) NSString *descriptiontxt;
@property(strong, nonatomic) NSString *expire_date;

@property(strong, nonatomic) NSDictionary *dataTransaction;

@property(strong, nonatomic)UIView *overlayView;
@property(strong, nonatomic)UIActivityIndicatorView * activityIndicator;

@property (nonatomic, retain) NSMutableDictionary *BTDeviceDictionary;

@end

@implementation ProcessTransactionViewController
@synthesize textScrollView, TransV, SidePanel;
@synthesize homeButton, reportButton, configButton, usuarioButton, turnoButton, canceltransactionButton, newtransactionButton, logoutButton, cerraturnoButton;
@synthesize transactionAmount, sessionInfoLabel;
@synthesize transactionAmountLabel, crediccardImageView, cardNumberTextField, cardNameTextField, CVVTextField, monthTableVIew, yearTableView, monthselectButton, yearselectButton, taxSwitchButton;
@synthesize titleLabel, amountLabel, maincommentLabel, cardnumberLabel, cardholdernameLabel, expiredateLabel, descriptionLabel, checkBoxLabel, processtransactionButton, contactsupportButton, sessioncommentLabel;
@synthesize BTDeviceListView, BTDeviceTable, devicecommentLabel;
@synthesize cardReadButton;


//Variables globales para lector
NSString *numberCard = @"";
NSString *exp_card = @"";
NSString *pan = @"";
NSInteger typeTransaction = 0;
NSString *swipe_ksn = @"";
NSString *swipe_encTrack1 = @"";
NSString *tlv_C0 = @"";
NSString *tlv_C2 = @"";
NSString *type_trans = @"";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    isAutoConnectLastBTDevice = NO;
    typeTransaction = 0;
    self.BTDeviceDictionary = [[NSMutableDictionary alloc] init];
    
    [[BBDeviceController sharedController] setDebugLogEnabled:YES];
    [[BBDeviceController sharedController] setDetectAudioDevicePlugged:YES];
    [[BBDeviceController sharedController] setDelegate:self];
    
    [[BBDeviceController sharedController] startBTScan:nil scanTimeout:kTimeout_ScanBT];
    
    Global *globals = [Global sharedInstance];
    if(globals.selected_language == 0) {
        self.titleLabel.text = @"Procesar transacción";
        self.amountLabel.text = @"Monto a cobrar:";
        self.maincommentLabel.text = @"Desliza la tarjeta y completa los campos requeridos.";
        self.cardnumberLabel.text = @"Número de tarjeta";
        self.cardholdernameLabel.text = @"Nombre de la tarjeta";
        self.cardNameTextField.placeholder = @"Nombre en la tarjeta";
        self.expiredateLabel.text = @"Fecha de Expiración";
        self.descriptionLabel.text = @"Descripción (opcional)";
//        self.descriptionTextField.placeholder = @"Usuario";
        self.checkBoxLabel.text = @"Los impuestos están incluidos.";
        [self.processtransactionButton setTitle:@"Procesar transacción" forState:UIControlStateNormal];
        [self.contactsupportButton setTitle:@"Contactar a Soporte" forState:UIControlStateNormal];
        self.sessioncommentLabel.text = @"Sesión iniciada:";
        self.devicecommentLabel.text = @"Encontrar dispositivos";
        [self.monthselectButton setTitle:@"Mes" forState:UIControlStateNormal];
        [self.yearselectButton setTitle:@"Año" forState:UIControlStateNormal];
//        [self.cardReadButton setTitle:@"Iniciar Lector" forState:UIControlStateNormal];
    } else {
        self.titleLabel.text = @"Process Transaction";
        self.amountLabel.text = @"Amount to charge:";
        self.maincommentLabel.text = @"Slide card and input all required fields.";
        self.cardnumberLabel.text = @"Card number";
        self.cardholdernameLabel.text = @"Cardholder name";
        self.cardNameTextField.placeholder = @"Cardholder Name";
        self.expiredateLabel.text = @"Expiration date";
        self.descriptionLabel.text = @"Description (optional)";
//        self.descriptionTextField.placeholder = @"User";
        self.checkBoxLabel.text = @"Taxes are included.";
        [self.processtransactionButton setTitle:@"Process transaction" forState:UIControlStateNormal];
        [self.contactsupportButton setTitle:@"Contact support" forState:UIControlStateNormal];
        self.sessioncommentLabel.text = @"Session statred:";
        self.devicecommentLabel.text = @"Find Devices";
        [self.monthselectButton setTitle:@"Month" forState:UIControlStateNormal];
        [self.yearselectButton setTitle:@"Year" forState:UIControlStateNormal];
//        [self.cardReadButton setTitle:@"Start Reader" forState:UIControlStateNormal];
        
    }
    
    [self setMenuButtonsicon];

    self.month_array = [[NSMutableArray alloc] initWithObjects:@"01", @"02", @"03", @"04", @"05", @"06", @"07", @"08", @"09", @"10", @"11", @"12", nil];
    self.year_array = [[NSMutableArray alloc] initWithObjects:@"19", @"20", @"21", @"22", @"23", @"24", @"25", @"26", @"27", @"28", @"29", @"30", nil];
    self.selected_month = @"";
    self.selected_year = @"";
    self.checkTax = @"1";
    
    //session info label
    NSString *sessionInfoLabelText = [NSString stringWithFormat:@"%@ / %@", globals.username, globals.nombreComercio];
    self.sessionInfoLabel.text = sessionInfoLabelText;
    
    //////. activity indicator  ///////
    self.overlayView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.overlayView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    self.activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    self.activityIndicator.center = self.overlayView.center;
    [self.overlayView addSubview:self.activityIndicator];
    
    ///  keyboard avoid
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:self.view.window];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:self.view.window];
    
    ///////  dismiss keyboard  //////
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer:tap];
    tap.cancelsTouchesInView = NO;
    
    /////   TransV tap event  /////////
    UITapGestureRecognizer *tapper = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideSidePanel:)];
    tapper.numberOfTapsRequired = 1;
    [TransV addGestureRecognizer:tapper];
    
    //////  init amount Label  //////
    NSDecimalNumber *amountDecimal = [NSDecimalNumber decimalNumberWithString:self.transactionAmount];
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    numberFormatter.locale = [NSLocale currentLocale];// this ensures the right separator behavior
    numberFormatter.numberStyle = NSNumberFormatterDecimalStyle;
    numberFormatter.usesGroupingSeparator = YES;
    [numberFormatter setGroupingSize:3];
    [numberFormatter setMaximumFractionDigits:2];
    [numberFormatter setMinimumFractionDigits:2];
    /////////
    
    NSString * formattedString = [NSString stringWithFormat:@"%@", [numberFormatter stringForObjectValue:amountDecimal]];
    self.transactionAmountLabel.text = [NSString stringWithFormat:@"%@%@", globals.currency ,formattedString];
    
    //set dashborad buttons background image according to priviledge ID
    if([globals.idPrivilegio isEqualToString:@"1"]) {
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
        
        [self.turnoButton setHidden:YES];
        [self.canceltransactionButton setHidden:YES];
        [self.newtransactionButton setHidden:YES];
        [self.cerraturnoButton setHidden:YES];
        ////////////////////////////////////////////
    } else if([globals.idPrivilegio isEqualToString:@"2"]) {
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
        
        CGRect usuarioButtonFrame = self.usuarioButton.frame;
        usuarioButtonFrame.origin.x = 0;
        usuarioButtonFrame.origin.y = 120;
        self.usuarioButton.frame = usuarioButtonFrame;
        UIView *usuariolineView = [[UIView alloc] initWithFrame:CGRectMake(0, 59, usuarioButton.frame.size.width, 1)];
        usuariolineView.backgroundColor = [UIColor lightGrayColor];
        [self.usuarioButton addSubview:usuariolineView];
        
        CGRect turnoButtonFrame = self.turnoButton.frame;
        turnoButtonFrame.origin.x = 0;
        turnoButtonFrame.origin.y = 180;
        self.turnoButton.frame = turnoButtonFrame;
        UIView *turnolineView = [[UIView alloc] initWithFrame:CGRectMake(0, 59, turnoButton.frame.size.width, 1)];
        turnolineView.backgroundColor = [UIColor lightGrayColor];
        [self.turnoButton addSubview:turnolineView];
        
        CGRect canceltransactionButtonFrame = self.canceltransactionButton.frame;
        canceltransactionButtonFrame.origin.x = 0;
        canceltransactionButtonFrame.origin.y = 240;
        self.canceltransactionButton.frame = canceltransactionButtonFrame;
        UIView *canceltransactionlineView = [[UIView alloc] initWithFrame:CGRectMake(0, 59, canceltransactionButton.frame.size.width, 1)];
        canceltransactionlineView.backgroundColor = [UIColor lightGrayColor];
        [self.canceltransactionButton addSubview:canceltransactionlineView];
        
        [self.configButton setHidden:YES];
        [self.newtransactionButton setHidden:YES];
        [self.cerraturnoButton setHidden:YES];
        ///////////////////////////////
        
    } else if([globals.idPrivilegio isEqualToString:@"3"]) {
        ///////  side menu button config   ////////////
        CGRect homeButtonFrame = self.homeButton.frame;
        homeButtonFrame.origin.x = 0;
        homeButtonFrame.origin.y = 0;
        self.homeButton.frame = homeButtonFrame;
        UIView *homelineView = [[UIView alloc] initWithFrame:CGRectMake(0, 59, homeButton.frame.size.width, 1)];
        homelineView.backgroundColor = [UIColor lightGrayColor];
        [self.homeButton addSubview:homelineView];
        
        CGRect newtransactionButtonFrame = self.newtransactionButton.frame;
        newtransactionButtonFrame.origin.x = 0;
        newtransactionButtonFrame.origin.y = 60;
        self.newtransactionButton.frame = newtransactionButtonFrame;
        UIView *newtransactiolineView = [[UIView alloc] initWithFrame:CGRectMake(0, 59, newtransactionButton.frame.size.width, 1)];
        newtransactiolineView.backgroundColor = [UIColor lightGrayColor];
        [self.newtransactionButton addSubview:newtransactiolineView];
        
        CGRect canceltransactionButtonFrame = self.canceltransactionButton.frame;
        canceltransactionButtonFrame.origin.x = 0;
        canceltransactionButtonFrame.origin.y = 120;
        self.canceltransactionButton.frame = canceltransactionButtonFrame;
        UIView *canceltransactionlineView = [[UIView alloc] initWithFrame:CGRectMake(0, 59, canceltransactionButton.frame.size.width, 1)];
        canceltransactionlineView.backgroundColor = [UIColor lightGrayColor];
        [self.canceltransactionButton addSubview:canceltransactionlineView];
        
        CGRect cerraturnoButtonFrame = self.cerraturnoButton.frame;
        cerraturnoButtonFrame.origin.x = 0;
        cerraturnoButtonFrame.origin.y = 180;
        self.cerraturnoButton.frame = cerraturnoButtonFrame;
        UIView *cerraturnolineView = [[UIView alloc] initWithFrame:CGRectMake(0, 59, cerraturnoButton.frame.size.width, 1)];
        cerraturnolineView.backgroundColor = [UIColor lightGrayColor];
        [self.cerraturnoButton addSubview:cerraturnolineView];
        
        [self.reportButton setHidden:YES];
        [self.configButton setHidden:YES];
        [self.usuarioButton setHidden:YES];
        [self.turnoButton setHidden:YES];
        
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
        [self.newtransactionButton addSubview:newtransactiolineView];
        
        CGRect canceltransactionButtonFrame = self.canceltransactionButton.frame;
        canceltransactionButtonFrame.origin.x = 0;
        canceltransactionButtonFrame.origin.y = 360;
        self.canceltransactionButton.frame = canceltransactionButtonFrame;
        UIView *canceltransactionlineView = [[UIView alloc] initWithFrame:CGRectMake(0, 59, canceltransactionButton.frame.size.width, 1)];
        canceltransactionlineView.backgroundColor = [UIColor lightGrayColor];
        [self.canceltransactionButton addSubview:canceltransactionlineView];
        
//        CGRect cerraturnoButtonFrame = self.cerraturnoButton.frame;
//        cerraturnoButtonFrame.origin.x = 0;
//        cerraturnoButtonFrame.origin.y = 420;
//        self.cerraturnoButton.frame = cerraturnoButtonFrame;
//        UIView *cerraturnolineView = [[UIView alloc] initWithFrame:CGRectMake(0, 59, cerraturnoButton.frame.size.width, 1)];
//        cerraturnolineView.backgroundColor = [UIColor lightGrayColor];
//        [self.cerraturnoButton addSubview:cerraturnolineView];
//        
        
        [self.cerraturnoButton setHidden:YES];
        
        ///////////////////////////////
        
    }
    
    self.cardNameTextField.delegate = self;
    self.CVVTextField.delegate = self;
}

- (IBAction)contactSupport:(id)sender {
    NSString * encodedString = [@"mailto:soporte@pagadito.com" stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]];
    
    UIApplication *application = [UIApplication sharedApplication];
    [application openURL:[NSURL URLWithString: encodedString] options:@{} completionHandler:nil];
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

- (void) keyboardWillShow:(NSNotification *) n
{
    NSDictionary* userInfo = [n userInfo];
    // get the size of the keyboard
    CGSize keyboardSize = [[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    // resize the noteView
    
    UIEdgeInsets contentInset = self.textScrollView.contentInset;
    contentInset.bottom = keyboardSize.height;
    self.textScrollView.contentInset = contentInset;
}

- (void) keyboardWillHide:(NSNotification *) n
{
    UIEdgeInsets contentInset = UIEdgeInsetsZero;
    self.textScrollView.contentInset = contentInset;
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

- (void)onBTReturnScanResults:(NSArray *)devices{
    
    if (devices == nil){
        return;
    }
    [self.BTDeviceDictionary removeObjectForKey:@"BT_foundDevices"];
    [self.BTDeviceDictionary setObject:[NSArray arrayWithArray:devices] forKey:@"BT_foundDevices"];
    [self.BTDeviceTable reloadData];
    if([[self.BTDeviceDictionary objectForKey:@"BT_foundDevices"] count] > 0) {
        [self.BTDeviceListView setHidden:NO];
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

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([segue.identifier isEqualToString:@"processtransactiontowelcome_segue"]) {
        WelcomeViewController *WelcomVC;
        WelcomVC = [segue destinationViewController];
    } else if([segue.identifier isEqualToString:@"processtransactiontoresult_segue"]) {
        TransactionResultViewController *TransactionResultVC;
        TransactionResultVC = [segue destinationViewController];
        TransactionResultVC.dataTransaction = self.dataTransaction;
    }
}

- (IBAction)signoutButtonAction:(id)sender {
    [self performSegueWithIdentifier:@"processtransactiontowelcome_segue" sender:self];
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
                                 @"param": string,
                                 @"TOKEN": globals.server_token
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
            [self performSegueWithIdentifier:@"processtransactiontowelcome_segue" sender:self];
        } else {
            if(globals.selected_language == 0) {
                [self displayAlertView:@"¡Advertencia!" :@"Ocurrió un error. Por favor contacte a soporte." :@"nil"];
            } else {
                [self displayAlertView:@"Warning!" :@"An error has occurred. Please contact support." :@"nil"];
            }
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self.activityIndicator stopAnimating];
        [self.overlayView removeFromSuperview];
        if(globals.selected_language == 0) {
            [self displayAlertView:@"¡Advertencia!" :@"Por favor asegurate que estás conectado a internet." :@"nil"];
        } else {
            [self displayAlertView:@"Warning!" :@"Please check your internet connection to continue." :@"nil"];
        }
    }];
}

- (IBAction)CVVhelpButtonAction:(id)sender {
    if([self.crediccardImageView isHidden]) {
        [self.crediccardImageView setHidden:NO];
    } else {
        [self.crediccardImageView setHidden:YES];
    }
}

- (IBAction)monthselectButtonAction:(id)sender {
    
    if([self.monthTableVIew isHidden]) {
        [self.monthTableVIew setHidden:NO];
    } else {
        [self.monthTableVIew setHidden:YES];
    }
}

- (IBAction)yearselectButtonAction:(id)sender {
    if([self.yearTableView isHidden]) {
        [self.yearTableView setHidden:NO];
    } else {
        [self.yearTableView setHidden:YES];
    }
}

- (IBAction)switchButtonAction:(id)sender {
    if(self.taxSwitchButton.on) {
        self.checkTax = @"1";
    } else {
        self.checkTax = @"0";
    }
}

-(NSString *)randomtransactionERN {
    Global *globals = [Global sharedInstance];
    NSString *randomERN = @"";
    double randNumdouble = 8999999 * drand48() + 1000000;
    int randNumint = (int)randNumdouble;
    randomERN = [NSString stringWithFormat:@"%@%d", globals.turnoCod, randNumint];
    return randomERN;
}

-(NSString *)getAmountToCurrency: (NSString *) amount{
    NSDecimalNumber *amountFinal = [NSDecimalNumber decimalNumberWithString:amount];
    NSNumberFormatter *numberFormatter1 = [[NSNumberFormatter alloc] init];
    numberFormatter1.locale = [NSLocale currentLocale];// this ensures the right separator behavior
    numberFormatter1.numberStyle = NSNumberFormatterDecimalStyle;
    numberFormatter1.usesGroupingSeparator = YES;
    [numberFormatter1 setGroupingSize:3];
    [numberFormatter1 setMaximumFractionDigits:2];
    [numberFormatter1 setMinimumFractionDigits:2];
    
    return [NSString stringWithFormat:@"%@", [numberFormatter1 stringForObjectValue:amountFinal]];
}

-(NSString *)getCreditCardTypeByNumber: (NSString *) creditCardNum {
    NSString *regVisa = @"^4[0-9]{3,}$";
    NSString *regMaster = @"^5[1-5][0-9]{2,}$";
    NSString *regExpress = @"^3[47][0-9]{2,}$";
    NSString *regDiners = @"^3(?:0[0-5]|[68][0-9])[0-9]{1,}$";
    NSString *regDiscover = @"^6(?:011|5[0-9]{2})[0-9]{0,}$";
    NSString *regJCB = @"^(?:2131|1800|35[0-9]{2})[0-9]{0,}$";
    
    NSString *cardType = @"";
    NSArray *cardTypeArray = @[regVisa, regMaster, regExpress, regDiners, regDiscover, regJCB];
    NSPredicate *checkVisaCardType;
    BOOL allDoneNow = NO;
    for(int i = 0; i < cardTypeArray.count; i ++) {
        checkVisaCardType = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", cardTypeArray[i]];
        if([checkVisaCardType evaluateWithObject: creditCardNum] == YES) {
            if(i == 0) {
                cardType = @"VISA";
                allDoneNow = YES;
                break;
            } else if(i == 1) {
                cardType = @"MASTERCARD";
                allDoneNow = YES;
                break;
            } else if(i == 2) {
                cardType = @"AMEX";
                allDoneNow = YES;
                break;
            } else if(i == 3) {
                cardType = @"DINERS";
                allDoneNow = YES;
                break;
            } else if(i == 4) {
                cardType = @"discover";
                allDoneNow = YES;
                break;
            } else if(i == 5) {
                cardType = @"jcb";
                allDoneNow = YES;
                break;
            } else {
                cardType = @"invalid";
                allDoneNow = YES;
                break;
            }
        } else {
            cardType = @"invalid";
        }
        if (allDoneNow) break;
    }
    return cardType;
}

- (IBAction)processtransactionButtonAction:(id)sender {
    Global *globals = [Global sharedInstance];
    [self.processtransactionButton setEnabled:NO];
    NSString *ksn_data = @"";
    NSString *card_data = @"";
    NSString *validCard = @"";
    
    //DATA TEST//
    /*self.cardNumberTextField.text = @"5564362752814906";
    self.cardNameTextField.text = @"Robert Salguero";
    self.CVVTextField.text = @"281";
    self.selected_year = @"19";
    self.selected_month = @"10";
    tlv_C0 = @"88888845700342200069";
    tlv_C2 = @"8068C45A1906E9DD703728426FF523A803CFCE5FABC10E97F2B653BE9A9780332ACA304A2E12D7B46F5F08299FF691E87A8E186467F9E140D1F409A3BAA924D3AC9CB71197DDCFB8C6FB85F71EEF885944A6A2F9B6F1E612972B41838F43BA43DB1DBA131453444D706C1BA024105719AB1F98ED53CA572AD5425685CA3365591F8F1900CCEBE0ECE7181B7217C3E7B74500B0CE2B92F209CC17EDCB076D9C96B3912FCA4CCD6E969FE46A9B8C4149DFB2BE7C476981AD161A91E10514A330BCCF098C1BE147BCB93F3BD195B7E545FFE506E251552F539F376ECFF4A71C0741E862D82AB3E8552EBD76CB683CB629E20A07F10B4D1A3E00ADFE9B25E23F9117D6B541C333AA2E2FC1B424D9B338362F1BEF07CD878DD170951CF76589A506AC49925EAB56002DEEFD12A776BC955371F114369944061FBF0B600B98FBE95E8736CCDAF0000286B5AD78D2B5CC8A575B441A5430343B2977479E7CF733B86E7F0C2E0EDAE7474C03E86B6A899F08BE9BB1D569A4D2A93843AE1863B61E4C0F1648B34FBCF6AFC962";
    type_trans = @"TLV";*/
    //DATA TEST//
    
    self.cardNumber = self.cardNumberTextField.text;
    self.cardHolderName = self.cardNameTextField.text;
    self.CVV = self.CVVTextField.text;
    self.descriptiontxt = self.descriptionTextField.text;
    self.expire_date = [NSString stringWithFormat:@"%@%@", self.selected_year, self.selected_month];
    
    pan = self.cardNumber;
    numberCard = pan;
    
    if(pan.length >= 15){
        validCard = [pan substringWithRange:NSMakeRange(0, 4)];
    }
    
    if(self.cardNumber.length < 15) {
        if(globals.selected_language == 0) {
            [self displayAlertView:@"¡Advertencia!" :@"Debes ingresar un número de tarjeta válido para continuar." :@"nil"];
        } else {
            [self displayAlertView:@"Warning!" :@"Please enter a valid card number to continue." :@"nil"];
        }
        self.cardNumberTextField.text = @"";
        self.cardNameTextField.text = @"";
        self.CVVTextField.text = @"";
        self.descriptionTextField.text = @"";
        self.selected_year = self.year_array[0];
        self.selected_month = self.month_array[0];
        [self.processtransactionButton setEnabled:YES];
        return;
    }
    if( !([[self getCreditCardTypeByNumber:validCard] isEqualToString:@"VISA"]) && !([[self getCreditCardTypeByNumber:validCard] isEqualToString:@"MASTERCARD"])){
        if(globals.selected_language == 0) {
            [self displayAlertView:@"¡Advertencia!" :@"El tipo de tarjeta seleccionada no es aceptada por este POS, por favor intenta con otra tarjeta." :@"nil"];
        } else {
            [self displayAlertView:@"Warning!" :@"The type of credit card selected is not accepted in this POS. Please try with a different card." :@"nil"];
        }
        self.cardNumberTextField.text = @"";
        self.cardNameTextField.text = @"";
        self.CVVTextField.text = @"";
        self.descriptionTextField.text = @"";
        self.selected_year = self.year_array[0];
        self.selected_month = self.month_array[0];
        [self.processtransactionButton setEnabled:YES];
        return;
    }
    if(self.cardHolderName.length == 0) {
        if(globals.selected_language == 0) {
            [self displayAlertView:@"¡Advertencia!" :@"Por favor ingrese su nombre." :@"nil"];
        } else {
            [self displayAlertView:@"Warning!" :@"Please input name." :@"nil"];
        }
        [self.processtransactionButton setEnabled:YES];
        return;
    }
    if(self.cardHolderName.length > 50) {
        if(globals.selected_language == 0) {
            [self displayAlertView:@"¡Advertencia!" :@"Nombre no puede ser mayor a 50 caracteres." :@"nil"];
        } else {
            [self displayAlertView:@"Warning!" :@"Name have to be less than 50 characters" :@"nil"];
        }
        [self.processtransactionButton setEnabled:YES];
        return;
    }
    if(self.CVV.length != 3) {
        if(globals.selected_language == 0) {
            [self displayAlertView:@"¡Advertencia!" :@"El CVV debe tener 3 dígitos." :@"nil"];
        } else {
            [self displayAlertView:@"Warning!" :@"CVV have to be 3 digits." :@"nil"];
        }
        [self.processtransactionButton setEnabled:YES];
        return;
    }
    if([self.selected_year isEqualToString:@""] || [self.selected_month isEqualToString:@""]) {
        if(globals.selected_language == 0) {
            [self displayAlertView:@"¡Advertencia!" :@"Por favor seleccione fecha de expiración." :@"nil"];
        } else {
            [self displayAlertView:@"Warning!" :@"Please select expire date." :@"nil"];
        }
        [self.processtransactionButton setEnabled:YES];
        return;
    }
    
    
    [self.activityIndicator startAnimating];
    [self.view addSubview:self.overlayView];
    
    NSDictionary *credentials = @{
                                    @"uid": globals.login_uid,
                                    @"wsk": globals.login_wsk,
                                    @"llaveCifrado": globals.llaveCifrado,
                                    @"cifradoIV": globals.cifradoIV,
                                    @"ambiente": globals.ambiente
                                };
    NSError *error;
    NSData *postCredentialsData = [NSJSONSerialization dataWithJSONObject:credentials options:0 error:&error];
    NSString *postCredentialsString = [[NSString alloc]initWithData:postCredentialsData encoding:NSUTF8StringEncoding];
    
    if([self.descriptiontxt isEqualToString:@""]) {
        self.descriptiontxt = @"Compra comercio pagadito";
    }
    NSDictionary *details = @{
                @"description": self.descriptiontxt,
                @"quantity": @"1",
                @"price": self.transactionAmount
                };
    
    NSMutableArray *details_array = [[NSMutableArray alloc] initWithObjects:details, nil];
    NSDictionary *transaction = @{
                                      @"ern": [self randomtransactionERN],
                                      @"currency": globals.moneda,
                                      @"total_amount": self.transactionAmount,
                                      @"details": details_array
                                  };
    NSData *postTransactionData = [NSJSONSerialization dataWithJSONObject:transaction options:0 error:&error];
    NSString *postTransactionString = [[NSString alloc]initWithData:postTransactionData encoding:NSUTF8StringEncoding];
    
    if([type_trans isEqualToString:@"Swipe"]){
        ksn_data = swipe_ksn;
        card_data = swipe_encTrack1;
    }else if([type_trans isEqualToString:@"TLV"]){
        ksn_data = tlv_C0;
        card_data = tlv_C2;
    }
    
    NSDictionary *card = @{
                           //@"pan": pan,
                           @"ksn": ksn_data,
                           @"data": card_data,
                           @"type": type_trans,
                           @"card_holder_name": self.cardHolderName,
                           @"card_expiration_date": self.expire_date,
                           @"cvv": self.CVV
                           };
    NSData *postCardData = [NSJSONSerialization dataWithJSONObject:card options:0 error:&error];
    NSString *postCardString = [[NSString alloc]initWithData:postCardData encoding:NSUTF8StringEncoding];
    
    NSDictionary *terminal = @{
                           @"branch_office_id": globals.branchid,
                           @"terminal_id":globals.terminalid,
                           };
    NSData *postTerminalData = [NSJSONSerialization dataWithJSONObject:terminal options:0 error:&error];
    NSString *postTerminalString = [[NSString alloc]initWithData:postTerminalData encoding:NSUTF8StringEncoding];
    
    
    NSDictionary *parameters = @{
                                 @"method": @"transaction_mobil",
                                 @"credentials": postCredentialsString,
                                 @"transaction": postTransactionString,
                                 @"terminal": postTerminalString,
                                 @"card": postCardString,
                                 @"TOKEN": globals.server_token
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

        if([jsonResponse[@"code"] isEqualToString:@"PG1019"]) {
            self.dataTransaction = jsonResponse;
            //NSString *last4digits = [self.cardNumber substringFromIndex:[self.cardNumber length] - 4];
            NSString *last4digits = [pan substringFromIndex:[pan length] - 4];
            [self.dataTransaction setValue:last4digits forKey:@"card"];
            [self.dataTransaction setValue:globals.nombreComercio forKey:@"comercio"];
            [self.dataTransaction setValue:[self getCreditCardTypeByNumber:validCard] forKey:@"type"];
            [self.dataTransaction setValue:self.cardHolderName forKey:@"name"];
            [self.dataTransaction setValue:[self getAmountToCurrency:self.transactionAmount] forKey:@"amount"];
            [self.dataTransaction setValue:jsonResponse[@"value"][@"date_trans"] forKey:@"date"];
            
            [self insertTransations:self.transactionAmount :jsonResponse[@"value"] :self.descriptiontxt];
            
        } else {
            if(globals.selected_language == 0) {
                [self displayAlertView:@"¡Advertencia!" :@"La información para la transacción es incorrecta. Por favor ingrese información válida." :@"nil"];
            } else {
                [self displayAlertView:@"Warning!" :@"Transaction information is incorrect. Please input valid information" :@"nil"];
            }
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self.activityIndicator stopAnimating];
        [self.overlayView removeFromSuperview];
        if(globals.selected_language == 0) {
            [self displayAlertView:@"¡Advertencia!" :@"Por favor asegurate que estás conectado a internet." :@"nil"];
        } else {
            [self displayAlertView:@"Warning!" :@"Please check your internet connection to continue." :@"nil"];
        }
    }];
    
}

-(void)insertTransations: (NSString *)total_amount :(NSDictionary *)data :(NSString *)descripton_para {
    Global *globals = [Global sharedInstance];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    NSTimeZone *timeZone = [NSTimeZone timeZoneWithName:@"America/El_Salvador"];
    [dateFormatter setTimeZone:timeZone];
    [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ssZ"];
    NSDate *fechaDate = [dateFormatter dateFromString:data[@"date_trans"]];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *fechaString = [dateFormatter stringFromDate:fechaDate];
    
    [self.activityIndicator startAnimating];
    [self.view addSubview:self.overlayView];
    
    NSDictionary *insertTransactions = @{
                               @"total": total_amount,
                               @"ern": data[@"ern"],
                               @"referencia": data[@"reference"],
                               @"fecha": fechaString,
                               @"status": data[@"status"],
                               @"concepto": descripton_para,
                               @"ipPublica": globals.IPAddress,
                               @"idTurno": globals.idTurno
                               };
    NSError *error;
    NSData *postinsertTransactionsData = [NSJSONSerialization dataWithJSONObject:insertTransactions options:0 error:&error];
    NSString *postinsertTransactionsString = [[NSString alloc]initWithData:postinsertTransactionsData encoding:NSUTF8StringEncoding];
    
    
    NSDictionary *parameters = @{
                                 @"method": @"insertTransactions",
                                 @"param": postinsertTransactionsString,
                                 @"TOKEN": globals.server_token
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
//            if(globals.selected_language == 0) {
//                [self displayAlertView:@"¡Felicidades!" :@"Transacción realizada exitosamente!." :@"transaction_result"];
//            } else {
//                [self displayAlertView:@"Congratulations!" :@"Transaction successful!." :@"transaction_result"];
//            }
            [self performSegueWithIdentifier:@"processtransactiontoresult_segue" sender:self];
        } else {
            if(globals.selected_language == 0) {
                [self displayAlertView:@"¡Advertencia!" :@"Ha ocurrido un error la transacción no fue ejecutada. Por favor comuníquese con soporte." :@"nil"];
            } else {
                [self displayAlertView:@"Warning!" :@"An error has ocurred during the transaction processing." :@"nil"];
            }
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self.activityIndicator stopAnimating];
        [self.overlayView removeFromSuperview];
        if(globals.selected_language == 0) {
            [self displayAlertView:@"¡Advertencia!" :@"Por favor asegurate que estás conectado a internet." :@"nil"];
        } else {
            [self displayAlertView:@"Warning!" :@"Please check your internet connection to continue." :@"nil"];
        }
    }];
    
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if(textField == self.cardNameTextField) {
        if (textField.text.length < 50 || string.length == 0){
            const char * _char = [string cStringUsingEncoding:NSUTF8StringEncoding];
            int isBackSpace = strcmp(_char, "\b");
            
            if (isBackSpace == -8) {
                NSLog(@"Backspace was pressed");
                return YES;
            }
            
            BOOL canEdit=NO;
            NSCharacterSet *myCharSet = [NSCharacterSet characterSetWithCharactersInString:@"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz "];
            for (int i = 0; i < [string length]; i++)
            {
                unichar c = [string characterAtIndex:i];
                if (![myCharSet characterIsMember:c])
                {
                    canEdit=NO;
                }
                else
                {
                    canEdit=YES;
                }
            }
            return canEdit;
        }else{
            return NO;
        }
        
    } else if (textField == self.CVVTextField){
        if (textField.text.length < 3 || string.length == 0){
            return YES;
        }
        else{
            return NO;
        }
    }else {
        return YES;
    }

}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(tableView == self.monthTableVIew) {
        return self.month_array.count;
    } else if(tableView == self.yearTableView) {
        return self.year_array.count;
    } else {
        return [[self.BTDeviceDictionary objectForKey:@"BT_foundDevices"] count];
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 40;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(tableView == self.monthTableVIew) {
        static NSString *cellIdentifier = @"month_cell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if(cell == nil) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        }
        cell.textLabel.text = self.month_array[indexPath.row];
        return cell;
    } else if(tableView == self.yearTableView) {
        static NSString *cellIdentifier = @"year_cell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if(cell == nil) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        }
        cell.textLabel.text = self.year_array[indexPath.row];
        return cell;
    } else {
        static NSString *cellIdentifier = @"btdevice_cell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if(cell == nil) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        }
//        cell.textLabel.text = self.year_array[indexPath.row];
        NSObject *tempDevice = [[self.BTDeviceDictionary objectForKey:@"BT_foundDevices"] objectAtIndex:indexPath.row];
        
        NSString *deviceName = @"";
        if ([tempDevice isKindOfClass:[EAAccessory class]]){
            deviceName = [NSString stringWithFormat:@"%@", [(EAAccessory *)tempDevice serialNumber]];
            cell.textLabel.text = deviceName;
            
        }else if ([tempDevice isKindOfClass:[CBPeripheral class]]){
            deviceName = [(CBPeripheral *)tempDevice name];
            [[cell textLabel] setText:deviceName];
        }
        return cell;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if(tableView == self.monthTableVIew) {
        [self.monthselectButton setTitle:self.month_array[indexPath.row] forState:UIControlStateNormal];
        self.selected_month = self.month_array[indexPath.row];
        [self.monthTableVIew setHidden:YES];
    } else if(tableView == self.yearTableView) {
        [self.yearselectButton setTitle:self.year_array[indexPath.row] forState:UIControlStateNormal];
        self.selected_year = self.year_array[indexPath.row];
        [self.yearTableView setHidden:YES];
    } else if (tableView == self.BTDeviceTable) {
        NSObject *device = [[self.BTDeviceDictionary objectForKey:@"BT_foundDevices"] objectAtIndex:indexPath.row];
        
        [[BBDeviceController sharedController] stopBTScan];
        [[BBDeviceController sharedController] connectBT:device];
    }
}

-(void)displayAlertView: (NSString *)header :(NSString *)message :(NSString *) nextscreen {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:header message:message preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *actionOK = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if([nextscreen isEqualToString:@"transaction_result"]) {
            [self performSegueWithIdentifier:@"processtransactiontoresult_segue" sender:self];
        }
    }];
    [alert addAction:actionOK];
    [self presentViewController:alert animated:YES completion:nil];
}

- (IBAction)BTDeviceListViewCloseButtonAction:(id)sender {
    [self.BTDeviceListView setHidden:YES];
}

- (void)onBTConnected:(NSObject *)connectedDevice{
    NSLog(@"onBTConnected - connectedDevice: %@", connectedDevice);
    isAutoConnectLastBTDevice = NO;
    
    NSString *deviceName = @"";
    if ([connectedDevice isKindOfClass:[EAAccessory class]]){
        deviceName = [NSString stringWithFormat:@"%@", [(EAAccessory *)connectedDevice serialNumber]];
    }else if ([connectedDevice isKindOfClass:[CBPeripheral class]]){
        deviceName = [(CBPeripheral *)connectedDevice name];
    }
    
    NSLog(@"onBTConnected\nConnected: %@", deviceName);
    
    [self.BTDeviceDictionary removeAllObjects];
    [self.BTDeviceTable reloadData];
    
}



//---------------------------------------- DATAFORM ----------------------------------------------------

- (void)dataCardHolderNameTLV:(NSString *)cardholderName{
    self.cardNameTextField.text = cardholderName;
    [self startEmvWithData];
}

- (void)dataForm:(NSString *)numberCard :(NSString *)cardHolderName :(NSString *)exp_card :(NSString *)type
                :(NSString *)ksn :(NSString *)encTrack1 :(NSString *)C0 :(NSString *)C2 {
    
    //set value numberCard in the field Number Card
    NSLog(@"number card: %@, cardholdername:%@, exp_card:%@, type:%@, ksn:%@, enctrack1:%@, C0:%@, C2:%@", numberCard, cardHolderName, exp_card, type, ksn, encTrack1, C0, C2);
    //set value cardHolderName in the field Cardholdername
    //set value exp_card in the fields month and year example of return: 2006 (20 is a year, and 06 is a month)
    
    //Global *globals = [Global sharedInstance];
    [self.activityIndicator startAnimating];
    [self.view addSubview:self.overlayView];

    typeTransaction = 1;
    NSString *month = @"";
    NSString *year = @"";
    year = [exp_card substringWithRange:NSMakeRange(0, 2)];
    month = [exp_card substringWithRange:NSMakeRange(2, 2)];
    NSLog(@"test year and month: %@ :: %@", year, month);
    self.cardNumberTextField.text = numberCard;
    
    type_trans = type;
    
    if([type isEqualToString:@"Swipe"]){
        self.cardNameTextField.text = cardHolderName;
        swipe_ksn = ksn;
        swipe_encTrack1 = encTrack1;
    }else if([type isEqualToString:@"TLV"]){
        tlv_C0 = C0;
        tlv_C2 = C2;
    }

    [self.monthselectButton setTitle:month forState:UIControlStateNormal];
    [self.yearselectButton setTitle:year forState:UIControlStateNormal];
    self.selected_year = year;
    self.selected_month = month;
    
    [self.activityIndicator stopAnimating];
    [self.overlayView removeFromSuperview];

}




//----------------------------------------- Utility ------------------------------------------------

#pragma mark - Utility

#pragma mark -- Utility -- General
- (NSString *)hexStringToAscii:(NSString *)hexString {
    NSMutableData *stringData = [[NSMutableData alloc] init];
    unsigned char whole_byte;
    char byte_chars[3] = {'\0','\0','\0'};
    int i;
    for (i=0; i < [hexString length] / 2; i++) {
        byte_chars[0] = [hexString characterAtIndex:i*2];
        byte_chars[1] = [hexString characterAtIndex:i*2+1];
        whole_byte = strtol(byte_chars, NULL, 16);
        [stringData appendBytes:&whole_byte length:1];
    }
    
    return [[NSString alloc] initWithData:stringData encoding:NSASCIIStringEncoding];
}

- (NSString *)asciiToHexString:(NSString *)asciiString{
    NSString *hexString = @"";
    for (int i=0; i<[asciiString length]; i++) {
        char loopChar = [asciiString characterAtIndex:i];
        hexString = [NSString stringWithFormat:@"%@%02X", hexString, loopChar];
    }
    return hexString;
}

- (NSData *)getPrintDataWithString:(NSString *)stringData{
    NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
    return [stringData dataUsingEncoding:enc];
}

- (NSData *)hexStringToBytes:(NSString *)hexString {
    if ([hexString length] % 2 != 0){
        hexString = [NSString stringWithFormat:@"0%@", hexString];
    }
    
    NSMutableData* data = [NSMutableData data];
    int idx;
    for (idx = 0; idx+2 <= [hexString length]; idx+=2) {
        NSRange range = NSMakeRange(idx, 2);
        NSString* hexStr = [hexString substringWithRange:range];
        NSScanner* scanner = [NSScanner scannerWithString:hexStr];
        unsigned int intValue;
        [scanner scanHexInt:&intValue];
        [data appendBytes:&intValue length:1];
    }
    return [NSData dataWithData:data];
}

- (BOOL)isContainString:(NSString *)wholeString containString:(NSString *)containString{
    NSRange range = [wholeString rangeOfString:containString];
    if (range.length > 0){
        if (range.location != NSNotFound) {
            return YES;
        }
    }
    return NO;
}

#pragma mark -- Utility -- NSUserDefaults
- (void)setNSUserDefaultsObject:(NSObject *)object key:(NSString *)key{
    //ViewControllerLog(@"key: %@", key);
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:object forKey:key];
    [defaults synchronize];
}

- (NSObject *)getNSUserDefaultsObject:(NSString *)key{
    //ViewControllerLog(@"key: %@", key);
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    return [defaults objectForKey:key];
}


//----------------------------------------- Basic Transaction Flow ------------------------------------------------

#pragma mark - Transaction Flow
#pragma mark -- Transaction Flow -- Set Amount

- (void)onReturnAmount:(NSDictionary *)data{
    NSLog(@"onReturnAmount - data: %@", data);
    NSString *currencyCode = [data objectForKey:@"currencyCode"];
    NSString *amount = [data objectForKey:@"amount"];
    NSString *cashbackAmount = [data objectForKey:@"cashbackAmount"];
    NSString *tipsAmount = [data objectForKey:@"tipsAmount"];
    NSNumber *currencyExponent = [data objectForKey:@"currencyExponent"];
}

#pragma mark -- Transaction Flow -- Check Card or Magnetic Swipe Transaction
- (IBAction)btnAction_StartTransaction:(id)sender {
    
    isClickedStartTransactionButton = YES;
    isCheckCardOnly = NO;
    isBadSwiped = NO;
    
    [self startEmvWithData];
    
}

- (void)onWaitingForCard:(BBDeviceCheckCardMode)checkCardMode{
    NSLog(@"onWaitingForCard - checkCardMode: %@", [self getCheckCardModeString:checkCardMode]);
}

- (NSString *)getCheckCardModeString:(BBDeviceCheckCardMode)checkCardMode{
    NSString *returnString = @"";
    switch (checkCardMode) {
        case BBDeviceCheckCardMode_Swipe:{ returnString = @"CheckCardMode_Swipe"; break; }
        case BBDeviceCheckCardMode_Insert:{ returnString = @"CheckCardMode_Insert"; break; }
        case BBDeviceCheckCardMode_Tap:{ returnString = @"CheckCardMode_Tap"; break; }
        case BBDeviceCheckCardMode_SwipeOrInsert:{ returnString = @"CheckCardMode_SwipeOrInsert"; break; }
        case BBDeviceCheckCardMode_SwipeOrTap:{ returnString = @"CheckCardMode_SwipeOrTap"; break; }
        case BBDeviceCheckCardMode_SwipeOrInsertOrTap:{ returnString = @"CheckCardMode_SwipeOrInsertOrTap"; break; }
        case BBDeviceCheckCardMode_InsertOrTap:{ returnString = @"CheckCardMode_InsertOrTap"; break; }
        case BBDeviceCheckCardMode_ManualPanEntry:{ returnString = @"CheckCardMode_ManualPanEntry"; break; }
        case BBDeviceCheckCardMode_QRCode:{ returnString = @"CheckCardMode_QR"; break; }
        default:{ returnString = @"Unknown CheckCardMode"; break; }
    }
    return returnString;
}

- (void)onReturnCheckCardResult:(BBDeviceCheckCardResult)result cardData:(NSDictionary *)cardData{  //ESTE METODO ES PARA SWIPE
    
    NSLog(@"cardData: %@", cardData);
    
    NSString *checkCardResultString = @"";
    switch (result) {
        case BBDeviceCheckCardResult_NoCard:{ checkCardResultString = @"onReturnCheckCardResult - result: BBDeviceCheckCardResult_NoCard"; break;}
        case BBDeviceCheckCardResult_InsertedCard:{ checkCardResultString = @"onReturnCheckCardResult - result: BBDeviceCheckCardResult_InsertedCard"; break;}
        case BBDeviceCheckCardResult_NotIccCard:{ checkCardResultString = @"onReturnCheckCardResult - result: BBDeviceCheckCardResult_NotIccCard"; break;}
        case BBDeviceCheckCardResult_BadSwipe:{ checkCardResultString = @"onReturnCheckCardResult - result: BBDeviceCheckCardResult_BadSwipe"; break;}
        case BBDeviceCheckCardResult_SwipedCard:{ checkCardResultString = @"onReturnCheckCardResult - result: BBDeviceCheckCardResult_SwipedCard"; break;}
        case BBDeviceCheckCardResult_MagHeadFail:{ checkCardResultString = @"onReturnCheckCardResult - result: BBDeviceCheckCardResult_MagHeadFail"; break;}
        case BBDeviceCheckCardResult_TapCardDetected:{ checkCardResultString = @"onReturnCheckCardResult - result: BBDeviceCheckCardResult_TapCardDetected"; break;}
        default:{ checkCardResultString = @"onReturnCheckCardResult - result: else"; break;}
    }
    //[self printLog:checkCardResultString];
    
    switch (result) {
        case BBDeviceCheckCardResult_SwipedCard:{
            NSString *type = @"Swipe";
            NSString *cardHolderName = @"";
            NSString *ksn = @"";
            NSString *encTrack1 = @"";
            
            NSArray *keys = [[cardData allKeys] sortedArrayUsingSelector:@selector(localizedCompare:)];
            for (NSString *loopKey in keys) {
                
                if([loopKey isEqualToString:@"maskedPAN"]){
                    NSLog(@"TARJETA: %@", [cardData objectForKey:loopKey]);
                    numberCard = [cardData objectForKey:loopKey];
                }else if([loopKey isEqualToString:@"cardholderName"]){
                    NSLog(@"CARDHOLDERNAME: %@", [cardData objectForKey:loopKey]);
                    cardHolderName = [cardData objectForKey:loopKey];
                }else if([loopKey isEqualToString:@"expiryDate"]){
                    NSLog(@"EXP_DATE: %@", [cardData objectForKey:loopKey]);
                    exp_card = [cardData objectForKey:loopKey];
                }else if([loopKey isEqualToString:@"ksn"]){
                    NSLog(@"KSN: %@", [cardData objectForKey:loopKey]);
                    ksn = [cardData objectForKey:loopKey];
                }else if([loopKey isEqualToString:@"encTrack1"]){
                    NSLog(@"ENCTRACK1: %@", [cardData objectForKey:loopKey]);
                    encTrack1 = [cardData objectForKey:loopKey];
                }
            }
            
            [self dataForm:numberCard :cardHolderName :exp_card :type :ksn :encTrack1 :@"" :@""];
            break;
        }
        case BBDeviceCheckCardResult_InsertedCard:{
            [[BBDeviceController sharedController] getEmvCardData];
            break;
        }
        default:{break;}
    }
}

- (void)checkCardAgainAfterBadSwipe{
    isBadSwiped = YES;
    [self startEmvWithData];
}

#pragma mark -- Transaction Flow -- StartEMV
- (IBAction)btnAction_StartEMV:(id)sender{
    
    isClickedStartTransactionButton = YES;
    
    //[self startEmvWithData];
    [self checkCard];
    
}

- (void)checkCard{
    
    NSMutableDictionary *inputData = [NSMutableDictionary dictionary];
    [inputData setObject:[NSNumber numberWithInt:(int)BBDeviceCheckCardMode_SwipeOrInsert] forKey:@"checkCardMode"];
    [inputData setObject:[NSNumber numberWithInt:30] forKey:@"checkCardTimeout"];
    NSLog(@"checkCard ...");
    
    [[BBDeviceController sharedController] checkCard:[NSDictionary dictionaryWithDictionary:inputData]];
}

- (void)startEmvWithData{
    
    // Common Input:
        NSMutableDictionary *inputData = [NSMutableDictionary dictionary];
        [inputData setObject:[NSNumber numberWithInt:30] forKey:@"checkCardTimeout"];
        [inputData setObject:[NSNumber numberWithInt:30] forKey:@"setAmountTimeout"];
        [inputData setObject:[NSNumber numberWithInt:30] forKey:@"selectApplicationTimeout"];
        [inputData setObject:[NSNumber numberWithInt:30] forKey:@"pinEntryTimeout"];
        [inputData setObject:[NSNumber numberWithInt:30] forKey:@"finalConfirmTimeout"];
        [inputData setObject:[NSNumber numberWithInt:30] forKey:@"onlineProcessTimeout"];
    //
        NSString *terminalTime = @""; //e.g. 130108152010 (YYMMddHHmmss)
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"YYMMddHHmmss"];
        [formatter setTimeZone:[NSTimeZone localTimeZone]];
        terminalTime = [formatter stringFromDate:[NSDate date]];
        //[formatter release];
        [inputData setObject:terminalTime forKey:@"terminalTime"];
    
        [inputData setObject:[NSNumber numberWithInt:(int)BBDeviceCheckCardMode_SwipeOrInsert] forKey:@"checkCardMode"];
        [inputData setObject:[NSNumber numberWithInt:(int)BBDeviceEmvOption_StartWithForceOnline] forKey:@"emvOption"];
        [inputData setObject:[NSNumber numberWithInt:(int)BBDeviceTransactionType_Goods] forKey:@"transactionType"];
        [inputData setObject:@"840" forKey:@"currencyCode"];
        [inputData setObject:@"1.99" forKey:@"amount"];
    NSLog(@"startEmvWithData ...");
    
        [[BBDeviceController sharedController] startEmvWithData:[NSDictionary dictionaryWithDictionary:inputData]];
    
   }

- (void)onReturnEmvCardDataResult:(BOOL)isSuccess tlv:(NSString *)tlv{
    //ViewControllerLog(@"onReturnEmvCardDataResult - isSuccess: %d, tlv: %@", isSuccess, tlv);
    //lblGeneralData.text = [NSString stringWithFormat:@"onReturnEmvCardDataResult \nisSuccess: %@", isSuccess ? @"YES" : @"NO"];
    NSLog(@"[[BBDeviceController sharedController] decodeTlv:tlv]: %@", [[BBDeviceController sharedController] decodeTlv:tlv]);
    NSDictionary *decodedTlv = [[BBDeviceController sharedController] decodeTlv:tlv];
    NSArray *keys = [[decodedTlv allKeys] sortedArrayUsingSelector:@selector(localizedCompare:)];
    NSString *tempDisplayString = @"";
    NSString *cardholdername = @"";
    for (NSString *loopKey in keys) {
        tempDisplayString = [NSString stringWithFormat:@"%@\n\n%@: %@", tempDisplayString, loopKey, [decodedTlv objectForKey:loopKey]];
        NSLog(@"RESULT: %@", tempDisplayString);
        if([loopKey isEqualToString:@"5F20"]){
            NSLog(@"cardholdername: %@", [decodedTlv objectForKey:loopKey]);
            cardholdername = [decodedTlv objectForKey:loopKey];
            NSString * str = cardholdername;
            NSMutableString * newString = [[NSMutableString alloc] init];
            int i = 0;
            while (i < [str length])
            {
                NSString * hexChar = [str substringWithRange: NSMakeRange(i, 2)];
                int value = 0;
                sscanf([hexChar cStringUsingEncoding:NSASCIIStringEncoding], "%x", &value);
                [newString appendFormat:@"%c", (char)value];
                i+=2;
            }
            NSLog(@"cardholdername: %@", newString);
            [self dataCardHolderNameTLV: newString];
        }
    }
    //[self displayLongData:[NSString stringWithFormat:@"EMV card data:\n%@", tlv]];
    
    //[self Debug_onReturnEmvCardDataResult];
}

#pragma mark -- Transaction Flow -- Terminal Time
- (void)onRequestTerminalTime{ //terminalTime can be input at startEmvWithData
    
    NSString *terminalTime = @""; //e.g. 130108152010 (YYMMddHHmmss)
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"YYMMddHHmmss"];
    [formatter setTimeZone:[NSTimeZone localTimeZone]];
    terminalTime = [formatter stringFromDate:[NSDate date]];
    //[formatter release];
    
    [[BBDeviceController sharedController] sendTerminalTime:terminalTime];
}

#pragma mark -- Transaction Flow -- Set Amount

//onRequestSetAmount will be triggered in the following conditions:
//1. Have not yet called setAmount before startEmvWithData
//2. No amount input at startEmvWithData

- (void)onRequestSetAmount{
    
        NSString *amountStr = @"10";
        NSString *cashbackStr = @"";
        NSString *currencyCharacter = @"Dollar";
        
        NSMutableDictionary *inputData = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                          amountStr, @"amount",
                                          cashbackStr, @"cashbackAmount",
                                          [NSNumber numberWithInteger:840], @"currencyCode",
                                          currencyCharacter, @"currencyCharacters",
                                          [NSNumber numberWithInt:(int)BBDeviceTransactionType_Goods], @"transactionType",
                                          nil];
        
        [[BBDeviceController sharedController] setAmount:[NSDictionary dictionaryWithDictionary:inputData]];
    
}

#pragma mark -- Transaction Flow -- Final Confirm
- (void)onRequestFinalConfirm{

        [[BBDeviceController sharedController] sendFinalConfirmResult:YES];
        return;
}

#pragma mark -- Transaction Flow -- Online Server Process
- (void)onRequestOnlineProcess:(NSString *)tlv{  //ESTE METODO ES EL QUE DEVUELVE LA DATA QUE NECESITAMOS PARA TLV

    NSDictionary *decodedTlv = [[BBDeviceController sharedController] decodeTlv:tlv];
    
    NSString *tempDisplayString = @"";
    NSString *type = @"TLV";
    NSString *C0 = @"";
    NSString *C2 = @"";
    NSArray *keys = [[decodedTlv allKeys] sortedArrayUsingSelector:@selector(localizedCompare:)];
    NSLog(@"test11111111");
    for (NSString *loopKey in keys) {
        tempDisplayString = [NSString stringWithFormat:@"%@\n\n%@: %@", tempDisplayString, loopKey, [decodedTlv objectForKey:loopKey]];
        //NSLog(@"RESULT: %@", tempDisplayString);
        
        
        
        if([loopKey isEqualToString:@"C0"]){
            NSLog(@"C0: %@", [decodedTlv objectForKey:loopKey]);
            C0 = [decodedTlv objectForKey:loopKey];
        }
        else if([loopKey isEqualToString:@"C2"]){
            NSLog(@"C2: %@", [decodedTlv objectForKey:loopKey]);
            C2 = [decodedTlv objectForKey:loopKey];
        }
        else if([loopKey isEqualToString:@"C4"]){
            NSLog(@"C4 CREDITCARD: %@", [decodedTlv objectForKey:loopKey]);
            numberCard = [decodedTlv objectForKey:loopKey];
        }
        else if([loopKey isEqualToString:@"5F24"]){
            NSString *exp = [decodedTlv objectForKey:loopKey];
            NSLog(@"EXPIRATION_CARD: %@", [[decodedTlv objectForKey:loopKey] substringWithRange:NSMakeRange(0, exp.length - 2)]);
            exp_card = [[decodedTlv objectForKey:loopKey] substringWithRange:NSMakeRange(0, exp.length - 2)];
        }
    }

    [self dataForm:numberCard :@"" :exp_card :type :@"" :@"" :C0 :C2];
    
}

#pragma mark -- Transaction Flow -- Output Transaction Result
- (void)onReturnTransactionResult:(BBDeviceTransactionResult)result{
    
    NSLog(@"onReturnTransactionResult - result: %d", (int)result);
    
}

- (NSString *)getTransactionResultString:(BBDeviceTransactionResult)transactionResult{
    NSString *returnString = @"";
    switch (transactionResult) {
        case BBDeviceTransactionResult_Approved:{ returnString = @"Approved"; break; }
        case BBDeviceTransactionResult_Terminated:{ returnString = @"Terminated"; break; }
        case BBDeviceTransactionResult_Declined:{ returnString = @"Declined"; break; }
        case BBDeviceTransactionResult_CanceledOrTimeout:{ returnString = @"CanceledOrTimeout"; break; }
        case BBDeviceTransactionResult_CapkFail:{ returnString = @"CapkFail"; break; }
        case BBDeviceTransactionResult_NotIcc:{ returnString = @"NotIcc"; break; }
        case BBDeviceTransactionResult_CardBlocked:{ returnString = @"CardBlocked"; break; }
        case BBDeviceTransactionResult_DeviceError:{ returnString = @"DeviceError"; break; }
        case BBDeviceTransactionResult_CardNotSupported:{ returnString = @"CardNotSupported"; break; }
        case BBDeviceTransactionResult_SelectApplicationFail:{ returnString = @"SelectApplicationFail"; break; }
        case BBDeviceTransactionResult_MissingMandatoryData:{ returnString = @"MissingMandatoryData"; break; }
        case BBDeviceTransactionResult_NoEmvApps:{ returnString = @"NoEmvApps"; break; }
        case BBDeviceTransactionResult_InvalidIccData:{ returnString = @"InvalidIccData"; break; }
        case BBDeviceTransactionResult_ConditionsOfUseNotSatisfied:{ returnString = @"ConditionsOfUseNotSatisfied"; break; }
        case BBDeviceTransactionResult_ApplicationBlocked:{ returnString = @"ApplicationBlocked"; break; }
        case BBDeviceTransactionResult_IccCardRemoved:{ returnString = @"IccCardRemoved"; break; }
        case BBDeviceTransactionResult_CardSchemeNotMatched:{ returnString = @"CardSchemeNotMatched"; break; }
        case BBDeviceTransactionResult_Canceled:{ returnString = @"Canceled"; break; }
        case BBDeviceTransactionResult_Timeout:{ returnString = @"Timeout"; break; }
        default:{ returnString = [NSString stringWithFormat:@"%d", (int)transactionResult]; break; }
    }
    return returnString;
}


//----------------------------------------- Error Handling ------------------------------------------------

#pragma mark - Error Handling

- (void)onError:(BBDeviceErrorType)errorType errorMessage:(NSString *)errorMessage{
    //ViewControllerLog(@"onError - errorType: %d, errorMessage: %@", (int)errorType, errorMessage);
    NSLog(@"onError - errorType: %d, errorMessage: %@", (int)errorType, errorMessage);
}

@end
