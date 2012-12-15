//
// Created by sschmid on 15.12.12.
//
// contact@sschmid.com
//


#import <objc/runtime.h>
#import "SDInjector.h"
#import "SDReflector.h"

static NSString *const SDInjectorException = @"SDInjectorException";

@interface SDInjector ()
@property(nonatomic, strong) NSMutableDictionary *map;

@end

@implementation SDInjector
@synthesize map = _map;

- (id)init {
    self = [super init];
    if (self) {
        self.map = [[NSMutableDictionary alloc] init];
    }

    return self;
}


- (id)getObject:(id)classOrProtocol {
    id object = [[[self.map objectForKey:[self keyForType:classOrProtocol]] alloc] init];
    [self injectIntoObject:object];
    return object;
}

- (void)injectIntoObject:(id)object {
    if ([[object class] respondsToSelector:@selector(desiredProperties)]) {
        NSSet *desiredProperties = [[object class] performSelector:@selector(desiredProperties)];
        [object setValuesForKeysWithDictionary:[self getDependenciesForObject:object forProperties:desiredProperties]];
    }
}

- (NSDictionary *)getDependenciesForObject:(id)object forProperties:(NSSet *)properties {
    NSMutableDictionary *dependencies = [[NSMutableDictionary alloc] init];
    for (NSString *propertyName in properties) {
        Class desiredPropertyType = [SDReflector getTypeForProperty:propertyName ofClass:[object class]];
        id dependency = [self getObject:desiredPropertyType];
        if (!dependency) {
            dependency = [[desiredPropertyType alloc] init];
            [self injectIntoObject:dependency];
        }
        [dependencies setObject:dependency forKey:propertyName];
    }

    return dependencies;
}

- (void)map:(id)whenAskedFor to:(id)use {
    if ([self isProtocol:whenAskedFor] && ![use conformsToProtocol:whenAskedFor])
        @throw [NSException exceptionWithName:SDInjectorException reason:[NSString stringWithFormat:@"%@ does not conform to protocol %@", use, [self keyForType:whenAskedFor]] userInfo:nil];

    [self.map setObject:use forKey:[self keyForType:whenAskedFor]];
}

- (BOOL)isProtocol:(id)type {
    return !class_isMetaClass(object_getClass(type));
}

- (NSString *)keyForType:(id)type {
    if (class_isMetaClass(object_getClass(type)))
        return NSStringFromClass(type);

    return [NSString stringWithFormat:@"<%@>", NSStringFromProtocol(type)];
}

@end