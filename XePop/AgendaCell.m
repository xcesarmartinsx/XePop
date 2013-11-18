//
//  AgendaCell.m
//  XePop
//
//  Created by Cesar Martins on 4/12/13.
//  Copyright (c) 2013 Cesar Martins. All rights reserved.
//

#import "AgendaCell.h"

@implementation AgendaCell

@synthesize tituloCell, enderecoCell, dateCell, backGroundCell;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
