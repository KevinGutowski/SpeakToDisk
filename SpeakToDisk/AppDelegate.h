//
//  AppDelegate.h
//  SpeakToDisk
//
//  Created by Kevin Gutowski on 6/2/20.
//  Copyright © 2020 Kevin. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface AppDelegate : NSObject <NSApplicationDelegate, NSSpeechSynthesizerDelegate, NSTableViewDataSource, NSTableViewDelegate>

@property NSArray* speakers;
@property NSSpeechSynthesizer* speechSynth;

@property (weak) IBOutlet NSTableView *tableView;
@property (weak) IBOutlet NSTextField *textArea;
@property (weak) IBOutlet NSButton *previewButton;

- (IBAction)previewSpeech:(id)sender;
- (IBAction)speakToDisk:(id)sender;

@end

