//
// Created by Simon Schmid
//
// contact@sschmid.com
//

#import "BrokenDefaultInitilaizerObject.h"
#import "GIInjector.h"

@implementation BrokenDefaultInitilaizerObject
injection_defaultInitializer(@selector(iDoNotExist:really:))

@end