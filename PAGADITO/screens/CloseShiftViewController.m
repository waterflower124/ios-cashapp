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

@interface CloseShiftViewController () <UITableViewDelegate, UITableViewDataSource>

@property(strong, nonatomic)NSMutableArray *closing_shift;
@property(nonatomic)NSInteger closing_shift_index;

@end

@implementation CloseShiftViewController
@synthesize shift_array;
@synthesize TransV, shiftlistTableView;
@synthesize closeshiftAlertView, alertMessageLabel;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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
        cell.closeEstadoLabel.text = @"Estado: Carrado";
        cell.closeEstadoLabel.backgroundColor = UIColor.grayColor;
    } else {
        cell.closeEstadoLabel.text = @"Estado: Abierto";
        cell.closeEstadoLabel.backgroundColor = UIColor.greenColor;
    }
    cell.closeUsernameLabel.text = self.shift_array[indexPath.row][2];
    cell.closeFachaInicioLabel.text = self.shift_array[indexPath.row][5];
    if(self.shift_array[indexPath.row][6] == (NSString*)[NSNull null]) {
        cell.closeFachaFinLabel.text = @"---";
    } else {
        cell.closeFachaFinLabel.text = self.shift_array[indexPath.row][6];
    }
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
}

- (IBAction)backButtonAction:(id)sender {
    [self performSegueWithIdentifier:@"closeshifttoshiftlist_segue" sender:self];
}

- (IBAction)mainmenuSearchShiftButtonAction:(id)sender {
    [self performSegueWithIdentifier:@"closeshifttosearchshift_segue" sender:self];
}

- (IBAction)mainmenuAssignShiftButtonAction:(id)sender {
    [self performSegueWithIdentifier:@"closeshifttoassignshift_segue" sender:self];
}

-(void) reloadCloseShiftTableViewData:(CloseShiftTableViewCell *)sender :(NSInteger)index {
//    self.deleting_user = self.user_array[index];
//    self.deleting_user_tableview_index = index;
//    [self.user_array removeObjectAtIndex:index];
//    [self.usersTableView reloadData];
//    NSString *usernameLabelText = [NSString stringWithFormat:@"al usuario %@?", self.deleting_user[4]];
//    deleteUserNameLabel.text = usernameLabelText;
//    [TransV setHidden:NO];
//    [deleteAlertView setHidden:NO];
    self.closing_shift = self.shift_array[index];
    self.closing_shift_index = index;
    [self.shift_array removeObjectAtIndex:index];
    [self.shiftlistTableView reloadData];
    NSString *alertMessage = [NSString stringWithFormat:@"¿Seguro que deseas cerrar el turno de %@?", self.closing_shift[2]];
    self.alertMessageLabel.text = alertMessage;
    [self.TransV setHidden:NO];
    [self.closeshiftAlertView setHidden:NO];
}
- (IBAction)cancelCloseShiftButtonAction:(id)sender {
    NSLog(@"aaaa  %@", self.shift_array);
    [self.shift_array insertObject:self.closing_shift atIndex:self.closing_shift_index];
    NSLog(@"bbbb  %@", self.shift_array);
    [self.shiftlistTableView reloadData];
    [self.TransV setHidden:YES];
    [self.closeshiftAlertView setHidden:YES];
}

- (IBAction)okCloseShiftButtonAction:(id)sender {
}
@end
