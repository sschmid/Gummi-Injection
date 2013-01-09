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
@synthesize keyObject = _keyObject;

- (id)initWithObject:(id)object mappedTo:(id)keyObject injector:(GIInjector *)injector {
    self = [super init];
    if (self) {
        if ([GIReflector isProtocol:keyObject] && ![object conformsToProtocol:keyObject])
            @throw [NSException exceptionWithName:@"GIInjectorEntryException" reason:[NSString stringWithFormat:@"%@ does not conform to protocol %@", object, NSStringFromProtocol(keyObject)] userInfo:nil];

        _object = object;
        _keyObject = keyObject;
        _injector = injector;
    }

    return self;
}

- (id)extractObject {
    return _object;
}

@end