//
// Created by Simon Schmid
//
// contact@sschmid.com
//


#import "GIInjectorInstanceEntry.h"
#import "GIInjector.h"
#import "GIReflector.h"


@implementation GIInjectorInstanceEntry

- (id)initWithObject:(id)object mappedTo:(id)keyObject injector:(GIInjector *)injector {
    self = [super initWithObject:object mappedTo:keyObject injector:injector];
    if (self) {
        if ([GIReflector isProtocol:keyObject] && ![object conformsToProtocol:keyObject])
            @throw [NSException exceptionWithName:@"GIInjectorInstanceEntryException" reason:[NSString stringWithFormat:@"%@ does not conform to protocol %@", object, NSStringFromProtocol(keyObject)] userInfo:nil];

        [_injector injectIntoObject:_object];
    }

    return self;
}

@end