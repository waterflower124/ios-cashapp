//
//  CloseShiftViewController.m
//  PAGADITO
//
//  Created by Water Flower on 2019/1/18.
//  Copyright © 2019 PAGADITO. All rights reserved.
//

#import "CloseShiftViewController.h"
#import "../SecondViewController.h"
#import "AssignShiftViewController.h"
#import "SearchShiftViewController.h"
#import "../tableviewcells/CloseShiftTableViewCell.h"
#import "ShiftListViewController.h"
#import "UserAdminViewController.h"
#import "WelcomeViewController.h"
#import "Global.h"
#import "AFNetworking.h"

@interface CloseShiftViewController () <UITableViewDelegate, UITableViewDataSource>

@property(strong, nonatomic)NSMutableArray *closing_shift;
@property(nonatomic)NSInteger closing_shift_index;
@property(strong, nonatomic)NSString *sessionInfoLabelText;

@property(strong, nonatomic)UIView *overlayView;
@property(strong, nonatomic)UIActivityIndicatorView * activityIndicator;

@end

@implementation CloseShiftViewController
@synthesize shift_array;
@synthesize TransV, shiftlistTableView, SidePanel, sessionInfoLabel;
@synthesize closeshiftAlertView, alertMessageLabel;
@synthesize homeButton, reportButton, configButton, usuarioButton, turnoButton, canceltransactionButton, newtransactionButton;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    Global *globals = [Global sharedInstance];
    //session info label
    self.sessionInfoLabelText = [NSString stringWithFormat:@"%@ / %@", globals.username, globals.nombreComercio];
    sessionInfoLabel.text = self.sessionInfoLabelText;
    
    /////////////////////////
    self.overlayView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.overlayView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    self.activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    self.activityIndicator.center = self.overlayView.center;
    [self.overlayView addSubview:self.activityIndicator];
    
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
    UITapGestureRecognizer *tapper = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideSidePanel:)];
    tapper.numberOfTapsRequired = 1;
    [TransV addGestureRecognizer:tapper];
}

-(void)hideSidePanel:(UIGestureRecognizer *)gesture{
    if([self.closeshiftAlertView isHidden]) {
        if (gesture.state == UIGestureRecognizerStateEnded) {
            
            [TransV setHidden:YES];
            [UIView transitionWithView:SidePanel duration:0.2 options:UIViewAnimationOptionCurveEaseIn animations:^{
                
                CGRect frame = self->SidePanel.frame;
                frame.origin.x = -self->SidePanel.frame.size.width;
                self->SidePanel.frame = frame;
                
            } completion:nil];
        }
    }
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.shift_array.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CloseShiftTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"closeshifttablecell"];
    if(cell == nil) {
        cell = [[CloseShiftTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"closeshifttablecell"];
    }
    cell.closeCodeShiftLabel.text = self.shift_array[indexPath.row][0];
    if([self.shift_array[indexPath.row][7] isEqualToString:@"0"]) {
        cell.closeEstadoLabel.text = @"Estado: Cerrado";
        cell.closeEstadoLabel.backgroundColor = UIColor.grayColor;
    } else {
        cell.closeEstadoLabel.text = @"Estado: Abierto";
        cell.closeEstadoLabel.backgroundColor = UIColor.greenColor;
    }
    cell.closeUsernameLabel.text = self.shift_array[indexPath.row][2];
    cell.closeFachaInicioLabel.text = self.shift_array[indexPath.row][5];
    cell.closeFachaFinLabel.text = self.shift_array[indexPath.row][6];
    
    [cell setCell_index:indexPath.row];
    cell.delegate = self;
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 100;
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([segue.identifier isEqualToString:@"closeshifttohome_segue"]) {
        SecondViewController *SecondVC;
        SecondVC = [segue destinationViewController];
    }
    if([segue.identifier isEqualToString:@"closeshifttosearchshift_segue"]) {
        SearchShiftViewController *SearchShiftVC;
        SearchShiftVC = [segue destinationViewController];
        SearchShiftVC.shift_array = self.shift_array;
    }
    if([segue.identifier isEqualToString:@"closeshifttoassignshift_segue"]) {
        AssignShiftViewController *AssignShiftVC;
        AssignShiftVC = [segue destinationViewController];
        AssignShiftVC.shift_array = self.shift_array;
    }
    if([segue.identifier isEqualToString:@"closeshifttoshiftlist_segue"]) {
        ShiftListViewController *ShiftListVC;
        ShiftListVC = [segue destinationViewController];
    }
    if([segue.identifier isEqualToString:@"closeshifttouseradmin_segue"]) {
        UserAdminViewController *UserAdminVC;
        UserAdminVC = [segue destinationViewController];
    }
    if([segue.identifier isEqualToString:@"closeshifttowelcome_segue"]) {
        WelcomeViewController *WelcomeVC;
        WelcomeVC = [segue destinationViewController];
    }
}

- (IBAction)backButtonAction:(id)sender {
    [self performSegueWithIdentifier:@"closeshifttoshiftlist_segue" sender:self];
}

- (IBAction)menuButtonAction:(id)sender {
    if([self.closeshiftAlertView isHidden]) {
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
}

- (IBAction)mainmenuSearchShiftButtonAction:(id)sender {
    [self performSegueWithIdentifier:@"closeshifttosearchshift_segue" sender:self];
}

- (IBAction)mainmenuAssignShiftButtonAction:(id)sender {
    [self performSegueWithIdentifier:@"closeshifttoassignshift_segue" sender:self];
}

-(void) reloadCloseShiftTableViewData:(CloseShiftTableViewCell *)sender :(NSInteger)index {
    if([self.shift_array[index][7] isEqualToString:@"1"]) {
        self.closing_shift = self.shift_array[index];
        self.closing_shift_index = index;
        [self.shift_array removeObjectAtIndex:index];
        [self.shiftlistTableView reloadData];
        NSString *alertMessage = [NSString stringWithFormat:@"¿Seguro que deseas cerrar el turno de %@?", self.closing_shift[2]];
        self.alertMessageLabel.text = alertMessage;
        [self.TransV setHidden:NO];
        [self.closeshiftAlertView setHidden:NO];
    } else {
        [self displayAlertView:@"Warning!" :@"This shift has already closed." :@"deny"];
    }
}
- (IBAction)cancelCloseShiftButtonAction:(id)sender {
    [self.shift_array insertObject:self.closing_shift atIndex:self.closing_shift_index];
    [self.shiftlistTableView reloadData];
    [self.TransV setHidden:YES];
    [self.closeshiftAlertView setHidden:YES];
}

- (IBAction)okCloseShiftButtonAction:(id)sender {
    [self.TransV setHidden:YES];
    [self.closeshiftAlertView setHidden:YES];
    
    [self.activityIndicator startAnimating];
    [self.view addSubview:self.overlayView];
    
    Global *globals = [Global sharedInstance];
    NSDictionary *closeShift = @{@"param": @{
                                        @"idUser": self.closing_shift[1],
                                        @"turnoCod": self.closing_shift[8]
                                        }};
    NSError *error;
    NSData *postData = [NSJSONSerialization dataWithJSONObject:closeShift options:0 error:&error];
    NSString *string = [[NSString alloc]initWithData:postData encoding:NSUTF8StringEncoding];
    NSDictionary *parameters = @{
                                 @"method": @"closeShift",
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
            [self displayAlertView:@"Success!" :@"Shift Closed" :@"success"];
        } else {
            [self displayAlertView:@"Warning!!" :@"An error has occured. Please contact support." :@"error"];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self.activityIndicator stopAnimating];
        [self.overlayView removeFromSuperview];
        [self displayAlertView:@"Warning!!" :@"Network error." :@"error"];
    }];
    
}

-(void)displayAlertView: (NSString *)header :(NSString *)message :(NSString *)status{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:header message:message preferredStyle:UIAlertControllerStyleAlert];
    
    UIApplication *actionOK = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if([status isEqualToString:@"deny"]) {
            [self.shiftlistTableView reloadData];
        } else if([status isEqualToString:@"success"]) {
            [self performSegueWithIdentifier:@"closeshifttoshiftlist_segue" sender:self];
        }
    }];
    [alert addAction:actionOK];
    [self presentViewController:alert animated:YES completion:nil];
}

- (IBAction)homeButtonAction:(id)sender {
    [self performSegueWithIdentifier:@"closeshifttohome_segue" sender:self];
}

- (IBAction)usuarioButtonAction:(id)sender {
    [self performSegueWithIdentifier:@"closeshifttouseradmin_segue" sender:self];
}

- (IBAction)turnoButtonAction:(id)sender {
    [self performSegueWithIdentifier:@"closeshifttoshiftlist_segue" sender:self];
}

- (IBAction)signoutButtonAction:(id)sender {
    [self performSegueWithIdentifier:@"closeshifttowelcome_segue" sender:self];
}
@end
