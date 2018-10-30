package test.com.intercommessenger

import android.app.Application
import android.util.Log
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodCall
import io.intercom.android.sdk.Intercom
import io.flutter.plugin.common.MethodChannel.Result
import io.intercom.android.sdk.identity.Registration
import io.intercom.android.sdk.UserAttributes
import io.intercom.android.sdk.Company
import io.intercom.android.sdk.UnreadConversationCountListener
import io.intercom.android.sdk.push.IntercomPushClient


class IntercomBridge(private val call: MethodCall, private val result: Result) {


    // Reserved keys
    private val NAME = "name"

    // User reserved keys
    private val EMAIL = "email"
    private val PHONE = "phone"
    private val SIGNED_UP_AT = "signed_up_at"
    private val UNSUBSCRIBED_FROM_EMAILS = "unsubscribed_from_emails"
    private val LANGUAGE_OVERRIDE = "language_override"

    // Company reserved keys
    private val COMPANY_ID = "id"
    private val CREATED_AT = "created_at"
    private val MONTHLY_SPEND = "monthly_spend"
    private val PLAN = "plan"

    companion object {
        fun with(call: MethodCall, result: Result): IntercomBridge {
            return IntercomBridge(call, result)
        }


        private val intercomPushClient = IntercomPushClient()
    }


    private fun success(msg: Any) {
        result.success(msg)
    }

    private fun error(msg: String) {
        result.error("Error", msg, null)
    }


    private fun getArgString(key: String): String {
        return call.argument<String>(key)
    }

    private fun getArgLong(key: String): Long {
        return call.argument<Long>(key)
    }

    private fun getArgInt(key: String): Int {
        return call.argument<Int>(key)
    }

    private fun getArgBool(key: String): Boolean {
        return call.argument<Boolean>(key)
    }


    /**
     * Keys
     * ================
     * androidApiKey
     * appId
     */
    fun initialize(context: Application) {
        Intercom.initialize(context, getArgString("androidApiKey"), getArgString("appId"))


        success("Intercom messaging initialized")
    }


    /**
     * Keys
     * ================
     * userId
     */
    fun registerIdentifiedUser() {
        val registration = Registration.create().withUserId(getArgString("userId"))
        Intercom.client().registerIdentifiedUser(registration)

        success("User registered")
    }


    /**
     * Keys
     * ================
     * userId
     */
    fun registerUnidentifiedUser() {
        Intercom.client().registerUnidentifiedUser()

        success("Anonymous User registered")
    }


    /**
     * Keys
     * ================
     */
    fun logout() {
        Intercom.client().logout()

        success("User logged out")
    }


    /**
     * Keys
     * ================
     * userId
     */
    fun updateUserCompany() {
        val company = Company.Builder()


        if (call.hasArgument(COMPANY_ID)) {
            company.withCompanyId(getArgString(COMPANY_ID))


            if (call.hasArgument(NAME)) {
                company.withName(getArgString(NAME))
            }

            if (call.hasArgument(CREATED_AT)) {
                company.withCreatedAt(getArgLong(CREATED_AT))
            }

            if (call.hasArgument(PLAN)) {
                company.withPlan(getArgString(PLAN))
            }


            if (call.hasArgument(MONTHLY_SPEND)) {
                company.withMonthlySpend(getArgInt(MONTHLY_SPEND))
            }

            val userAttributes = UserAttributes.Builder()
                    .withCompany(company.build())
                    .build()
            Intercom.client().updateUser(userAttributes)

            success("Company updated")
        } else {
            error("Error: Company id required")
        }


    }

    fun setCompanyCustomAttributes() {
        val company = Company.Builder()
        if (call.arguments is Map<*, *>) {
            company.withCustomAttributes(call.arguments as Map<String, *>)
        }
        val userAttributes = UserAttributes.Builder()
                .withCompany(company.build())
                .build()
        Intercom.client().updateUser(userAttributes)
    }


    /**
     * Keys
     * ================
     * userId
     */
    fun updateUser() {
        val userAttributes = UserAttributes.Builder()


        if (call.hasArgument(NAME)) {
            userAttributes.withName(getArgString(NAME))
        }

        if (call.hasArgument(EMAIL)) {
            userAttributes.withEmail(getArgString(EMAIL))
        }

        if (call.hasArgument(PHONE)) {
            userAttributes.withPhone(getArgString(PHONE))
        }

        if (call.hasArgument(LANGUAGE_OVERRIDE)) {
            userAttributes.withLanguageOverride(getArgString(LANGUAGE_OVERRIDE))
        }

        if (call.hasArgument(SIGNED_UP_AT)) {
            userAttributes.withSignedUpAt(getArgLong(SIGNED_UP_AT))
        }
        if (call.hasArgument(UNSUBSCRIBED_FROM_EMAILS)) {
            userAttributes.withUnsubscribedFromEmails(getArgBool(UNSUBSCRIBED_FROM_EMAILS))
        }

        if (call.hasArgument(LANGUAGE_OVERRIDE)) {
            userAttributes.withName(getArgString(LANGUAGE_OVERRIDE))
        }


        Intercom.client().updateUser(userAttributes.build())

        success("User updated")
    }


    fun setUserCustomAttributes() {
        val userAttributes = UserAttributes.Builder()
        if (call.arguments is Map<*, *>) {
            userAttributes.withCustomAttributes(call.arguments as Map<String, *>)
        }
        Intercom.client().updateUser(userAttributes.build())
    }


    fun setLauncherVisibility() {
        if (getArgBool("visible")) {
            Intercom.client().setLauncherVisibility(Intercom.Visibility.VISIBLE)
        } else {
            Intercom.client().setLauncherVisibility(Intercom.Visibility.GONE)
        }
    }

    fun getUnreadConversationCountListener() {
        success(Intercom.client().unreadConversationCount)
    }




    fun setInAppMessageVisibility() {
        if (getArgBool("visible")) {
            Intercom.client().setInAppMessageVisibility(Intercom.Visibility.VISIBLE)
        } else {
            Intercom.client().setInAppMessageVisibility(Intercom.Visibility.GONE)
        }
    }

    fun displayMessenger() {
        Intercom.client().displayMessenger()
    }

    fun hideMessenger() {
        Intercom.client().hideMessenger()
    }

    fun displayHelpCenter() {
        Intercom.client().displayHelpCenter()
    }


    fun sendTokenToIntercom(context: Application) {
        intercomPushClient.sendTokenToIntercom(context, getArgString("refreshedToken"));
    }


    fun handleIntercomPushNotification(context: Application) {
        val message = call.argument<Map<String, String>>("data")
        if (intercomPushClient.isIntercomPush(message)) {
            intercomPushClient.handlePush(context, message)
        }
    }


}