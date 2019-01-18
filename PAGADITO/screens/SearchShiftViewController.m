//
//  SearchShiftViewController.m
//  PAGADITO
//
//  Created by Water Flower on 2019/1/18.
//  Copyright © 2019 PAGADITO. All rights reserved.
//

#import "SearchShiftViewController.h"
#import "../tableviewcells/ShiftListTableViewCell.h"
#import "AssignShiftViewController.h"
#import "../SecondViewController.h"
#import "CloseShiftViewController.h"
#import "ShiftListViewController.h"

@interface SearchShiftViewController ()<UITableViewDataSource, UITableViewDelegate>

@property(strong, nonatomic)NSString *searchWord;
@property(strong, nonatomic)NSMutableArray *showShiftArray;

@end

@implementation SearchShiftViewController
@synthesize shift_array;
@synthesize shiftlistTableView;
@synthesize searchwordTextView;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    
    ////   add event whenever search text view text is changed
    [self.searchwordTextView addTarget:self action:@selector(searchWordTextViewDidChange) forControlEvents:UIControlEventEditingChanged];
    
    ////  array copy  /////
    self.showShiftArray = [[NSMutableArray alloc] initWithArray: self.shift_array copyItems:YES];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.showShiftArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ShiftListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"shifttablecell"];
    if(cell == nil) {
        cell = [[ShiftListTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"shifttablecell"];
    }
    cell.codeShiftLabel.text = self.showShiftArray[indexPath.row][0];
    if([self.showShiftArray[indexPath.row][7] isEqualToString:@"0"]) {
        cell.estadoLabel.text = @"Estado: Carrado";
        cell.estadoLabel.backgroundColor = UIColor.grayColor;
    } else {
        cell.estadoLabel.text = @"Estado: Abierto";
        cell.estadoLabel.backgroundColor = UIColor.greenColor;
    }
    cell.usernameLabel.text = self.showShiftArray[indexPath.row][2];
    cell.fachaInicioLabel.text = self.showShiftArray[indexPath.row][5];
    if(self.showShiftArray[indexPath.row][6] == (NSString*)[NSNull null]) {
        cell.fachaFinLabel.text = @"---";
    } else {
        cell.fachaFinLabel.text = self.showShiftArray[indexPath.row][6];
    }
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 100;
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
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
}

- (IBAction)backButtonAction:(id)sender {
    [self performSegueWithIdentifier:@"searchshifttoshiftlist_segue" sender:self];
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

@end
