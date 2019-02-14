//
//  ProcessTransactionViewController.m
//  PAGADITO
//
//  Created by Water Flower on 2019/2/4.
//  Copyright © 2019 PAGADITO. All rights reserved.
//

#import "ProcessTransactionViewController.h"
#import "Global.h"
#import "WelcomeViewController.h"
#import "AFNetworking.h"
#import "TransactionResultViewController.h"

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

@end

@implementation ProcessTransactionViewController
@synthesize TransV, SidePanel;
@synthesize homeButton, reportButton, configButton, usuarioButton, turnoButton, canceltransactionButton, newtransactionButton;
@synthesize transactionAmount, sessionInfoLabel;
@synthesize transactionAmountLabel, crediccardImageView, cardNumberTextField, CVVTextField, monthTableVIew, yearTableView, taxSwitchButton;
@synthesize titleLabel, amountLabel, maincommentLabel, cardnumberLabel, cardholdernameLabel, expiredateLabel, descriptionLabel, checkBoxLabel, processtransactionButton, contactsupportButton, sessioncommentLabel;


- (void)viewDidLoad {
    [super viewDidLoad];
    
    Global *globals = [Global sharedInstance];
    if(globals.selected_language == 0) {
        self.titleLabel.text = @"Procesar transacción";
        self.amountLabel.text = @"Monto a cobrar:";
        self.maincommentLabel.text = @"Desliza la tarjeta y completa los campos requeridos.";
        self.cardnumberLabel.text = @"Número de tarjeta";
        self.cardholdernameLabel.text = @"Nombre de la tarjeta";
        self.expiredateLabel.text = @"Fecha de Expiración";
        self.descriptionLabel.text = @"Descripción (opcional)";
        self.descriptionTextField.placeholder = @"Usuario";
        self.checkBoxLabel.text = @"Los impuestos están incluidos.";
        [self.processtransactionButton setTitle:@"Procesar transacción" forState:UIControlStateNormal];
        [self.contactsupportButton setTitle:@"Contactar a Soporte" forState:UIControlStateNormal];
        self.sessioncommentLabel.text = @"Sesión iniciada:";
    } else {
        self.titleLabel.text = @"Process Transaction";
        self.amountLabel.text = @"Amount to charge:";
        self.maincommentLabel.text = @"Slide card and input all required fields.";
        self.cardnumberLabel.text = @"Card number";
        self.cardholdernameLabel.text = @"Card holder name";
        self.expiredateLabel.text = @"Expiration date";
        self.descriptionLabel.text = @"Description (optional)";
        self.descriptionTextField.placeholder = @"User";
        self.checkBoxLabel.text = @"Taxes are included.";
        [self.processtransactionButton setTitle:@"Process transaction" forState:UIControlStateNormal];
        [self.contactsupportButton setTitle:@"Contact support" forState:UIControlStateNormal];
        self.sessioncommentLabel.text = @"Session statred:";
    }

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
    [numberFormatter setMaximumFractionDigits:10];
    /////////
    
    NSString * formattedString = [NSString stringWithFormat:@"%@", [numberFormatter stringForObjectValue:amountDecimal]];
    self.transactionAmountLabel.text = [NSString stringWithFormat:@"$%@", formattedString];
    
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
        
        CGRect canceltransactionButtonFrame = self.canceltransactionButton.frame;
        canceltransactionButtonFrame.origin.x = 0;
        canceltransactionButtonFrame.origin.y = 60;
        self.canceltransactionButton.frame = canceltransactionButtonFrame;
        UIView *canceltransactionlineView = [[UIView alloc] initWithFrame:CGRectMake(0, 59, canceltransactionButton.frame.size.width, 1)];
        canceltransactionlineView.backgroundColor = [UIColor lightGrayColor];
        [self.canceltransactionButton addSubview:canceltransactionlineView];
        
        CGRect newtransactionButtonFrame = self.newtransactionButton.frame;
        newtransactionButtonFrame.origin.x = 0;
        newtransactionButtonFrame.origin.y = 120;
        self.newtransactionButton.frame = newtransactionButtonFrame;
        UIView *newtransactiolineView = [[UIView alloc] initWithFrame:CGRectMake(0, 59, newtransactionButton.frame.size.width, 1)];
        newtransactiolineView.backgroundColor = [UIColor lightGrayColor];
        [self.newtransactionButton addSubview:newtransactiolineView];
        
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
        
        ///////////////////////////////
        
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

-(NSString *)getCreditCardTypeByNumber: (NSString *) creditCardNum {
    NSString *regVisa = @"^4[0-9]{12}(?:[0-9]{3})?$";
    NSString *regMaster = @"^5[1-5][0-9]{14}$";
    NSString *regExpress = @"^3[47][0-9]{13}$";
    NSString *regDiners = @"^3(?:0[0-5]|[68][0-9])[0-9]{11}$";
    NSString *regDiscover = @"^6(?:011|5[0-9]{2})[0-9]{12}$";
    NSString *regJCB = @"^(?:2131|1800|35\\d{3})\\d{11}$";
    
    NSString *cardType = @"";
    NSArray *cardTypeArray = @[regVisa, regMaster, regExpress, regDiners, regDiscover, regJCB];
    NSPredicate *checkVisaCardType;
    for(int i = 0; i < cardTypeArray.count; i ++) {
        checkVisaCardType = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", cardTypeArray[i]];
        if([checkVisaCardType evaluateWithObject: creditCardNum] == YES) {
            if(i == 0) {
                cardType = @"VISA";
            } else if(i == 1) {
                cardType = @"MASTERCARD";
            } else if(i == 2) {
                cardType = @"AMEX";
            } else if(i == 3) {
                cardType = @"DINERS";
            } else if(i == 4) {
                cardType = @"discover";
            } else if(i == 5) {
                cardType = @"jcb";
            } else {
                cardType = @"invlaid";
            }
        } else {
            cardType = @"invalid";
        }
    }
    return @"invalid";
}

- (IBAction)processtransactionButtonAction:(id)sender {
    Global *globals = [Global sharedInstance];
    self.cardNumber = self.cardNameTextField.text;
    self.cardHolderName = self.cardNameTextField.text;
    self.CVV = self.CVVTextField.text;
    self.descriptiontxt = self.descriptionTextField.text;
    self.expire_date = [NSString stringWithFormat:@"%@%@", self.selected_year, self.selected_month];
    
//    self.cardNumber = @"5564362752814906";
//    self.cardHolderName = @"test holder name";
//    self.CVV = @"281";
    
    if(self.cardNumber.length < 15 && self.cardNumber.length > 16) {
        if(globals.selected_language == 0) {
            [self displayAlertView:@"¡Advertencia!" :@"Su tarjeta de crédito debe tener 15 o 16 dígitos." :@"nil"];
        } else {
            [self displayAlertView:@"Warning!" :@"Your credit card number must have 15 or 16 digits." :@"nil"];
        }
        return;
    }
    if(self.cardHolderName.length == 0) {
        if(globals.selected_language == 0) {
            [self displayAlertView:@"¡Advertencia!" :@"Por favor ingrese su nombre." :@"nil"];
        } else {
            [self displayAlertView:@"Warning!" :@"Please input name." :@"nil"];
        }
        return;
    }
    if(self.CVV.length < 3 && self.CVV.length > 4) {
        if(globals.selected_language == 0) {
            [self displayAlertView:@"¡Advertencia!" :@"El CVV debe tener entre 3 a 4 dígitos." :@"nil"];
        } else {
            [self displayAlertView:@"Warning!" :@"CVV have to be 3 or 4 characters." :@"nil"];
        }
        return;
    }
    if([self.selected_year isEqualToString:@""] || [self.selected_month isEqualToString:@""]) {
        if(globals.selected_language == 0) {
            [self displayAlertView:@"¡Advertencia!" :@"Por favor seleccione fecha de expiración." :@"nil"];
        } else {
            [self displayAlertView:@"Warning!" :@"Please select expire date." :@"nil"];
        }
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
    
    NSDictionary *card = @{
                           @"pan": self.cardNumber,
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
                                 @"card": postCardString
                                 };
    
    AFHTTPSessionManager *sessionManager = [AFHTTPSessionManager manager];
    sessionManager.requestSerializer = [AFHTTPRequestSerializer serializer];
    sessionManager.responseSerializer = [AFHTTPResponseSerializer serializer];
    sessionManager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects: @"application/json", nil];
    [sessionManager POST: @"http://ninjahosting.us/web_api/service.php" parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        [self.activityIndicator stopAnimating];
        [self.overlayView removeFromSuperview];
        
        NSError *jsonError;
        NSDictionary *jsonResponse = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:&jsonError];

        if([jsonResponse[@"code"] isEqualToString:@"PG1019"]) {
            self.dataTransaction = jsonResponse;
            NSString *last4digits = [self.cardNumber substringFromIndex:[self.cardNumber length] - 4];
            [self.dataTransaction setValue:last4digits forKey:@"card"];
            [self.dataTransaction setValue:globals.nombreComercio forKey:@"comercio"];
            [self.dataTransaction setValue:[self getCreditCardTypeByNumber:self.cardNumber] forKey:@"type"];
            [self.dataTransaction setValue:self.cardHolderName forKey:@"name"];
            [self.dataTransaction setValue:self.transactionAmount forKey:@"amount"];
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
            [self displayAlertView:@"¡Advertencia!" :@"Error de red." :@"nil"];
        } else {
            [self displayAlertView:@"Warning!" :@"Network error." :@"nil"];
        }
    }];
    
}

-(void)insertTransations: (NSString *)total_amount :(NSDictionary *)data :(NSString *)descripton_para {
    Global *globals = [Global sharedInstance];
    NSLog(@"12345:  %@", total_amount);
    
    [self.activityIndicator startAnimating];
    [self.view addSubview:self.overlayView];
    
    NSDictionary *insertTransactions = @{
                               @"total": total_amount,
                               @"ern": data[@"ern"],
                               @"referencia": data[@"reference"],
                               @"fecha": data[@"date_trans"],
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
                                 @"param": postinsertTransactionsString
                                 };
    
    AFHTTPSessionManager *sessionManager = [AFHTTPSessionManager manager];
    sessionManager.requestSerializer = [AFHTTPRequestSerializer serializer];
    sessionManager.responseSerializer = [AFHTTPResponseSerializer serializer];
    sessionManager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects: @"application/json", nil];
    [sessionManager POST: @"http://ninjahosting.us/web_api/service.php" parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        [self.activityIndicator stopAnimating];
        [self.overlayView removeFromSuperview];
        
        NSError *jsonError;
        NSDictionary *jsonResponse = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:&jsonError];
        NSLog(@"wewewewe:   %@", jsonResponse);
        BOOL status = [jsonResponse[@"status"] boolValue];
        if(status) {
            if(globals.selected_language == 0) {
                [self displayAlertView:@"¡Felicidades!" :@"Transacción realizada exitosamente!." :@"transaction_result"];
            } else {
                [self displayAlertView:@"Congratulations!" :@"Transaction successful!." :@"transaction_result"];
            }
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
            [self displayAlertView:@"¡Advertencia!" :@"Error de red." :@"nil"];
        } else {
            [self displayAlertView:@"Warning!" :@"Network error." :@"nil"];
        }
    }];
    
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if(textField == self.cardNumberTextField) {
        const char * _char = [string cStringUsingEncoding:NSUTF8StringEncoding];
        int isBackSpace = strcmp(_char, "\b");
        
        if (isBackSpace == -8) {
            NSLog(@"Backspace was pressed");
            return YES;
        }
        
        BOOL canEdit=NO;
        NSCharacterSet *myCharSet = [NSCharacterSet characterSetWithCharactersInString:@"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz"];
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
    } else {
        return YES;
    }
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(tableView == self.monthTableVIew) {
        return self.month_array.count;
    } else {
        return self.year_array.count;
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
    } else {
        static NSString *cellIdentifier = @"year_cell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if(cell == nil) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        }
        cell.textLabel.text = self.year_array[indexPath.row];
        return cell;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if(tableView == self.monthTableVIew) {
        [self.monthselectButton setTitle:self.month_array[indexPath.row] forState:UIControlStateNormal];
        self.selected_month = self.month_array[indexPath.row];
        [self.monthTableVIew setHidden:YES];
    } else {
        [self.yearselectButton setTitle:self.year_array[indexPath.row] forState:UIControlStateNormal];
        self.selected_year = self.year_array[indexPath.row];
        [self.yearTableView setHidden:YES];
    }
}

-(void)displayAlertView: (NSString *)header :(NSString *)message :(NSString *) nextscreen {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:header message:message preferredStyle:UIAlertControllerStyleAlert];
    
    UIApplication *actionOK = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if([nextscreen isEqualToString:@"transaction_result"]) {
            [self performSegueWithIdentifier:@"processtransactiontoresult_segue" sender:self];
        }
    }];
    [alert addAction:actionOK];
    [self presentViewController:alert animated:YES completion:nil];
}
@end
