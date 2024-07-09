import { NativeModules, Platform } from 'react-native';
import { SpotIMEventEmitter } from './SpotIMEventEmitter';

const ISIOS = Platform.OS === "ios";

export interface OpenFullConversationParams {
  postId: string;
  url: string;
  title: string;
  subtitle: string;
  thumbnailUrl: string;
}

const SpotIMModule = NativeModules.SpotIM;

export class SpotIMAPI {

  static init = (spotId: string) => {
    SpotIMModule.initWithSpotId(spotId)
  }

  static startSSO = () => {
    return new Promise((resolve, reject) => {
      const successSubscription = SpotIMEventEmitter.addListener('startSSOSuccess', (response) => {
        successSubscription.remove();
        failureSubscription.remove();
        resolve(response);
      });

      const failureSubscription = SpotIMEventEmitter.addListener('startSSOFailed', (event) => {
        successSubscription.remove();
        failureSubscription.remove();
        reject(event);
      });

      SpotIMModule.startSSO();
    })
  }

  static completeSSO = (str: string) => {
    return new Promise((resolve, reject) => {
      const successSubscription = SpotIMEventEmitter.addListener('completeSSOSuccess', (response) => {
        successSubscription.remove();
        failureSubscription.remove();
        setTimeout(() => { // Workaround - short delay to make sure the UI is updated
          resolve(response);
        }, 200);
      });

      const failureSubscription = SpotIMEventEmitter.addListener('completeSSOFailed', (event) => {
        successSubscription.remove();
        failureSubscription.remove();
        reject(event);
      });

      SpotIMModule.completeSSO(str);
    })
  }

  static sso = (jwt: string) => {
    return new Promise((resolve, reject) => {
      const successSubscription = SpotIMEventEmitter.addListener('ssoSuccess', (response) => {
        successSubscription.remove();
        failureSubscription.remove();
        resolve(response);
      });

      const failureSubscription = SpotIMEventEmitter.addListener('ssoFailed', (event) => {
        successSubscription.remove();
        failureSubscription.remove();
        reject(event);
      });

      SpotIMModule.ssoWithJwtSecret(jwt);
    })
  }

  static getUserLoginStatus = () => {
    return new Promise((resolve, reject) => {
      const successSubscription = SpotIMEventEmitter.addListener('getUserLoginStatusSuccess', (response) => {
        successSubscription.remove();
        failureSubscription.remove();
        resolve(response);
      });

      const failureSubscription = SpotIMEventEmitter.addListener('getUserLoginStatusFailed', (event) => {
        successSubscription.remove();
        failureSubscription.remove();
        reject(event);
      });

      SpotIMModule.getUserLoginStatus();
    })
  }

  static logout = () => {
    return new Promise((resolve, reject) => {
      const successSubscription = SpotIMEventEmitter.addListener('logoutSuccess', (response) => {
        successSubscription.remove();
        failureSubscription.remove();
        resolve(response);
      });

      const failureSubscription = SpotIMEventEmitter.addListener('logoutFailed', (event) => {
        successSubscription.remove();
        failureSubscription.remove();
        reject(event);
      });

      SpotIMModule.logout();
    })
  }

  static showFullConversation = () => {
    SpotIMModule.showFullConversation()
  }

  static openFullConversation = (params: OpenFullConversationParams) => {
    return new Promise((resolve, reject) => {
      const successSubscription = SpotIMEventEmitter.addListener('openFullConversationSuccess', (response) => {
        successSubscription.remove();
        failureSubscription.remove();
        resolve(response);
      });

      const failureSubscription = SpotIMEventEmitter.addListener('openFullConversationFailed', (error) => {
        successSubscription.remove();
        failureSubscription.remove();
        reject(error);
      });

      SpotIMModule.openFullConversation(
        params.postId,
        params.url,
        params.title,
        params.subtitle,
        params.thumbnailUrl,
      )
    })
  }

  static setIOSDarkMode = (isOn: boolean) => {
    if (ISIOS) {
      SpotIMModule.setIsDarkMode(isOn)
    }
  }
}