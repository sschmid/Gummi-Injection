//
// Created by sschmid on 17.12.12.
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

            it(@"creates module", ^{
                [[module should] beKindOfClass:[GIModule class]];
            });

        });

        SPEC_END
