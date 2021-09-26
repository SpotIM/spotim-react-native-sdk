package com.spotim.reactnative;

import android.content.Context;
import android.util.Log;

import com.facebook.react.bridge.Arguments;
import com.facebook.react.bridge.Promise;
import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactContextBaseJavaModule;
import com.facebook.react.bridge.ReactMethod;
import com.facebook.react.bridge.WritableMap;
import com.facebook.react.modules.core.DeviceEventManagerModule;
import com.google.gson.Gson;

import org.json.JSONException;
import org.json.JSONObject;

import spotIm.common.SpotCallback;
import spotIm.common.SpotException;
import spotIm.common.SpotVoidCallback;
import spotIm.common.UserStatus;
import spotIm.common.login.LoginDelegate;
import spotIm.common.model.CompleteSSOResponse;
import spotIm.common.model.SsoWithJwtResponse;
import spotIm.common.model.StartSSOResponse;
import spotIm.sdk.SpotIm;

public class SpotIMModule extends ReactContextBaseJavaModule {

    public static final String LOGIN_STATUS_GUEST = "guest";
    public static final String LOGIN_STATUS_LOGGED_IN = "loggedIn";
    public static final String LOGOUT_SUCCESS = "Logout from SpotIm was successful";

    private static ReactApplicationContext reactContext;

    @Override
    public String getName() {
        return "SpotIM";
    }

    SpotIMModule(ReactApplicationContext context) {
        super(context);
        reactContext = context;
    }

    @ReactMethod
    public void initWithSpotId(String spodId) {
        SpotIm.init(reactContext, spodId);

        SpotIm.setLoginDelegate(new LoginDelegate() {
            @Override
            public void startLoginFlow(Context activityContext) {
                WritableMap params = Arguments.createMap();
                reactContext
                        .getJSModule(DeviceEventManagerModule.RCTDeviceEventEmitter.class)
                        .emit("startLoginFlow", params);
            }
            @Override
            public boolean shouldDisplayLoginPromptForGuests() {
                return false;
            }
        });
    }

    @ReactMethod
    public void startSSO() {
        SpotIm.startSSO(new SpotCallback<StartSSOResponse>() {
            @Override
            public void onSuccess(StartSSOResponse response) {
                try {
                    Gson gson = new Gson();
                    WritableMap responseMap = ReactNativeJson.convertJsonToMap(new JSONObject(gson.toJson(response)));
                    reactContext
                            .getJSModule(DeviceEventManagerModule.RCTDeviceEventEmitter.class)
                            .emit("startSSOSuccess", responseMap);
                } catch (JSONException e) {
                    sendError("startSSOFailed", e);
                }
            }

            @Override
            public void onFailure(SpotException e) {
                sendError("startSSOFailed", e);
            }
        });
    }

    @ReactMethod
    public void completeSSO(String codeB) {
        SpotIm.completeSSO(codeB, new SpotCallback<CompleteSSOResponse>() {
            @Override
            public void onSuccess(CompleteSSOResponse response) {
                try {
                    Gson gson = new Gson();
                    WritableMap responseMap = ReactNativeJson.convertJsonToMap(new JSONObject(gson.toJson(response)));
                    reactContext
                            .getJSModule(DeviceEventManagerModule.RCTDeviceEventEmitter.class)
                            .emit("completeSSOSuccess", responseMap);
                } catch (JSONException e) {
                    sendError("completeSSOFailed", e);
                }
            }

            @Override
            public void onFailure(SpotException e) {
                sendError("completeSSOFailed", e);
            }
        });
    }

    @ReactMethod
    public void ssoWithJwtSecret(String jwt) {
        SpotIm.ssoWithJwt(jwt, new SpotCallback<SsoWithJwtResponse>() {
            @Override
            public void onSuccess(SsoWithJwtResponse response) {
                try {
                    Gson gson = new Gson();
                    WritableMap responseMap = ReactNativeJson.convertJsonToMap(new JSONObject(gson.toJson(response)));
                    reactContext
                            .getJSModule(DeviceEventManagerModule.RCTDeviceEventEmitter.class)
                            .emit("ssoSuccess", responseMap);
                } catch (JSONException e) {
                    sendError("ssoFailed", e);
                }
            }

            @Override
            public void onFailure(SpotException e) {
                sendError("ssoFailed", e);
            }
        });
    }

    @ReactMethod
    public void getUserLoginStatus(final Promise promise) {
        SpotIm.getUserStatus(new SpotCallback<UserStatus>() {
            @Override
            public void onSuccess(UserStatus status) {
                JSONObject json = new JSONObject();
                String statusString = "";
                if (status == UserStatus.GUEST) {
                    statusString = LOGIN_STATUS_GUEST;
                } else {
                    statusString = LOGIN_STATUS_LOGGED_IN;
                }

                try {
                    json.put("status", statusString);
                    WritableMap responseMap = ReactNativeJson.convertJsonToMap(json);
                    reactContext
                            .getJSModule(DeviceEventManagerModule.RCTDeviceEventEmitter.class)
                            .emit("getUserLoginStatusSuccess", responseMap);
                } catch (JSONException jsonException) {
                    sendError("getUserLoginStatusFailed", jsonException);
                }
            }

            @Override
            public void onFailure(SpotException e) {
                sendError("getUserLoginStatusFailed", e);
            }
        });
    }

    @ReactMethod
    public void logout() {
        SpotIm.logout(new SpotVoidCallback() {
            @Override
            public void onSuccess() {
                try {
                    JSONObject json = new JSONObject();
                    json.put("success", true);
                    WritableMap responseMap = ReactNativeJson.convertJsonToMap(json);
                    reactContext
                            .getJSModule(DeviceEventManagerModule.RCTDeviceEventEmitter.class)
                            .emit("logoutSuccess", responseMap);
                } catch (JSONException jsonException) {
                    sendError("logoutFailed", jsonException);
                }
            }

            @Override
            public void onFailure(SpotException e) {
                sendError("logoutFailed", e);
            }
        });
    }

    private void sendError(String errorEvent, Exception e) {
        JSONObject json = new JSONObject();
        WritableMap responseMap = Arguments.createMap();
        try {
            json.put("error", e.toString());
            responseMap = ReactNativeJson.convertJsonToMap(json);
        } catch (JSONException jsonException) {
            jsonException.printStackTrace();
        } finally {
            reactContext
                    .getJSModule(DeviceEventManagerModule.RCTDeviceEventEmitter.class)
                    .emit(errorEvent, responseMap);
        }
    }
}
