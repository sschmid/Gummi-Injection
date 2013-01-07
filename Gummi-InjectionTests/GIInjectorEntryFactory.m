//
// Created by Simon Schmid
//
// contact@sschmid.com
//


#import "Kiwi.h"
#import "GIInjectorEntryFactory.h"
#import "GIInjector.h"
#import "GIInjectorEntry.h"
#import "GIInjectorClassEntry.h"
#import "GIInjectorInstanceEntry.h"


SPEC_BEGIN(GIInjectorEntryFactorySpec)

        describe(@"GIInjectorEntryFactory", ^{

            __block GIInjectorEntryFactory *factory;
            beforeEach(^{
                factory = [[GIInjectorEntryFactory alloc] initWithInjector:[[GIInjector alloc] init]];
            });

            it(@"instantiates a factory", ^{
                [[factory should] beKindOfClass:[GIInjectorEntryFactory class]];
            });

            it(@"returns a class entry", ^{
                GIInjectorEntry *entry = [factory createEntryForObject:[[NSObject alloc] init] mappedTo:[NSObject class] asSingleton:NO];

                [[entry should] beKindOfClass:[GIInjectorInstanceEntry class]];
            });

            it(@"returns an instance entry", ^{
                GIInjectorEntry *entry = [factory createEntryForObject:[NSObject class] mappedTo:[NSObject class] asSingleton:NO];

                [[entry should] beKindOfClass:[GIInjectorClassEntry class]];
            });

            it(@"returns nil", ^{
                GIInjectorEntry *entry = [factory createEntryForObject:nil mappedTo:[NSObject class] asSingleton:NO];

                [entry shouldBeNil];
            });

            it(@"thorws protocol error", ^{
                [[theBlock(^{
                    [factory createEntryForObject:@protocol(NSObject) mappedTo:@protocol(NSObject) asSingleton:NO];
                }) should] raiseWithName:@"GIInjectorEntryFactoryException"];
            });

        });

        SPEC_END
