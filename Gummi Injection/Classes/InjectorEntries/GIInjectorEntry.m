//
// Created by Simon Schmid
//
// contact@sschmid.com
//


#import "GIInjectorEntry.h"
#import "GIInjector.h"
#import "GIReflector.h"


@implementation GIInjectorEntry
@synthesize whenAskedFor = _whenAskedFor;
@synthesize use = _use;

- (id)initWithObject:(id)whenAskedFor mappedTo:(id)use injector:(GIInjector *)injector {
    self = [super init];
    if (self) {
        if ([GIReflector isProtocol:whenAskedFor] && ![use conformsToProtocol:whenAskedFor])
            @throw [NSException exceptionWithName:@"GIInjectorEntryException" reason:[NSString stringWithFormat:@"%@ does not conform to protocol %@", use, NSStringFromProtocol(whenAskedFor)] userInfo:nil];

        _whenAskedFor = whenAskedFor;
        _use = use;
        _injector = injector;
    }

    return self;
}

- (id)extractObject {
    return _use;
}

@end