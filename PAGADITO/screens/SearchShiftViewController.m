//
//  SearchShiftViewController.m
//  PAGADITO
//
//  Created by Javier Calderon  on 2019/1/18.
//  Copyright © 2019 PAGADITO. All rights reserved.
//

#import "SearchShiftViewController.h"
#import "../tableviewcells/ShiftListTableViewCell.h"
#import "AssignShiftViewController.h"
#import "../SecondViewController.h"
#import "CloseShiftViewController.h"
#import "ShiftListViewController.h"
#import "UserAdminViewController.h"
#import "WelcomeViewController.h"
#import "Global.h"
#import "AFNetworking.h"

@interface SearchShiftViewController ()<UITableViewDataSource, UITableViewDelegate>

@property(strong, nonatomic)NSString *searchWord;
@property(strong, nonatomic)NSMutableArray *showShiftArray;
@property(strong, nonatomic)NSString *sessionInfoLabelText;

@property(strong, nonatomic)UIView *overlayView;
@property(strong, nonatomic)UIActivityIndicatorView * activityIndicator;

@end

@implementation SearchShiftViewController
@synthesize shift_array;
@synthesize shiftlistTableView;
@synthesize searchwordTextView;
@synthesize TransV, sessionInfoLabel;
@synthesize SidePanel, homeButton, reportButton, configButton, usuarioButton, turnoButton, canceltransactionButton, newtransactionButton, logoutButton, cerraturnoButton;
@synthesize titleLabel, closeshiftButtonLabel, assignshiftButtonLabel, searchshiftButtonLabel, codeheadLabel, usernameheadLabel, timedateheadLabel, sessioncommentLabel;

- (void)viewDidLoad {
    [super viewDidLoad];

    Global *globals = [Global sharedInstance];
    if(globals.selected_language == 0) {
        self.titleLabel.text = @"Listado de turnos";
        self.closeshiftButtonLabel.text = @"Cerrar";
        self.assignshiftButtonLabel.text = @"Asignar";
        self.searchshiftButtonLabel.text = @"Buscar";
        self.codeheadLabel.text = @"Codigo";
        self.usernameheadLabel.text = @"Usuario";
        self.timedateheadLabel.text = @"Fecha/hora";
        self.sessioncommentLabel.text = @"Sesión iniciada:";
        searchwordTextView.placeholder = @"Buscar...";
    } else {
        self.titleLabel.text = @"Shift List";
        self.closeshiftButtonLabel.text = @"Close";
        self.assignshiftButtonLabel.text = @"Assign";
        self.searchshiftButtonLabel.text = @"Search";
        self.codeheadLabel.text = @"Code";
        self.usernameheadLabel.text = @"Username";
        self.timedateheadLabel.text = @"Time/Date";
        self.sessioncommentLabel.text = @"Session started:";
        searchwordTextView.placeholder = @"Search...";
    }
    
    [self setMenuButtonsicon];
    
    //session info label
    self.sessionInfoLabelText = [NSString stringWithFormat:@"%@ / %@", globals.username, globals.nombreComercio];
    sessionInfoLabel.text = self.sessionInfoLabelText;
    
    ////   add event whenever search text view text is changed
    [self.searchwordTextView addTarget:self action:@selector(searchWordTextViewDidChange) forControlEvents:UIControlEventEditingChanged];
    
    ///////  dismiss keyboard  //////
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer:tap];
    tap.cancelsTouchesInView = NO;
    
    ////  array copy  /////
    self.showShiftArray = [[NSMutableArray alloc] initWithArray: self.shift_array copyItems:YES];
    
    /////////////////////////
    self.overlayView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.overlayView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    self.activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    self.activityIndicator.center = self.overlayView.center;
    [self.overlayView addSubview:self.activityIndicator];
    
    ///////////////   side menu buttons configure   /////////////////
    if([globals.idPrivilegio isEqualToString:@"2"]) {
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
        
        [self.configButton setHidden:YES];
        [self.newtransactionButton setHidden:YES];
        [self.canceltransactionButton setHidden:YES];
        [self.cerraturnoButton setHidden:YES];
        
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
        
        [self.cerraturnoButton setHidden:YES];
        
    }
    /////////////////////////////////////////////////////
    //////    side menu view action   ////////////////////
    UITapGestureRecognizer *tapper = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideSidePanel:)];
    tapper.numberOfTapsRequired = 1;
    [TransV addGestureRecognizer:tapper];
    //////////////////////////////
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

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.showShiftArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    Global *globals = [Global sharedInstance];
    ShiftListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"shifttablecell"];
    if(cell == nil) {
        cell = [[ShiftListTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"shifttablecell"];
    }
    cell.codeShiftLabel.text = self.showShiftArray[indexPath.row][0];
    if([self.shift_array[indexPath.row][7] isEqualToString:@"0"]) {
        if(globals.selected_language == 0) {
            cell.estadoLabel.text = @"Estado: Cerrado";
        } else {
            cell.estadoLabel.text = @"Status: Closed";
        }
        cell.estadoLabel.backgroundColor = UIColor.grayColor;
    } else {
        if(globals.selected_language == 0) {
            cell.estadoLabel.text = @"Estado: Abierto";
        } else {
            cell.estadoLabel.text = @"Status: Open";
        }
        cell.estadoLabel.backgroundColor = UIColor.greenColor;
    }
    cell.usernameLabel.text = self.showShiftArray[indexPath.row][2];
    cell.fachaInicioLabel.text = self.showShiftArray[indexPath.row][5];
    cell.fachaFinLabel.text = self.showShiftArray[indexPath.row][6];
    if(globals.selected_language == 0) {
        cell.fechaInicio_commentLabel.text = @"Inicio:";
        cell.Fin_commentLabel.text = @"Fin:";
    } else {
        cell.fechaInicio_commentLabel.text = @"Start:";
        cell.Fin_commentLabel.text = @"End:";
    }
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 100;
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([segue.identifier isEqualToString:@"searchshifttowelcome_segue"]) {
        WelcomeViewController *WelcomeVC;
        WelcomeVC =  [segue destinationViewController];
    }
    if([segue.identifier isEqualToString:@"searchshifttohome_segue"]) {
        SecondViewController *SecondVC;
        SecondVC =  [segue destinationViewController];
    }
    if([segue.identifier isEqualToString:@"searchshifttoassignshift_segue"]) {
        AssignShiftViewController *AssignShiftVC;
        AssignShiftVC =  [segue destinationViewController];
        AssignShiftVC.shift_array = self.shift_array;
    }
    if([segue.identifier isEqualToString:@"searchshifttocloseshift_segue"]) {
        CloseShiftViewController *CloseShiftVC;
        CloseShiftVC =  [segue destinationViewController];
        CloseShiftVC.shift_array = self.shift_array;
    }
    if([segue.identifier isEqualToString:@"searchshifttoshiftlist_segue"]) {
        ShiftListViewController *ShiftListVC;
        ShiftListVC =  [segue destinationViewController];
    }
    if([segue.identifier isEqualToString:@"searchshifttouseradmin_segue"]) {
        UserAdminViewController *UserAdminVC;
        UserAdminVC =  [segue destinationViewController];
    }
}

- (IBAction)backButtonAction:(id)sender {
    [self performSegueWithIdentifier:@"searchshifttoshiftlist_segue" sender:self];
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

- (IBAction)mainmenuAssignShiftButtonAction:(id)sender {
    [self performSegueWithIdentifier:@"searchshifttoassignshift_segue" sender:self];
}

- (IBAction)mainmenuCloseShiftButtonAction:(id)sender {
    [self performSegueWithIdentifier:@"searchshifttocloseshift_segue" sender:self];
}

-(void)searchWordTextViewDidChange {
    self.searchWord = self.searchwordTextView.text;
    [self.showShiftArray removeAllObjects];
    if(self.searchWord.length > 0) {
        for(int i = 0; i < self.shift_array.count; i ++) {
            if(self.shift_array[i][6] == (NSString*)[NSNull null]) {
                if( [self.shift_array[i][0] containsString:self.searchWord] || [self.shift_array[i][2] containsString:self.searchWord] || [self.shift_array[i][5] containsString:self.searchWord] || [self.shift_array[i][7] containsString:self.searchWord] ) {
                    [self.showShiftArray addObject:self.shift_array[i]];
                }
            } else {
                if( [self.shift_array[i][0] containsString:self.searchWord] || [self.shift_array[i][2] containsString:self.searchWord] || [self.shift_array[i][5] containsString:self.searchWord] || [self.shift_array[i][6] containsString:self.searchWord] || [self.shift_array[i][7] containsString:self.searchWord] ) {
                    [self.showShiftArray addObject:self.shift_array[i]];
                }
            }
        }
    } else {
        self.showShiftArray = [[NSMutableArray alloc] initWithArray: self.shift_array copyItems:YES];
    }
    [self.shiftlistTableView reloadData];
}

- (IBAction)homeButtonAction:(id)sender {
    [self performSegueWithIdentifier:@"searchshifttohome_segue" sender:self];
}

- (IBAction)usuarionButtonAction:(id)sender {
    [self performSegueWithIdentifier:@"searchshifttouseradmin_segue" sender:self];
}

- (IBAction)turnoButtonAction:(id)sender {
    [self performSegueWithIdentifier:@"searchshifttoshiftlist_segue" sender:self];
}

- (IBAction)signoutButtonAction:(id)sender {
    [self performSegueWithIdentifier:@"searchshifttowelcome_segue" sender:self];
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
            [self performSegueWithIdentifier:@"searchshifttowelcome_segue" sender:self];
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

-(void)displayAlertView: (NSString *)header :(NSString *)message :(NSString *)status{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:header message:message preferredStyle:UIAlertControllerStyleAlert];
    
    UIApplication *actionOK = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [alert addAction:actionOK];
    [self presentViewController:alert animated:YES completion:nil];
}

@end
