//
//  AlbumViewController.h
//  XePop
//
//  Created by Cesar Martins on 6/19/13.
//  Copyright (c) 2013 Cesar Martins. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MBProgressHUD/MBProgressHUD.h>

@interface AlbumViewController : UIViewController<UITableViewDelegate, UITableViewDataSource, MBProgressHUDDelegate>{

    MBProgressHUD *HUD;
}
@property (strong, nonatomic) IBOutlet UITableView *albumTableView;
@property (strong, nonatomic) NSMutableArray *json;

-(IBAction)refreshData:(id)sender;
@end
