import { Platform } from 'react-native';
import {
  ANDROID_SSO_ENDPOINT_CODE_B_URL,
  SSO_ENDPOINT_CODE_B_URL,
  ACCESS_TOKEN_NETWORK,
} from './Consts';
import { SpotIMAPI } from '@spot.im/react-native-spotim';

export function getCodeB(codeA, userToken, username) {
  return new Promise((resolve, reject) => {
    const Http = new XMLHttpRequest();
    if (Platform.OS === 'ios') {
      Http.open('POST', SSO_ENDPOINT_CODE_B_URL);
    } else {
      Http.open('POST', ANDROID_SSO_ENDPOINT_CODE_B_URL);
    }
    Http.setRequestHeader('access-token-network', ACCESS_TOKEN_NETWORK);
    Http.setRequestHeader('content-type', 'application/json');
    Http.send(
      JSON.stringify({
        code_a: codeA,
        access_token: userToken,
        username: username,
        environment: 'production',
      }),
    );
    Http.onreadystatechange = e => {
      if (Http.readyState === 4) {
        const json = JSON.parse(Http.responseText);
        console.log('Got code B: ');
        console.log(json);
        SpotIMAPI.completeSSO(json.code_b)
          .then(response => {
            console.log('SpotIm: ' + response.success);
            if (response.success) {
              resolve();
            } else {
              reject();
            }
          })
          .catch(error => {
            console.log('SpotIm: ' + error);
            reject();
          });
      }
    };
  });
}

export function getUserStatus() {
  return new Promise((resolve, reject) => {
    SpotIMAPI.getUserLoginStatus()
      .then(response => {
        console.log('User status is: ' + response.status);
        resolve(response.status);
      })
      .catch(error => {
        console.log('User status error: ');
        console.log(error);
        reject();
      });
  });
}
