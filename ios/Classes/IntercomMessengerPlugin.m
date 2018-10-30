#import "IntercomMessengerPlugin.h"
#import <intercom_messenger/intercom_messenger-Swift.h>

@implementation IntercomMessengerPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftIntercomMessengerPlugin registerWithRegistrar:registrar];
}
@end
