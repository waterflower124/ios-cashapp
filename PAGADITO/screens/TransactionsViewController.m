//
//  TransactionsViewController.m
//  PAGADITO
//
//  Created by Water Flower on 2019/1/23.
//  Copyright © 2019 PAGADITO. All rights reserved.
//

#import "TransactionsViewController.h"
#import "Global.h"
#import "AFNetworking.h"
#import "WelcomeViewController.h"
#import "../tableviewcells/TransactionsTableViewCell.h"

@interface TransactionsViewController ()<UITableViewDelegate, UITableViewDataSource, NSXMLParserDelegate>

@property(strong, nonatomic)NSString *sessionInfoLabelText;

@property(strong, nonatomic)UIView *overlayView;
@property(strong, nonatomic)UIActivityIndicatorView * activityIndicator;

@property(strong, nonatomic)NSMutableArray *transaction_array;
@property(strong, nonatomic)NSArray *transaction;

@property (strong, nonatomic) NSXMLParser *xmlTransactionsParser;
@property(strong, nonatomic) NSString *transaction_status;
@property(strong, nonatomic) NSString *transaction_token;
@property(strong, nonatomic) NSString *transaction_ern;
@property(strong, nonatomic) NSString *transaction_amount;
@property(strong, nonatomic) NSString *transaction_datetime;
@property(strong, nonatomic) NSString *transaction_reference;

@end

@implementation TransactionsViewController
@synthesize sourceVC, shift_code, start_datetime, finish_datetime;
@synthesize TransV, SidePanel, sessionInfoLabel, turnocodigoLabel, turnocodigoTitleLabel, transactionTableView;
@synthesize homeButton, reportButton, configButton, usuarioButton, turnoButton, canceltransactionButton, newtransactionButton;
@synthesize titleLabel, exportcommentLabel, sessioncommentLabel;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //////  init transaction array  //////
    self.transaction_array = [[NSMutableArray alloc] init];
    
    Global *globals = [Global sharedInstance];
    if(globals.selected_language == 0) {
        self.titleLabel.text = @"Transacciones";
        self.turnocodigoTitleLabel.text = @"Turno código:";
        self.exportcommentLabel.text = @"Exportar:";
        self.sessioncommentLabel.text = @"Sesión iniciada:";
    } else {
        self.titleLabel.text = @"Transactions";
        self.turnocodigoTitleLabel.text = @"Shift Code:";
        self.exportcommentLabel.text = @"Export:";
        self.sessioncommentLabel.text = @"Session started:";
    }
    
    /////////  TransV  tanp event   /////////
    UITapGestureRecognizer *tapper = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideSidePanel:)];
    tapper.numberOfTapsRequired = 1;
    [TransV addGestureRecognizer:tapper];
    
    //session info label
    self.sessionInfoLabelText = [NSString stringWithFormat:@"%@ / %@", globals.username, globals.nombreComercio];
    sessionInfoLabel.text = self.sessionInfoLabelText;
    
    //////////// init for activity indicator  /////////
    self.overlayView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.overlayView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    self.activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    self.activityIndicator.center = self.overlayView.center;
    [self.overlayView addSubview:self.activityIndicator];
    
    ///// set side menu buttons
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
    } else if([globals.idPrivilegio isEqualToString:@"2"]) {
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
        
    } else if([globals.idPrivilegio isEqualToString:@"4"]) {
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
    
    ////////   get transactions  /////////
    [self.activityIndicator startAnimating];
    [self.view addSubview:self.overlayView];
    NSDictionary *parameters;
    if([self.sourceVC isEqualToString:@"ShiftReportVC"] || [self.sourceVC isEqualToString:@"CashierShiftSearchVC"]) {
        NSDictionary *credentials = @{
                                        @"uid": globals.login_uid,
                                        @"wsk": globals.login_wsk,
                                        @"ambiente": globals.ambiente
                                    };
        NSDictionary *terminal = @{
                                      @"branch_office_id": globals.branchid,
                                      @"terminal_id": globals.terminalid
                                    };
        
        NSError *error;
        NSData *credentialsPostData = [NSJSONSerialization dataWithJSONObject:credentials options:0 error:&error];
        NSString *credentialsString = [[NSString alloc]initWithData:credentialsPostData encoding:NSUTF8StringEncoding];
        
        NSData *terminalPostData = [NSJSONSerialization dataWithJSONObject:terminal options:0 error:&error];
        NSString *terminalString = [[NSString alloc]initWithData:terminalPostData encoding:NSUTF8StringEncoding];
        
       parameters = @{
                         @"method": @"get_terminal_transactions_by_shift_mobil",
                         @"credentials": credentialsString,
                         @"terminal": terminalString,
                         @"shift_code": self.shift_code,
                         @"typeReport": @"2"
                     };
    } else if([self.sourceVC isEqualToString:@"TransactionReportVC"]) {
        NSDictionary *credentials = @{
                                      @"uid": globals.login_uid,
                                      @"wsk": globals.login_wsk,
                                      @"ambiente": globals.ambiente
                                      };
        NSDictionary *terminal = @{
                                   @"branch_office_id": globals.branchid,
                                   @"terminal_id": globals.terminalid
                                   };
        NSDictionary *period = @{
                                   @"start_datetime": self.start_datetime,
                                   @"finish_datetime": self.finish_datetime
                                   };
        NSLog(@"%@", period);
        NSError *error;
        NSData *credentialsPostData = [NSJSONSerialization dataWithJSONObject:credentials options:0 error:&error];
        NSString *credentialsString = [[NSString alloc]initWithData:credentialsPostData encoding:NSUTF8StringEncoding];
        
        NSData *terminalPostData = [NSJSONSerialization dataWithJSONObject:terminal options:0 error:&error];
        NSString *terminalString = [[NSString alloc]initWithData:terminalPostData encoding:NSUTF8StringEncoding];
        
        NSData *periodPostData = [NSJSONSerialization dataWithJSONObject:period options:0 error:&error];
        NSString *periodString = [[NSString alloc]initWithData:periodPostData encoding:NSUTF8StringEncoding];
        
        parameters = @{
                       @"method": @"get_terminal_transaction_mobil",
                       @"credentials": credentialsString,
                       @"terminal": terminalString,
                       @"period": periodString
                       };
    }
    AFHTTPSessionManager *sessionManager = [AFHTTPSessionManager manager];
    sessionManager.requestSerializer = [AFHTTPRequestSerializer serializer];
    sessionManager.responseSerializer = [AFHTTPResponseSerializer serializer];
    sessionManager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects: @"application/json", nil];
    [sessionManager POST: @"http://ninjahosting.us/web_api/service.php" parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        [self.activityIndicator stopAnimating];
        [self.overlayView removeFromSuperview];
        
        NSError *jsonError;
        NSDictionary *jsonResponse = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:&jsonError];
        NSLog(@"%@", jsonResponse);
        NSString *numberString = jsonResponse[@"value"][@"num_transactions"];
        NSInteger transactionCount = [numberString integerValue];
        if(transactionCount > 0) {
            if([self.sourceVC isEqualToString:@"ShiftReportVC"] || [self.sourceVC isEqualToString:@"CashierShiftSearchVC"]) {
                [self.turnocodigoTitleLabel setHidden:NO];
                [self.turnocodigoLabel setHidden:NO];
                self.turnocodigoLabel.text = jsonResponse[@"value"][@"shift_code"];
            } else if([self.sourceVC isEqualToString:@"TransactionReportVC"]) {
                [self.turnocodigoTitleLabel setHidden:YES];
                [self.turnocodigoLabel setHidden:YES];
            }
            
            NSString *xml_string = jsonResponse[@"value"][@"xml_transactions"];
            NSData *xmlData = [xml_string dataUsingEncoding:NSUTF8StringEncoding];
            self.xmlTransactionsParser = [[NSXMLParser alloc] initWithData:xmlData];
            self.xmlTransactionsParser.delegate = self;
            
            [self.xmlTransactionsParser parse];
            
        } else {
            [self displayAlertView:@"Notice!" :@"No transactions found."];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self.activityIndicator stopAnimating];
        [self.overlayView removeFromSuperview];
        [self displayAlertView:@"Warning!" :@"Network error."];
        NSLog(@"errororororor");
    }];
    ////////////
    
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

bool isTerminal_transaction = false;
bool isTransaction = false;
bool isTransaction_status = false;
bool isTransaction_token = false;
bool isTransaction_ern = false;
bool isTransaction_amount = false;
bool isTransaction_datetime = false;
bool isTransaction_reference = false;
-(void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary<NSString *,NSString *> *)attributeDict {
    if([elementName isEqualToString:@"terminal_transactions"]) {
        isTerminal_transaction = true;
    }
    if(isTerminal_transaction && [elementName isEqualToString:@"transaction"]) {
        isTransaction = true;
    }
    if(isTransaction && [elementName isEqualToString:@"transaction_status"]) {
        isTransaction_status = true;
    }
    if(isTransaction && [elementName isEqualToString:@"transaction_token"]) {
        isTransaction_token = true;
    }
    if(isTransaction && [elementName isEqualToString:@"transaction_ern"]) {
        isTransaction_ern = true;
    }
    if(isTransaction && [elementName isEqualToString:@"transaction_amount"]) {
        isTransaction_amount = true;
    }
    if(isTransaction && [elementName isEqualToString:@"transaction_datetime"]) {
        isTransaction_datetime = true;
    }
    if(isTransaction && [elementName isEqualToString:@"transaction_reference"]) {
        isTransaction_reference = true;
    }
}

-(void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {
    if([elementName isEqualToString:@"terminal_transactions"]) {
        [self.transactionTableView reloadData];
    }
    if([elementName isEqualToString:@"transaction"]) {
        self.transaction = [[NSArray alloc] init];
        self.transaction = @[self.transaction_status, self.transaction_token, self.transaction_ern, self.transaction_amount, self.transaction_datetime, self.transaction_reference];
        [self.transaction_array addObject:self.transaction];
        isTransaction = false;
    }
    if([elementName isEqualToString:@"transaction_status"]) {
        isTransaction_status = false;
    }
    if([elementName isEqualToString:@"transaction_token"]) {
        isTransaction_token = false;
    }
    if([elementName isEqualToString:@"transaction_ern"]) {
        isTransaction_ern = false;
    }
    if([elementName isEqualToString:@"transaction_amount"]) {
        isTransaction_amount = false;
    }
    if([elementName isEqualToString:@"transaction_datetime"]) {
        isTransaction_datetime = false;
    }
    if([elementName isEqualToString:@"transaction_reference"]) {
        isTransaction_reference = false;
    }
}

-(void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
    if(isTransaction && isTransaction_status) {
        self.transaction_status = string;
    }
    if(isTransaction && isTransaction_token) {
        self.transaction_token = string;
    }
    if(isTransaction && isTransaction_ern) {
        self.transaction_ern = string;
    }
    if(isTransaction && isTransaction_amount) {
        self.transaction_amount = string;
    }
    if(isTransaction && isTransaction_datetime) {
        self.transaction_datetime = string;
    }
    if(isTransaction && isTransaction_reference) {
        self.transaction_reference = string;
    }
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.transaction_array.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    Global *globals = [Global sharedInstance];
    TransactionsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"transactionstableviewcell"];
    if(cell == nil) {
        cell = [[TransactionsTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"transactionstableviewcell"];
    }
    NSString *amountLabelText = [NSString stringWithFormat:@"$%@", self.transaction_array[indexPath.row][3]];
    cell.transaction_amountLabel.text = amountLabelText;
    cell.transaction_ernLabel.text = self.transaction_array[indexPath.row][2];
    cell.transaction_datetimeLabel.text = self.transaction_array[indexPath.row][4];
    cell.transaction_referenceLabel.text = self.transaction_array[indexPath.row][5];
    cell.transaction_statusLabel.text = self.transaction_array[indexPath.row][0];
    if(globals.selected_language == 0) {
        cell.amountcommentLabel.text = @"Monto Total:";
        cell.erncommentLabel.text = @"ERN:";
        cell.fechacommentLabel.text = @"Fecha:";
        cell.referencecommentLabel.text = @"Referncia de pago:";
        cell.statuscommentLabel.text = @"Estado:";
    } else {
        cell.amountcommentLabel.text = @"Amount Charged:";
        cell.erncommentLabel.text = @"ERN:";
        cell.fechacommentLabel.text = @"Date:";
        cell.referencecommentLabel.text = @"Pay Reference:";
        cell.statuscommentLabel.text = @"Status:";
    }
    return cell;
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([segue.identifier isEqualToString:@"transactionstowelcome_segue"]) {
        WelcomeViewController *WelcomeVC;
        WelcomeVC = [segue destinationViewController];
    }
}

- (IBAction)signoutButtonAction:(id)sender {
    [self performSegueWithIdentifier:@"transactionstowelcome_segue" sender:self];
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


-(void)displayAlertView: (NSString *)header :(NSString *)message {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:header message:message preferredStyle:UIAlertControllerStyleAlert];
    UIApplication *actionOK = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"OK action");
    }];
    [alert addAction:actionOK];
    [self presentViewController:alert animated:YES completion:nil];
}


@end
