//
// Created by Simon Schmid
//
// contact@sschmid.com
//

#import "PostConstructObject.h"
#import "GIInjector.h"

@implementation PostConstructObject
injection_complete(@"allSet")

- (void)allSet {
    self.ready = YES;
}

@end