/*
 * Copyright (c) 2010-2011 SURFnet bv
 * All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions
 * are met:
 * 1. Redistributions of source code must retain the above copyright
 *    notice, this list of conditions and the following disclaimer.
 * 2. Redistributions in binary form must reproduce the above copyright
 *    notice, this list of conditions and the following disclaimer in the
 *    documentation and/or other materials provided with the distribution.
 * 3. Neither the name of SURFnet bv nor the names of its contributors
 *    may be used to endorse or promote products derived from this
 *    software without specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE AUTHOR ``AS IS'' AND ANY EXPRESS OR
 * IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
 * WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
 * ARE DISCLAIMED. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY
 * DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
 * DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE
 * GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
 * INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER
 * IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR
 * OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN
 * IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */

import Foundation
import NotificationCenter

@objcMembers
public class RecentNotifications: NSObject {
    
    private static let keyLastNotificationTimeoutTimestamp = "lastNotificationTimeoutTimestamp"
    private static let keyLastNotificationChallenge = "lastNotificationChallenge"
    private static let keyLastNotificationIdentifier = "lastNotificationIdentifier"
    
    private let appGroup: String
    
    /**
     Create a new instance of this helper class. You need to supply the app group in the constructor, so that NSE and the app itself can deliver the data through UserDefaults.
     If you supply the wrong app group, the data will not arrive in the app. If you see the following warning in the console log while starting the app, it probably works fine:
     "[User Defaults] Couldn't read values in CFPrefsPlistSource..."
     */
    public init(appGroup: String) {
        self.appGroup = appGroup
    }
    
    private func defaults() -> UserDefaults {
        return UserDefaults.init(suiteName: appGroup)!
    }
    
    public func onNewNotification(timeOut: Any?, challenge: Any?, notificationId: String) {
        guard let challengeUrl = challenge as? String else {
            assertionFailure("Challenge is not a string! Received: \(challenge ?? "<nil>").")
            return
        }
        var timeOutSeconds = 150
        if timeOut is Int {
            timeOutSeconds = timeOut as! Int
        } else if timeOut is Float {
            timeOutSeconds = Int(timeOut as! Float)
        } else if timeOut is Double {
            timeOutSeconds = Int(timeOut as! Double)
        } else if timeOut is String {
            if let timeOutInt = Int(timeOut as! String) {
                timeOutSeconds = timeOutInt
            }
        }
        let timeoutTimestamp = Int(Date().timeIntervalSince1970) + timeOutSeconds * 1000
        let defaults = defaults()
        defaults.setValue(timeoutTimestamp, forKey: RecentNotifications.keyLastNotificationTimeoutTimestamp)
        defaults.setValue(challengeUrl, forKey: RecentNotifications.keyLastNotificationChallenge)
        defaults.setValue(notificationId, forKey: RecentNotifications.keyLastNotificationIdentifier)
    }
    
    public func getLastNotificationChallenge() -> String? {
        let defaults = defaults()
        let timeoutTimestamp = defaults.integer(forKey: RecentNotifications.keyLastNotificationTimeoutTimestamp)
        if timeoutTimestamp < Int(Date().timeIntervalSince1970) {
            // Already timed out
            return nil
        }
        let challengeUrl = defaults.string(forKey: RecentNotifications.keyLastNotificationChallenge)
        if let notificationIdentifier = defaults.string(forKey: RecentNotifications.keyLastNotificationIdentifier) {
            UNUserNotificationCenter.current().removeDeliveredNotifications(withIdentifiers: [notificationIdentifier])
        }
        // Clear so we don't trigger it twice
        defaults.removeObject(forKey: RecentNotifications.keyLastNotificationChallenge)
        defaults.removeObject(forKey: RecentNotifications.keyLastNotificationTimeoutTimestamp)
        defaults.removeObject(forKey: RecentNotifications.keyLastNotificationIdentifier)
        return challengeUrl
    }
}
