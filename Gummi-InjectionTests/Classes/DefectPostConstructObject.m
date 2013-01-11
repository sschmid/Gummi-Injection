//
// Created by Simon Schmid
//
// contact@sschmid.com
//

#import "DefectPostConstructObject.h"
#import "GIInjector.h"

@implementation DefectPostConstructObject
injection_complete(@"unknownSelector")

- (void)allSet {
    self.ready = YES;
}

@end