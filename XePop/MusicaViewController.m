//
//  MusicaViewController.m
//  XePop
//
//  Created by Cesar Martins on 4/9/13.
//  Copyright (c) 2013 Cesar Martins. All rights reserved.
//

#import "MusicaViewController.h"
#define musicURL @"http://sisev.sedir.me/musicas/obter"
#import "AFJSONRequestOperation.h"
#import "AudioStreamer.h"
#import <QuartzCore/CoreAnimation.h>
#import <MediaPlayer/MediaPlayer.h>
#import <CFNetwork/CFNetwork.h>

@interface MusicaViewController ()

@end

@implementation MusicaViewController

@synthesize json, musicTableView, HUD, musicaNavationBar;

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
    
    //ccria o objeto HUD para a animação de loading
    HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    HUD.labelText = @"Carregando Músicas..";
    
    //chama a funcao que carrega o json enquanto mostra animação
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        // Do something...
        [self loadJson];
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        });
    });
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark- funcao que carrega os dados do servidor
-(void)loadJson{
    
    NSString *urlString = [NSString stringWithFormat:@"%@",musicURL];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlString]];
    
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        
        self.json = JSON;
        [musicTableView reloadData];
        
        NSLog(@"my music json, %@", JSON);
        
        
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

#pragma mark- funcoes table view
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return [json count];
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MyCell"];
    
    if(cell == nil){
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"MyCell"];
    }
    
    cell.textLabel.text = [[json objectAtIndex:[indexPath row]] objectForKey:@"titulo"];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    //carrega a url da mp3 para ser carregada
    urlToBePlayer = [[NSURL alloc] initWithString:[[json objectAtIndex:[indexPath row]] objectForKey:@"url"]];
    [self setButtonImageNamed:@"playbutton.png"];
    currentImageName = @"playbutton.png";
   
}

#pragma mark- AudioStreamer

//
// setButtonImageNamed:
//
// Used to change the image on the playbutton. This method exists for
// the purpose of inter-thread invocation because
// the observeValueForKeyPath:ofObject:change:context: method is invoked
// from secondary threads and UI updates are only permitted on the main thread.
//
// Parameters:
//    imageNamed - the name of the image to set on the play button.
//
- (void)setButtonImageNamed:(NSString *)imageName
{
	if (!imageName)
	{
		imageName = @"playButton";
	}
	[currentImageName autorelease];
	currentImageName = [imageName retain];
	
	UIImage *image = [UIImage imageNamed:imageName];
	
	[button.layer removeAllAnimations];
	[button setImage:image forState:0];
    
	if ([imageName isEqual:@"loadingbutton.png"])
	{
		[self spinButton];
	}
}

//
// destroyStreamer
//
// Removes the streamer, the UI update timer and the change notification
//
- (void)destroyStreamer
{
	if (streamer)
	{
		[[NSNotificationCenter defaultCenter]
         removeObserver:self
         name:ASStatusChangedNotification
         object:streamer];
		[progressUpdateTimer invalidate];
		progressUpdateTimer = nil;
		
		[streamer stop];
		[streamer release];
		streamer = nil;
	}
}

//
// createStreamer
//
// Creates or recreates the AudioStreamer object.
//
- (void)createStreamer
{
	if (streamer)
	{
		return;
	}
    
	[self destroyStreamer];
	
	
	streamer = [[AudioStreamer alloc] initWithURL:urlToBePlayer];
	
	progressUpdateTimer =
    [NSTimer
     scheduledTimerWithTimeInterval:0.1
     target:self
     selector:@selector(updateProgress:)
     userInfo:nil
     repeats:YES];
	[[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(playbackStateChanged:)
     name:ASStatusChangedNotification
     object:streamer];
}

//
// viewDidLoad
//
// Creates the volume slider, sets the default path for the local file and
// creates the streamer immediately if we already have a file at the local
// location.
//
//
// spinButton
//
// Shows the spin button when the audio is loading. This is largely irrelevant
// now that the audio is loaded from a local file.
//
- (void)spinButton
{
	[CATransaction begin];
	[CATransaction setValue:(id)kCFBooleanTrue forKey:kCATransactionDisableActions];
	CGRect frame = [button frame];
	button.layer.anchorPoint = CGPointMake(0.5, 0.5);
	button.layer.position = CGPointMake(frame.origin.x + 0.5 * frame.size.width, frame.origin.y + 0.5 * frame.size.height);
	[CATransaction commit];
    
	[CATransaction begin];
	[CATransaction setValue:(id)kCFBooleanFalse forKey:kCATransactionDisableActions];
	[CATransaction setValue:[NSNumber numberWithFloat:2.0] forKey:kCATransactionAnimationDuration];
    
	CABasicAnimation *animation;
	animation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
	animation.fromValue = [NSNumber numberWithFloat:0.0];
	animation.toValue = [NSNumber numberWithFloat:2 * M_PI];
	animation.timingFunction = [CAMediaTimingFunction functionWithName: kCAMediaTimingFunctionLinear];
	animation.delegate = self;
	[button.layer addAnimation:animation forKey:@"rotationAnimation"];
    
	[CATransaction commit];
}

//
// animationDidStop:finished:
//
// Restarts the spin animation on the button when it ends. Again, this is
// largely irrelevant now that the audio is loaded from a local file.
//
// Parameters:
//    theAnimation - the animation that rotated the button.
//    finished - is the animation finised?
//
- (void)animationDidStop:(CAAnimation *)theAnimation finished:(BOOL)finished
{
	if (finished)
	{
		[self spinButton];
	}
}

//
// buttonPressed:
//
// Handles the play/stop button. Creates, observes and starts the
// audio streamer when it is a play button. Stops the audio streamer when
// it isn't.
//
// Parameters:
//    sender - normally, the play/stop button.
//
- (IBAction)buttonPressed:(id)sender
{
	if ([currentImageName isEqual:@"playbutton.png"])
	{		
		[self destroyStreamer];
        [self createStreamer];
		[streamer start];
	}
	else if ([currentImageName isEqual:@"pausebutton.png"])
	{
		[streamer pause];
	}
}

//
// sliderMoved:
//
// Invoked when the user moves the slider
//
// Parameters:
//    aSlider - the slider (assumed to be the progress slider)
//
- (IBAction)sliderMoved:(UISlider *)aSlider
{
	if (streamer.duration)
	{
		double newSeekTime = (aSlider.value / 100.0) * streamer.duration;
        NSLog(@"new seek to time: %f", newSeekTime);
		[streamer seekToTime:newSeekTime];
	}
}

//
// playbackStateChanged:
//
// Invoked when the AudioStreamer
// reports that its playback status has changed.
//
- (void)playbackStateChanged:(NSNotification *)aNotification
{
	if ([streamer isWaiting])
	{
		[self setButtonImageNamed:@"loadingbutton.png"];
	}
	else if ([streamer isPlaying])
	{
		[self setButtonImageNamed:@"pausebutton.png"];
	}
	else if ([streamer isIdle])
	{
		[self destroyStreamer];
		[self setButtonImageNamed:@"playbutton.png"];
	}
}

//
// updateProgress:
//
// Invoked when the AudioStreamer
// reports that its playback progress has changed.
//
- (void)updateProgress:(NSTimer *)updatedTimer
{
	if (streamer.bitRate != 0.0)
	{
		double progress = streamer.progress;
		double duration = streamer.duration;
		
		if (duration > 0)
		{
			[positionLabel setText:
             [NSString stringWithFormat:@"Time Played: %.1f/%.1f seconds",
              progress,
              duration]];
			[progressSlider setEnabled:YES];
			[progressSlider setValue:100 * progress / duration];
		}
		else
		{
			[progressSlider setEnabled:NO];
		}
	}
	else
	{
		positionLabel.text = @"Time Played:";
	}
}

//
// textFieldShouldReturn:
//
// Dismiss the text field when done is pressed
//
// Parameters:
//    sender - the text field
//
// returns YES
//
- (BOOL)textFieldShouldReturn:(UITextField *)sender
{
	[sender resignFirstResponder];
	[self createStreamer];
	return YES;
}

//
// dealloc
//
// Releases instance memory.
//
- (void)dealloc
{
	[self destroyStreamer];
	if (progressUpdateTimer)
	{
		[progressUpdateTimer invalidate];
		progressUpdateTimer = nil;
	}
	[super dealloc];
}

#pragma mark- Refresh Data
-(IBAction)refreshData:(id)sender{
    
    HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    HUD.labelText = @"Carregando Dados..";
    
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        // Do something...
        [self loadJson];
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        });
    });
}
@end
