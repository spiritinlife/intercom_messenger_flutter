import Flutter
import UIKit
import Intercom

public class SwiftIntercomMessengerPlugin: NSObject, FlutterPlugin, FlutterStreamHandler {
    
    
    enum METHODS: String  {
        case INTERCOM_INITIALISE,
        INTERCOM_REGISTER_IDENTIFIED_USER,
        INTERCOM_REGISTER_UNIDENTIFIED_USER,
        INTERCOM_LOGOUT,
        INTERCOM_UPDATE_USER_COMPANY,
        INTERCOM_SET_COMPANY_CUSTOM_ATTRIBUTES,
        INTERCOM_UPDATE_USER,
        INTERCOM_SET_USER_CUSTOM_ATTRIBUTES,
        INTERCOM_SET_LAUNCHER_VISIBILITY,
        INTERCOM_GET_UNREAD_CONVERSATION_COUNT,
        INTERCOM_ADD_UNREAD_CONVERSATION_COUNT_LISTENER,
        INTERCOM_SET_IN_APP_MESSAGE_VISIBILITY,
        INTERCOM_HIDE_MESSENGER,
        INTERCOM_DISPLAY_HELP_CENTER,
        INTERCOM_DISPLAY_MESSENGER,
        INTERCOM_SEND_TOKEN_TO_INTERCOM,
        INTERCOM_HANDLE_INTERCOM_PUSH_NOTIFICATION
    }
    
    private var mEvents:FlutterEventSink?
    
    
    override init() {
        self.mEvents = nil
    }

        
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "intercom_messaging", binaryMessenger: registrar.messenger())
     let eventChannel = FlutterEventChannel(name: "intercom_messaging_stream", binaryMessenger: registrar.messenger())
    let instance = SwiftIntercomMessengerPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
    eventChannel.setStreamHandler(instance)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    
    if let method = METHODS(rawValue: call.method) {
        switch method {
        case .INTERCOM_INITIALISE:
            IntercomBridge.with(call: call, result: result).initialize()
            break
        case .INTERCOM_REGISTER_UNIDENTIFIED_USER:
            IntercomBridge.with(call: call, result: result).registerUnidentifiedUser()
            break
        case .INTERCOM_SET_LAUNCHER_VISIBILITY:
            IntercomBridge.with(call: call, result: result).setLauncherVisibility()
            break
        case .INTERCOM_SET_IN_APP_MESSAGE_VISIBILITY:
            IntercomBridge.with(call: call, result: result).setInAppMessageVisibility()
            break
        case .INTERCOM_DISPLAY_MESSENGER:
            IntercomBridge.with(call: call, result: result).displayMessenger()
            break
        case .INTERCOM_GET_UNREAD_CONVERSATION_COUNT:
            IntercomBridge.with(call: call, result: result).getUnreadConversationCountListener()
            break
        default:
            print("Not a safe place for humans")
        }
    } else {
        print("There isn't a method called \(call.method)")
    }
    

    result("iOS " + UIDevice.current.systemVersion)
  }
    
    
    @objc func updateUnreadCount(_ notification:Notification) {
        mEvents!(Intercom.unreadConversationCount())
    }
    
    public func onListen(withArguments arguments: Any?, eventSink events: @escaping FlutterEventSink) -> FlutterError? {
        mEvents = events
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(updateUnreadCount(_:)),
                                               name: NSNotification.Name.IntercomUnreadConversationCountDidChange,
                                               object: nil)
        
        return nil
    }
    
    public func onCancel(withArguments arguments: Any?) -> FlutterError? {
        return nil
    }
    
}
