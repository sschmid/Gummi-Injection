//
// Created by Simon Schmid
//
// contact@sschmid.com
//

#import "Kiwi.h"
#import "GIInjector.h"

SPEC_BEGIN(ChildInjectiorSpec)

        describe(@"GIInjector", ^{

            __block GIInjector *injector;
            beforeEach(^{
                injector = [[GIInjector alloc] init];
            });

            it(@"instantiates GIInjector", ^{
                [[injector should] beKindOfClass:[GIInjector class]];
            });

            it(@"instantiates a child injector", ^{
                GIInjector *childInjector = [injector createChildInjector];
                [[childInjector should] beKindOfClass:[GIInjector class]];
            });

            it(@"child injector returns parent mapping", ^{
                NSObject *objectForParent = [[NSObject alloc] init];
                [injector map:objectForParent to:[objectForParent class]];

                GIInjector *childInjector = [injector createChildInjector];

                id childObject = [childInjector getObject:[objectForParent class]];
                [[childObject should] equal:objectForParent];

                id parentObject = [injector getObject:[objectForParent class]];
                [[parentObject should] equal:objectForParent];
            });

            it(@"child injector returns child mapping", ^{
                NSObject *objectForParent = [[NSObject alloc] init];
                [injector map:objectForParent to:[objectForParent class]];

                GIInjector *childInjector = [injector createChildInjector];

                NSObject *objectForChild = [[NSObject alloc] init];
                [childInjector map:objectForChild to:[objectForChild class]];

                id childObject = [childInjector getObject:[NSObject class]];
                [[childObject should] equal:objectForChild];

                id parentObject = [injector getObject:[NSObject class]];
                [[parentObject should] equal:objectForParent];

                [[childObject shouldNot] equal:parentObject];
            });

        });

        SPEC_END