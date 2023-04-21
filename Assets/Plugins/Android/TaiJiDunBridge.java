package com.dun.bridge;

import android.content.Context;
import android.text.TextUtils;
import android.util.Log;
//import com.cloudaemon.libguandujni.Guandu;
//import com.cloudaemon.libguandujni.GuanduWebViewClient;

import android.app.Activity;
import android.content.Intent;
import android.net.Uri;
import android.os.Build;
import android.os.Bundle;
import android.telephony.TelephonyManager;

import com.android.installreferrer.api.InstallReferrerClient;
import com.android.installreferrer.api.InstallReferrerStateListener;
import com.android.installreferrer.api.ReferrerDetails;
import com.unity3d.player.UnityPlayer;

public class TaiJiDunBridge
{
    private static final String TAG = "u3d";
    private static cn.ay.clinkapi.Api api = null;//定义api对象
    public static int Init(String key){
		api = new cn.ay.clinkapi.Api();//创建api对象
        int ret = api.start(key);//启动客户端安全接入组件(只需要调用一次，最好不要重复调用)，返回150表示成功，其它的为失败，返回0有可能是网络不通或密钥错误，返回170有可能是实例到期或不存在。如果重复调用start()有可能会返回150也可能返回1000，这取决于当时连接的状态，所以最好不要重复调用
        return ret;
    }
    public static void Exit(){
        System.exit(0);
    }
    public static boolean IsEmulator()
    {
        try
        {
            Activity m_activity = UnityPlayer.currentActivity;
            String url = "tel:" + "12345678910";
            Intent intent = new Intent();
            intent.setData(Uri.parse(url));
            intent.setAction(Intent.ACTION_DIAL);
            // 是否可以处理跳转到拨号的 Intent
            boolean canResolveIntent = intent.resolveActivity(m_activity.getPackageManager()) != null;
    
            return Build.FINGERPRINT.startsWith("generic")
                    || Build.FINGERPRINT.toLowerCase().contains("vbox")
                    || Build.FINGERPRINT.toLowerCase().contains("test-keys")
                    || Build.MODEL.contains("google_sdk")
                    || Build.MODEL.contains("Emulator")
                   // || Build.BOARD.equals("unknown")
                   // || Build.BOOTLOADER.equals("unknown")
                    || Build.MODEL.contains("Android SDK built for x86")
                    || Build.MANUFACTURER.contains("Genymotion")
                    || (Build.BRAND.startsWith("generic") && Build.DEVICE.startsWith("generic"))
                    || Build.PRODUCT.equals("google_sdk")
                    || ((TelephonyManager)m_activity.getSystemService(Context.TELEPHONY_SERVICE))
                        .getNetworkOperatorName().toLowerCase().equals("android")
                    || !canResolveIntent;
        }
        catch (Exception e)
        {
            return false;
        }
    }
     //获取用户来源
        public static String initInstallReferrer(){
            Log.d("test", "安卓层获取用户来源");
            try {
                Activity m_activity = UnityPlayer.currentActivity;
                final InstallReferrerClient installReferrerClient = InstallReferrerClient.newBuilder(m_activity.getBaseContext()).build();
                installReferrerClient.startConnection(new InstallReferrerStateListener() {
                    @Override
                    public void onInstallReferrerSetupFinished(int responseCode) {
                        switch (responseCode) {
                            case InstallReferrerClient.InstallReferrerResponse.OK:
                                // Connection established, get referrer
                                if (installReferrerClient != null) {
                                    try {
                                        ReferrerDetails response = installReferrerClient.getInstallReferrer();
                                        String referrer = response.getInstallReferrer();// 你要得referrer值
                                        if (!TextUtils.isEmpty(referrer)) {
                                            UnityPlayer.UnitySendMessage("Singleton Of AndroidBridge","OnGetAndroidMessage",referrer);
                                        }
                                        installReferrerClient.endConnection();
                                    } catch (Exception ex) {
                                        Log.e("InstallReferrerHelper", ex.toString());
                                    }
                                }
                                break;
                            case InstallReferrerClient.InstallReferrerResponse.FEATURE_NOT_SUPPORTED:
                                // API not available on the current Play Store app
                                Log.d("InstallReferrerHelper", "FEATURE_NOT_SUPPORTED");
                                UnityPlayer.UnitySendMessage("Singleton Of AndroidBridge","OnGetAndroidMessage","ERROR");
    
                                break;
                            case InstallReferrerClient.InstallReferrerResponse.SERVICE_UNAVAILABLE:
                                // Connection could not be established
                                Log.d("InstallReferrerHelper", "SERVICE_UNAVAILABLE");
                                UnityPlayer.UnitySendMessage("Singleton Of AndroidBridge","OnGetAndroidMessage","ERROR");
    
                                break;
                        }
                    }
    
                    @Override
                    public void onInstallReferrerServiceDisconnected() {
                        // Try to restart the connection on the next request to
                        // Google Play by calling the startConnection() method.
                    }
    
                });
            } catch (Exception ex) {
                Log.e("InstallReferrerHelper", ex.toString());
            }
            return "";
    
        }
}
