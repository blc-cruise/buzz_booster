package com.buzzvil.buzz_booster

import android.app.Activity
import android.content.Context
import android.content.Intent
import android.os.Build
import androidx.appcompat.app.AppCompatDelegate
import com.buzzvil.booster.external.BuzzBooster
import com.buzzvil.booster.external.BuzzBoosterActivityTag
import com.buzzvil.booster.external.BuzzBoosterConfig
import com.buzzvil.booster.external.BuzzBoosterJavaScriptInterface
import com.buzzvil.booster.external.BuzzBoosterUser
import com.buzzvil.booster.external.UserEvent
import com.buzzvil.booster.external.UserEventListener
import com.buzzvil.booster.external.campaign.CampaignType
import com.buzzvil.booster.external.campaign.OptInMarketingCampaignMoveButtonClickListener
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import io.flutter.plugin.common.PluginRegistry

/** BuzzBoosterPlugin */
class BuzzBoosterPlugin : FlutterPlugin, MethodCallHandler, ActivityAware, EventChannel.StreamHandler, PluginRegistry.NewIntentListener {
    /// The MethodChannel that will the communication between Flutter and native Android
    ///
    /// This local reference serves to register the plugin with the Flutter Engine and unregister it
    /// when the Flutter Engine is detached from the Activity
    private lateinit var channel: MethodChannel
    private lateinit var context: Context
    private var eventSink: EventChannel.EventSink? = null
    private var activity: Activity? = null
    private var userEvent: UserEvent? = null
    private var optInMarketingMoveButtonClicked: Boolean = false

    override fun onAttachedToEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        context = flutterPluginBinding.applicationContext
        channel = MethodChannel(flutterPluginBinding.binaryMessenger, "buzz_booster")
        channel.setMethodCallHandler(this)

        val linkEventChannel = EventChannel(flutterPluginBinding.binaryMessenger, "buzz_booster/link")
        linkEventChannel.setStreamHandler(this)
        handleOptInMarketingCampaignMoveButtonClicked()
    }

    override fun onMethodCall(call: MethodCall, result: Result) {
        if (call.method == "init") {
            val appKey = call.argument("androidAppKey") as String?
            if (appKey != null) {
                val config = BuzzBoosterConfig(appKey)
                BuzzBooster.init(context, config)
                BuzzBooster.getInstance().setOptInMarketingCampaignMoveButtonClickListener(object: OptInMarketingCampaignMoveButtonClickListener {
                    override fun onClick() {
                        BuzzBooster.getInstance().finishActivity(context, BuzzBoosterActivityTag.CAMPAIGN)
                        BuzzBooster.getInstance().finishActivity(context, BuzzBoosterActivityTag.HOME)
                        optInMarketingMoveButtonClicked = true
                        handleOptInMarketingCampaignMoveButtonClicked()
                    }
                })
                BuzzBooster.getInstance().addUserEventListener(object : UserEventListener {
                    override fun onUserEvent(userEvent: UserEvent) {
                        handleUserEvent(userEvent)
                    }
                })
                result.success(null)
            } else {
                result.error("400", "AndroidAppKey is required", null)
            }
        } else if (call.method == "isInitialized") {
            return result.success(BuzzBooster.isInitialized())
        } else if (call.method == "setUser") {
            val userId = call.argument("userId") as String?
            val optInMarketing = call.argument("optInMarketing") as Boolean?
            val properties = call.argument("properties") as Map<String, Any>?
            
            if (userId != null) {
                val userBuilder = BuzzBoosterUser.Builder()
                    .setUserId(userId)
                
                if (optInMarketing != null){
                    userBuilder.setOptInMarketing(optInMarketing)
                }
                properties?.forEach { entry ->
                    userBuilder.addProperty(entry.key, entry.value)
                }
                BuzzBooster.setUser(userBuilder.build())
            } else {
                BuzzBooster.setUser(null)
            }

            result.success(null)
        } else if (call.method == "sendEvent") {
            val eventName = call.argument("eventName") as String?
            if (eventName != null) {
                val eventValues = call.argument("eventValues") as Map<String, Any>?
                if (eventValues != null) {
                    BuzzBooster.getInstance().sendEvent(eventName, eventValues)
                } else {
                    BuzzBooster.getInstance().sendEvent(eventName)
                }
                result.success(null)
            } else {
                result.error("400", "EventName is required", null)
            }
        } else if (call.method == "showInAppMessage") {
            if (activity != null) {
                BuzzBooster.getInstance().showInAppMessage(activity!!)
            }
            result.success(null)
        } else if (call.method == "showHome") {
            if (activity != null) {
                BuzzBooster.getInstance().showHome(activity!!)
            }
            result.success(null)
        } else if (call.method == "showNaverPayExchange") {
            if (activity != null) {
                BuzzBooster.getInstance().showNaverPayExchange(activity!!)
            }
            result.success(null)
        } else if (call.method == "showCampaignWithId") {
            if (activity != null) {
                val campaignId = call.argument("campaignId") as String?
                BuzzBooster.getInstance().showCampaign(activity!!, campaignId!!)
            }
            result.success(null)
        } else if (call.method == "showCampaignWithType") {
            if (activity != null) {
                when (call.argument("campaignType") as String?) {
                    "attendance" -> BuzzBooster.getInstance().showCampaign(activity!!, CampaignType.Attendance)
                    "referral" -> BuzzBooster.getInstance().showCampaign(activity!!, CampaignType.Referral)
                    "optInMarketing" -> BuzzBooster.getInstance().showCampaign(activity!!, CampaignType.OptInMarketing)
                    "scratchLottery" -> BuzzBooster.getInstance().showCampaign(activity!!, CampaignType.ScratchLottery)
                    "roulette" -> BuzzBooster.getInstance().showCampaign(activity!!, CampaignType.Roulette)
                }
            }
            result.success(null)
        } else if (call.method == "showPage") {
            if (activity != null) {
                val pageId = call.argument("pageId") as String?
                BuzzBooster.getInstance().showPage(activity!!, pageId!!)
            }
            result.success(null)
        } else if (call.method == "setPushToken") {
            val token = call.argument("token") as String?
            if (token != null) {
                BuzzBooster.setFCMToken(token)
            }
            return result.success(null)
        } else if (call.method == "setTheme") {
            if (activity != null) {
                when(val theme = call.argument("theme") as String?) {
                    "light" -> AppCompatDelegate.setDefaultNightMode(AppCompatDelegate.MODE_NIGHT_NO)
                    "dark" -> AppCompatDelegate.setDefaultNightMode(AppCompatDelegate.MODE_NIGHT_YES)
                    "system" -> {
                        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.Q) {
                            AppCompatDelegate.setDefaultNightMode(AppCompatDelegate.MODE_NIGHT_FOLLOW_SYSTEM)
                        } else {
                            AppCompatDelegate.setDefaultNightMode(AppCompatDelegate.MODE_NIGHT_AUTO_BATTERY)
                        }
                    }
                    else -> throw RuntimeException("$theme is not a member of Theme")
                }
            }
            result.success(null)
        } else if (call.method == "isBuzzBoosterNotification") {
            val map = call.argument("map") as Map<String, String>?
            if (map != null) {
                return result.success(BuzzBooster.isBuzzBoosterNotification(map))
            }
            return result.success(false)
        } else if (call.method == "handleNotification") {
            val map = call.argument("map") as Map<String, String>?
            if (map != null) {
                BuzzBooster.handleNotification(map)
            }
            return result.success(null)
        } else if (call.method == "hasUnhandledNotificationClick") {
            activity?.let {
                return result.success(BuzzBooster.hasUnhandledNotificationClick(it))
            }
            return result.success(false)
        } else if (call.method == "handleNotificationClick") {
            activity?.let {
                BuzzBooster.handleNotification(it)
            }
            return result.success(null)
        } else if (call.method == "postJavaScriptMessage") {
            val message = call.argument("message") as String?
            activity?.let {
                if (message == null) {
                    return result.error("400", "Message is required", null)
                }
                BuzzBoosterJavaScriptInterface(it).postMessage(message)
            }
            return result.success(null)
        } else {
            result.notImplemented()
        }
    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
    }

    override fun onAttachedToActivity(binding: ActivityPluginBinding) {
        activity = binding.activity
        binding.addOnNewIntentListener(this)
    }

    override fun onDetachedFromActivity() {
        activity = null
    }

    override fun onDetachedFromActivityForConfigChanges() {
        activity = null
    }

    override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
        activity = binding.activity
        binding.addOnNewIntentListener(this)
    }

    override fun onListen(arguments: Any?, eventSink: EventChannel.EventSink?) {
        this.eventSink = eventSink
    }
    override fun onCancel(arguments: Any?) { 
        this.eventSink = null
    }

    override fun onNewIntent(intent: Intent): Boolean {
        activity?.apply {
            if (BuzzBooster.hasUnhandledNotificationClick(intent)) {
                BuzzBooster.handleNotification(this, intent)
                return true
            }
        }
        return false
    }

    private fun handleOptInMarketingCampaignMoveButtonClicked() {
        if (optInMarketingMoveButtonClicked) {
            if (eventSink != null) {
                eventSink!!.success(mapOf(
                    "event" to "optInMarketingCampaignMoveButtonClicked"
                ))
                optInMarketingMoveButtonClicked = false
            }
        }
    }

    private fun handleUserEvent(userEvent: UserEvent) {
        if (eventSink != null) {
            eventSink!!.success(mapOf(
                "event" to "userEventDidOccur",
                "userEventName" to userEvent.name,
                "userEventValues" to userEvent.values,
            ))
        }
    }
}
