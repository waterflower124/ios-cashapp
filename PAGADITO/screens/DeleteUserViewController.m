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
#import "UserListTableViewCell.h"
#import "SearchUserViewController.h"

@interface DeleteUserViewController () <UITableViewDelegate, UITableViewDataSource>

@end

@implementation DeleteUserViewController
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
    }
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.user_array.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UserListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"userlisttableviewcell"];
    /*   set user full name and user name and image*/
    cell.userFullNameLabel.text = self.user_array[indexPath.row][1];
    cell.userNameLabel.text = self.user_array[indexPath.row][4];
    if([self.user_array[indexPath.row][3] isEqualToString:@"Supervisor"]) {/////supervisor
        cell.roleImageView.image = [UIImage imageNamed:@"user_supervisor_icon.png"];
    } else if([self.user_array[indexPath.row][3] isEqualToString:@"Cajero"]) {/////cajero
        cell.roleImageView.image = [UIImage imageNamed:@"user_cajero_icon.png"];    }
    
    return cell;
}

@end
