//
//  DaoController.h
//  XePop
//
//  Created by Cesar Martins on 4/12/13.
//  Copyright (c) 2013 Cesar Martins. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Users.h"

@interface DaoController : UIViewController

-(void)sendTokenToServer:(NSString *)token;

@property (nonatomic, strong) NSArray *dados;
@end

