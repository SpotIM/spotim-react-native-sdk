import { Platform } from 'react-native';
import {
  ANDROID_SSO_ENDPOINT_CODE_B_URL,
  SSO_ENDPOINT_CODE_B_URL,
  ACCESS_TOKEN_NETWORK,
  SSO_ENDPOINT_LOGIN,
  ANDROID_SSO_ENDPOINT_LOGIN,
  USERNAME,
  PASSWORD,
} from './Consts';
import axios from 'axios';
import { SpotIMAPI } from '@spot.im/react-native-spotim';

// currently just Test user
export const login = async () => {
  await loginUser();

  const startSSOResponse = await SpotIMAPI.startSSO();
  const codeA = startSSOResponse.code_a;
  const token = startSSOResponse.jwt_token;

  const codeB = await getCodeB(codeA, token, USERNAME);

  const completeSSOResponse = await SpotIMAPI.completeSSO(codeB)

  return completeSSOResponse.success;
}

const loginUser = async () => {
  const url = Platform.OS === 'ios' ? SSO_ENDPOINT_LOGIN : ANDROID_SSO_ENDPOINT_LOGIN;

  const res = await axios.post(url, { username: USERNAME, password: PASSWORD });

  return res?.data?.token;
}

const getCodeB = async (codeA: string, userToken: string, username: string) => {
  const url = Platform.OS === 'ios' ? SSO_ENDPOINT_CODE_B_URL : ANDROID_SSO_ENDPOINT_CODE_B_URL;

  const res = await axios.post(
    url,
    { code_a: codeA, access_token: userToken, username: username, environment: 'production' },
    { headers: { 'access-token-network': ACCESS_TOKEN_NETWORK, 'content-type': 'application/json' } });

  return res?.data?.code_b;
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
