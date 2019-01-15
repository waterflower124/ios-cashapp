//
//  EditUserViewController.m
//  PAGADITO
//
//  Created by Water Flower on 2019/1/14.
//  Copyright © 2019 PAGADITO. All rights reserved.
//

#import "EditUserViewController.h"
#import "Global.h"
#import "UserListTableViewCell.h"
#import "EditUserScreenViewController.h"
#import "DeleteUserViewController.h"
#import "InsertUserViewController.h"
#import "SearchUserViewController.h"

@interface EditUserViewController ()<UITableViewDelegate, UITableViewDataSource>

@property(nonatomic)NSInteger selected_index;

@end

@implementation EditUserViewController
@synthesize SidePanel,MenuBtn,TransV;
@synthesize user_array;
@synthesize usersTableView;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UITapGestureRecognizer *tapper = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideSidePanel:)];
    tapper.numberOfTapsRequired = 1;
    [TransV addGestureRecognizer:tapper];
    
    [self.usersTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
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



-(IBAction)buttonPressed:(id)sender{
    Global *globals = [Global sharedInstance];
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

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return user_array.count;
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

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    self.selected_index = indexPath.row;
    [self performSegueWithIdentifier:@"editusertoeditscreen_segue" sender:self];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([segue.identifier isEqualToString:@"editusertoeditscreen_segue"]) {
        EditUserScreenViewController *EditUserScreenVC;
        EditUserScreenVC = [segue destinationViewController];
        EditUserScreenVC.user_array = self.user_array;
        EditUserScreenVC.selected_index = self.selected_index;
    } else if([segue.identifier isEqualToString:@"editusertodeleteuser_segue"]) {
        DeleteUserViewController *DeleteUserVC;
        DeleteUserVC = [segue destinationViewController];
        DeleteUserVC.user_array = self.user_array;

    } else if([segue.identifier isEqualToString:@"editusertoinsertuser_segue"]) {
        InsertUserViewController *InsertUserVC;
        InsertUserVC = [segue destinationViewController];
       
        
    } else if([segue.identifier isEqualToString:@"editusertosearchuser_segue"]) {
        SearchUserViewController *SearchUserVC;
        SearchUserVC = [segue destinationViewController];
        SearchUserVC.user_array = self.user_array;
        
    }
}

- (IBAction)createUserButtonAction:(id)sender {
    [self performSegueWithIdentifier:@"editusertoinsertuser_segue" sender:self];
}

- (IBAction)deleteUserButtonAction:(id)sender {
    [self performSegueWithIdentifier:@"editusertodeleteuser_segue" sender:self];
}

- (IBAction)searchUserButtonAction:(id)sender {
    [self performSegueWithIdentifier:@"editusertosearchuser_segue" sender:self];
}
@end
