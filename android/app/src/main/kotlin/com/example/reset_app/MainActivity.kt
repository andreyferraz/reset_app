package com.example.reset_app

import android.content.Intent
import android.provider.Settings
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity: FlutterActivity() {
    private val CHANNEL = "com.example.reset_app/settings"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            when (call.method) {
                "openSettings" -> {
                    try {
                        // Abre as configurações do sistema (onde o usuário pode acessar reset de fábrica)
                        val intent = Intent(Settings.ACTION_SETTINGS)
                        intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
                        startActivity(intent)
                        result.success("Configurações abertas com sucesso")
                    } catch (e: Exception) {
                        result.error("UNAVAILABLE", "Não foi possível abrir as configurações", e.message)
                    }
                }
                else -> {
                    result.notImplemented()
                }
            }
        }
    }
}
