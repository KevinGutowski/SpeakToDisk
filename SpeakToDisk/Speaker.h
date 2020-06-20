//
//  Speaker.h
//  SpeakToDisk
//
//  Created by Kevin Gutowski on 6/2/20.
//  Copyright © 2020 Kevin. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Speaker : NSObject

@property NSString* name;
@property NSString* language;
@property NSString* previewText;
@property NSString* identifier;

@end

NS_ASSUME_NONNULL_END
