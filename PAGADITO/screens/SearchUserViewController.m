//
//  SearchUserViewController.m
//  PAGADITO
//
//  Created by Water Flower on 2019/1/14.
//  Copyright © 2019 PAGADITO. All rights reserved.
//

#import "SearchUserViewController.h"
#import "Global.h"
#import "DeleteUserViewController.h"
#import "EditUserViewController.h"
#import "InsertUserViewController.h"
#import "../tableviewcells/UserListTableViewCell.h"

@interface SearchUserViewController () <UITableViewDataSource, UITableViewDelegate>

@property(strong, nonatomic)NSMutableArray *showUsersArray;
@property(strong, nonatomic)NSString *searchWord;
@property(strong, nonatomic)NSString *userFullName;
@property(strong, nonatomic)NSString *user_name;

@end

@implementation SearchUserViewController
@synthesize SidePanel,MenuBtn,TransV;
@synthesize user_array;

@synthesize usersTableView, searchWordTextView;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer:tap];
    tap.cancelsTouchesInView = NO;
    
    
    UITapGestureRecognizer *tapper = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideSidePanel:)];
    tapper.numberOfTapsRequired = 1;
    [TransV addGestureRecognizer:tapper];
    
    [self.usersTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    self.showUsersArray = [[NSMutableArray alloc] initWithArray: self.user_array copyItems:YES];
//    self.showUsersArray = user_array;
    
    ////   add event whenever search text view text is changed
    [self.searchWordTextView addTarget:self action:@selector(searchWordTextViewDidChange) forControlEvents:UIControlEventEditingChanged];
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
    [self performSegueWithIdentifier:@"searchusertoinsertuser_segue" sender:self];
}

- (IBAction)deleteUserButtonAction:(id)sender {
    [self performSegueWithIdentifier:@"searchusertodeleteuser_segue" sender:self];
}

- (IBAction)editUserButtonAction:(id)sender {
    [self performSegueWithIdentifier:@"searchusertoedituser_segue" sender:self];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([segue.identifier isEqualToString:@"searchusertoinsertuser_segue"]) {
        InsertUserViewController *InsertUserVC;
        InsertUserVC = [segue destinationViewController];
        
    } else if([segue.identifier isEqualToString:@"searchusertodeleteuser_segue"]) {
        DeleteUserViewController *DeleteUserVC;
        DeleteUserVC = [segue destinationViewController];
        DeleteUserVC.user_array = self.user_array;
    } else if([segue.identifier isEqualToString:@"searchusertoedituser_segue"]) {
        EditUserViewController *EditUserVC;
        EditUserVC = [segue destinationViewController];
        EditUserVC.user_array = self.user_array;
    }
}

-(void)searchWordTextViewDidChange {
    self.searchWord = self.searchWordTextView.text;
    [self.showUsersArray removeAllObjects];
    if(self.searchWord.length > 0) {
        for (int i = 0; i < self.user_array.count; i ++) {
            self.user_name = self.user_array[i][4];
            self.userFullName = [NSString stringWithFormat:@"%@ %@", self.user_array[i][1], self.user_array[i][2]];
            if([self.user_name containsString: self.searchWord] || [self.userFullName containsString: self.searchWord]) {
                [self.showUsersArray addObject:self.user_array[i]];
            }
        }
    } else {
        self.showUsersArray = [[NSMutableArray alloc] initWithArray: self.user_array copyItems:YES];
    }
    [self.usersTableView reloadData];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.showUsersArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UserListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"userlisttableviewcell"];
    /*   set user full name and user name and image*/
    NSString *userfullname = [NSString stringWithFormat:@"%@ %@", self.showUsersArray[indexPath.row][1], self.showUsersArray[indexPath.row][2]];
    cell.userFullNameLabel.text = userfullname;
    cell.userNameLabel.text = self.showUsersArray[indexPath.row][4];
    if([self.showUsersArray[indexPath.row][3] isEqualToString:@"Supervisor"]) {/////supervisor
        cell.roleImageView.image = [UIImage imageNamed:@"user_supervisor_icon.png"];
    } else if([self.showUsersArray[indexPath.row][3] isEqualToString:@"Cajero"]) {/////cajero
        cell.roleImageView.image = [UIImage imageNamed:@"user_cajero_icon.png"];    }
    
    return cell;
}

@end
