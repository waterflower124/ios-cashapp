//
//  Global.h
//  PAGADITO
//
//  Created by Water Flower on 2019/1/6.
//  Copyright © 2019 PAGADITO. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface Global : NSObject
{
    int *selected_language;
    NSString *uid;
    NSString *wsk;
    NSString *private_key;
    NSString *initialization_vector;
    NSString *office_id;
    NSString *terminal_id;
    
    NSString *logo_imagePath;
    UIImage *logo_image;
}

+ (Global *)sharedInstance;

@property(nonatomic, assign) int *selected_language;
@property(strong, nonatomic, readwrite) NSString *uid;
@property(strong, nonatomic, readwrite) NSString *wsk;
@property(strong, nonatomic, readwrite) NSString *private_key;
@property(strong, nonatomic, readwrite) NSString *initialization_vector;
@property(strong, nonatomic, readwrite) NSString *office_id;
@property(strong, nonatomic, readwrite) NSString *terminal_id;
@property(strong, nonatomic, readwrite) NSString *logo_imagePath;
@property(strong, nonatomic, readwrite) UIImage *logo_image;

@end
