//
//  Global.m
//  PAGADITO
//
//  Created by Water Flower on 2019/1/6.
//  Copyright © 2019 PAGADITO. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Global.h"

@implementation Global

@synthesize selected_language;
@synthesize macAddress, uid, wsk, private_key, initialization_vector, office_id, terminal_id, logo_image, logo_imagePath;

@synthesize username, idPrivilegio, nombreCompleto, idUser, idDispositivo, login_wsk, login_uid, llaveCifrado, cifradoIV, moneda, nombreComercio, nombreTerminal, numeroRegistro, mensajeVoucher, emailComercio, currency, idComercio, branchid, terminalid, ambiente;

@synthesize turnoCod,codeShift,idTurno;

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
        uid = nil;
    }
    return self;
}

@end
