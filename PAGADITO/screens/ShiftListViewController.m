//
//  ShiftListViewController.m
//  PAGADITO
//
//  Created by Water Flower on 2019/1/16.
//  Copyright © 2019 PAGADITO. All rights reserved.
//

#import "ShiftListViewController.h"
#import "Global.h"
#import "../tableviewcells/ShiftListTableViewCell.h"
#import "AFNetworking.h"
#import "../SecondViewController.h"
#import "AssignShiftViewController.h"
#import "SearchShiftViewController.h"
#import "CloseShiftViewController.h"
#import "UserAdminViewController.h"
#import "WelcomeViewController.h"

@interface ShiftListViewController ()<UITableViewDelegate, UITableViewDataSource>

@property(strong, nonatomic)NSMutableArray *shift_array;
@property(strong, nonatomic)NSMutableArray *cashier_array;

@property(strong, nonatomic)UIView *overlayView;
@property(strong, nonatomic)UIActivityIndicatorView * activityIndicator;

@end

@implementation ShiftListViewController
@synthesize shiftlistTableView, sessionInfoLabel;
@synthesize TransV, SidePanel;
@synthesize mainmenuCloseShiftButton, mainmenuAssignShiftButton, mainmenuSearchButton;
@synthesize homeButton, reportButton, configButton, usuarioButton, turnoButton, canceltransactionButton, newtransactionButton;

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    [self.shiftlistTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    
//    self.shift_array = [[NSMutableArray alloc] initWithObjects:@"111", @"2222", @"333", nil];
  
    self.shift_array = [[NSMutableArray alloc] init];
    self.cashier_array = [[NSMutableArray alloc] init];
    Global *globals = [Global sharedInstance];
    //session info label
    NSString *sessionInfoLabelText = [NSString stringWithFormat:@"%@ / %@", globals.username, globals.nombreComercio];
    sessionInfoLabel.text = sessionInfoLabelText;
    
    //////    side menu view action   ////////////////////
    UITapGestureRecognizer *tapper = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideSidePanel:)];
    tapper.numberOfTapsRequired = 1;
    [TransV addGestureRecognizer:tapper];
    //////////////////////////////
    
    ///////////////   side menu buttons configure   /////////////////
    if([globals.idPrivilegio isEqualToString:@"2"]) {
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
    /////////////////////////////////////////////////////
    
    ///////////  get shift list from server
    self.overlayView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.overlayView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    self.activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    self.activityIndicator.center = self.overlayView.center;
    [self.overlayView addSubview:self.activityIndicator];
    
    [self.activityIndicator startAnimating];
    [self.view addSubview:self.overlayView];
    
    NSDictionary *infoShift = @{@"infoShift": @{
                                          @"idDispositivo": globals.idDispositivo,
                                          }};
    NSError *error;
    NSData *postData = [NSJSONSerialization dataWithJSONObject:infoShift options:0 error:&error];
    NSString *string = [[NSString alloc]initWithData:postData encoding:NSUTF8StringEncoding];
    NSDictionary *parameters = @{
                                 @"method": @"getAllShift",
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
        Boolean status = [jsonResponse[@"status"] boolValue];
                NSLog(@"%@", jsonResponse);
        if(status) {
            NSMutableArray *jsonArray = jsonResponse[@"getAllShift"];
            NSArray *shift = [[NSArray alloc] init];
            
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            
//            NSDate *date = [dateFormatter dateFromString:@"2019-01-12 19:06:33"];
//            [dateFormatter setDateFormat:@"dd/MM/yyyy hh:mm a"];
//            NSString *newDate = [dateFormatter stringFromDate:date];
            NSDate *date;
            NSString *newDate;
            
            if(jsonArray.count > 0) {
                for(int i = 0; i < jsonArray.count; i ++) {
                    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
                    date = [dateFormatter dateFromString:jsonArray[i][@"fechaInicio"]];
                    [dateFormatter setDateFormat:@"dd/MM/yyyy hh:mm a"];
                    newDate = [dateFormatter stringFromDate:date];
                    shift = @[jsonArray[i][@"codeShift"], jsonArray[i][@"idUser"], jsonArray[i][@"username"], jsonArray[i][@"nombres"],  jsonArray[i][@"apellidos"], newDate, jsonArray[i][@"fechaFin"], jsonArray[i][@"estado"]];
                    [self.shift_array insertObject: shift atIndex: i];
                }
                [self.shiftlistTableView reloadData];
            } else {
                [self displayAlertView:@"Notice" :@"There is no users."];
            }
        } else {
            
        }
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self.activityIndicator stopAnimating];
        [self.overlayView removeFromSuperview];
        NSLog(@"bbbb %@", error);
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

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
        return self.shift_array.count;
    
}

-(ShiftListTableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
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
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
        return 100;
    
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([segue.identifier isEqualToString:@"shiftlisttohome_segue"]) {
        SecondViewController *SecondViewVC;
        SecondViewVC = [segue destinationViewController];
    }
    if([segue.identifier isEqualToString:@"shiftlisttoassignshift_segue"]) {
        AssignShiftViewController *AssignShiftVC;
        AssignShiftVC = [segue destinationViewController];
        AssignShiftVC.shift_array = self.shift_array;
    }
    if([segue.identifier isEqualToString:@"shiftlisttosearchshift_segue"]) {
        SearchShiftViewController *SearchShiftVC;
        SearchShiftVC = [segue destinationViewController];
        SearchShiftVC.shift_array = self.shift_array;
    }
    if([segue.identifier isEqualToString:@"shiftlisttocloseshift_segue"]) {
        CloseShiftViewController *CloseShiftVC;
        CloseShiftVC = [segue destinationViewController];
        CloseShiftVC.shift_array = self.shift_array;
    }
    if([segue.identifier isEqualToString:@"shiftlisttouseradmin_segue"]) {
        UserAdminViewController *UserAdminVC;
        UserAdminVC = [segue destinationViewController];
    }
    if([segue.identifier isEqualToString:@"shiftlisttowelcome_segue"]) {
        WelcomeViewController *WelcomeVC;
        WelcomeVC = [segue destinationViewController];
    }
}

-(void)displayAlertView: (NSString *)header :(NSString *)message {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:header message:message preferredStyle:UIAlertControllerStyleAlert];
    
    UIApplication *actionOK = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"");
    }];
    [alert addAction:actionOK];
    [self presentViewController:alert animated:YES completion:nil];
}


- (IBAction)backButtonAction:(id)sender {
    [self performSegueWithIdentifier:@"shiftlisttohome_segue" sender:self];
}

- (IBAction)mainmenuCloseShiftButtonAction:(id)sender {
    [self performSegueWithIdentifier:@"shiftlisttocloseshift_segue" sender:self];
}

- (IBAction)mainmenuAssignShiftButtonAction:(id)sender {
    [self performSegueWithIdentifier:@"shiftlisttoassignshift_segue" sender:self];
}

- (IBAction)mainmenuSearchButtonAction:(id)sender {
    [self performSegueWithIdentifier:@"shiftlisttosearchshift_segue" sender:self];
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
- (IBAction)homeButtonAction:(id)sender {
    [self performSegueWithIdentifier:@"shiftlisttohome_segue" sender:self];
}

- (IBAction)usuarioButtonAction:(id)sender {
    [self performSegueWithIdentifier:@"shiftlisttouseradmin_segue" sender:self];
}

- (IBAction)turnoButtonAction:(id)sender {
    [TransV setHidden:YES];
    [UIView transitionWithView:SidePanel duration:0.2 options:UIViewAnimationOptionCurveEaseIn animations:^{
        
        CGRect frame = self->SidePanel.frame;
        frame.origin.x = -self->SidePanel.frame.size.width;
        self->SidePanel.frame = frame;
        
    } completion:nil];
}

- (IBAction)signoutButtonAction:(id)sender {
    [self performSegueWithIdentifier:@"shiftlisttowelcome_segue" sender:self];
}
@end
