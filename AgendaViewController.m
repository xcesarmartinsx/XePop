//
//  AgendaViewController.m
//  XePop
//
//  Created by Cesar Martins on 4/9/13.
//  Copyright (c) 2013 Cesar Martins. All rights reserved.
//

#import "AgendaViewController.h"
#import "AgendaCell.h"
#import "AFJSONRequestOperation.h"
#import "DetailViewController.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "AppDelegate.h"
#define kGetURL @"http://sisev.sedir.me/shows/obter"
@interface AgendaViewController ()

@end

@implementation AgendaViewController

@synthesize agendaCell , json, myTableView, singleTap, backgroundView, navigationBar;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"Agenda XéPoP!";
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
#pragma mark- Inserindo Token no servidor e no banco
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *token = [NSString stringWithFormat:@"%@",[defaults objectForKey:@"token"]];
    
    dao = [[DaoController alloc]init];
    
    [dao sendTokenToServer:token];
  
    
#pragma mark- INICIO DAS OUTRAS FUNCOES DO ViewDidLoad
    
    UIImageView *testXePop = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"placeholder.png"]];
    
    [navigationBar setTitleView:testXePop];
   
    json = [[NSMutableArray alloc] init];
    
    //chama a funcao que carrega o json
    
    HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    HUD.labelText = @"Carregando Dados..";
    
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        // Do something...
        [self loadJson];
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        });
    });
    
    //adicionado gestureRegnizer para UIImageView
    singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imgTapped:)];
    
    singleTap.numberOfTapsRequired =1;
    singleTap.numberOfTouchesRequired = 1;
    
}
    

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark- CARREGA O JSON APARTIR DA URL

-(void)loadJson{
    
    
    NSString *urlString = [NSString stringWithFormat:@"%@",kGetURL];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlString]];
    
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        
        self.json = JSON;
        [myTableView reloadData];
        
        NSLog(@"deu certo CARALHOOOOO !!!");
        
        
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
    

#pragma mark- METODOS DA TABLEVIEW

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return [json count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MyCell"];
    
    if(cell == nil){
        
        NSArray *nibObjects = [[NSBundle mainBundle] loadNibNamed:@"AgendaCell" owner:self options:nil];
        cell = [nibObjects objectAtIndex:0];
    
    }
    
    agendaCell.dateCell.text = [[json objectAtIndex:[indexPath row]] objectForKey:@"data"];
    agendaCell.tituloCell.text = [[json objectAtIndex:[indexPath row]] objectForKey:@"titulo"];
    agendaCell.enderecoCell.text = [[json objectAtIndex:[indexPath row]] objectForKey:@"endereco"];
    [agendaCell.imgCell setImageWithURL:[NSURL URLWithString:[[json objectAtIndex:[indexPath row]] objectForKey:@"imagemurl"]] placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
    
    
    [agendaCell.imgCell setUserInteractionEnabled:YES];
    [agendaCell.imgCell addGestureRecognizer:singleTap];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    //quando clica.
    DetailViewController *detailView = [[DetailViewController alloc] initWithNibName:@"DetailViewController" bundle:nil];
    
    detailView.temp = [[NSMutableArray alloc] initWithObjects:[[json objectAtIndex:[indexPath row]] objectForKey:@"data"], [[json objectAtIndex:[indexPath row]] objectForKey:@"titulo"], [[json objectAtIndex:[indexPath row]] objectForKey:@"latitude"], [[json objectAtIndex:[indexPath row]] objectForKey:@"longitude"], [[json objectAtIndex:[indexPath row]] objectForKey:@"endereco"], [[json objectAtIndex:[indexPath row]] objectForKey:@"imagemurl"], nil];
    

    
    [self.navigationController pushViewController:detailView animated:YES];


}

#pragma mark- DA REFRESH NA DATA DO BANCO DE DADOS

-(IBAction)refresData:(id)sender{
    
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

#pragma mark- ACAO AO CLICAR NA IMAGEM
-(void)imgTapped:(UIGestureRecognizer *)gestureRecognizer{
    
    NSLog(@"a imagem foi tocada");
 
}

@end
