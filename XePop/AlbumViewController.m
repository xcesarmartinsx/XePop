//
//  AlbumViewController.m
//  XePop
//
//  Created by Cesar Martins on 6/19/13.
//  Copyright (c) 2013 Cesar Martins. All rights reserved.
//

#import "AlbumViewController.h"
#import "AFJSONRequestOperation.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "FotoViewController.h"

#define kGetURL @"http://sisev.sedir.me/fotos/obterAlbuns"

@interface AlbumViewController ()

@end

@implementation AlbumViewController

@synthesize albumTableView, json;

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
	// Do any additional setup after loading the view.
    
    self.json = [[NSMutableArray alloc] init];
    
    HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    HUD.labelText = @"Carregando Dados..";
    
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        // Do something...
        [self loadJson];
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        });
    });
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return [json count];
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MyCell"];
    
    if(cell == nil){
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"MyCell"];
    }
    
    cell.textLabel.text = [[json objectAtIndex:[indexPath row]] objectForKey:@"titulo"];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
 
    //quando clica.
    FotoViewController *fotoView = [[FotoViewController alloc] initWithNibName:@"FotoViewController" bundle:nil];
    
    fotoView.url = [[json objectAtIndex:[indexPath row]] objectForKey:@"url"];
    
    
    [self.navigationController pushViewController:fotoView animated:YES];
    
    
}

#pragma mark- CARREGA OS ALBUMS APARTIR DA URL
-(void)loadJson{

    
    
    NSString *urlString = [NSString stringWithFormat:@"%@",kGetURL];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlString]];
    
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        
        self.json = JSON;
        [albumTableView reloadData];
        
        NSLog(@"%@",json);
        
        
    } failure:^(NSURLRequest *request , NSURLResponse *response , NSError *error , id JSON){
        
        NSLog(@"Failed: %@",[error localizedDescription]);
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Erro ao Conectar"
                                                        message:@"Não conseguiu conectar com o servidor"
                                                       delegate:self
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles: nil];
        [alert show];
        
        
        
    }];
    
    [operation start];

}

#pragma mark- funcao de recarregar os dados.
-(IBAction)refreshData:(id)sender{

    HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    HUD.labelText = @"Carregando Dados..";
    
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        // Do something...
        [self loadJson];
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        });
    });
}

@end
