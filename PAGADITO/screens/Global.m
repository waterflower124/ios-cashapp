//
//  Global.m
//  PAGADITO
//
//  Created by Javier Calderon  on 2019/1/6.
//  Copyright © 2019 PAGADITO. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Global.h"
#import "JFBCrypt.h"

@implementation Global

@synthesize server_url, selected_language;
@synthesize macAddress,IPAddress, uid, wsk, private_key, initialization_vector, office_id, terminal_id, logo_image, logo_imagePath;

@synthesize username, idPrivilegio, nombreCompleto, idUser, idDispositivo, login_wsk, login_uid, llaveCifrado, cifradoIV, moneda, nombreComercio, nombreTerminal, numeroRegistro, mensajeVoucher, emailComercio, currency, idComercio, branchid, terminalid, ambiente;

@synthesize turnoCod,codeShift,idTurno;
@synthesize signatureStatus;
@synthesize server_token;
    
+ (Global *)sharedInstance {
    static dispatch_once_t onceToken;
    static Global *instance = nil;
    dispatch_once(&onceToken, ^{
        instance = [[Global alloc] init];

    });
    return instance;
}

-(id)init {
    self = [super init];
    if(self) {
        //URL WS
        server_url = @"http://3.130.254.187/ws_pg/service.php";
        
        //PRIVATE KEY
        NSString *salt = [JFBCrypt generateSaltWithNumberOfRounds: 10];
        NSString *hashedPassword = [JFBCrypt hashPassword: @"@PG$WS$2019$APPS$!@" withSalt: salt];
        //NSLog(@"%@",hashedPassword);
        server_token = hashedPassword;
    }
    return self;
}

@end
