//
//  IMGDetailViewController.m
//  XePop
//
//  Created by Cesar Martins on 5/3/13.
//  Copyright (c) 2013 Cesar Martins. All rights reserved.
//

#import "IMGDetailViewController.h"

@interface IMGDetailViewController ()

@end

@implementation IMGDetailViewController

@synthesize imgDetail, imgArray;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    NSLog(@"carregou a view da IMGDetail");
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
