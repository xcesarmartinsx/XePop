//
//  AgendaCell.h
//  XePop
//
//  Created by Cesar Martins on 4/12/13.
//  Copyright (c) 2013 Cesar Martins. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AgendaCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UIImageView *imgCell;
@property (strong, nonatomic) IBOutlet UILabel *dateCell;
@property (strong, nonatomic) IBOutlet UILabel *tituloCell;
@property (strong, nonatomic) IBOutlet UILabel *enderecoCell;
@property (strong, nonatomic) IBOutlet UIImageView *backGroundCell;



@end
