//
//  LastCommercialInfoViewController.m
//  PAGADITO
//
//  Created by Water Flower on 2019/1/7.
//  Copyright © 2019 PAGADITO. All rights reserved.
//

#import "LastCommercialInfoViewController.h"
#import "WelcomeViewController.h"
#import "AFNetworking.h"
#import "Global.h"

#include <sys/socket.h>
#include <sys/sysctl.h>
#include <net/if.h>
#include <net/if_dl.h>
#include <ifaddrs.h>
#include <arpa/inet.h>

@interface LastCommercialInfoViewController () <UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITableViewDelegate, UITableViewDataSource>

@property(strong, nonatomic)UIView *overlayView;
@property(strong, nonatomic)UIActivityIndicatorView * activityIndicator;

@property(strong, nonatomic)NSString *macAddress;
@property(strong, nonatomic)NSString *IPAddress;
@property(strong, nonatomic)NSString *osName;
@property(strong, nonatomic)NSString *osVersion;

@property(strong, nonatomic)NSString *commercialName;
@property(strong, nonatomic)NSString *commercialEmail;
@property(strong, nonatomic)NSString *commercialNumber;
@property(strong, nonatomic)NSString *terminalName;
@property(strong, nonatomic)NSString *currencyUnit;

@property(strong, nonatomic)NSMutableArray *currencyNameArray;
@property(strong, nonatomic)NSMutableArray *currencyUnitArray;

@end

@implementation LastCommercialInfoViewController

@synthesize logoImageView, commercialNameTextField, commercialEmailTextField, commercialNumberTextField, terminalNameTextField, currencyTableView, selectCurrencyButton;
@synthesize infoUsuario;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    /////  initialization ////
    self.currencyNameArray = [[NSMutableArray alloc] initWithObjects:@"($) Dólares Americanos", @"(Q) Quetzales", @"(L) Lempiras", @"(C$) Córdobas", @"(₡) Colones Costarricenses", @"(B/.) Balboas", @"(RD$) Pesos Dominicanos", nil];
    self.currencyUnitArray = [[NSMutableArray alloc] initWithObjects:@"USD", @"GTQ", @"HNL", @"NIO", @"CRC", @"PAB", @"DOP", nil];
    
    self.commercialName = @"";
    self.commercialNumber = @"";
    self.commercialEmail = @"";
    self.terminalName = @"";
    self.currencyUnit = @"";
//////////////////////////////////////
    
    [currencyTableView setHidden:YES ];
    
    self.macAddress =[self getMacAddress];
    self.IPAddress =[self getIPAddress];
    self.osName = [[UIDevice currentDevice] systemName];
    self.osVersion = [[UIDevice currentDevice] systemVersion];
    
    
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(logoImageViewTapDetected)];
    singleTap.numberOfTapsRequired = 1;
    [logoImageView setUserInteractionEnabled:YES];
    [logoImageView addGestureRecognizer:singleTap];
    
    
    self.overlayView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.overlayView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    self.activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    self.activityIndicator.center = self.overlayView.center;
    [self.overlayView addSubview:self.activityIndicator];
    
}

- (IBAction)selectCurrencyButtonAction:(id)sender {
    if([currencyTableView isHidden]) {
        [currencyTableView setHidden:NO];
    } else {
        [currencyTableView setHidden:YES];
    }
}

- (IBAction)continueButtonAction:(id)sender {
    self.commercialName = commercialNameTextField.text;
    self.commercialNumber = commercialNumberTextField.text;
    self.commercialEmail = commercialEmailTextField.text;
    self.terminalName = terminalNameTextField.text;
    if((self.commercialName.length == 0) || (self.commercialName.length == 0) || (self.commercialName.length == 0) || (self.commercialName.length == 0) || (self.currencyUnit.length == 0)) {
        [self displayAlertView:@"Warning!" :@"Please fill all of the fields."];
        return;
    } else {
        
        [self.activityIndicator startAnimating];
        [self.view addSubview:self.overlayView];
        
        Global *globals = [Global sharedInstance];
        NSDictionary *comercio = @{
                                      @"uid": globals.uid,
                                      @"wsk": globals.wsk,
                                      @"llaveCifrado": globals.private_key,
                                      @"cifradoIV": globals.initialization_vector,
                                      @"nombreComercio": self.commercialName,
                                      @"emailComercio": self.commercialEmail,
                                      @"numeroRegistro": self.commercialNumber
                                      };
        NSDictionary *dispositivo = @{
                                           @"nombreTerminal": self.terminalName,
                                           @"branchid": globals.office_id,
                                           @"terminalid": globals.terminal_id,
                                           @"mac": self.macAddress,
                                           @"moneda": self.currencyUnit,
                                           @"ambiente": @"0",
                                           @"tipoDispositivo": @"Mobile",
                                           @"ipInstalacion": self.IPAddress,
                                           @"sistemaOperativoInstalacion": self.osName,
                                           @"versionSOInstalacion": self.osVersion
                                           };
        
        NSError *error;
        NSData *infoUsuarioData = [NSJSONSerialization dataWithJSONObject:infoUsuario options:0 error:&error];
        NSString *infoUsuarioString = [[NSString alloc]initWithData:infoUsuarioData encoding:NSUTF8StringEncoding];
        
        NSDictionary *param = @{
                                    @"comercio": comercio,
                                    @"dispositivo": dispositivo,
                                    @"infoUsuario": infoUsuarioString
                                };
        NSData *paramData = [NSJSONSerialization dataWithJSONObject:param options:0 error:&error];
        NSString *paramString = [[NSString alloc]initWithData:paramData encoding:NSUTF8StringEncoding];
        
        NSDictionary *parameters = @{
                                     @"method": @"insertSetBranchOffice",
                                     @"param": paramString
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
                [self displayAlertView:@"Congratulations!" :@"INSTALLATION SUCCESSFUL!"];
            } else {
                [self displayAlertView:@"Warning!" :@"FAILED INSTALLATION, CONTACT SUPPORT!"];
            }

        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            [self.activityIndicator stopAnimating];
            [self.overlayView removeFromSuperview];
            NSLog(@"bbbb %@", error);
        }];
        
    }
}

-(void)logoImageViewTapDetected {
    
    UIAlertController *logoImageAlertView = [UIAlertController alertControllerWithTitle:@"Choose Image" message:@"Pick Image from:" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction* gallery = [UIAlertAction
                             actionWithTitle:@"Gallery"
                             style:UIAlertActionStyleDefault
                             handler:^(UIAlertAction * action)
                             {
                                     UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
                                     imagePicker.delegate = self;
                                     imagePicker.allowsEditing = YES;
                                     imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                                     [self presentViewController:imagePicker animated:YES completion:nil];
                             }];
    
    UIAlertAction* camera = [UIAlertAction
                         actionWithTitle:@"Camera"
                         style:UIAlertActionStyleDefault
                         handler:^(UIAlertAction * action)
                         {
                             UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
                             imagePicker.delegate = self;
                             imagePicker.allowsEditing = YES;
                             imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
                             [self presentViewController:imagePicker animated:YES completion:nil];
                         }];
    
    UIAlertAction* cancel = [UIAlertAction
                           actionWithTitle:@"Cancel"
                           style:UIAlertActionStyleDefault
                           handler:^(UIAlertAction * action)
                           {
                               NSLog(@"Cancel     ");
                           }];
    
    [logoImageAlertView addAction:gallery] ;
    [logoImageAlertView addAction:camera];
    [logoImageAlertView addAction:cancel];
    [self presentViewController:logoImageAlertView animated:YES completion:nil];
    
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<UIImagePickerControllerInfoKey,id> *)info {
    UIImage *selectedImage = info[UIImagePickerControllerEditedImage];
    self.logoImageView.image = selectedImage;
    [picker dismissViewControllerAnimated:YES completion:nil];
    

    NSString *stringPath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)objectAtIndex:0]stringByAppendingPathComponent:@"pagadito"];
    // New Folder is your folder name
    NSError *error = nil;
    if (![[NSFileManager defaultManager] fileExistsAtPath:stringPath])
        [[NSFileManager defaultManager] createDirectoryAtPath:stringPath withIntermediateDirectories:NO attributes:nil error:&error];
    
    NSString *fileName = [stringPath stringByAppendingFormat:@"/pagadito_logo.png"];
    NSData *imageData = UIImagePNGRepresentation(selectedImage);
//    NSLog(@"Image size:: %lu::", (unsigned long)[imageData length]);
    if([imageData length] < 2 * 1024 * 1024) {
        [imageData writeToFile:fileName atomically:YES];
        Global *globals = [Global sharedInstance];
        globals.logo_imagePath = fileName;
    } else {
        [self displayAlertView:@"Warning!" :@"Logo Image have to be less than 2MB. Please select another image"];
    }
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.currencyNameArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if(cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    cell.textLabel.text = self.currencyNameArray[indexPath.row];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [selectCurrencyButton setTitle:self.currencyNameArray[indexPath.row] forState:UIControlStateNormal];
    self.currencyUnit = self.currencyUnitArray[indexPath.row];
    [currencyTableView setHidden:YES ];
}

-(void)displayAlertView: (NSString *)header :(NSString *)message {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:header message:message preferredStyle:UIAlertControllerStyleAlert];
    
    UIApplication *actionOK = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if([message isEqualToString:@"INSTALLATION SUCCESSFUL!"]) {
            [self performSegueWithIdentifier:@"lasttowelcome_segue" sender:self];
        }
    }];
    [alert addAction:actionOK];
    [self presentViewController:alert animated:YES completion:nil];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([segue.identifier isEqualToString:@"lasttowelcome_segue"]) {
        WelcomeViewController *nextVC = segue.destinationViewController;
//        self.providesPresentationContextTransitionStyle = YES;
//        self.definesPresentationContext = YES;
    }
}

// get the IP address of current-device
- (NSString *)getIPAddress {
    NSString *address = @"error";
    struct ifaddrs *interfaces = NULL;
    struct ifaddrs *temp_addr = NULL;
    int success = 0;
    // retrieve the current interfaces - returns 0 on success
    success = getifaddrs(&interfaces);
    if (success == 0) {
        // Loop through linked list of interfaces
        temp_addr = interfaces;
        while(temp_addr != NULL) {
            if(temp_addr->ifa_addr->sa_family == AF_INET) {
                // Check if interface is en0 which is the wifi connection on the iPhone
                if([[NSString stringWithUTF8String:temp_addr->ifa_name] isEqualToString:@"en0"]) {
                    // Get NSString from C String
                    address = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)temp_addr->ifa_addr)->sin_addr)];
                }
            }
            temp_addr = temp_addr->ifa_next;
        }
    }
    freeifaddrs(interfaces);
    return address;
}
// get the mac address of current-device
-(NSString *)getMacAddress
{
    int mgmtInfoBase[6];
    char *msgBuffer = NULL;
    NSString *errorFlag = NULL;
    size_t length;
    // Setup the management Information Base (mib)
    mgmtInfoBase[0] = CTL_NET; // Request network subsystem
    mgmtInfoBase[1] = AF_ROUTE; // Routing table info
    mgmtInfoBase[2] = 0;
    mgmtInfoBase[3] = AF_LINK; // Request link layer information
    mgmtInfoBase[4] = NET_RT_IFLIST; // Request all configured interfaces
    // With all configured interfaces requested, get handle index
    if ((mgmtInfoBase[5] = if_nametoindex("en0")) == 0)
        errorFlag = @"if_nametoindex failure";
    // Get the size of the data available (store in len)
    else if (sysctl(mgmtInfoBase, 6, NULL, &length, NULL, 0) < 0)
        errorFlag = @"sysctl mgmtInfoBase failure";
    // Alloc memory based on above call
    else if ((msgBuffer = malloc(length)) == NULL)
        errorFlag = @"buffer allocation failure";
    // Get system information, store in buffer
    else if (sysctl(mgmtInfoBase, 6, msgBuffer, &length, NULL, 0) < 0) {
        free(msgBuffer);
        errorFlag = @"sysctl msgBuffer failure";
    } else {
        // Map msgbuffer to interface message structure
        struct if_msghdr *interfaceMsgStruct = (struct if_msghdr *) msgBuffer;
        // Map to link-level socket structure
        struct sockaddr_dl *socketStruct = (struct sockaddr_dl *) (interfaceMsgStruct + 1);
        // Copy link layer address data in socket structure to an array
        unsigned char macAddress[6];
        memcpy(&macAddress, socketStruct->sdl_data + socketStruct->sdl_nlen, 6);
        // Read from char array into a string object, into traditional Mac address format
        NSString *macAddressString = [NSString stringWithFormat:@"%02X:%02X:%02X:%02X:%02X:%02X",
                                      macAddress[0], macAddress[1], macAddress[2], macAddress[3], macAddress[4], macAddress[5]];
//        NSLog(@"Mac Address: %@", macAddressString);
        // Release the buffer memory
        free(msgBuffer);
        return macAddressString;
    }
    // Error...
    NSLog(@"Error: %@", errorFlag);
    return nil;
}


@end
