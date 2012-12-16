//
// Created by sschmid on 15.12.12.
//
// contact@sschmid.com
//


#import <objc/runtime.h>
#import "SDInjector.h"
#import "SDInjectorEntry.h"
#import "SDInjectorClassEntry.h"
#import "SDInjectorInstanceEntry.h"

static NSString *const SDInjectorException = @"SDInjectorException";
static SDInjector *sInjector;

@interface SDInjector ()
@property(nonatomic, strong) NSMutableDictionary *context;
@end

@implementation SDInjector
@synthesize context = _context;

+ (SDInjector *)sharedInjector {
    if (!sInjector)
        sInjector = [[SDInjector alloc] init];
    return sInjector;
}

- (id)init {
    self = [super init];
    if (self) {
        self.context = [[NSMutableDictionary alloc] init];
    }

    return self;
}

- (id)getObject:(id)type {
    SDInjectorEntry *entry = [self.context objectForKey:[self keyForType:type]];
    return entry.extractObject;
}

- (void)injectIntoObject:(id)object {
    if ([[object class] respondsToSelector:@selector(desiredProperties)]) {
        NSSet *properties = [[object class] performSelector:@selector(desiredProperties)];
        [object setValuesForKeysWithDictionary:[self getDependenciesForObject:object forProperties:properties]];
    }
}

- (NSDictionary *)getDependenciesForObject:(id)object forProperties:(NSSet *)properties {
    NSMutableDictionary *dependencies = [[NSMutableDictionary alloc] init];
    for (NSString *propertyName in properties) {
        Class propertyType = [self getTypeForProperty:propertyName ofClass:[object class]];
        id dependency = [self getObject:propertyType];
        if (!dependency) {
            dependency = [[propertyType alloc] init];
            [self injectIntoObject:dependency];
        }
        [dependencies setObject:dependency forKey:propertyName];
    }

    return dependencies;
}

- (void)map:(id)whenAskedFor to:(id)use {
    [self map:whenAskedFor to:use asSingleton:NO];
}

- (void)map:(id)whenAskedFor to:(id)use asSingleton:(BOOL)asSingleton {
    if ([self isProtocol:whenAskedFor] && ![use conformsToProtocol:whenAskedFor])
        @throw [NSException exceptionWithName:SDInjectorException reason:[NSString stringWithFormat:@"%@ does not conform to protocol %@", use, [self keyForType:whenAskedFor]] userInfo:nil];

    SDInjectorEntry *entry;
    if ([self isInstance:use])
        entry = [SDInjectorInstanceEntry entryWithObject:use injector:self];
    else
        entry = [SDInjectorClassEntry entryWithObject:use injector:self asSingleton:asSingleton];

    [self.context setObject:entry forKey:[self keyForType:whenAskedFor]];
}

- (void)mapSingleton:(Class)aClass {
    [self map:aClass to:aClass asSingleton:YES];
}

- (NSString *)keyForType:(id)type {
    if ([self isProtocol:type])
        return [NSString stringWithFormat:@"<%@>", NSStringFromProtocol(type)];

    return NSStringFromClass(type);
}


#pragma mark Reflection

// see: https://developer.apple.com/library/mac/#documentation/Cocoa/Conceptual/ObjCRuntimeGuide/Articles/ocrtPropertyIntrospection.html

- (Class)getTypeForProperty:(NSString *)propertyName ofClass:(Class)aClass {
    objc_property_t property = class_getProperty(aClass, [propertyName UTF8String]);
    if (!property)
        @throw [NSException exceptionWithName:SDInjectorException reason:[NSString stringWithFormat:@"Property declaration for propertyName: '%@' does not exist", propertyName] userInfo:nil];
    NSString *attributes = [NSString stringWithCString:property_getAttributes(property) encoding:NSUTF8StringEncoding];
    NSRange startRange = [attributes rangeOfString:@"T@\""];
    if (startRange.location == NSNotFound)
        @throw [NSException exceptionWithName:SDInjectorException reason:[NSString stringWithFormat:@"Unable to determine class type for property declaration: '%@'. Did you type your property properly?", propertyName] userInfo:nil];
    NSString *startOfClassName = [attributes substringFromIndex:startRange.length];
    NSRange endRange = [startOfClassName rangeOfString:@"\""];
    if (endRange.location == NSNotFound)
        @throw [NSException exceptionWithName:SDInjectorException reason:[NSString stringWithFormat:@"Unable to determine class type for property declaration: '%@'. Did you type the property properly?", propertyName] userInfo:nil];
    return NSClassFromString([startOfClassName substringToIndex:endRange.location]);
}

- (BOOL)isProtocol:(id)type {
    return !class_isMetaClass(object_getClass(type));
}

- (BOOL)isInstance:(id)type {
    return [type isKindOfClass:[type class]];
}

@end