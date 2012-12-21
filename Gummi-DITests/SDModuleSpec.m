//
// Created by sschmid on 17.12.12.
//
// contact@sschmid.com
//


#import "Kiwi.h"
#import "SDModule.h"
#import "SDInjector.h"


SPEC_BEGIN(SDModuleSpec)

        describe(@"SDModule", ^{

            __block SDModule *module;
            __block SDInjector *injector;
            beforeEach(^{
                module = [[SDModule alloc] init];
                injector = [[SDInjector alloc] init];
            });

            it(@"creates module", ^{
                [[module should] beKindOfClass:[SDModule class]];
            });

        });

        SPEC_END
