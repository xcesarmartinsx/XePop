//
//  AgendaViewController.h
//  XePop
//
//  Created by Cesar Martins on 4/9/13.
//  Copyright (c) 2013 Cesar Martins. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MBProgressHUD/MBProgressHUD.h>
#import "DaoController.h"

@class AgendaCell;

@interface AgendaViewController : UIViewController <UITableViewDataSource, UITableViewDelegate,     MBProgressHUDDelegate>{
    DaoController *dao;
    MBProgressHUD *HUD;

}

@property (strong, nonatomic) IBOutlet UITableView *myTableView;
@property (strong, nonatomic) IBOutlet AgendaCell *agendaCell;
@property (strong, nonatomic) NSMutableArray *json;
@property (strong, nonatomic) UITapGestureRecognizer *singleTap;
@property (strong, nonatomic) IBOutlet UIImageView *backgroundView;
@property (strong, nonatomic) IBOutlet UINavigationItem *navigationBar;


-(IBAction)refresData:(id)sender;
-(void)imgTapped:(UIGestureRecognizer *)gestureRecognizer;

@end
