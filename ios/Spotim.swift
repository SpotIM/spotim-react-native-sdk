//
//  RNSpotim-swift.swift
//  RNSpotim
//
//  Created by SpotIM on 11/04/2020.
//  Copyright © 2020 Facebook. All rights reserved.
//

import Foundation
import SpotImCore

@objc public protocol SpotImLoginDelegate: AnyObject {
    @objc func startLoginFlow()
}

@objc public protocol SpotImLayoutDelegate: AnyObject {
    @objc func viewHeightDidChange(to newValue: CGFloat)
}

@objc public enum SpotImUserInterfaceStyle: Int {
    case light, dark
}

@objc(SpotImBridge)
public class SpotImBridge: NSObject, SpotImCore.SpotImLoginDelegate, SpotImCore.SpotImLayoutDelegate {
    
    var spotImCoordinator: SpotImSDKFlowCoordinator!
    
    @objc public func startLoginFlow() {
        NotificationCenter.default.post(name: Notification.Name("StartLoginFlow"), object: nil)
    }
    
    @objc public func viewHeightDidChange(to newValue: CGFloat) {
        NotificationCenter.default.post(name: Notification.Name("ViewHeightDidChange"), object: String(describing: newValue))
    }
    
    @objc public func initialize(_ spotId: String) {
        SpotIm.initialize(spotId: spotId)
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
    
    @objc public func startSSO(_ completion: @escaping (String) -> Void,
                                 onError: @escaping (Error) -> Void) {
        SpotIm.startSSO { [weak self] response, error in
            if let error = error {
                onError(error)
            } else {
                completion(String(describing: response))
            }
        }
    }
    
    @objc public func completeSSO(_ with: String, completion: @escaping (String) -> Void,
                                    onError: @escaping (Error) -> Void) {
        SpotIm.completeSSO(with: with) { [weak self] success, error in
            if let error = error {
                onError(error)
            } else if success {
                completion(String(describing: success))
            }
        }
    }
    
    @objc public func sso(_ withJwtSecret: String, completion: @escaping (String) -> Void,
                            onError: @escaping (Error) -> Void) {
        SpotIm.sso(withJwtSecret: withJwtSecret) { [weak self] response, error in
            if let error = error {
                onError(error)
            } else {
                completion(String(describing: response))
            }
        }
    }
    
    @objc public func getUserLoginStatus(_ completion: @escaping (String) -> Void,
                                           onError: @escaping (Error) -> Void) {
        SpotIm.getUserLoginStatus(completion: { result in
            switch result {
                case .success(let loginStatus):
                    completion("\(loginStatus)")
                case .failure(let error):
                    onError(error)
                @unknown default:
                    print("Got unknown response")
            }
        })
    }
    
    @objc public func logout(_ completion: @escaping (String) -> Void,
                               onError: @escaping (Error) -> Void) {
        SpotIm.logout(completion: { result in
            switch result {
                case .success():
                    completion("Logout from SpotIm was successful")
                case .failure(let error):
                    onError(error)
                @unknown default:
                    print("Got unknown response")
            }
        })
    }
}
