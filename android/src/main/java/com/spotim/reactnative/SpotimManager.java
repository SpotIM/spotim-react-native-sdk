package com.spotim.reactnative;

import android.app.Activity;
import android.graphics.Color;
import android.graphics.Rect;
import android.util.Log;
import android.view.Choreographer;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.view.ViewTreeObserver;
import android.widget.FrameLayout;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import androidx.appcompat.app.AppCompatActivity;
import androidx.appcompat.widget.AppCompatCheckBox;
import androidx.fragment.app.Fragment;
import androidx.fragment.app.FragmentActivity;
import androidx.fragment.app.FragmentManager;
import androidx.fragment.app.FragmentTransaction;

import com.facebook.react.bridge.Arguments;
import com.facebook.react.bridge.Dynamic;
import com.facebook.react.bridge.ReadableArray;
import com.facebook.react.bridge.WritableMap;
import com.facebook.react.common.MapBuilder;
import com.facebook.react.uimanager.SimpleViewManager;
import com.facebook.react.uimanager.ThemedReactContext;
import com.facebook.react.uimanager.UIManagerModule;
import com.facebook.react.uimanager.ViewGroupManager;
import com.facebook.react.uimanager.annotations.ReactProp;
import com.facebook.react.uimanager.annotations.ReactPropGroup;
import com.facebook.react.uimanager.events.RCTEventEmitter;

import java.util.Map;
import java.util.concurrent.CountDownLatch;

import spotIm.common.SpotCallback;
import spotIm.common.SpotException;
import spotIm.common.SpotLayoutListener;
import spotIm.common.options.Article;
import spotIm.common.options.ConversationOptions;
import spotIm.common.options.theme.SpotImThemeMode;
import spotIm.common.options.theme.SpotImThemeParams;
import spotIm.sdk.SpotIm;

public class SpotimManager extends ViewGroupManager<FrameLayout> {

    ThemedReactContext context;
    FrameLayout viewRoot;

    String spotId = "";
    String postId = "";
    String url = "";
    String title = "";
    String subtitle = "";
    String thumbnailUrl = "";
    String darkModeBackgroundColor = "";

    public static final String REACT_CLASS = "SpotIM";
    public final int COMMAND_CREATE = 1;

    @Override
    public String getName() {
        return REACT_CLASS;
    }

    @ReactPropGroup(names = {"spotId","postId","url","title","subtitle","thumbnailUrl","darkModeBackgroundColor"})
    public void setSpotId(View view, int index, Dynamic value) {
        switch (index) {
            case 0:
                spotId = value.asString();
                break;
            case 1:
                postId = value.asString();
                break;
            case 2:
                url = value.asString();
                break;
            case 3:
                title = value.asString();
                break;
            case 4:
                subtitle = value.asString();
                break;
            case 5:
                thumbnailUrl = value.asString();
                break;
            case 6:
                darkModeBackgroundColor = value.asString();
                break;
        }
    }

    @Override
    public boolean needsCustomLayoutForChildren() {
        return true;
    }

    @ReactProp(name = "spotId")
    public void setSpotId(FrameLayout view, @NonNull String value) {
        SpotIm.init(context, value);
        spotId = value;
    }

    @Override
    public Map<String, Integer> getCommandsMap() {
        return MapBuilder.of(
                "create", COMMAND_CREATE
        );
    }

    @Override
    public void receiveCommand(@NonNull FrameLayout root, String commandId, @Nullable ReadableArray args) {
        super.receiveCommand(root, commandId, args);

        viewRoot = root;

        int reactNativeViewId = args.getInt(0);
        int commandIdInt = Integer.parseInt(commandId);

        switch (commandIdInt) {
            case COMMAND_CREATE:
                createFragment(root, reactNativeViewId);
                break;
            default: {

            }
        }
    }

    public void createFragment(FrameLayout parentLayout, final int reactNativeViewId) {
        SpotImThemeParams themeParams = new SpotImThemeParams(false, SpotImThemeMode.LIGHT, Color.WHITE);
        if (darkModeBackgroundColor != "") {
            SpotImThemeMode themeMode = SpotImThemeMode.DARK;
            int backgroundColor = Color.parseColor(darkModeBackgroundColor);
            themeParams = new SpotImThemeParams(false, themeMode, backgroundColor);
        }

        ConversationOptions options = new ConversationOptions.Builder()
                .configureArticle(new Article(url, thumbnailUrl, title, subtitle))
                .addMaxCountOfPreConversationComments(2)
                .addTheme(themeParams)
                .build();

        SpotIm.getPreConversationFragment(postId, options, new SpotCallback<Fragment>() {
            @Override
            public void onSuccess(final Fragment fragment) {
                ((FragmentActivity)context.getCurrentActivity())
                        .getSupportFragmentManager()
                        .beginTransaction()
                        .replace(reactNativeViewId, fragment, String.valueOf(reactNativeViewId))
                        .commit();
                ((FragmentActivity)context.getCurrentActivity())
                        .getSupportFragmentManager().executePendingTransactions();
            }

            @Override
            public void onFailure(SpotException exception) {
                Log.d("MainActivity", exception.toString());
            }
        }, new SpotLayoutListener() {
            @Override
            public void heightDidChange(float v) {
                WritableMap map = Arguments.createMap();
                map.putInt("height", Math.round(v));
                context.getJSModule(RCTEventEmitter.class)
                        .receiveEvent(reactNativeViewId, "topChange", map);
            }
        });
    }

    @Override
    public Map getExportedCustomBubblingEventTypeConstants() {
        return MapBuilder.builder()
                .put(
                        "topChange",
                        MapBuilder.of("phasedRegistrationNames", MapBuilder.of("bubbled", "onChange"))
                )
                .build();
    }

    @Override
    public FrameLayout createViewInstance(ThemedReactContext c) {
        context = c;
        return new FrameLayout(context);
    }
}
