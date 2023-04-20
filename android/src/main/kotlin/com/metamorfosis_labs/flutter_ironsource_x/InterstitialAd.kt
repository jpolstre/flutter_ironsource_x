package com.metamorfosis_labs.flutter_ironsource_x
import android.app.Activity
import com.ironsource.mediationsdk.adunit.adapter.utility.AdInfo
import com.ironsource.mediationsdk.logger.IronSourceError
import com.ironsource.mediationsdk.sdk.LevelPlayInterstitialListener
import io.flutter.plugin.common.MethodChannel
import java.util.HashMap

class InterstitialAd(activity: Activity, channel: MethodChannel): LevelPlayInterstitialListener {

    private var mActivity : Activity
    private var mChannel : MethodChannel
    init {
        mActivity = activity
        mChannel = channel
//        IronSource.setLevelPlayRewardedVideoListener(this)
    }
    override fun onAdReady(p0: AdInfo?) {
        mActivity.runOnUiThread {
            mChannel.invokeMethod(IronSourceConsts.ON_INTERSTITIAL_AD_READY, null)
        }
    }

    override fun onAdLoadFailed(p0: IronSourceError?) {
        mActivity.runOnUiThread {
            val arguments = HashMap<String, Any>()
            if(p0!=null){
                arguments["errorCode"] = p0.errorCode
                arguments["errorMessage"] = p0.errorMessage
            }
            mChannel.invokeMethod(IronSourceConsts.ON_INTERSTITIAL_AD_LOAD_FAILED, arguments)
        }
    }

    override fun onAdOpened(p0: AdInfo?) {
        mActivity.runOnUiThread {

            mChannel.invokeMethod(IronSourceConsts.ON_INTERSTITIAL_AD_OPENED, null)


        }
    }

    override fun onAdShowSucceeded(p0: AdInfo?) {
        println("onAdShowSucceeded $p0")
        mActivity.runOnUiThread {
            mChannel.invokeMethod(IronSourceConsts.ON_INTERSTITIAL_AD_SHOW_SUCCEEDED, null)
        }
    }

    override fun onAdShowFailed(p0: IronSourceError?, p1: AdInfo?) {
        mActivity.runOnUiThread {
            val arguments = HashMap<String, Any>()
            if(p0!=null){
                arguments["errorCode"] = p0.errorCode
                arguments["errorMessage"] = p0.errorMessage
            }
            mChannel.invokeMethod(IronSourceConsts.ON_INTERSTITIAL_AD_SHOW_FAILED, arguments)

        }
    }

    override fun onAdClicked(p0: AdInfo?) {
        mActivity.runOnUiThread { //back on UI thread...
            mChannel.invokeMethod(IronSourceConsts.ON_INTERSTITIAL_AD_CLICKED, null)
        }
    }

    override fun onAdClosed(p0: AdInfo?) {
        mActivity.runOnUiThread {
            mChannel.invokeMethod(IronSourceConsts.ON_INTERSTITIAL_AD_CLOSED, null)
        }
    }
}