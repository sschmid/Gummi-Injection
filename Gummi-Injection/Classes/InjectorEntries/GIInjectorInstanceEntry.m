//
// Created by Simon Schmid
//
// contact@sschmid.com
//

#import "GIInjectorInstanceEntry.h"
#import "GIInjector.h"
#import "GRReflection.h"

@implementation GIInjectorInstanceEntry

- (id)initWithObject:(id)object mappedTo:(id)keyObject injector:(GIInjector *)injector {
    self = [super initWithObject:object mappedTo:keyObject injector:injector];
    if (self) {
        if ([GRReflection isProtocol:keyObject] && ![object conformsToProtocol:keyObject])
            @throw [NSException exceptionWithName:@"GIInjectorInstanceEntryException"
                                           reason:[NSString stringWithFormat:@"%@ does not conform to protocol %@", object, NSStringFromProtocol(keyObject)]
                                         userInfo:nil];
    }

    return self;
}

@end