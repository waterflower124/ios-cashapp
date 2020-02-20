//
//  FileViewViewController.m
//  PAGADITO
//
//  Created by Javier Calderon  on 2019/3/22.
//  Copyright © 2019 PAGADITO. All rights reserved.
//

#import "FileViewViewController.h"
#import "TransactionsViewController.h"

@interface FileViewViewController ()

@end

@implementation FileViewViewController
@synthesize file_url, file_local, fileData;
@synthesize webView;
@synthesize sourceVC, shift_code, start_datetime, finish_datetime, userCajero, selectedTurnoCode;

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"%@", self.file_url);
    NSLog(@"%@", self.file_local);
    //NSURL *fileURL = [NSURL URLWithString:self.file_local];
    NSURL *fileURL = [NSURL fileURLWithPath:self.file_local];
    NSURLRequest *request = [NSURLRequest requestWithURL:fileURL];
    [webView loadRequest:request];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([segue.identifier isEqualToString:@"fileviewtotransactionview_segue"]) {
        TransactionsViewController *TransactionVC;
        TransactionVC = [segue destinationViewController];
        TransactionVC.start_datetime = self.start_datetime;
        TransactionVC.finish_datetime = self.finish_datetime;
        TransactionVC.userCajero = self.userCajero;
        TransactionVC.shift_code = self.shift_code;
        TransactionVC.sourceVC = self.sourceVC;
        TransactionVC.selectedTurnoCode = selectedTurnoCode;
    }
}

- (IBAction)backButtonAction:(id)sender {
    [self performSegueWithIdentifier:@"fileviewtotransactionview_segue" sender:self];
}

- (IBAction)shareButtonAction:(id)sender {
    NSArray* sharedObjects=[NSArray arrayWithObjects:self.fileData,  nil];
    UIActivityViewController *activityViewController = [[UIActivityViewController alloc] initWithActivityItems:sharedObjects applicationActivities:nil];
    activityViewController.popoverPresentationController.sourceView = self.view;
    [self presentViewController:activityViewController animated:YES completion:nil];
}
@end
