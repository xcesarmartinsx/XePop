//
//  FotoViewController.m
//  XePop
//
//  Created by Cesar Martins on 6/19/13.
//  Copyright (c) 2013 Cesar Martins. All rights reserved.
//

#import "FotoViewController.h"
#import "AFJSONRequestOperation.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface FotoViewController ()

@end

@implementation FotoViewController
@synthesize url, urlArray, fotoImageView, swipeLeft, swipeRight, pinch;

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
    
    pinch = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinch:)];
    
    //cria contador universal
    globalCount = 0;
    
    //implementa pinch gesture
    //implementa inicializa gesto para esquerda
    swipeLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeLeftImage:)];
    
    swipeLeft.direction = UISwipeGestureRecognizerDirectionLeft;
    
    //inicializa  gesto para a direita
    swipeRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeRightImage:)];
    
    swipeRight.direction = UISwipeGestureRecognizerDirectionRight;
    
    //inicializa o array de imagens.
    urlArray = [[NSMutableArray alloc] init];
    
    //chama a funcao de carregar os dados.
    [self loadJson];
 
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma -mark funcao que carrega os dados do servidor
-(void)loadJson{
    
    NSString *urlString = [NSString stringWithFormat:@"%@",url];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlString]];
    
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        
        
        for (int i =0; i<[JSON count]; i++) {
            
            [urlArray addObject:[NSURL URLWithString:[[JSON objectAtIndex:i] objectForKey:@"url"]]];
            
        }
        
        //adiciona os 2 gestos na view
        [self.view addGestureRecognizer:swipeLeft];
        [self.view addGestureRecognizer:swipeRight];
        [self.view addGestureRecognizer:pinch];
        
        [fotoImageView setImageWithURL:[urlArray objectAtIndex:0] placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
    
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

#pragma -mark funcao que reconhece o gesto, deslize para esquerda e muda imagem.
-(IBAction)swipeLeftImage:(UISwipeGestureRecognizer *)sender{
    
    NSLog(@"swipe left");
    globalCount = globalCount + 1;
    
    if (globalCount >= [urlArray count]) {
        globalCount = 0;
    }
    
    [UIView transitionWithView:self.view
                      duration:0.33f
                       options:UIViewAnimationOptionTransitionFlipFromRight
                    animations:^{
                        
                        [fotoImageView setImageWithURL:[urlArray objectAtIndex:globalCount] placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
                        NSLog(@"array %@ na posicao %i",[urlArray objectAtIndex:globalCount], globalCount);
                    }
                    completion:NULL];

    
}

#pragma -mark funcao que reconhece o gesto, deslize para direita e muda imagem.
-(IBAction)swipeRightImage:(UISwipeGestureRecognizer *)sender{
    
    NSLog(@"swipe right");
    globalCount = globalCount - 1;
    
    if (globalCount < 0) {
        globalCount = [urlArray count] - 1;
    }
    
    [UIView transitionWithView:self.view
                      duration:0.33f
                       options:UIViewAnimationOptionTransitionFlipFromLeft
                    animations:^{
                        
                        [fotoImageView setImageWithURL:[urlArray objectAtIndex:globalCount] placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
                        NSLog(@"array %@ na posicao %i",[urlArray objectAtIndex:globalCount], globalCount);
                        
                    }
                    completion:NULL];
}

- (void)pinch:(UIPinchGestureRecognizer *)gesture {
    
    if ([pinch state] == UIGestureRecognizerStateEnded) {
        NSLog(@"======== Scale Applied ===========");
        if ([pinch scale]<1.0f) {
            [pinch setScale:1.0f];
        }
        CGAffineTransform transform = CGAffineTransformMakeScale([pinch scale],  [pinch scale]);
        fotoImageView.transform = transform;
    }
}



@end
