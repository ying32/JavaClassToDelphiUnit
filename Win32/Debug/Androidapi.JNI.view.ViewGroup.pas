//====================================================
//
//  转换来自JavaClassToDelphiUnit
//  时间：2014/8/4 22:14:22
//  作者：ying32
//  QQ: 1444386932
//      396506155
//  Email：yuanfen3287@vip.qq.com
//  个人小站：http://www.ying32.com
//  博客：http://blog.csdn.net/zyjying520
//
//====================================================
unit Androidapi.JNI.view.ViewGroup;

interface

uses
  Androidapi.JNIBridge,
  Androidapi.JNI.JavaTypes;


type
  JViewGroup = interface; // android.view.ViewGroup

  JViewGroupClass = interface(JViewClass)
  ['{CE5E73D0-E5FA-48E8-8D60-9D32E5A5F4A6}']
    { Property Methods }
    function _GETFOCUS_BEFORE_DESCENDANTS: Integer;
    function _GETFOCUS_AFTER_DESCENDANTS: Integer;
    function _GETFOCUS_BLOCK_DESCENDANTS: Integer;
    function _GETPERSISTENT_NO_CACHE: Integer;
    function _GETPERSISTENT_ANIMATION_CACHE: Integer;
    function _GETPERSISTENT_SCROLLING_CACHE: Integer;
    function _GETPERSISTENT_ALL_CACHES: Integer;
    function _GETCLIP_TO_PADDING_MASK: Integer;

    { static Methods }
    function init(context: JContext): JViewGroup; cdecl;
    function init(context: JContext; attrs: JAttributeSet): JViewGroup; cdecl;
    function init(context: JContext; attrs: JAttributeSet; defStyle: Integer): JViewGroup; cdecl;
    function getChildMeasureSpec(padding: Integer; childDimension: Integer): JViewGroup; cdecl;

    { Property }
    property FOCUS_BEFORE_DESCENDANTS: Integer read _GETFOCUS_BEFORE_DESCENDANTS;
    property FOCUS_AFTER_DESCENDANTS: Integer read _GETFOCUS_AFTER_DESCENDANTS;
    property FOCUS_BLOCK_DESCENDANTS: Integer read _GETFOCUS_BLOCK_DESCENDANTS;
    property PERSISTENT_NO_CACHE: Integer read _GETPERSISTENT_NO_CACHE;
    property PERSISTENT_ANIMATION_CACHE: Integer read _GETPERSISTENT_ANIMATION_CACHE;
    property PERSISTENT_SCROLLING_CACHE: Integer read _GETPERSISTENT_SCROLLING_CACHE;
    property PERSISTENT_ALL_CACHES: Integer read _GETPERSISTENT_ALL_CACHES;
    property CLIP_TO_PADDING_MASK: Integer read _GETCLIP_TO_PADDING_MASK;
  end;

  [JavaSignature('android/view/ViewGroup')]
  JViewGroup = interface(JView)
  ['{AC419BA1-2A66-4B4A-B986-E7118DD224B8}']
    { methods }
    function getDescendantFocusability(): Integer; cdecl;
    procedure setDescendantFocusability(focusability: Integer); cdecl;
    procedure requestChildFocus(child: JView; focused: JView); cdecl;
    procedure focusableViewAvailable(v: JView); cdecl;
    function showContextMenuForChild(originalView: JView): Boolean; cdecl;
    function startActionModeForChild(originalView: JView; callback: JActionMode_Callback): JActionMode; cdecl;
    function focusSearch(focused: JView; direction: Integer): JView; cdecl;
    function requestChildRectangleOnScreen(child: JView; rectangle: JRect; immediate: Boolean): Boolean; cdecl;
    function requestSendAccessibilityEvent(child: JView; event: JAccessibilityEvent): Boolean; cdecl;
    function onRequestSendAccessibilityEvent(child: JView; event: JAccessibilityEvent): Boolean; cdecl;
    function dispatchUnhandledMove(focused: JView; direction: Integer): Boolean; cdecl;
    procedure clearChildFocus(child: JView); cdecl;
    procedure clearFocus(); cdecl;
    function getFocusedChild(): JView; cdecl;
    function hasFocus(): Boolean; cdecl;
    function findFocus(): JView; cdecl;
    function hasFocusable(): Boolean; cdecl;
    procedure addFocusables(views: JArrayList; direction: Integer; focusableMode: Integer); cdecl;
    procedure findViewsWithText(outViews: JArrayList; text: JCharSequence; flags: Integer); cdecl;
    procedure dispatchWindowFocusChanged(hasFocus: Boolean); cdecl;
    procedure addTouchables(views: JArrayList); cdecl;
    procedure dispatchDisplayHint(hint: Integer); cdecl;
    procedure dispatchWindowVisibilityChanged(visibility: Integer); cdecl;
    procedure dispatchConfigurationChanged(newConfig: JConfiguration); cdecl;
    procedure recomputeViewAttributes(child: JView); cdecl;
    procedure bringChildToFront(child: JView); cdecl;
    function dispatchDragEvent(event: JDragEvent): Boolean; cdecl;
    procedure dispatchWindowSystemUiVisiblityChanged(visible: Integer); cdecl;
    procedure dispatchSystemUiVisibilityChanged(visible: Integer); cdecl;
    function dispatchKeyEventPreIme(event: JKeyEvent): Boolean; cdecl;
    function dispatchKeyEvent(event: JKeyEvent): Boolean; cdecl;
    function dispatchKeyShortcutEvent(event: JKeyEvent): Boolean; cdecl;
    function dispatchTrackballEvent(event: JMotionEvent): Boolean; cdecl;
    procedure addChildrenForAccessibility(childrenForAccessibility: JArrayList); cdecl;
    function onInterceptHoverEvent(event: JMotionEvent): Boolean; cdecl;
    function dispatchTouchEvent(ev: JMotionEvent): Boolean; cdecl;
    procedure setMotionEventSplittingEnabled(split: Boolean); cdecl;
    function isMotionEventSplittingEnabled(): Boolean; cdecl;
    procedure requestDisallowInterceptTouchEvent(disallowIntercept: Boolean); cdecl;
    function onInterceptTouchEvent(ev: JMotionEvent): Boolean; cdecl;
    function requestFocus(direction: Integer; previouslyFocusedRect: JRect): Boolean; cdecl;
    procedure setClipChildren(clipChildren: Boolean); cdecl;
    procedure setClipToPadding(clipToPadding: Boolean); cdecl;
    procedure dispatchSetSelected(selected: Boolean); cdecl;
    procedure dispatchSetActivated(activated: Boolean); cdecl;
    procedure addView(child: JView); cdecl;
    procedure addView(child: JView; index: Integer); cdecl;
    procedure addView(child: JView; width: Integer; height: Integer); cdecl;
    procedure addView(child: JView; params: JViewGroup_LayoutParams); cdecl;
    procedure addView(child: JView; index: Integer; params: JViewGroup_LayoutParams); cdecl;
    procedure updateViewLayout(view: JView; params: JViewGroup_LayoutParams); cdecl;
    procedure setOnHierarchyChangeListener(listener: JViewGroup_OnHierarchyChangeListener); cdecl;
    procedure removeView(view: JView); cdecl;
    procedure removeViewInLayout(view: JView); cdecl;
    procedure removeViewsInLayout(start: Integer; count: Integer); cdecl;
    procedure removeViewAt(index: Integer); cdecl;
    procedure removeViews(start: Integer; count: Integer); cdecl;
    procedure setLayoutTransition(transition: JLayoutTransition); cdecl;
    function getLayoutTransition(): JLayoutTransition; cdecl;
    procedure removeAllViews(); cdecl;
    procedure removeAllViewsInLayout(); cdecl;
    function invalidateChildInParent(location: TArray<Integer>; dirty: JRect): JViewParent; cdecl;
    function getChildVisibleRect(child: JView; r: JRect; offset: JPoint): Boolean; cdecl;
    procedure startLayoutAnimation(); cdecl;
    procedure scheduleLayoutAnimation(); cdecl;
    procedure setLayoutAnimation(controller: JLayoutAnimationController); cdecl;
    function getLayoutAnimation(): JLayoutAnimationController; cdecl;
    function isAnimationCacheEnabled(): Boolean; cdecl;
    procedure setAnimationCacheEnabled(enabled: Boolean); cdecl;
    function isAlwaysDrawnWithCacheEnabled(): Boolean; cdecl;
    procedure setAlwaysDrawnWithCacheEnabled(always: Boolean); cdecl;
    function getPersistentDrawingCache(): Integer; cdecl;
    procedure setPersistentDrawingCache(drawingCacheToKeep: Integer); cdecl;
    function generateLayoutParams(attrs: JAttributeSet): JViewGroup_LayoutParams; cdecl;
    function indexOfChild(child: JView): Integer; cdecl;
    function getChildCount(): Integer; cdecl;
    function getChildAt(index: Integer): JView; cdecl;
    procedure clearDisappearingChildren(); cdecl;
    procedure startViewTransition(view: JView); cdecl;
    procedure endViewTransition(view: JView); cdecl;
    function gatherTransparentRegion(region: JRegion): Boolean; cdecl;
    procedure requestTransparentRegion(child: JView); cdecl;
    function getLayoutAnimationListener(): JAnimation_AnimationListener; cdecl;
    procedure jumpDrawablesToCurrentState(); cdecl;
    procedure setAddStatesFromChildren(addsStates: Boolean); cdecl;
    function addStatesFromChildren(): Boolean; cdecl;
    procedure childDrawableStateChanged(child: JView); cdecl;
    procedure setLayoutAnimationListener(animationListener: JAnimation_AnimationListener); cdecl;
    function shouldDelayChildPressedState(): Boolean; cdecl;
  end;

  TJViewGroup = class(TJavaGenericImport<JViewGroupClass, JViewGroup>) end;

implementation

end.
