package com.spotim.reactnative;

import android.graphics.Color;
import android.util.Log;
import android.view.Choreographer;
import android.view.View;
import android.view.ViewGroup;
import android.widget.FrameLayout;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import androidx.fragment.app.Fragment;
import androidx.fragment.app.FragmentActivity;

import com.facebook.react.bridge.Arguments;
import com.facebook.react.bridge.Dynamic;
import com.facebook.react.bridge.ReadableArray;
import com.facebook.react.bridge.WritableMap;
import com.facebook.react.common.MapBuilder;
import com.facebook.react.uimanager.ThemedReactContext;
import com.facebook.react.uimanager.ViewGroupManager;
import com.facebook.react.uimanager.annotations.ReactPropGroup;
import com.facebook.react.uimanager.events.RCTEventEmitter;

import java.util.Map;

import spotIm.common.SpotCallback;
import spotIm.common.SpotException;
import spotIm.common.SpotLayoutListener;
import spotIm.common.SpotSSOStartLoginFlowMode;
import spotIm.common.options.Article;
import spotIm.common.options.ConversationOptions;
import spotIm.common.options.theme.SpotImThemeMode;
import spotIm.common.options.theme.SpotImThemeParams;
import spotIm.sdk.SpotIm;

public class SpotimManager extends ViewGroupManager<FrameLayout> {

    ThemedReactContext context;
    FrameLayout viewRoot;

    String postId = "";
    String url = "";
    String title = "";
    String subtitle = "";
    String thumbnailUrl = "";
    Boolean supportAndroidSystemDarkMode = false;
    Boolean androidIsDarkMode = false;
    String darkModeBackgroundColor = "";
    Boolean showLoginScreenOnRootScreen = false;

    public static final String REACT_CLASS = "SpotIM";
    public final int COMMAND_CREATE = 1;

    @Override
    public String getName() {
        return REACT_CLASS;
    }

    @ReactPropGroup(names = {"postId","url","title","subtitle","thumbnailUrl", "supportAndroidSystemDarkMode", "androidIsDarkMode", "darkModeBackgroundColor","showLoginScreenOnRootScreen"})
    public void setProps(View view, int index, Dynamic value) {
        switch (index) {
            case 0:
                postId = value.asString();
                break;
            case 1:
                url = value.asString();
                break;
            case 2:
                title = value.asString();
                break;
            case 3:
                subtitle = value.asString();
                break;
            case 4:
                thumbnailUrl = value.asString();
                break;
            case 5:
                supportAndroidSystemDarkMode = value.asBoolean();
                break;
            case 6:
                androidIsDarkMode = value.asBoolean();
                break;
            case 7:
                darkModeBackgroundColor = value.asString();
                break;
            case 8:
                showLoginScreenOnRootScreen = value.asBoolean();
                break;
        }
    }

    @Override
    public boolean needsCustomLayoutForChildren() {
        return true;
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

        if (commandIdInt == COMMAND_CREATE) {
            createFragment(root, reactNativeViewId);
        }
    }

    public void createFragment(FrameLayout parentLayout, final int reactNativeViewId) {
        SpotImThemeMode themeMode = SpotImThemeMode.LIGHT;
        if (androidIsDarkMode) {
            themeMode = SpotImThemeMode.DARK;
        }

        int darkModeBackgroundColor;
        if (!this.darkModeBackgroundColor.equals("")) {
            darkModeBackgroundColor = Color.parseColor(this.darkModeBackgroundColor);
        } else {
            darkModeBackgroundColor = Color.parseColor("#181818"); // default dark background color
        }

        SpotImThemeParams themeParams = new SpotImThemeParams(supportAndroidSystemDarkMode, themeMode, darkModeBackgroundColor);

        ConversationOptions options = new ConversationOptions.Builder()
                .configureArticle(new Article(url, thumbnailUrl, title, subtitle))
                .addMaxCountOfPreConversationComments(2)
                .addTheme(themeParams)
                .build();

        setupLayoutHack(viewRoot, reactNativeViewId);

        SpotIm.setSsoStartLoginFlowMode(
                showLoginScreenOnRootScreen ?
                        SpotSSOStartLoginFlowMode.ON_ROOT_ACTIVITY :
                        SpotSSOStartLoginFlowMode.DEFAULT
        );

        SpotIm.getPreConversationFragment(postId, options, new SpotCallback<Fragment>() {
            @Override
            public void onSuccess(final Fragment fragment) {
                if(context.getCurrentActivity() != null && context.getCurrentActivity() instanceof FragmentActivity && context.getCurrentActivity().findViewById(reactNativeViewId) != null) {
                    ((FragmentActivity) context.getCurrentActivity())
                            .getSupportFragmentManager()
                            .beginTransaction()
                            .replace(reactNativeViewId, fragment, String.valueOf(reactNativeViewId))
                            .commitAllowingStateLoss();
                    ((FragmentActivity) context.getCurrentActivity())
                            .getSupportFragmentManager().executePendingTransactions();
                }
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

    private void setupLayoutHack(final ViewGroup view,final Integer reactNativeViewId) {
        Choreographer.getInstance().postFrameCallback(new Choreographer.FrameCallback() {
            @Override
            public void doFrame(long frameTimeNanos) {
                ViewGroup parentView = (ViewGroup) view.findViewById(reactNativeViewId).getParent();
                if (parentView != null) {
                    manuallyLayoutChildren(parentView);
                    parentView.getViewTreeObserver().dispatchOnGlobalLayout();
                    Choreographer.getInstance().postFrameCallback(this);
                }
            }
        });
    }

    private void manuallyLayoutChildren(ViewGroup view) {
        for (int i = 0; i < view.getChildCount(); i++) {
            View child = view.getChildAt(i);
            if(child == viewRoot) {
                child.measure(
                        View.MeasureSpec.makeMeasureSpec(view.getMeasuredWidth(), View.MeasureSpec.EXACTLY),
                        View.MeasureSpec.makeMeasureSpec(view.getMeasuredHeight(), View.MeasureSpec.EXACTLY));
                child.layout(child.getLeft(), child.getTop(), child.getMeasuredWidth(), child.getMeasuredHeight());
            }
        }
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
