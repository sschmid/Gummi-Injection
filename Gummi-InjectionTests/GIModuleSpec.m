//
// Created by Simon Schmid
//
// contact@sschmid.com
//

#import "Kiwi.h"
#import "GIModule.h"
#import "GIInjector.h"

SPEC_BEGIN(GIModuleSpec)

        describe(@"GIModule", ^{

            __block GIModule *module;
            __block GIInjector *injector;
            beforeEach(^{
                module = [[GIModule alloc] init];
                injector = [[GIInjector alloc] init];
            });

            it(@"creates a module", ^{
                [[module should] beKindOfClass:[GIModule class]];
            });

            it(@"has no mappings", ^{
                BOOL has = [module isObject:[NSObject class] mappedTo:[NSObject class]];

                [[theValue(has) should] beNo];
            });

            context(@"when mapping added", ^{

                beforeEach(^{
                    [module configure:injector];
                    [module map:[NSObject class]to:@protocol(NSObject)];
                });

                it(@"has mapping", ^{
                    BOOL has = [module isObject:[NSObject class] mappedTo:@protocol(NSObject)];

                    [[theValue(has) should] beYes];
                });

                it(@"injector has mapping", ^{
                    BOOL has = [injector isObject:[NSObject class] mappedTo:@protocol(NSObject)];

                    [[theValue(has) should] beYes];
                });

                it(@"injector returns instance", ^{
                    id obj = [injector getObject:@protocol(NSObject)];

                    [[obj should] beKindOfClass:[NSObject class]];
                });

                context(@"when removed mapping", ^{

                    beforeEach(^{
                        [module unMap:[NSObject class] from:@protocol(NSObject)];
                    });

                    it(@"has no mapping", ^{
                        BOOL has = [module isObject:[NSObject class] mappedTo:@protocol(NSObject)];

                        [[theValue(has) should] beNo];
                    });

                    it(@"injector has no mapping", ^{
                        BOOL has = [injector isObject:[NSObject class] mappedTo:@protocol(NSObject)];

                        [[theValue(has) should] beNo];
                    });

                    it(@"injector returns no instance", ^{
                        [[theBlock(^{
                            id obj = [injector getObject:@protocol(NSObject)];
                        }) should] raiseWithName:@"GIInjectorException"];
                    });

                });

                context(@"when unload module", ^{

                    beforeEach(^{
                        [module unload];
                    });

                    it(@"has no mapping", ^{
                        BOOL has = [module isObject:[NSObject class] mappedTo:@protocol(NSObject)];

                        [[theValue(has) should] beNo];
                    });

                    it(@"injector has no mapping", ^{
                        BOOL has = [module isObject:[NSObject class] mappedTo:@protocol(NSObject)];

                        [[theValue(has) should] beNo];
                    });

                });

            });

        });

        SPEC_END