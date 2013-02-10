//
// Created by Simon Schmid
//
// contact@sschmid.com
//

#import "Kiwi.h"
#import "GIInjector.h"
#import "SomeDependency.h"
#import "ObjectWithDependency.h"

SPEC_BEGIN(ChildInjectiorSpec)

        describe(@"GIInjector child injector", ^{

            __block GIInjector *injector;
            beforeEach(^{
                injector = [[GIInjector alloc] init];
            });

            context(@"when first created", ^{

                it(@"instantiates GIInjector", ^{
                    [[injector should] beKindOfClass:[GIInjector class]];
                });

            });

            context(@"when child injector first created", ^{

                __block GIInjector *childInjector;
                beforeEach(^{
                    childInjector = [injector createChildInjector];
                });

                it(@"instantiates a child injector", ^{
                    [[childInjector should] beKindOfClass:[GIInjector class]];
                });

                it(@"child injector returns parentInjector mapping", ^{
                    NSObject *objectForParent = [[NSObject alloc] init];
                    [injector map:objectForParent to:[objectForParent class]];

                    id childObject = [childInjector getObject:[objectForParent class]];
                    [[childObject should] equal:objectForParent];

                    id parentObject = [injector getObject:[objectForParent class]];
                    [[parentObject should] equal:objectForParent];
                });

                context(@"when child injector has own mapping", ^{

                    it(@"child injector returns own mapping", ^{
                        NSObject *objectForParent = [[NSObject alloc] init];
                        NSObject *objectForChild = [[NSObject alloc] init];
                        [injector map:objectForParent to:[objectForParent class]];
                        [childInjector map:objectForChild to:[objectForChild class]];

                        id parentObject = [injector getObject:[NSObject class]];
                        id childObject = [childInjector getObject:[NSObject class]];

                        [[parentObject should] equal:objectForParent];
                        [[childObject should] equal:objectForChild];
                        [[childObject shouldNot] equal:parentObject];
                    });

                });

                it(@"child injector satisfies dependencies with child context", ^{
                    SomeDependency *baseDependencyForParent = [[SomeDependency alloc] init];
                    SomeDependency *baseDependencyForChild = [[SomeDependency alloc] init];

                    [injector map:baseDependencyForParent to:[SomeDependency class]];
                    [childInjector map:baseDependencyForChild to:[SomeDependency class]];

                    ObjectWithDependency *baseObjectFromParent = [injector getObject:[ObjectWithDependency class]];
                    ObjectWithDependency *baseObjectFromChild = [childInjector getObject:[ObjectWithDependency class]];

                    [[baseObjectFromParent.someDependency should] equal:baseDependencyForParent];
                    [[baseObjectFromChild.someDependency should] equal:baseDependencyForChild];
                });

                it(@"child injector satisfies dependencies with parentInjector context, when not available", ^{
                    SomeDependency *baseDependencyForParent = [[SomeDependency alloc] init];
                    [injector map:baseDependencyForParent to:[SomeDependency class]];

                    ObjectWithDependency *baseObjectFromParent = [injector getObject:[ObjectWithDependency class]];
                    ObjectWithDependency *baseObjectFromChild = [childInjector getObject:[ObjectWithDependency class]];

                    [[baseObjectFromParent.someDependency should] equal:baseDependencyForParent];
                    [[baseObjectFromChild.someDependency should] equal:baseDependencyForParent];
                });

            });

        });

        SPEC_END