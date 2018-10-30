package test.com.intercommessenger

import android.app.Application
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.PluginRegistry.Registrar
import io.intercom.android.sdk.Intercom


class IntercomMessengerPlugin(private val application: Application): MethodCallHandler, EventChannel.StreamHandler {



  enum class METHODS(val method: String) {
    INTERCOM_INITIALISE("INTERCOM_INITIALISE"),
    INTERCOM_REGISTER_IDENTIFIED_USER("INTERCOM_REGISTER_IDENTIFIED_USER"),
    INTERCOM_REGISTER_UNIDENTIFIED_USER("INTERCOM_REGISTER_UNIDENTIFIED_USER"),
    INTERCOM_LOGOUT("INTERCOM_LOGOUT"),
    INTERCOM_UPDATE_USER_COMPANY("INTERCOM_UPDATE_USER_COMPANY"),
    INTERCOM_SET_COMPANY_CUSTOM_ATTRIBUTES("INTERCOM_SET_COMPANY_CUSTOM_ATTRIBUTES"),
    INTERCOM_UPDATE_USER("INTERCOM_UPDATE_USER"),
    INTERCOM_SET_USER_CUSTOM_ATTRIBUTES("INTERCOM_SET_USER_CUSTOM_ATTRIBUTES"),
    INTERCOM_SET_LAUNCHER_VISIBILITY("INTERCOM_SET_LAUNCHER_VISIBILITY"),
    INTERCOM_GET_UNREAD_CONVERSATION_COUNT("INTERCOM_GET_UNREAD_CONVERSATION_COUNT"),
    INTERCOM_ADD_UNREAD_CONVERSATION_COUNT_LISTENER("INTERCOM_ADD_UNREAD_CONVERSATION_COUNT_LISTENER"),
    INTERCOM_SET_IN_APP_MESSAGE_VISIBILITY("INTERCOM_SET_IN_APP_MESSAGE_VISIBILITY"),
    INTERCOM_HIDE_MESSENGER("INTERCOM_HIDE_MESSENGER"),
    INTERCOM_DISPLAY_HELP_CENTER("INTERCOM_DISPLAY_HELP_CENTER"),
    INTERCOM_DISPLAY_MESSENGER("INTERCOM_DISPLAY_MESSENGER"),
    INTERCOM_SEND_TOKEN_TO_INTERCOM("INTERCOM_SEND_TOKEN_TO_INTERCOM"),
    INTERCOM_HANDLE_INTERCOM_PUSH_NOTIFICATION("INTERCOM_HANDLE_INTERCOM_PUSH_NOTIFICATION")
  }



  companion object {
    @JvmStatic
    fun registerWith(registrar: Registrar): Unit {
      val channel = MethodChannel(registrar.messenger(), "intercom_messaging")
      val plugin = IntercomMessengerPlugin(registrar.context() as Application)
      val eventChannel = EventChannel(registrar.messenger(), "intercom_messaging_stream")
      channel.setMethodCallHandler(plugin)
      eventChannel.setStreamHandler(plugin)
    }
  }




  override fun onMethodCall(call: MethodCall, result: Result) {

    when (IntercomMessengerPlugin.METHODS.valueOf(call.method)) {
      IntercomMessengerPlugin.METHODS.INTERCOM_INITIALISE -> IntercomBridge.with(call, result).initialize(application)
      IntercomMessengerPlugin.METHODS.INTERCOM_REGISTER_IDENTIFIED_USER -> IntercomBridge.with(call, result).registerIdentifiedUser()
      IntercomMessengerPlugin.METHODS.INTERCOM_REGISTER_UNIDENTIFIED_USER -> IntercomBridge.with(call, result).registerUnidentifiedUser()
      IntercomMessengerPlugin.METHODS.INTERCOM_LOGOUT -> IntercomBridge.with(call, result).logout()
      IntercomMessengerPlugin.METHODS.INTERCOM_UPDATE_USER_COMPANY -> IntercomBridge.with(call, result).updateUserCompany()
      IntercomMessengerPlugin.METHODS.INTERCOM_SET_COMPANY_CUSTOM_ATTRIBUTES -> IntercomBridge.with(call, result).setCompanyCustomAttributes()
      IntercomMessengerPlugin.METHODS.INTERCOM_UPDATE_USER -> IntercomBridge.with(call, result).updateUser()
      IntercomMessengerPlugin.METHODS.INTERCOM_SET_USER_CUSTOM_ATTRIBUTES -> IntercomBridge.with(call, result).setUserCustomAttributes()
      IntercomMessengerPlugin.METHODS.INTERCOM_SET_LAUNCHER_VISIBILITY -> IntercomBridge.with(call, result).setLauncherVisibility()
      IntercomMessengerPlugin.METHODS.INTERCOM_GET_UNREAD_CONVERSATION_COUNT -> IntercomBridge.with(call, result).getUnreadConversationCountListener()
      IntercomMessengerPlugin.METHODS.INTERCOM_SET_IN_APP_MESSAGE_VISIBILITY -> IntercomBridge.with(call, result).setInAppMessageVisibility()
      IntercomMessengerPlugin.METHODS.INTERCOM_HIDE_MESSENGER -> IntercomBridge.with(call, result).hideMessenger()
      IntercomMessengerPlugin.METHODS.INTERCOM_DISPLAY_HELP_CENTER -> IntercomBridge.with(call, result).displayHelpCenter()
      IntercomMessengerPlugin.METHODS.INTERCOM_DISPLAY_MESSENGER -> IntercomBridge.with(call, result).displayMessenger()
      IntercomMessengerPlugin.METHODS.INTERCOM_SEND_TOKEN_TO_INTERCOM -> IntercomBridge.with(call, result).sendTokenToIntercom(application)
      IntercomMessengerPlugin.METHODS.INTERCOM_HANDLE_INTERCOM_PUSH_NOTIFICATION -> IntercomBridge.with(call, result).handleIntercomPushNotification(application)

    }

  }



  override fun onListen(p0: Any?, eventSink: EventChannel.EventSink?) {
    Intercom.client().addUnreadConversationCountListener { v -> eventSink!!.success(v)}
  }

  override fun onCancel(p0: Any?) {
  }

}


