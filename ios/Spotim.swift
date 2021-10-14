//
//  RNSpotim-swift.swift
//  RNSpotim
//
//  Created by SpotIM on 11/04/2020.
//  Copyright © 2019 Spot.IM. All rights reserved.
//

import Foundation
import SpotImCore

@objc public protocol SpotImLoginDelegate: AnyObject {
    @objc func startLoginFlow()
}

@objc public protocol SpotImLayoutDelegate: AnyObject {
    @objc func viewHeightDidChange(to newValue: CGFloat)
}

public protocol SPAnalyticsEventDelegate: AnyObject {
    func trackEvent(type: SPEventType, event: SPEventInfo)
}

@objc public enum SpotImUserInterfaceStyle: Int {
    case light, dark
}

@objc(SpotImBridge)
public class SpotImBridge: NSObject, SpotImCore.SpotImLoginDelegate, SpotImCore.SpotImLayoutDelegate, SpotImCore.SPAnalyticsEventDelegate {

    var spotImCoordinator: SpotImSDKFlowCoordinator!

    @objc public func notifyOnCommentCreate(_ shouldNotify: Bool) {
        SpotIm.reactNativeNotifyOnCreateComment = shouldNotify
    }

    @objc public func startLoginFlow() {
        NotificationCenter.default.post(name: Notification.Name("StartLoginFlow"), object: nil)
    }

    @objc public func viewHeightDidChange(to newValue: CGFloat) {
        NotificationCenter.default.post(name: Notification.Name("ViewHeightDidChange"), object: String(describing: newValue))
    }

    public func trackEvent(type: SPEventType, event: SPEventInfo) {
        NotificationCenter.default.post(name: Notification.Name("TrackAnalyticsEvent"), object: getAnalyticsEventAsDictionary(event: event))
    }

    @objc public func initialize(_ spotId: String) {
        SpotIm.initialize(spotId: spotId)
        SpotIm.setAnalyticsEventDelegate(delegate: self)
    }

    @objc public func setBackgroundColor(_ red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat) {
        SpotIm.darkModeBackgroundColor = UIColor(red: red, green: green, blue: blue, alpha: alpha);
    }

    @objc public func overrideUserInterfaceStyle(style: SpotImUserInterfaceStyle) {
        switch style {
        case .light:
            SpotIm.overrideUserInterfaceStyle = .light
        case .dark:
            SpotIm.overrideUserInterfaceStyle = .dark
        }
    }

    @objc public func getConversationCounters(_ conversationIds: Array<String>,
                                                completion: @escaping (String) -> Void,
                                                onError: @escaping (Error) -> Void) {
        SpotIm.getConversationCounters(conversationIds: conversationIds) { result in
            switch result {
                case .success(let counters):
                    completion(String(describing: counters))
                case .failure(let error):
                    onError(error)
                @unknown default:
                    print("Got unknown response")
            }
        }
    }

    @objc public func createSpotImFlowCoordinator(_ loginDelegate: Any,
                                                    completion: @escaping () -> Void,
                                                    onError: @escaping (Error) -> Void) {

        SpotIm.createSpotImFlowCoordinator(loginDelegate: self) { result in
            switch result {
                case .success(let coordinator):
                    self.spotImCoordinator = coordinator
                    self.spotImCoordinator.setLayoutDelegate(delegate: self)
                    completion()
                case .failure(let error):
                    print(error)
                @unknown default:
                    print("Got unknown response")
            }
        }
    }

    @objc public func getPreConversationController(_ nc: UINavigationController,
                                                   postId: String,
                                                   url: String,
                                                   title: String,
                                                   subtitle: String,
                                                   thumbnailUrl: String,
                                                   completion: @escaping (UIViewController) -> Void,
                                                   onError: @escaping (Error) -> Void) {

        let articleMetadata: SpotImArticleMetadata = SpotImArticleMetadata.init(url: url, title: title, subtitle: subtitle, thumbnailUrl: thumbnailUrl)

        self.spotImCoordinator?.preConversationController(withPostId: postId, articleMetadata: articleMetadata, navigationController: nc, completion: { preConversationVC in
             completion(preConversationVC)
        })

    }

    @objc public func startSSO(_ completion: @escaping ([String:Any]) -> Void,
                                 onError: @escaping (Error) -> Void) {
        SpotIm.startSSO { response, error in
            if let error = error {
                onError(error)
            } else {
                if let response = response, let responseAsDic = self.dictionary(encodable: response) {
                    completion(responseAsDic)
                } else {
                    completion([String:Any]())
                }
            }
        }
    }

    @objc public func completeSSO(_ with: String, completion: @escaping ([String:Any]) -> Void,
                                    onError: @escaping (Error) -> Void) {
        SpotIm.completeSSO(with: with) { success, error in
            if let error = error {
                onError(error)
            } else if success {
                completion(["success": success])
            }
        }
    }

    @objc public func sso(_ withJwtSecret: String, completion: @escaping ([String:Any]) -> Void,
                            onError: @escaping (Error) -> Void) {
        SpotIm.sso(withJwtSecret: withJwtSecret) { response, error in
            if let error = error {
                onError(error)
            } else {
                if let response = response, let responseAsDic = self.dictionary(encodable: response) {
                    completion(responseAsDic)
                } else {
                    completion([String:Any]())
                }
            }
        }
    }

    @objc public func getUserLoginStatus(_ completion: @escaping ([String:Any]) -> Void,
                                           onError: @escaping (Error) -> Void) {
        SpotIm.getUserLoginStatus(completion: { result in
            switch result {
                case .success(let loginStatus):
                    completion(["status":"\(loginStatus)"])
                case .failure(let error):
                    onError(error)
                @unknown default:
                    print("Got unknown response")
            }
        })
    }

    @objc public func logout(_ completion: @escaping ([String:Any]) -> Void,
                               onError: @escaping (Error) -> Void) {
        SpotIm.logout(completion: { result in
            switch result {
                case .success():
                    completion(["success": true])
                case .failure(let error):
                    onError(error)
                @unknown default:
                    print("Got unknown response")
            }
        })
    }

    private func getAnalyticsEventAsDictionary(event: SPEventInfo)-> [String: Any] {
        let eventAsDic = dictionary(encodable: event)
        if var eventAsDic = eventAsDic {
            // change key "event_type" to "type"
            eventAsDic["type"] = eventAsDic["event_type"]
            eventAsDic.removeValue(forKey: "event_type")
            // change key "engine_status_type" to "engine_status"
            eventAsDic["engine_status"] = eventAsDic["engine_status_type"]
            eventAsDic.removeValue(forKey: "engine_status_type")
            return eventAsDic
        } else {
            return [:]
        }

    }

    private func dictionary<T>(encodable: T) -> [String: Any]? where T : Encodable {
        let encoder = JSONEncoder()
        encoder.keyEncodingStrategy = .convertToSnakeCase
        guard let data = try? encoder.encode(encodable) else { return nil }
        return (try? JSONSerialization.jsonObject(with: data, options: .allowFragments)).flatMap { $0 as? [String: Any] }
    }
}
