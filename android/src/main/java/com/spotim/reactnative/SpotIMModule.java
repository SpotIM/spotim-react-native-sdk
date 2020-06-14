package com.spotim.reactnative;

import android.content.Context;

import com.facebook.react.bridge.Arguments;
import com.facebook.react.bridge.NativeModule;
import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactContext;
import com.facebook.react.bridge.ReactContextBaseJavaModule;
import com.facebook.react.bridge.ReactMethod;
import com.facebook.react.bridge.Promise;
import com.facebook.react.bridge.WritableMap;
import com.facebook.react.modules.core.DeviceEventManagerModule;
import com.google.gson.Gson;

import org.json.JSONException;
import org.json.JSONObject;

import java.util.Map;
import java.util.HashMap;

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
    public void initWithSpotId(String spodId, Promise promise) {
        SpotIm.init(reactContext, spodId);

        SpotIm.setLoginDelegate(new LoginDelegate() {
            @Override
            public void startLoginFlow(Context activityContext) {
                WritableMap params = Arguments.createMap();
                reactContext
                        .getJSModule(DeviceEventManagerModule.RCTDeviceEventEmitter.class)
                        .emit("startLoginFlow", params);
            }
        });
    }

    @ReactMethod
    public void startSSO(final Promise promise) {
        SpotIm.startSSO(new SpotCallback<StartSSOResponse>() {
            @Override
            public void onSuccess(StartSSOResponse response) {
                try {
                    Gson gson = new Gson();
                    WritableMap responseMap = ReactNativeJson.convertJsonToMap(new JSONObject(gson.toJson(response)));
                    promise.resolve(responseMap);
                } catch (JSONException e) {
                    promise.reject(e);
                }
            }

            @Override
            public void onFailure(SpotException e) {
                promise.reject(e);
            }
        });
    }

    @ReactMethod
    public void completeSSO(String codeB, final Promise promise) {
        SpotIm.completeSSO(codeB, new SpotCallback<CompleteSSOResponse>() {
            @Override
            public void onSuccess(CompleteSSOResponse response) {
                try {
                    Gson gson = new Gson();
                    WritableMap responseMap = ReactNativeJson.convertJsonToMap(new JSONObject(gson.toJson(response)));
                    promise.resolve(responseMap);
                } catch (JSONException e) {
                    promise.reject(e);
                }
            }

            @Override
            public void onFailure(SpotException e) {
                promise.reject(e);
            }
        });
    }

    @ReactMethod
    public void sso(String jwt, final Promise promise) {
        SpotIm.ssoWithJwt(jwt, new SpotCallback<SsoWithJwtResponse>() {
            @Override
            public void onSuccess(SsoWithJwtResponse response) {
                try {
                    Gson gson = new Gson();
                    WritableMap responseMap = ReactNativeJson.convertJsonToMap(new JSONObject(gson.toJson(response)));
                    promise.resolve(responseMap);
                } catch (JSONException e) {
                    promise.reject(e);
                }
            }

            @Override
            public void onFailure(SpotException e) {
                promise.reject(e);
            }
        });
    }

    @ReactMethod
    public void getUserLoginStatus(final Promise promise) {
        SpotIm.getUserStatus(new SpotCallback<UserStatus>() {
            @Override
            public void onSuccess(UserStatus status) {
                if (status == UserStatus.GUEST) {
                    promise.resolve(LOGIN_STATUS_GUEST);
                } else {
                    promise.resolve("user is logged in");
                }
            }

            @Override
            public void onFailure(SpotException e) {
                promise.reject(e);
            }
        });
    }

    @ReactMethod
    public void logout(final Promise promise) {
        SpotIm.logout(new SpotVoidCallback() {
            @Override
            public void onSuccess() {
                promise.resolve(LOGOUT_SUCCESS);
            }

            @Override
            public void onFailure(SpotException e) {
                promise.reject(e);
            }
        });
    }
}