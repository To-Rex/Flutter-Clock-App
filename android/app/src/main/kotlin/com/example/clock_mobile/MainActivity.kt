package com.example.clock_mobile

import MusicService
import android.content.Intent
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugins.GeneratedPluginRegistrant

class MainActivity : FlutterActivity() {
    private val channel = "lightacademy/channel"
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        GeneratedPluginRegistrant.registerWith(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, channel).setMethodCallHandler { call, result ->
            when (call.method) {
                "startMusicService" -> {
                    val intent = Intent(this, MusicService::class.java)
                    startService(intent)
                    result.success("Music Service Started")
                }
                "stopMusicService" -> {
                    val intent = Intent(this, MusicService::class.java)
                    stopService(intent)
                    result.success("Music Service Stopped")
                }
                else -> {
                    result.notImplemented()
                }
            }
        }
    }
}
