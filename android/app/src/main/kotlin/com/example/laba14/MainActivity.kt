package com.example.lab14

import android.os.Bundle
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import java.text.SimpleDateFormat
import java.util.*

class MainActivity : FlutterActivity() {

    private val CHANNEL = "native/date"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL)
            .setMethodCallHandler { call, result ->
                if (call.method == "getDate") {
                    val sdf = SimpleDateFormat("dd.MM.yyyy", Locale.getDefault())
                    val currentDate = sdf.format(Date())
                    result.success(currentDate)
                } else {
                    result.notImplemented()
                }
            }
    }
}
