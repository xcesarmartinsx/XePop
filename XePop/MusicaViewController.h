//
//  MusicaViewController.h
//  XePop
//
//  Created by Cesar Martins on 4/9/13.
//  Copyright (c) 2013 Cesar Martins. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MBProgressHUD/MBProgressHUD.h>


@class AudioStreamer;


@interface MusicaViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>{
    
    IBOutlet UITextField *downloadSourceField;
	IBOutlet UIButton *button;
	IBOutlet UIView *volumeSlider;
	IBOutlet UILabel *positionLabel;
	IBOutlet UISlider *progressSlider;
	AudioStreamer *streamer;
	NSTimer *progressUpdateTimer;
	NSString *currentImageName;
    NSURL *urlToBePlayer;
    BOOL isPaused;
}


@property (strong, nonatomic) NSMutableArray *json;
@property (strong, nonatomic) IBOutlet UITableView *musicTableView;
@property (strong, nonatomic) MBProgressHUD *HUD;
@property (strong, nonatomic) IBOutlet UINavigationBar *musicaNavationBar;

- (IBAction)buttonPressed:(id)sender;
- (void)spinButton;
- (void)updateProgress:(NSTimer *)aNotification;
- (IBAction)sliderMoved:(UISlider *)aSlider;
-(IBAction)refreshData:(id)sender;

@end
