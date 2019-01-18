//
//  AssignShiftViewController.m
//  PAGADITO
//
//  Created by Water Flower on 2019/1/18.
//  Copyright © 2019 PAGADITO. All rights reserved.
//

#import "AssignShiftViewController.h"
#import "../tableviewcells/ShiftListTableViewCell.h"
#import "AFNetworking.h"
#import "Global.h"
#import "../SecondViewController.h"
#import "SearchShiftViewController.h"
#import "CloseShiftViewController.h"
#import "ShiftListViewController.h"

@interface AssignShiftViewController ()<UITableViewDataSource, UITableViewDelegate>

@property(strong, nonatomic)NSMutableArray *cashier_array;
@property(strong, nonatomic)UIView *overlayView;
@property(strong, nonatomic)UIActivityIndicatorView * activityIndicator;

@property(strong, nonatomic)NSString *selected_cashierUserID;
@property(strong, nonatomic)NSString *shifEveryday;

@end

@implementation AssignShiftViewController
@synthesize shift_array;
@synthesize TransV, shiftlistTableView;
@synthesize assignturnoAlertView, selectcashierButton, cashierlistTableView, switchButton, cashierlistTableViewHeightConstraint;
@synthesize completeInsertShiftAlertView;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.cashier_array = [[NSMutableArray alloc] init];
    self.selected_cashierUserID = @"";
    self.shifEveryday = @"1";
    
    self.overlayView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.overlayView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    self.activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    self.activityIndicator.center = self.overlayView.center;
    [self.overlayView addSubview:self.activityIndicator];
    
    [self getCashierDisplayView];
    
}

-(void)getCashierDisplayView {
    Global *globals = [Global sharedInstance];
    
    [self.activityIndicator startAnimating];
    [self.view addSubview:self.overlayView];
    
    NSDictionary *infoComercio = @{@"infoComercio": @{
                                           @"idComercio": globals.idComercio,
                                           @"cashier": @"1",
                                           }};
    
    NSError *error;
    NSData *postData = [NSJSONSerialization dataWithJSONObject:infoComercio options:0 error:&error];
    NSString *string = [[NSString alloc]initWithData:postData encoding:NSUTF8StringEncoding];
    
    NSDictionary *parameters = @{
                                 @"method": @"getUsersPOS",
                                 @"param": string
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
        BOOL status = [jsonResponse[@"status"] boolValue];
        if(status) {
            
            NSMutableArray *jsonArray = jsonResponse[@"getUsersPOS"];
            NSArray *cashier = [[NSArray alloc] init];
            for(int i = 0; i < jsonArray.count; i ++) {
                cashier = @[jsonArray[i][@"idUser"], jsonArray[i][@"username"], jsonArray[i][@"removeAt"]];
                [self.cashier_array insertObject:cashier atIndex:i];
            }
            [self.cashierlistTableView reloadData];
            if(self.cashier_array.count * 40 < 100) {
                self.cashierlistTableViewHeightConstraint.constant = self.cashier_array.count * 40;
            } else {
                self.cashierlistTableViewHeightConstraint.constant = 100;
            }
            [self.TransV setHidden:NO];
            [self.assignturnoAlertView setHidden:NO];
        } else {
            [self displayAlertView:@"Notice!" :@"No Cashiers found! Please add a cashier."];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self.activityIndicator stopAnimating];
        [self.overlayView removeFromSuperview];
        [self displayAlertView:@"Warning!" :@"Network error."];
    }];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(tableView == shiftlistTableView) {
        return self.shift_array.count;
    } else {
        return self.cashier_array.count;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(tableView == shiftlistTableView) {
        ShiftListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"shifttablecell"];
        if(cell == nil) {
            cell = [[ShiftListTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"shifttablecell"];
        }
        cell.codeShiftLabel.text = self.shift_array[indexPath.row][0];
        if([self.shift_array[indexPath.row][7] isEqualToString:@"0"]) {
            cell.estadoLabel.text = @"Estado: Carrado";
            cell.estadoLabel.backgroundColor = UIColor.grayColor;
        } else {
            cell.estadoLabel.text = @"Estado: Abierto";
            cell.estadoLabel.backgroundColor = UIColor.greenColor;
        }
        cell.usernameLabel.text = self.shift_array[indexPath.row][2];
        cell.fachaInicioLabel.text = self.shift_array[indexPath.row][5];
        if(self.shift_array[indexPath.row][6] == (NSString*)[NSNull null]) {
            cell.fachaFinLabel.text = @"---";
        } else {
            cell.fachaFinLabel.text = self.shift_array[indexPath.row][6];
        }
        return cell;
    } else {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cashiertablecell"];
        if(cell == nil) {
            cell = [[ShiftListTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cashiertablecell"];
        }
        cell.textLabel.text = self.cashier_array[indexPath.row][1];
        return cell;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(tableView == shiftlistTableView) {
        return 100;
    } else {
        return 40;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if(tableView == self.cashierlistTableView) {
        [self.selectcashierButton setTitle:self.cashier_array[indexPath.row][1] forState:UIControlStateNormal];
        self.selected_cashierUserID = self.cashier_array[indexPath.row][0];
        [self.cashierlistTableView setHidden:YES];
    }
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([segue.identifier isEqualToString:@"assignshifttohome_segue"]) {
        SecondViewController *SecondVC;
        SecondVC = [segue destinationViewController];
    }
    if([segue.identifier isEqualToString:@"assignshifttosearchshift_segue"]) {
        SearchShiftViewController *SearchShiftVC;
        SearchShiftVC = [segue destinationViewController];
        SearchShiftVC.shift_array = self.shift_array;
    }
    if([segue.identifier isEqualToString:@"assignshifttocloseshift_segue"]) {
        CloseShiftViewController *CloseShiftVC;
        CloseShiftVC = [segue destinationViewController];
        CloseShiftVC.shift_array = self.shift_array;
    }
    if([segue.identifier isEqualToString:@"assignshifttoshiftlist_segue"]) {
        ShiftListViewController *ShiftListVC;
        ShiftListVC = [segue destinationViewController];
    }
}

- (IBAction)selectcashierButtonAction:(id)sender {
    if([self.cashierlistTableView isHidden]) {
        [self.cashierlistTableView setHidden:NO];
    } else {
        [self.cashierlistTableView setHidden:YES];
    }
}

- (IBAction)switchButtonAction:(id)sender {
    if(self.switchButton.on) {
        self.shifEveryday = @"1";
    } else {
        self.shifEveryday = @"0";
    }
}

- (IBAction)assignturnoCancelButtonAction:(id)sender {
    [self.TransV setHidden:YES];
    [self.assignturnoAlertView setHidden:YES];
    self.selected_cashierUserID = @"";
}

- (IBAction)assignturnoOKButtonAction:(id)sender {
    if(self.selected_cashierUserID.length == 0) {
        [self displayAlertView:@"Warning!" :@"Please select cashier."];
        return;
    }
    
    [self.TransV setHidden:YES];
    [self.assignturnoAlertView setHidden:YES];
    
    
    [self.activityIndicator startAnimating];
    [self.view addSubview:self.overlayView];
    
    Global *globals = [Global sharedInstance];
    NSDictionary *asignarTurno = @{@"asignarTurno": @{
                                           @"cmbUserAsign": self.selected_cashierUserID,
                                           @"idDispositivo": globals.idDispositivo,
                                           @"idUserSupervisor": globals.idUser,
                                           @"shiftEveryday": self.shifEveryday
                                           }};
    NSLog(@"%@", asignarTurno);
    NSError *error;
    NSData *postData = [NSJSONSerialization dataWithJSONObject:asignarTurno options:0 error:&error];
    NSString *string = [[NSString alloc]initWithData:postData encoding:NSUTF8StringEncoding];
    
    NSDictionary *parameters = @{
                                 @"method": @"insertShiftCode",
                                 @"param": string
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
        
        self.selected_cashierUserID = @"";
        NSString *status1 = jsonResponse[@"status1"];
        if([status1 isEqualToString:@"1"]) {
            [self.TransV setHidden:NO];
            [self.completeInsertShiftAlertView setHidden:NO];
            
        } else if([status1 isEqualToString:@"0"]) {
            [self displayAlertView:@"Warning!" :@"An error has occured. please contact support."];
        } else {
            [self displayAlertView:@"Warning!" :@"Cahier already as an active shift!"];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self.activityIndicator stopAnimating];
        [self.overlayView removeFromSuperview];
        [self displayAlertView:@"Warning!" :@"Network error."];
    }];
}

- (IBAction)backButtonAction:(id)sender {
    [self performSegueWithIdentifier:@"assignshifttoshiftlist_segue" sender:self];
}

- (IBAction)mainmenuSearchShiftButtonAction:(id)sender {
    [self performSegueWithIdentifier:@"assignshifttosearchshift_segue" sender:self];
}

- (IBAction)mainmenuAssignShiftButtonAction:(id)sender {
    self.cashier_array = [[NSMutableArray alloc] init];
    self.selected_cashierUserID = @"";
    [self.selectcashierButton setTitle:@"Select Cashier" forState:UIControlStateNormal];
    [switchButton setOn:YES];
    [self getCashierDisplayView];
}

- (IBAction)mainmenuCloseShiftButtonAction:(id)sender {
    [self performSegueWithIdentifier:@"assignshifttocloseshift_segue" sender:self];
}

- (IBAction)completeAlertViewContinueButtonAction:(id)sender {
    [self.TransV setHidden:YES];
    [self.completeInsertShiftAlertView setHidden:YES];
    [self performSegueWithIdentifier:@"assignshifttoshiftlist_segue" sender:self];
}

-(void)displayAlertView: (NSString *)header :(NSString *)message {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:header message:message preferredStyle:UIAlertControllerStyleAlert];
    
    UIApplication *actionOK = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"OK");
    }];
    [alert addAction:actionOK];
    [self presentViewController:alert animated:YES completion:nil];
}

@end