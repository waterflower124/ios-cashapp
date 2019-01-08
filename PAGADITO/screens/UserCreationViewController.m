//
//  UserCreationViewController.m
//  PAGADITO
//
//  Created by Water Flower on 2019/1/7.
//  Copyright © 2019 PAGADITO. All rights reserved.
//

#import "UserCreationViewController.h"
#import "LastCommercialInfoViewController.h"

@interface UserCreationViewController () <UITableViewDelegate, UITableViewDataSource>

@property(strong, nonatomic)NSMutableArray *role_list;

@property(strong, nonatomic)NSMutableArray *infoUserArray;

@property(strong, nonatomic)NSString *checkStatus;

@property(strong, nonatomic)NSString *name;
@property(strong, nonatomic)NSString *lastname;
@property(strong, nonatomic)NSString *username;
@property(strong, nonatomic)NSString *password;
@property(strong, nonatomic)NSString *confirmpassword;
@property(strong, nonatomic)NSString *pin_code;

@property(strong, nonatomic)NSDictionary *infoUserDic;


@end

@implementation UserCreationViewController

@synthesize roleTableView;
@synthesize nameTextField, lastnameTextField, usernameTextField, passwordTextField, confirmpwdTextField;
@synthesize selectRoleButton, continueButton, switchButton, checkBoxUIView, pincodeUIView, pincodeTextField;
@synthesize roleTableViewHeightConstraint;

int role_int = -1;


- (void)viewDidLoad {
    [super viewDidLoad];
    
    role_int = -1;
    self.checkStatus = @"1";
    self.infoUserArray = [[NSMutableArray alloc] init];
    self.role_list = [[NSMutableArray alloc] initWithObjects:@"Administrador", @"Administrador Único", nil];
    
    roleTableViewHeightConstraint.constant = 40 * self.role_list.count;
    
    [roleTableView setHidden:YES];
    [checkBoxUIView setHidden:YES];
    [pincodeUIView setHidden:YES];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)continueButtonAction:(id)sender {
    
    if(role_int == -1) {
        [self displayAlertView:@"Warning!" :@"Please select one of user role."];
        return;
    }
    NSLog(@"button click role int: %d", role_int);
    self.name = nameTextField.text;
    self.lastname = lastnameTextField.text;
    self.username = usernameTextField.text;
    self.password = passwordTextField.text;
    self.confirmpassword = confirmpwdTextField.text;
    self.pin_code = pincodeTextField.text;
    
    if((self.name.length == 0) || (self.lastname.length == 0) || (self.username.length == 0) || (self.password.length == 0) || (self.confirmpassword.length == 0)) {
        [self displayAlertView:@"Warning!" :@"Please fill all of data."];
        return;
    }
    if(self.password.length < 6) {
        [self displayAlertView:@"Warning!" :@"Password have to be at least 6 characters."];
        return;
    }
    if(![self.password isEqualToString:self.confirmpassword]) {
        [self displayAlertView:@"Warning!" :@"Password doesn't match."];
        return;
    }
    
    if(role_int == 4) {
        
        NSDictionary *dataUserDic = @{@"nombres":self.name, @"apellidos":self.lastname, @"idPrivilegio":@"4", @"username":self.username, @"password":self.password, @"shiftEveryday":self.checkStatus, @"codigoAprobacion":@""};
        [self.infoUserArray addObject:dataUserDic];
        self.infoUserDic = @{@"infoUsuario":self.infoUserArray};
        /****************
         go to next screen with infoUserArray
         ***************/
        [self performSegueWithIdentifier:@"creationtolast_segue" sender:nil];
    } else if(role_int == 1) {
        [self displayAlertView:@"Notice" :@"Usuario Guardado"];
        NSDictionary *dataUserDic = @{@"nombres":self.name, @"apellidos":self.lastname, @"idPrivilegio":@"1", @"username":self.username, @"password":self.password, @"shiftEveryday":@"0", @"codigoAprobacion":@""};
        [self.infoUserArray addObject:dataUserDic];
        role_int = 2;
        [selectRoleButton setTitle:@"Supervisor" forState:UIControlStateNormal];
        self.role_list = [[NSMutableArray alloc] initWithObjects:@"Supervisor", nil];
        [self.roleTableView reloadData];
        roleTableViewHeightConstraint.constant = 40 * self.role_list.count;
        [pincodeUIView setHidden:NO];
    } else if(role_int == 2) {
        [self displayAlertView:@"Notice" :@"Usuario Guardado"];
        NSDictionary *dataUserDic = @{@"nombres":self.name, @"apellidos":self.lastname, @"idPrivilegio":@"2", @"username":self.username, @"password":self.password, @"shiftEveryday":@"0", @"codigoAprobacion":self.pin_code};
        [self.infoUserArray addObject:dataUserDic];
        role_int = 3;
        [selectRoleButton setTitle:@"Cajero" forState:UIControlStateNormal];
        [continueButton setTitle:@"Guardar y continuar" forState:UIControlStateNormal];
        self.role_list = [[NSMutableArray alloc] initWithObjects:@"Cajero", nil];
        [self.roleTableView reloadData];
        roleTableViewHeightConstraint.constant = 40 * self.role_list.count;
        [pincodeUIView setHidden:YES];
        [checkBoxUIView setHidden:NO];
        [switchButton setOn:YES];
        self.checkStatus = @"1";
    } else if(role_int == 3) {
        NSDictionary *dataUserDic = @{@"nombres":self.name, @"apellidos":self.lastname, @"idPrivilegio":@"3", @"username":self.username, @"password":self.password, @"shiftEveryday":self.checkStatus, @"codigoAprobacion":@""};
        [self.infoUserArray addObject:dataUserDic];
        
        self.infoUserDic = @{@"infoUsuario":self.infoUserArray};
        
        /****************
         go to next screen with infoUserArray
         ***************/
        [self performSegueWithIdentifier:@"creationtolast_segue" sender:nil];
    }
    nameTextField.text = @"";
    lastnameTextField.text = @"";
    usernameTextField.text = @"";
    passwordTextField.text = @"";
    confirmpwdTextField.text = @"";
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([segue.identifier isEqualToString:@"creationtolast_segue"]) {
        LastCommercialInfoViewController *nextVC = segue.destinationViewController;
        self.providesPresentationContextTransitionStyle = YES;
        self.definesPresentationContext = YES;
        nextVC.infoUsuario = self.infoUserDic;
    }
}

- (IBAction)selectRoleButtonAction:(id)sender {
    if([roleTableView isHidden]) {
        [roleTableView setHidden:NO];
    } else {
        [roleTableView setHidden:YES];
    }
}

- (IBAction)switchAction:(id)sender {
    if(switchButton.on) {
        self.checkStatus = @"1";
    } else {
        self.checkStatus = @"0";
    }
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//    CGFloat numberOfRows =  self.role_list.count;
//
//    CGRect tableViewFrame = tableView.frame;
//    tableViewFrame.size.height = numberOfRows * 40.0f;
//    tableView.frame = tableViewFrame;
    
    return self.role_list.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"role_cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if(cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    cell.textLabel.text = self.role_list[indexPath.row];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [selectRoleButton setTitle:self.role_list[indexPath.row] forState:UIControlStateNormal];
    [roleTableView setHidden:YES];
    if(indexPath.row == 0) {
        if((role_int == -1) || (role_int == 4)) {// select adiministrator
            role_int = 1;
            [continueButton setTitle:@"Guardar y crear otro usuario" forState:UIControlStateNormal];
            [checkBoxUIView setHidden:YES];
        }
    } else if(indexPath.row == 1) { // select administrator unico
        role_int = 4;
        [checkBoxUIView setHidden:NO];
        [switchButton setOn:YES];
        self.checkStatus = @"1";
        [continueButton setTitle:@"Guardar y continuar" forState:UIControlStateNormal];
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 40.0f;
}

-(void)setHeightOfTableView
{
    
    /**** set frame size of tableview according to number of cells ****/
    CGFloat rowHeight = 40.0f;
    int tableHeight = rowHeight * self.role_list.count;
//    CGRect tableFrame = self.roleTableView.frame;
//    tableFrame.size.height = tableHeight;
//    self.roleTableView.frame = tableFrame;
    [self.roleTableView setFrame:(CGRect){roleTableView.frame.origin.x, roleTableView.frame.origin.y, self.roleTableView.frame.size.width, tableHeight}];

}

-(void)displayAlertView: (NSString *)header :(NSString *)message {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:header message:message preferredStyle:UIAlertControllerStyleAlert];
    UIApplication *actionOK = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"OK action");
    }];
    [alert addAction:actionOK];
    [self presentViewController:alert animated:YES completion:nil];
}

@end
