package com.example.benin_num_auto

import android.content.Intent
import android.net.Uri
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

//import io.flutter.embedding.android.FlutterActivity

//class MainActivity: FlutterActivity()

class MainActivity: FlutterActivity() {
    private val CHANNEL = "com.example.benin_num_auto"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL)
            .setMethodCallHandler { call, result ->
                if (call.method == "refreshContacts") {
                    try {
                        // Diffuser un broadcast pour forcer le rafraîchissement des contacts
                        val intent = Intent(Intent.ACTION_PROVIDER_CHANGED)
                        intent.data = Uri.parse("content://contacts/phones/")
                        sendBroadcast(intent)
                        result.success("Contacts refreshed")
                    } catch (e: Exception) {
                        result.error("ERROR", "Failed to refresh contacts: ${e.message}", null)
                    }
                } else {
                    result.notImplemented()
                }
            }
    }
}



/*
// Dans MainActivity.java ou MainActivity.kt
@Override
fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
    super.configureFlutterEngine(flutterEngine)
    MethodChannel(flutterEngine.getDartExecutor(), "com.example.benin_num_auto")
        .setMethodCallHandler { call, result ->
            if (call.method.equals("refreshContacts")) {
                // Diffuser un broadcast pour informer l'application Contacts de la mise à jour
                val intent: Intent = Intent(Intent.ACTION_PROVIDER_CHANGED)
                intent.setData(Uri.parse("content://contacts/phones/"))
                sendBroadcast(intent)
                result.success("Contacts refreshed")
            } else {
                result.notImplemented()
            }
        }
}
*/
