//
//  AppDelegate.m
//  SpeakToDisk
//
//  Created by Kevin Gutowski on 6/2/20.
//  Copyright © 2020 Kevin. All rights reserved.
//

#import "AppDelegate.h"
#import "Speaker.h"

@interface AppDelegate ()

@property (weak) IBOutlet NSWindow *window;
@end

@implementation AppDelegate

- (instancetype)init
{
	self = [super init];
	if (self) {
		_speechSynth = [[NSSpeechSynthesizer alloc] initWithVoice:nil];
		[_speechSynth setDelegate:self];
		
		NSArray* voices = [NSSpeechSynthesizer availableVoices];
		
		NSMutableArray* tempSpeakers = [[NSMutableArray alloc] init];
		for (NSString* voice in voices) {
			Speaker* speaker = [[Speaker alloc] init];
			NSDictionary* voiceDict = [NSSpeechSynthesizer attributesForVoice:voice];
			
			speaker.name = [voiceDict objectForKey:NSVoiceName];
			
			NSLocale *locale = [NSLocale autoupdatingCurrentLocale];
			NSString *voiceLocaleCode = [voiceDict objectForKey:NSVoiceLocaleIdentifier];
			speaker.language = [locale localizedStringForLanguageCode:voiceLocaleCode];
			
			speaker.previewText = [voiceDict objectForKey:NSVoiceDemoText];
			
			speaker.identifier = [voiceDict objectForKey:NSVoiceIdentifier];
			
			[tempSpeakers addObject:speaker];
		}
		
		_speakers = tempSpeakers;
	}
	return self;
}

- (void)awakeFromNib {
    
    
    NSArray<NSSpeechSynthesizerVoiceName> *possibleVoices = [NSSpeechSynthesizer availableVoices];
    
    NSInteger samanthaPremiumInt = [possibleVoices indexOfObject:@"com.apple.speech.synthesis.voice.samantha.premium"];
    NSInteger defaultRow;
    if (NSNotFound == samanthaPremiumInt) {
        NSString *defaultIdentifier = [NSSpeechSynthesizer defaultVoice];
        defaultRow = [possibleVoices indexOfObject:defaultIdentifier];
    } else {
        defaultRow = samanthaPremiumInt;
    }
    NSIndexSet *indices = [NSIndexSet indexSetWithIndex:defaultRow];
	[_tableView selectRowIndexes:indices byExtendingSelection:NO];
	[_tableView scrollRowToVisible:defaultRow];
}

- (IBAction)previewSpeech:(id)sender {
	if ([_previewButton.title isEqual: @"Preview"]) {
		NSString* speechText = [_textArea stringValue];
		
		if (speechText.length == 0) {
			Speaker* currentSpeaker = [_speakers objectAtIndex:[_tableView selectedRow]];
			speechText = currentSpeaker.previewText;
		}
		
		[_speechSynth startSpeakingString:speechText];
		[_previewButton setTitle:@"Stop"];
		[_previewButton setImage: [NSImage imageNamed:NSImageNameTouchBarRecordStopTemplate]];
		[_tableView setEnabled:NO];
	} else {
		[_speechSynth stopSpeaking];
	}
}

- (void)speechSynthesizer:(NSSpeechSynthesizer *)sender didFinishSpeaking:(BOOL)finishedSpeaking {
	[_previewButton setTitle:@"Preview"];
	[_previewButton setImage:[NSImage imageNamed:NSImageNameTouchBarPlayTemplate]];
	[_tableView setEnabled:YES];
}

- (IBAction)speakToDisk:(id)sender {
	NSString* speechText = [_textArea stringValue];
	
	if (speechText.length == 0) {
		NSAlert* alert = [[NSAlert alloc] init];
		[alert setMessageText:@"No text to speak"];
		[alert setInformativeText:@"Add some text to speak to disk."];
		[alert addButtonWithTitle:@"OK"];
		[alert runModal];
	}
	
	NSString* folderPath = @"/Users/Kski/Downloads/";
	NSString* filePathString = [[NSString stringWithFormat:@"%@%@.aiff", folderPath, speechText] stringByReplacingOccurrencesOfString:@" " withString:@"_"];
	NSLog(@"%@", filePathString);
	NSURL* URL = [NSURL fileURLWithPath:filePathString];
	NSLog(@"%@",URL);
	[_speechSynth startSpeakingString:speechText toURL:URL];
	[_previewButton setTitle:@"Stop"];
	[_previewButton setImage: [NSImage imageNamed:NSImageNameTouchBarRecordStopTemplate]];
	[_tableView setEnabled:NO];
}

- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView {
	return [_speakers count];
}

- (id)tableView:(NSTableView *)tableView objectValueForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row {
	NSString* identifier = [tableColumn identifier];
	
	Speaker* speaker = [_speakers objectAtIndex:row];
	
	if ([identifier isEqualToString:@"name"]) {
		return speaker.name;
	} else {
		return speaker.language;
	}
}

- (void)tableViewSelectionDidChange:(NSNotification *)notification {
	NSInteger row = [_tableView selectedRow];
	if (row == -1) {
		return;
	}
	
	Speaker* selectedSpeaker = [_speakers objectAtIndex:row];
	[_speechSynth setVoice:selectedSpeaker.identifier];
}

@end
