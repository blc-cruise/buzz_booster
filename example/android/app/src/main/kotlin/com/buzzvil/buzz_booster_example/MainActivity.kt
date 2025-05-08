package com.buzzvil.buzz_booster_example

import android.content.Context
import androidx.annotation.NonNull
import com.buzzvil.lib.endpoint.ServerDomain
import com.buzzvil.lib.endpoint.ServerUrl
import com.buzzvil.lib.endpoint.ServerUrlSettings
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity: FlutterActivity() {
  private val CHANNEL = "com.buzzvil.dev/booster"

  override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
    super.configureFlutterEngine(flutterEngine)
    MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler {
      call, result ->
      if (call.method == "changeEnvironment") {
        val environment = call.argument("environment") as String?
        changeEnvironment(environment!!)
        result.success(null)
      } else if (call.method == "clearCursor") {
        clearCursor()
        result.success(null)
      } else if (call.method == "showDebugger") {
        // todo: show debug activity
        result.success(null)
      } else if (call.method == "getVersionName") {
        val versionName = BuildConfig.VERSION_NAME
        result.success(versionName)
      }
    }
  }

  private fun changeEnvironment(environment: String) {
    val url = if (environment == "Production") {
      "https://api.buzzvil.com/buzzbooster"
    } else if (environment == "Staging") {
      "https://api-staging.buzzvil.com/buzzbooster"
    } else if (environment == "StagingQA") {
      "https://api-stagingqa.buzzvil.com/buzzbooster"
    } else if (environment == "Dev") {
      "https://api-dev.buzzvil.com/buzzbooster"
    } else {
      "http://10.0.2.2:80"
    }
    ServerUrlSettings.set(ServerDomain.BOOSTER_API, ServerUrl(url))
  }

  private fun clearCursor() {
    val prefs = getSharedPreferences("BuzzBoosterPrefs", Context.MODE_PRIVATE)
    val editor = prefs.edit()
    editor.remove("MESSAGE_CURSOR")
    editor.apply()
  }
}
