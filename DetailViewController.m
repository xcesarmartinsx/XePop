//
//  DetailViewController.m
//  XePop
//
//  Created by Cesar Martins on 4/19/13.
//  Copyright (c) 2013 Cesar Martins. All rights reserved.
//

#import "DetailViewController.h"
#import "AFJSONRequestOperation.h"
#import "Show.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import <Social/Social.h>

@interface DetailViewController ()

@end

@implementation DetailViewController

@synthesize date, temp, mapaView, detailEnd, locationManager, facebookShareImage;

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
    [detailEnd setUserInteractionEnabled:NO];
    NSLog(@" tempo %@",temp);
    date.text = [temp objectAtIndex:0];
    
    [self searchCoordinatesForAddressWithTitle:[temp objectAtIndex:1]];
    UIImageView *faceImage = [[UIImageView alloc] init];
    NSLog(@"last object: %@",[temp lastObject]);
    [faceImage setImageWithURL:[NSURL URLWithString:[temp lastObject]] placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
    
    facebookShareImage = faceImage.image;
    [detailEnd setText:[temp objectAtIndex:4]];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark- Procura latitude e Longitude do endereço e adiciona no mapa.
-(void)searchCoordinatesForAddressWithTitle:(NSString *)title{
    
//    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
//    
//    [geocoder geocodeAddressString:address completionHandler:^(NSArray *placemarks, NSError *error) {
//        
//        NSLog(@"Endereco: %@",address);
//
//        
//        for (CLPlacemark* aPlacemark in placemarks)
//        {
//            // Process the placemark.
//                        
//                if(placemarks == NULL){
//            
//                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Endereço Não Encontrado"
//                                                                message:@"Esse Endereço Não Foi Encontrado no Mapa"
//                                                               delegate:self
//                                                      cancelButtonTitle:@"OK"
//                                                      otherButtonTitles: nil];
//                [alert show];
//            
//                }else{
    
                    //NSLog(@"Place Mark: %@",placemarks);
            
                    CLLocationCoordinate2D coordinate;
                    
                    coordinate.latitude = [[temp objectAtIndex:2] doubleValue];
                    coordinate.longitude = [[temp objectAtIndex:3] doubleValue];
                    Show *local = [[Show alloc] initWithTitle:title andCoordinate:coordinate];

                    [mapaView addAnnotation:local];
                    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(coordinate, 100, 100);
                    [mapaView setRegion:region animated:YES];
//            }
//
//        }
//        
//    }];

}

#pragma mark- compartilha o show no facebook
-(IBAction)facebook:(id)sender{
    
    if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook]) {
        // Initialize Compose View Controller
        SLComposeViewController *vc = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
        // Configure Compose View Controller
        [vc setInitialText:@"Vamos Na Pisadinha do XéPoP!!"];
        
        //adiciona a imagem compartilhada
        [vc addImage:facebookShareImage];
        // Present Compose View Controller
        [self presentViewController:vc animated:YES completion:nil];
    } else {
        NSString *message = @"Parece que não conseguimos contactar o facebook ou você não adicionou uma conta de facebook padrão no seu celular. Vá em ajustes para adicionar uma conta do facebook no seu celular.";
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Erro!" message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alertView show];
    }
}




@end
