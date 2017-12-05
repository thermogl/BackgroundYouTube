//
//  Copyright (c) 2013-2016 Cédric Luthi. All rights reserved.
//

@import MediaPlayer;

@interface MPMoviePlayerController (BackgroundPlayback)
@property (nonatomic, assign, getter = isBackgroundPlaybackEnabled) BOOL backgroundPlaybackEnabled;
@end
