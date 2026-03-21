package com.aeternavault.aeternavault

import android.content.Intent
import android.net.Uri
import android.os.Build
import android.provider.Settings
import io.flutter.embedding.android.FlutterFragmentActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterFragmentActivity() {

    private val AUTOFILL_CHANNEL = "aeterna/autofill"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, AUTOFILL_CHANNEL)
            .setMethodCallHandler { call, result ->
                when (call.method) {
                    "openAutofillSettings" -> {
                        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
                            startActivity(
                                Intent(Settings.ACTION_REQUEST_SET_AUTOFILL_SERVICE).apply {
                                    data = Uri.parse("package:$packageName")
                                }
                            )
                        } else {
                            startActivity(Intent(Settings.ACTION_SETTINGS))
                        }
                        result.success(null)
                    }
                    "isAutofillServiceEnabled" -> {
                        val enabled = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
                            getSystemService(android.view.autofill.AutofillManager::class.java)
                                ?.hasEnabledAutofillServices() == true
                        } else {
                            false
                        }
                        result.success(enabled)
                    }
                    else -> result.notImplemented()
                }
            }
    }
}
