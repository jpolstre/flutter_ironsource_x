package com.metamorfosis_labs.flutter_ironsource_x

import android.app.Activity
import android.content.Context
import android.util.Log
import android.view.View
import android.widget.FrameLayout

import android.widget.Toast
import com.ironsource.mediationsdk.ISBannerSize
import com.ironsource.mediationsdk.IronSource
import com.ironsource.mediationsdk.IronSourceBannerLayout
import com.ironsource.mediationsdk.adunit.adapter.utility.AdInfo
import com.ironsource.mediationsdk.logger.IronSourceError

import com.ironsource.mediationsdk.sdk.LevelPlayBannerListener
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.platform.PlatformView
import java.util.*


class IronSourceBannerView internal constructor(
    context: Context?,
    id: Int,
    args: HashMap<*, *>,
    messenger: BinaryMessenger?,
    activity: Activity
) : PlatformView, LevelPlayBannerListener {
    private val adView: FrameLayout
    private val tag = "IronSourceBannerView"
    private val channel: MethodChannel
    private val args: HashMap<*, *>
    private val context: Context
    private val activity: Activity
    private val mIronSourceBannerLayout: IronSourceBannerLayout
//    private fun loadBanner() {
//        if (adView.childCount > 0) adView.removeAllViews()
//        val layoutParams = FrameLayout.LayoutParams(FrameLayout.LayoutParams.MATCH_PARENT,
//                FrameLayout.LayoutParams.WRAP_CONTENT)
//        adView.addView(
//                mIronSourceBannerLayout, 0, layoutParams
//        )
//        adView.visibility = View.VISIBLE
//        IronSource.loadBanner(mIronSourceBannerLayout)
//    }

    override fun getView(): View {
        return adView
    }

    override fun dispose() {
        adView.visibility = View.INVISIBLE
        mIronSourceBannerLayout.removeBannerListener()
        IronSource.destroyBanner(mIronSourceBannerLayout)
        channel.setMethodCallHandler(null)
    }


    override fun onAdLoaded(p0: AdInfo?) {
        activity.runOnUiThread { channel.invokeMethod(IronSourceConsts.ON_BANNER_AD_LOADED, null) }
    }


    override fun onAdLoadFailed(p0: IronSourceError?) {
        activity.runOnUiThread {
            val arguments: MutableMap<String, Any> = HashMap()
            arguments["errorCode"] = p0?.errorCode ?: ""
            arguments["errorMessage"] = p0?.errorMessage ?: ""
            channel.invokeMethod(IronSourceConsts.ON_BANNER_AD_LOAD_FAILED, arguments)
        }
    }

    override fun onAdClicked(p0: AdInfo?) {
        activity.runOnUiThread { channel.invokeMethod(IronSourceConsts.ON_BANNER_AD_CLICKED, null) }
    }

    override fun onAdScreenPresented(p0: AdInfo?) {
        activity.runOnUiThread {
            channel.invokeMethod(
                IronSourceConsts.ON_BANNER_AD_SCREEN_PRESENTED,
                null
            )
        }

    }

    override fun onAdScreenDismissed(p0: AdInfo?) {
        activity.runOnUiThread {
            channel.invokeMethod(
                IronSourceConsts.ON_BANNER_AD_sCREEN_DISMISSED,
                null
            )
        }

    }

    override fun onAdLeftApplication(p0: AdInfo?) {
        activity.runOnUiThread {
            channel.invokeMethod(
                IronSourceConsts.ON_BANNER_AD_LEFT_APPLICATION,
                null
            )
        }

    }


    init {
        channel = MethodChannel(
            messenger!!,
            IronSourceConsts.BANNER_AD_CHANNEL + id
        )
        this.activity = activity
        this.args = args
        this.context = context!!
        adView = FrameLayout(context)
        // choose banner size
        val bannerType = args["banner_type"] as String
        val height = args["height"] as Int
        val width = args["width"] as Int
        val placementName = args["placementName"] as String?
        Log.d("BANNER Width", width.toString())
        Log.d("BANNER Height", height.toString())
//        val size = ISBannerSize.LARGE
        val size = ISBannerSize(bannerType, width, height)


//        val lp = LinearLayout.LayoutParams(width, height)
        // instantiate IronSourceBanner object, using the IronSource.createBanner API
        Log.d("BANNER COUNT:", adView.childCount.toString())
        mIronSourceBannerLayout = IronSource.createBanner(activity, size)
//        mIronSourceBannerLayout = IronSource.createBanner(this, size)
//        adView.addView(mIronSourceBannerLayout, 0, lp)
        // mIronSourceBannerLayout.bannerListener = this

        mIronSourceBannerLayout?.let {
            // add IronSourceBanner to your container
            /*val layoutParams = FrameLayout.LayoutParams(FrameLayout.LayoutParams.MATCH_PARENT,
                    FrameLayout.LayoutParams.MATCH_PARENT)*/

            // binding.bannerFooter.addView(it, 0, layoutParams)
            if (adView.childCount > 0) adView.removeAllViews()

            val layoutParams = FrameLayout.LayoutParams(
                FrameLayout.LayoutParams.MATCH_PARENT,
                FrameLayout.LayoutParams.WRAP_CONTENT
            )
            adView.addView(
                mIronSourceBannerLayout, 0, layoutParams
            )


            // set the banner listener

            it.levelPlayBannerListener = object : LevelPlayBannerListener {
                override fun onAdLoaded(p0: AdInfo?) {
                    Log.d(tag, "onBannerAdLoaded")
                    // since banner container was "gone" by default, we need to make it visible as soon as the banner is ready
                    // binding.bannerFooter.visibility = View.VISIBLE
                    adView.visibility = View.VISIBLE
                }

                override fun onAdLoadFailed(p0: IronSourceError?) {
                    Log.d(tag, "onBannerAdLoadFailed $p0")
                }

                override fun onAdClicked(p0: AdInfo?) {
                    Log.d(tag, "onBannerAdClicked")
                }

                override fun onAdLeftApplication(p0: AdInfo?) {
                    TODO("Not yet implemented")
                }

                override fun onAdScreenPresented(p0: AdInfo?) {
                    Log.d(tag, "onBannerAdLeftApplication")
                }

                override fun onAdScreenDismissed(p0: AdInfo?) {
                    Log.d(tag, "onBannerAdScreenDismissed")
                }

            }

            // load ad into the created banner
//                println("placementName Banner: $placementName")
            if (placementName != null) {
                IronSource.loadBanner(it, placementName)
            } else {
                IronSource.loadBanner(it)
            }


        } ?: run {
            Toast.makeText(activity, "IronSource.createBanner returned null", Toast.LENGTH_LONG)
                .show()

        }

//         loadBanner()
    }


}
 