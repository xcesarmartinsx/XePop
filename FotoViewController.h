//
//  FotoViewController.h
//  XePop
//
//  Created by Cesar Martins on 6/19/13.
//  Copyright (c) 2013 Cesar Martins. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MBProgressHUD/MBProgressHUD.h>
@interface FotoViewController : UIViewController<MBProgressHUDDelegate>{

    MBProgressHUD *HUD;
    NSInteger globalCount;

}
@property (strong, nonatomic) IBOutlet UIImageView *fotoImageView;
@property (strong, nonatomic) NSString *url;
@property (strong, nonatomic) NSMutableArray *urlArray;
@property (strong, nonatomic) UISwipeGestureRecognizer *swipeLeft;
@property (strong, nonatomic) UISwipeGestureRecognizer *swipeRight;
@property (strong, nonatomic) UIPinchGestureRecognizer *pinch;
- (void)pinch:(UIPinchGestureRecognizer *)gesture;
@end
