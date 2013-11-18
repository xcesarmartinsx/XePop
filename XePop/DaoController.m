//
//  DaoController.m
//  XePop
//
//  Created by Cesar Martins on 4/12/13.
//  Copyright (c) 2013 Cesar Martins. All rights reserved.
//

#import "DaoController.h"
#import "AFHTTPClient.h"
#import "AFHTTPRequestOperation.h"
#import "AFHTTPClient.h"
#import "AppDelegate.h"
#import "Users.h"

#define tokenUrl @"http://sisev.sedir.me/dispositivos/put?token="
#define ktoken @"token"

@interface DaoController ()

@end

@implementation DaoController

@synthesize dados;

-(void)sendTokenToServer:(NSString *)token{
    
    NSLog(@"o token da funcao e: %@",token);
    
    NSLog(@"chamou a função");
#pragma -mark procura se tem token no banco local
    AppDelegate *myDelegate = (AppDelegate *) [[UIApplication sharedApplication]delegate];
   
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    
    fetchRequest.entity = [NSEntityDescription entityForName:@"Users" inManagedObjectContext:myDelegate.managedObjectContext];
    
    fetchRequest.predicate = [NSPredicate predicateWithFormat:@"token LIKE %@",token];
    
    NSError *error = nil;
    
    self.dados = [[NSArray alloc] init];
    
    NSLog(@"meus dados da funcao: %@",self.dados);
    
    self.dados = [myDelegate.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    
    if ([self.dados count] >= 1) {
        
        NSLog(@"encontrou um token");
        
    }else{
        
        NSLog(@"nao encontrou nenhum token");
        
        #pragma -mark envia o token pro webservice
       
        //remove os <> e os espacos em branco do token
        NSString *deviceToken = [[token description] stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]];
        deviceToken = [deviceToken stringByReplacingOccurrencesOfString:@" " withString:@""];
        NSLog(@"Novo Token Sem espacos: %@",deviceToken);
        
        //monta a nova url
        NSString *newUrlString = [NSString stringWithFormat:@"%@",tokenUrl];
         newUrlString = [newUrlString stringByAppendingString:deviceToken];
        
        //imrpimi a nova url
        NSLog(@"nova URL EM STRING %@",newUrlString);
        
        //transforma a nova string url em URL
        NSURL *url = [NSURL URLWithString:newUrlString];
        
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];

        
        AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
        [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
            
            NSLog(@"enviou o token pela URL");
            
            #pragma -mark envia o token pro banco local
            
            Users *usuario = [NSEntityDescription insertNewObjectForEntityForName:@"Users" inManagedObjectContext:myDelegate.managedObjectContext];
            
            usuario.token = token;
            
            [myDelegate.managedObjectContext save:nil];
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            //FALHA
            
            NSLog(@"falha ao enviar token para o webservice");
        }];
        
        [operation start];
    }
}


@end
