//
//  UserListTableViewCell.m
//  PAGADITO
//
//  Created by Water Flower on 2019/1/13.
//  Copyright © 2019 PAGADITO. All rights reserved.
//

#import "UserListTableViewCell.h"

@implementation UserListTableViewCell

//@synthesize userTableViewCellView, cellIndex;

//float originX = 0;
//float originY = 0;
//float deviceWidth = 0;
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
//    originX = userTableViewCellView.center.x;
//    originY = userTableViewCellView.center.y;
//    CGRect screen = [[UIScreen mainScreen] bounds];
//    deviceWidth = CGRectGetWidth(screen);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


//-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
////    NSLog(@"%f, %f", userTableViewCellView.center.x, userTableViewCellView.center.y);
////    NSLog(@"////////////");
//    
////    UITouch *touch = [[event allTouches] anyObject];
////    CGPoint location = [touch locationInView: self];
////    startX = location.x - userTableViewCellView.center.x;
////    NSLog(@"%f,  %f", location.x, location.y);
////    NSLog(@"%f,  %f", userTableViewCellView.center.x, userTableViewCellView.center.y);
//    
//}
//
//-(void) touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
//    UITouch *touch = [[event allTouches] anyObject];
//    CGPoint location = [touch locationInView:self];
////    NSLog(@"%f, %f", location.x, location.y);
////    NSLog(@"////////////");
//    CGPoint culocation = userTableViewCellView.center;
//    culocation.x = location.x;
//    userTableViewCellView.center = culocation;
////    NSLog(@"%f, %f", userTableViewCellView.center.x, userTableViewCellView.center.y);
////    if(userTableViewCellView.center.x > deviceWidth / 4) {
////        [self autoMoveTableViewCellView:@"origin"];
////    } else {
////        [self autoMoveTableViewCellView:@"disappear"];
////    }
////    if(userTableViewCellView.center.x < deviceWidth / 4) {
////        if(!disappearStatus) {
////            [self autoMoveTableViewCellView:@"disappear"];
////        }
////    }
//    
//}
//-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
////    NSLog(@"%f, %f", userTableViewCellView.center.x, userTableViewCellView.center.y);
//    if(userTableViewCellView.center.x > deviceWidth / 4) {
//        [self autoMoveTableViewCellView:@"origin"];
//    } else {
//        [self autoMoveTableViewCellView:@"disappear"];
//    }
//}
//
//-(void)autoMoveTableViewCellView: (NSString *)status {
//    if([status isEqualToString:@"origin"]) {
//        [UIView transitionWithView:userTableViewCellView duration:0.3 options:UIViewAnimationOptionCurveEaseIn animations:^{
//            CGRect frame = self->userTableViewCellView.frame;
//            frame.origin.x = 0;
//            self->userTableViewCellView.frame = frame;
//        } completion:nil];
//    } else if([status isEqualToString:@"disappear"]) {
//        [UIView transitionWithView:userTableViewCellView duration:0.5 options:UIViewAnimationOptionCurveEaseIn animations:^{
//            CGRect frame = self->userTableViewCellView.frame;
//            frame.origin.x = (0 - deviceWidth);
//            self->userTableViewCellView.frame = frame;
//        } completion:^(BOOL finished){
//            [self.delegate reloadTableView:self :self->cellIndex];
//        }];
//       
//        
//    }
//}

@end
