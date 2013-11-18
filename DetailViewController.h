//
//  DetailViewController.h
//  XePop
//
//  Created by Cesar Martins on 4/19/13.
//  Copyright (c) 2013 Cesar Martins. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>


@interface DetailViewController : UIViewController <CLLocationManagerDelegate, MKMapViewDelegate>{

      CLLocationManager *locationManager;

}

@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, strong) IBOutlet UILabel *date;
@property (strong, nonatomic) IBOutlet MKMapView *mapaView;
@property (strong, nonatomic) IBOutlet UILabel *detailEnd;
@property (nonatomic, strong) NSMutableArray *temp;
@property(nonatomic, strong) UIImage *facebookShareImage;

-(void)searchCoordinatesForAddressWithTitle:(NSString *)title;
-(IBAction)facebook:(id)sender;

@end
