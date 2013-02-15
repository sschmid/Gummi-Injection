//
// Created by Simon Schmid
//
// contact@sschmid.com
//

#import "ExternalAir.h"

@implementation ExternalAir

- (id)initDefaultInitializer {
    self = [super init];
    if (self) {
        self.type = @"O2";
    }

    return self;
}

@end