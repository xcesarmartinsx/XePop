//
//  Show.m
//  XePop
//
//  Created by Cesar Martins on 4/19/13.
//  Copyright (c) 2013 Cesar Martins. All rights reserved.
//

#import "Show.h"

@implementation Show

@synthesize title, coordinate;

- (id)initWithTitle:(NSString *)ttl andCoordinate:(CLLocationCoordinate2D)c2d {

	title = ttl;
	coordinate = c2d;
	return self;
}



@end