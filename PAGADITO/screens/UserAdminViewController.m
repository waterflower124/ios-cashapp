//
//  UserAdminViewController.m
//  PAGADITO
//
//  Created by Water Flower on 2019/1/12.
//  Copyright © 2019 PAGADITO. All rights reserved.
//

#import "UserAdminViewController.h"
#import "Global.h"
#import "../tableviewcells/UserListTableViewCell.h"
#import "AFNetworking.h"
#import "InsertUserViewController.h"
#import "EditUserViewController.h"
#import "DeleteUserViewController.h"
#import "SearchUserViewController.h"

@interface UserAdminViewController () <UITableViewDelegate, UITableViewDataSource>

@property(strong, nonatomic)NSString *sessionInfoLabelText;
@property(strong, nonatomic)NSMutableArray *user_array;

@property(strong, nonatomic)UIView *overlayView;
@property(strong, nonatomic)UIActivityIndicatorView * activityIndicator;

@end

@implementation UserAdminViewController
@synthesize SidePanel, MenuBtn, TransV;
@synthesize sessionInfoLabel;
@synthesize usersTableView;
@synthesize createuserbutton, deleteuserButton, edituserButton, searchuserButton;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.user_array = [[NSMutableArray alloc] init];
    [self.usersTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    
    UITapGestureRecognizer *tapper = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideSidePanel:)];
    tapper.numberOfTapsRequired = 1;
    [TransV addGestureRecognizer:tapper];
    
    Global *globals = [Global sharedInstance];
    //session info label
    self.sessionInfoLabelText = [NSString stringWithFormat:@"%@ / %@", globals.username, globals.nombreComercio];
    sessionInfoLabel.text = self.sessionInfoLabelText;
    
    ///////////  get all users from server
    self.overlayView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.overlayView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    self.activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    self.activityIndicator.center = self.overlayView.center;
    [self.overlayView addSubview:self.activityIndicator];
    
    [self.activityIndicator startAnimating];
    [self.view addSubview:self.overlayView];
    
    NSDictionary *infoUsuario = @{@"infoUsuario": @{
                                          @"idComercio": globals.idComercio,
                                          @"idPrivilegio": globals.idPrivilegio
                                          }};
    NSError *error;
    NSData *postData = [NSJSONSerialization dataWithJSONObject:infoUsuario options:0 error:&error];
    NSString *string = [[NSString alloc]initWithData:postData encoding:NSUTF8StringEncoding];
    NSDictionary *parameters = @{
                                 @"method": @"getAllUsers",
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
//        NSLog(@"%@", jsonResponse);
        if(status) {
            NSMutableArray *jsonArray = jsonResponse[@"allUsers"];
            NSArray *user = [[NSArray alloc] init];
            if(jsonArray.count > 0) {
                for(int i = 0; i < jsonArray.count; i ++) {
                    user = @[jsonArray[i][@"idUser"], jsonArray[i][@"nombres"], jsonArray[i][@"apellidos"], jsonArray[i][@"rol"], jsonArray[i][@"username"], jsonArray[i][@"password"], jsonArray[i][@"codigoAprobacion"]];
                    [self.user_array insertObject: user atIndex: i];
                }
                [self.usersTableView reloadData];
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
    return self.user_array.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UserListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"userlisttableviewcell"];
    /*   set user full name and user name and image*/
    NSString *userfullname = [NSString stringWithFormat:@"%@ %@", self.user_array[indexPath.row][1], self.user_array[indexPath.row][2]];
    cell.userFullNameLabel.text = userfullname;
    cell.userNameLabel.text = self.user_array[indexPath.row][4];
    if([self.user_array[indexPath.row][3] isEqualToString:@"Supervisor"]) {/////supervisor
        cell.roleImageView.image = [UIImage imageNamed:@"user_supervisor_icon.png"];
    } else if([self.user_array[indexPath.row][3] isEqualToString:@"Cajero"]) {/////cajero
        cell.roleImageView.image = [UIImage imageNamed:@"user_cajero_icon.png"];    }
    
    return cell;
}

-(IBAction)buttonPressed:(id)sender{
    
    if (sender == MenuBtn) {
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
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    Global *globals = [Global sharedInstance];
    if([segue.identifier isEqualToString:@"admintocreateuser_segue"]) {
        InsertUserViewController *InsertUserVC;
        InsertUserVC = [segue destinationViewController];
        InsertUserVC.user_role = globals.idPrivilegio;
    } else if([segue.identifier isEqualToString:@"useradmintoedit_segue"]) {
        EditUserViewController *EditUserVC;
        EditUserVC = [segue destinationViewController];
        EditUserVC.user_array = self.user_array;
    } else if([segue.identifier isEqualToString:@"useradmintodeleteuser_segue"]) {
        DeleteUserViewController *DeleteUserVC;
        DeleteUserVC = [segue destinationViewController];
        DeleteUserVC.user_array = self.user_array;
    } else if([segue.identifier isEqualToString:@"useradmintosearchuser_segue"]) {
        SearchUserViewController *SearchUserVC;
        SearchUserVC = [segue destinationViewController];
        SearchUserVC.user_array = self.user_array;
    }
}

- (IBAction)createuserButtonAction:(id)sender {
    [self performSegueWithIdentifier:@"admintocreateuser_segue" sender:self];
}

- (IBAction)deleteuserButtonAction:(id)sender {
    [self performSegueWithIdentifier:@"useradmintodeleteuser_segue" sender:self];
}

- (IBAction)edituserButtonAction:(id)sender {
    [self performSegueWithIdentifier:@"useradmintoedit_segue" sender:self];
}

- (IBAction)searchuserButtonAction:(id)sender {
    [self performSegueWithIdentifier:@"useradmintosearchuser_segue" sender:self];
    
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
