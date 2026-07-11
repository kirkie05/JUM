package com.jumministry.jum

import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import com.ryanheise.audioservice.AudioServicePlugin

import io.flutter.plugin.common.MethodChannel
import android.os.Build

class MainActivity : FlutterActivity() {
    private val CHANNEL = "com.jumministry.jum/pip"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            if (call.method == "enterPip") {
                if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
                    try {
                        val entered = enterPictureInPictureMode()
                        result.success(entered)
                    } catch (e: Exception) {
                        result.error("PIP_ERROR", e.message, null)
                    }
                } else {
                    result.error("UNSUPPORTED", "Android version does not support PiP", null)
                }
            } else {
                result.notImplemented()
            }
        }
    }

    override fun provideFlutterEngine(context: android.content.Context): FlutterEngine? {
        return AudioServicePlugin.getFlutterEngine(context)
    }
}

