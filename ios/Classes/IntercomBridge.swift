//
//  IntercomBridge.swift
//  firebase_messaging
//
//  Created by George Chailazopoulos on 29/10/2018.
//

import Foundation
import Intercom

class IntercomBridge {
    var call: FlutterMethodCall
    var result: FlutterResult
    
    
    // Reserved keys
    private var NAME = "name"
    
    // User reserved keys
    private var EMAIL = "email"
    private var PHONE = "phone"
    private var SIGNED_UP_AT = "signed_up_at"
    private var UNSUBSCRIBED_FROM_EMAILS = "unsubscribed_from_emails"
    private var LANGUAGE_OVERRIDE = "language_override"
    
    // Company reserved keys
    private var COMPANY_ID = "id"
    private var CREATED_AT = "created_at"
    private var MONTHLY_SPEND = "monthly_spend"
    private var PLAN = "plan"

    
    init(call: FlutterMethodCall, result: @escaping FlutterResult) {
        self.call = call
        self.result = result
    }
    
    class func with(call: FlutterMethodCall, result: @escaping FlutterResult) -> IntercomBridge {
        return IntercomBridge(call: call, result: result)
    }
    
    private func success(_ msg: Any) {
        self.result(msg)
    }
    
    private func error(_ msg: String) {
        self.result(FlutterError(code: "Error", message: msg, details: nil))
    }
    
    
    private func hasArgument(_ key: String) -> Bool {
        if let arg = call.arguments as? [String: Any] {
            return arg[key] != nil ? true : false
        }
        return false
    }
    
    
    private func getArgString(_ key: String) -> String {
        if let arg = call.arguments as? [String: Any] {
            return arg[key] as! String
        }
        return ""
    }
    
    private func getArgLong(_ key: String) -> Int64 {
        if let arg = call.arguments as? [String: Any] {
            return arg[key] as! Int64
        }
        
        return -1
    }
    
    private func getArgInt(_ key: String) -> Int {
        if let arg = call.arguments as? [String: Any] {
            return arg[key] as! Int
        }
        
        return -1
    }
    
    private func getArgBool(_ key: String) -> Bool {
        if let arg = call.arguments as? [String: Any] {
            return arg[key] as! Bool
        }
        
        return false
    }
    
    private func getArgDate(_ key: String) -> Date {
        if let arg = call.arguments as? [String: Any] {
            return arg[key] as! Date
        }
        
        return Date()
    }
    
    /**
     * Keys
     * ================
     * androidApiKey
     * appId
     */
    func initialize() {
        Intercom.setApiKey(getArgString("iosApiKey"), forAppId: getArgString("appId"))
        success("Intercom messaging initialized")
    }


    /**
     * Keys
     * ================
     * userId
     */
    func registerIdentifiedUser() {
        Intercom.registerUser(withUserId: getArgString("userId"))
        success("User registered")
    }


    /**
     * Keys
     * ================
     * userId
     */
    func registerUnidentifiedUser() {
        Intercom.registerUnidentifiedUser()
        success("Anonymous User registered")
    }


    /**
     * Keys
     * ================
     */
    func logout() {
        Intercom.logout()
        success("User logged out")
    }


    /**
     * Keys
     * ================
     * userId
     */
    func updateUserCompany() {
        let company = ICMCompany()

        if (hasArgument(COMPANY_ID)) {
            company.companyId = getArgString(COMPANY_ID)


            if (hasArgument(NAME)) {
                company.name = getArgString(NAME)
            }

            if (hasArgument(CREATED_AT)) {
                company.createdAt = getArgDate(CREATED_AT)
            }

            if (hasArgument(PLAN)) {
                company.plan = getArgString(PLAN)
            }


            if (hasArgument(MONTHLY_SPEND)) {
                company.monthlySpend = getArgInt(MONTHLY_SPEND) as NSNumber
            }
            
            let userAttributes = ICMUserAttributes()
            userAttributes.companies = [company]

            
            Intercom.updateUser(userAttributes)

            success("Company updated")
        } else {
            error("Error: Company id required")
        }

    }

//    func setCompanyCustomAttributes() {
//        let company = ICMCompany()
//        if (call.arguments is Map<*, *>) {
//        company.withCustomAttributes(call.arguments as Map<String, *>)
//        }
//        val userAttributes = UserAttributes.Builder()
//        .withCompany(company.build())
//        .build()
//        Intercom.client().updateUser(userAttributes)
//    }
//
//
//    /**
//     * Keys
//     * ================
//     * userId
//     */
//    func updateUser() {
//        val userAttributes = UserAttributes.Builder()
//
//
//        if (call.hasArgument(NAME)) {
//        userAttributes.withName(getArgString(NAME))
//        }
//
//        if (call.hasArgument(EMAIL)) {
//        userAttributes.withEmail(getArgString(EMAIL))
//        }
//
//        if (call.hasArgument(PHONE)) {
//        userAttributes.withPhone(getArgString(PHONE))
//        }
//
//        if (call.hasArgument(LANGUAGE_OVERRIDE)) {
//        userAttributes.withLanguageOverride(getArgString(LANGUAGE_OVERRIDE))
//        }
//
//        if (call.hasArgument(SIGNED_UP_AT)) {
//        userAttributes.withSignedUpAt(getArgLong(SIGNED_UP_AT))
//        }
//        if (call.hasArgument(UNSUBSCRIBED_FROM_EMAILS)) {
//        userAttributes.withUnsubscribedFromEmails(getArgBool(UNSUBSCRIBED_FROM_EMAILS))
//        }
//
//        if (call.hasArgument(LANGUAGE_OVERRIDE)) {
//        userAttributes.withName(getArgString(LANGUAGE_OVERRIDE))
//        }
//
//
//        Intercom.client().updateUser(userAttributes.build())
//
//        success("User updated")
//    }
//
//
//    func setUserCustomAttributes() {
//        val userAttributes = UserAttributes.Builder()
//        if (call.arguments is Map<*, *>) {
//        userAttributes.withCustomAttributes(call.arguments as Map<String, *>)
//        }
//        Intercom.client().updateUser(userAttributes.build())
//        }
//
//
    func setLauncherVisibility() {
        Intercom.setLauncherVisible(getArgBool("visible"))
    }

    func getUnreadConversationCountListener() {
        success(Intercom.unreadConversationCount())
    }

    func setInAppMessageVisibility() {
        Intercom.setInAppMessagesVisible(getArgBool("visible"))
    }

    func displayMessenger() {
        Intercom.presentMessenger()
    }

    func hideMessenger() {
        Intercom.hideMessenger()
    }

    func displayHelpCenter() {
        Intercom.presentHelpCenter()
    }


    func sendTokenToIntercom() {
        Intercom.setDeviceToken(getArgString("refreshedToken").data(using: .utf8)!)
    }


    func handleIntercomPushNotification() {
        if let arg = call.arguments as? [String: Any] {
            let message = arg["data"] as! [String : Any]
            if (Intercom.isIntercomPushNotification(message)) {
                Intercom.handlePushNotification(message)
            }
        }
    }

    
    
    
    
}
