package com.metamorfosis_labs.flutter_ironsource_x

import android.app.Activity
import com.ironsource.mediationsdk.adunit.adapter.utility.AdInfo
import com.ironsource.mediationsdk.logger.IronSourceError
import com.ironsource.mediationsdk.model.Placement
import com.ironsource.mediationsdk.sdk.LevelPlayRewardedVideoListener
import io.flutter.plugin.common.MethodChannel
import java.util.HashMap

class RewardedVideoAd(activity: Activity, channel: MethodChannel): LevelPlayRewardedVideoListener {
    private var mActivity : Activity
    private var mChannel : MethodChannel
    init {
        mActivity = activity
        mChannel = channel
//        IronSource.setLevelPlayRewardedVideoListener(this)
    }
    override fun onAdOpened(p0: AdInfo?) {
        mActivity.runOnUiThread {
        mChannel.invokeMethod(IronSourceConsts.ON_REWARDED_VIDEO_AD_OPENED, null)
        }
    }

    override fun onAdShowFailed(p0: IronSourceError?, p1: AdInfo?) {
        mActivity.runOnUiThread { //back on UI thread...
            val arguments = HashMap<String, Any>()
            if(p0!=null){
                arguments["errorCode"] = p0.errorCode
                arguments["errorMessage"] = p0.errorMessage
            }
             mChannel.invokeMethod(IronSourceConsts.ON_REWARDED_VIDEO_AD_SHOW_FAILED, arguments)
        }
    }

    override fun onAdClicked(p0: Placement?, p1: AdInfo?) {
        mActivity.runOnUiThread {
            val arguments = HashMap<String, Any>()
            arguments["placementId"] = p0?.placementId ?:""
            arguments["placementName"] = p0?.placementName ?:""
            arguments["rewardAmount"] = p0?.rewardAmount ?:""
            arguments["rewardName"] =p0?.rewardName ?:""
            mChannel.invokeMethod(IronSourceConsts.ON_REWARDED_VIDEO_AD_CLICKED, arguments)
        }
    }

    override fun onAdRewarded(p0: Placement?, p1: AdInfo?) {
        mActivity.runOnUiThread {
            val arguments = HashMap<String, Any>()
            if(p0!=null){
                arguments["placementId"] = p0.placementId
                arguments["placementName"] = p0.placementName
                arguments["rewardAmount"] = p0.rewardAmount
                arguments["rewardName"] = p0.rewardName
            }
            mChannel.invokeMethod(IronSourceConsts.ON_REWARDED_VIDEO_AD_REWARDED, arguments)
        }
    }

    override fun onAdClosed(p0: AdInfo?) {
        mActivity.runOnUiThread {
            mChannel.invokeMethod(IronSourceConsts.ON_REWARDED_VIDEO_AD_CLOSED, null)
        }
    }

    override fun onAdAvailable(p0: AdInfo?) {
        mActivity.runOnUiThread {
            mChannel.invokeMethod(IronSourceConsts.ON_REWARDED_VIDEO_AVAILABILITY_CHANGED, true)
        }
    }

    override fun onAdUnavailable() {
        mActivity.runOnUiThread {
            mChannel.invokeMethod(IronSourceConsts.ON_REWARDED_VIDEO_AVAILABILITY_CHANGED, false)
        }
    }
}