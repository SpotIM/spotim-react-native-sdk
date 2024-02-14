import { NativeModules, NativeEventEmitter } from 'react-native';

const SpotIMEvents = NativeModules.SpotIMEvents;
export const SpotIMEventEmitter = new NativeEventEmitter(SpotIMEvents);