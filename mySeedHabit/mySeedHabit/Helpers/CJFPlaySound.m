//
//  CJFPlaySound.m
//  mySeedHabit
//
//  Created by cjf on 8/21/16.
//  Copyright © 2016 Jinfei Chen. All rights reserved.
//

#import "CJFPlaySound.h"

#import <UIKit/UIKit.h>

@implementation CJFPlaySound

-(id)initForPlayingVibrate
{
    self = [super init];
    if (self) {
        soundID = kSystemSoundID_Vibrate;
    }
    return self;
}

-(id)init{
    self=[super init];
    if(self){
        NSString *soundPath = [[NSBundle mainBundle]pathForResource:@"Sound12" ofType:@"aif"];
        
        if(soundPath){
            NSURL *soundURL =[NSURL fileURLWithPath:soundPath];
            OSStatus err = AudioServicesCreateSystemSoundID((__bridge CFURLRef)soundURL, &soundID);
            if(err!= kAudioServicesNoError){
                NSLog(@"Could not load %@,error code:%d",soundURL,err);
                
            }
        }
    }
    return  self;
}

-(id)initForPlayingSystemSoundEffectWith:(NSString *)resourceName ofType:(NSString *)type
{
    self = [super init];
    if (self) {
        
        NSString *path = [[NSBundle bundleWithIdentifier:@"com.apple.UIKit"] pathForResource:resourceName ofType:type];
        //        NSString *path = [NSString stringWithFormat:@"/System/Library/Audio/UISounds/%@.%@", resourceName, type];
        if (path) {
            SystemSoundID theSoundID;
            OSStatus error =  AudioServicesCreateSystemSoundID((__bridge CFURLRef)[NSURL fileURLWithPath:path], &theSoundID);
            if (error == kAudioServicesNoError) {
                soundID = theSoundID;
            }else {
                NSLog(@"Failed to create sound ");
            }
        }
    }
    return self;
}


-(id)initForPlayingSoundEffectWith:(NSString *)filename
{
    self = [super init];
    if (self) {
        NSURL *fileURL = [[NSBundle mainBundle] URLForResource:filename withExtension:nil];
        if (fileURL != nil)
        {
            SystemSoundID theSoundID;
            OSStatus error = AudioServicesCreateSystemSoundID((__bridge CFURLRef)fileURL, &theSoundID);
            if (error == kAudioServicesNoError){
                soundID = theSoundID;
            }else {
                NSLog(@"Failed to create sound ");
            }
        }
    }
    return self;
}



-(void)play
{
    AudioServicesPlaySystemSound((SystemSoundID)soundID);
    ////    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
}

-(void)dealloc
{
    AudioServicesDisposeSystemSoundID(soundID);
}


@end
