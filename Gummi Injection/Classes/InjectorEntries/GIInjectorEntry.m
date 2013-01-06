//
// Created by Simon Schmid
//
// contact@sschmid.com
//


#import "GIInjectorEntry.h"
#import "GIInjector.h"
#import "GIReflector.h"


@implementation GIInjectorEntry
@synthesize object = _object;
@synthesize whenAskedFor = _whenAskedFor;

- (id)initWithObject:(id)object mappedTo:(id)whenAskedFor injector:(GIInjector *)injector {
    self = [super init];
    if (self) {
        if ([GIReflector isProtocol:whenAskedFor] && ![object conformsToProtocol:whenAskedFor])
            @throw [NSException exceptionWithName:@"GIInjectorEntryException" reason:[NSString stringWithFormat:@"%@ does not conform to protocol %@", object, NSStringFromProtocol(whenAskedFor)] userInfo:nil];

        _object = object;
        _whenAskedFor = whenAskedFor;
        _injector = injector;
    }

    return self;
}

- (id)extractObject {
    return _object;
}

@end