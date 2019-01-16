//
//  ShiftListViewController.m
//  PAGADITO
//
//  Created by Water Flower on 2019/1/16.
//  Copyright © 2019 PAGADITO. All rights reserved.
//

#import "ShiftListViewController.h"
#import "Global.h"
#import "../tableviewcells/ShiftListTableViewCell.h"
#import "AFNetworking.h"

@interface ShiftListViewController ()<UITableViewDelegate, UITableViewDataSource>

@property(strong, nonatomic)NSMutableArray *shift_array;

@property(strong, nonatomic)UIView *overlayView;
@property(strong, nonatomic)UIActivityIndicatorView * activityIndicator;

@end

@implementation ShiftListViewController
@synthesize shiftlistTableView, sessionInfoLabel;

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    [self.shiftlistTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    
//    self.shift_array = [[NSMutableArray alloc] initWithObjects:@"111", @"2222", @"333", nil];
  
    self.shift_array = [[NSMutableArray alloc] init];
    Global *globals = [Global sharedInstance];
    //session info label
    NSString *sessionInfoLabelText = [NSString stringWithFormat:@"%@ / %@", globals.username, globals.nombreComercio];
    sessionInfoLabel.text = sessionInfoLabelText;
    
    ///////////  get shift list from server
    self.overlayView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.overlayView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    self.activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    self.activityIndicator.center = self.overlayView.center;
    [self.overlayView addSubview:self.activityIndicator];
    
    [self.activityIndicator startAnimating];
    [self.view addSubview:self.overlayView];
    
    NSDictionary *infoShift = @{@"infoShift": @{
                                          @"idDispositivo": globals.idDispositivo,
                                          }};
    NSError *error;
    NSData *postData = [NSJSONSerialization dataWithJSONObject:infoShift options:0 error:&error];
    NSString *string = [[NSString alloc]initWithData:postData encoding:NSUTF8StringEncoding];
    NSDictionary *parameters = @{
                                 @"method": @"getAllShift",
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
                NSLog(@"%@", jsonResponse);
        if(status) {
            NSMutableArray *jsonArray = jsonResponse[@"getAllShift"];
            NSArray *shift = [[NSArray alloc] init];
            
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
//            NSDate *date = [dateFormatter dateFromString:@"2019-01-12 19:06:33"];
//            [dateFormatter setDateFormat:@"dd/MM/yyyy hh:mm a"];
//            NSString *newDate = [dateFormatter stringFromDate:date];
            NSDate *date;
            NSString *newDate;
            
            NSLog(@"%@", newDate);
            if(jsonArray.count > 0) {
                for(int i = 0; i < jsonArray.count; i ++) {
                    date = [dateFormatter dateFromString:jsonArray[i][@"fechaInicio"]];
                    [dateFormatter setDateFormat:@"dd/MM/yyyy hh:mm a"];
                    newDate = [dateFormatter stringFromDate:date];
                    
                    shift = @[jsonArray[i][@"codeShift"], jsonArray[i][@"idUser"], jsonArray[i][@"username"], jsonArray[i][@"nombres"],  jsonArray[i][@"apellidos"], newDate, jsonArray[i][@"fechaFin"], jsonArray[i][@"estado"]];
                    [self.shift_array insertObject: shift atIndex: i];
                }
                [self.shiftlistTableView reloadData];
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

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.shift_array.count;
}

-(ShiftListTableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ShiftListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"shifttablecell"];
    if(cell == nil) {
        cell = [[ShiftListTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"shifttablecell"];
    }
    cell.codeShiftLabel.text = self.shift_array[indexPath.row][0];
    if([self.shift_array[indexPath.row][7] isEqualToString:@"0"]) {
        cell.estadoLabel.text = @"Estado: Carrado";
        cell.estadoLabel.backgroundColor = UIColor.grayColor;
    } else {
        cell.estadoLabel.text = @"Estado: Abierto";
        cell.estadoLabel.backgroundColor = UIColor.greenColor;
    }
    cell.usernameLabel.text = self.shift_array[indexPath.row][2];
    cell.fachaInicioLabel.text = self.shift_array[indexPath.row][5];
    if(self.shift_array[indexPath.row][6] == (NSString*)[NSNull null]) {
        cell.fachaFinLabel.text = @"---";
    } else {
        cell.fachaFinLabel.text = self.shift_array[indexPath.row][6];
    }
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 100;
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
