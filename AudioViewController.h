//
//  AudioViewController.h
//  XePop
//
//  Created by Cesar Martins on 7/20/13.
//  Copyright (c) 2013 Cesar Martins. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AudioPlayer.h"


@protocol AudioViewControllerDelegate<NSObject>
@end
@interface AudioViewController : UIViewController
{
@private
	NSTimer* timer;
	UISlider* slider;
	UIButton* playButton;
	UIButton* playFromHTTPButton;
	UIButton* playFromLocalFileButton;
}

@property (readwrite, retain) AudioPlayer* audioPlayer;
@property (readwrite, unsafe_unretained) id<AudioPlayerViewDelegate> delegate;

@end
