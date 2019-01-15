//
//  DeleteUserViewController.m
//  PAGADITO
//
//  Created by Water Flower on 2019/1/13.
//  Copyright © 2019 PAGADITO. All rights reserved.
//

#import "DeleteUserViewController.h"
#import "Global.h"
#import "EditUserViewController.h"
#import "InsertUserViewController.h"
#import "SearchUserViewController.h"
#import "AFNetworking.h"
#import "UserAdminViewController.h"
#import "DeletTableViewCell.h"


@interface DeleteUserViewController () <UITableViewDelegate, UITableViewDataSource>

@property(strong, nonatomic)NSMutableArray *deleting_user;
@property(nonatomic)NSInteger deleting_user_tableview_index;

@property(strong, nonatomic)UIView *overlayView;
@property(strong, nonatomic)UIActivityIndicatorView * activityIndicator;

@end

@implementation DeleteUserViewController
@synthesize SidePanel,MenuBtn,TransV;
@synthesize user_array;
@synthesize usersTableView;
@synthesize deleteAlertView, deleteUserNameLabel;


- (void)viewDidLoad {
    [super viewDidLoad];
    
    UITapGestureRecognizer *tapper = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideSidePanel:)];
    tapper.numberOfTapsRequired = 1;
    
    [TransV addGestureRecognizer:tapper];
   
    [self.usersTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];

    self.overlayView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.overlayView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    self.activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    self.activityIndicator.center = self.overlayView.center;
    [self.overlayView addSubview:self.activityIndicator];
}

-(void)hideSidePanel:(UIGestureRecognizer *)gesture{
    if([deleteAlertView isHidden]) {
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

-(IBAction)buttonPressed:(id)sender{
    Global *globals = [Global sharedInstance];
    if (sender == MenuBtn) {
        if([deleteAlertView isHidden]) {
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
}

- (IBAction)backButtonAction:(id)sender {
    [self performSegueWithIdentifier:@"deleteusertouseradmin_segue" sender:self];
}

- (IBAction)createUserButtonAction:(id)sender {
    [self performSegueWithIdentifier:@"deleteusertocreateuser_segue" sender:self];
}

- (IBAction)editUserButtonAction:(id)sender {
    [self performSegueWithIdentifier:@"deleteusertoedituser_segue" sender:self];
}

- (IBAction)searchUserButtonAction:(id)sender {
    [self performSegueWithIdentifier:@"deleteusertosearchuser_segue" sender:self];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([segue.identifier isEqualToString:@"deleteusertoedituser_segue"]) {
        EditUserViewController *EditUserVC;
        EditUserVC = [segue destinationViewController];
        EditUserVC.user_array = self.user_array;
    } else if([segue.identifier isEqualToString:@"deleteusertocreateuser_segue"]) {
        InsertUserViewController *InsertUserVC;
        InsertUserVC = [segue destinationViewController];
        
    } else if([segue.identifier isEqualToString:@"deleteusertosearchuser_segue"]) {
        SearchUserViewController *SearchUserVC;
        SearchUserVC = [segue destinationViewController];
        SearchUserVC.user_array = self.user_array;
    } else if([segue.identifier isEqualToString:@"deleteusertouseradmin_segue"]) {
        UserAdminViewController *UserAdminVC;
        UserAdminVC = [segue destinationViewController];
    }
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.user_array.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    DeletTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"deletusertableviewcell"];
    /*   set user full name and user name and image*/
    NSString *userfullname = [NSString stringWithFormat:@"%@ %@", self.user_array[indexPath.row][1], self.user_array[indexPath.row][2]];
    cell.fullnameLabel.text = userfullname;
    cell.usernameLabel.text = self.user_array[indexPath.row][4];
    if([self.user_array[indexPath.row][3] isEqualToString:@"Supervisor"]) {/////supervisor
        cell.logoimageview.image = [UIImage imageNamed:@"user_supervisor_icon.png"];
    } else if([self.user_array[indexPath.row][3] isEqualToString:@"Cajero"]) {/////cajero
        cell.logoimageview.image = [UIImage imageNamed:@"user_cajero_icon.png"];
    }
    [cell setCellIndex:indexPath.row];
    cell.delegate = self;
    return cell;
    
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"deletusertableviewcell"];
//    cell.textLabel.text = @"22222";
//    return cell;
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"%ld", (long)indexPath.row);
}

-(void) reloadDeleteTableViewData:(DeletTableViewCell *)sender :(NSInteger)index {
    self.deleting_user = self.user_array[index];
    self.deleting_user_tableview_index = index;
    [self.user_array removeObjectAtIndex:index];
    [self.usersTableView reloadData];
    NSString *usernameLabelText = [NSString stringWithFormat:@"al usuario %@?", self.deleting_user[4]];
    deleteUserNameLabel.text = usernameLabelText;
    [TransV setHidden:NO];
    [deleteAlertView setHidden:NO];
}

- (IBAction)deleteUserCancelButtonAction:(id)sender {
    [self.user_array insertObject:self.deleting_user atIndex:_deleting_user_tableview_index];
    [self.usersTableView reloadData];
    [TransV setHidden:YES];
    [deleteAlertView setHidden:YES];
    
}

- (IBAction)deleteUserOKButtonAction:(id)sender {
    [TransV setHidden:YES];
    [deleteAlertView setHidden:YES];
    
    [self.activityIndicator startAnimating];
    [self.view addSubview:self.overlayView];
    
    NSDictionary *deleteUser = @{@"deleteUser": @{
                                          @"idUser": self.deleting_user[0]
                                          }};

    
    NSError *error;
    NSData *postData = [NSJSONSerialization dataWithJSONObject:deleteUser options:0 error:&error];
    NSString *string = [[NSString alloc]initWithData:postData encoding:NSUTF8StringEncoding];
    
    NSDictionary *parameters = @{
                                 @"method": @"deleteSystemUsers",
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
            [self displayAlertView:@"Success!" :@"User delete succesfully."];
        } else {
            [self displayAlertView:@"Warning!" :@"There has been an error deleting this user."];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self.activityIndicator stopAnimating];
        [self.overlayView removeFromSuperview];
        NSLog(@"bbbb %@", error);
    }];
    
}

-(void)displayAlertView: (NSString *)header :(NSString *)message {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:header message:message preferredStyle:UIAlertControllerStyleAlert];
    
    UIApplication *actionOK = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if([header isEqualToString:@"Success!"]) {
            [self performSegueWithIdentifier:@"deleteusertouseradmin_segue" sender:self];
        }
    }];
    [alert addAction:actionOK];
    [self presentViewController:alert animated:YES completion:nil];
}

@end
