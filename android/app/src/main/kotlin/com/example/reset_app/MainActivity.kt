package com.example.reset_app

import android.content.ComponentName
import android.content.Intent
import android.os.Build
import android.os.Environment
import android.provider.Settings
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import kotlinx.coroutines.*
import java.io.File

class MainActivity: FlutterActivity() {
    private val CHANNEL = "com.example.reset_app/settings"
    private lateinit var methodChannel: MethodChannel

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        
        methodChannel = MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL)

        methodChannel.setMethodCallHandler { call, result ->
            when (call.method) {
                "openSettings" -> {
                    openFactoryResetSettings(result)
                }
                "openPrivacySettings" -> {
                    openPrivacySettings(result)
                }
                "openBackupSettings" -> {
                    openBackupSettings(result)
                }
                "deleteAllFiles" -> {
                    deleteAllUserFiles(result)
                }
                "openManageStorageSettings" -> {
                    openManageStorageSettings(result)
                }
                else -> {
                    result.notImplemented()
                }
            }
        }
    }

    /**
     * Tenta abrir diretamente a tela de Reset de Fábrica
     * Usa diferentes métodos dependendo da versão do Android
     */
    private fun openFactoryResetSettings(result: MethodChannel.Result) {
        try {
            var success = false

            // Método 1: Para Android 10+ (API 29+) - Tela de Privacy/Reset
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.Q) {
                try {
                    val intent = Intent(Settings.ACTION_PRIVACY_SETTINGS)
                    intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
                    startActivity(intent)
                    success = true
                } catch (e: Exception) {
                    // Se falhar, tenta o próximo método
                }
            }

            // Método 2: Tenta acessar diretamente a Activity de Factory Reset (funciona em alguns dispositivos)
            if (!success) {
                try {
                    val intent = Intent()
                    intent.component = ComponentName(
                        "com.android.settings",
                        "com.android.settings.Settings\$FactoryResetActivity"
                    )
                    intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
                    startActivity(intent)
                    success = true
                } catch (e: Exception) {
                    // Se falhar, tenta o próximo método
                }
            }

            // Método 3: Abre a tela de Backup & Reset (funciona em versões mais antigas)
            if (!success) {
                try {
                    val intent = Intent(Settings.ACTION_PRIVACY_SETTINGS)
                    intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
                    startActivity(intent)
                    success = true
                } catch (e: Exception) {
                    // Se falhar, usa o método padrão
                }
            }

            // Método 4: Fallback - Abre as configurações gerais
            if (!success) {
                val intent = Intent(Settings.ACTION_SETTINGS)
                intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
                startActivity(intent)
            }

            result.success(mapOf(
                "status" to "success",
                "message" to "Configurações de reset abertas. Procure por 'Redefinir' ou 'Reset de fábrica'",
                "apiLevel" to Build.VERSION.SDK_INT
            ))
        } catch (e: Exception) {
            result.error(
                "UNAVAILABLE", 
                "Não foi possível abrir as configurações de reset",
                mapOf(
                    "error" to e.message,
                    "apiLevel" to Build.VERSION.SDK_INT
                )
            )
        }
    }

    /**
     * Abre a tela de Privacidade (onde geralmente está a opção de reset)
     */
    private fun openPrivacySettings(result: MethodChannel.Result) {
        try {
            val intent = Intent(Settings.ACTION_PRIVACY_SETTINGS)
            intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
            startActivity(intent)
            result.success("Configurações de privacidade abertas")
        } catch (e: Exception) {
            result.error("UNAVAILABLE", "Não foi possível abrir configurações de privacidade", e.message)
        }
    }

    /**
     * Abre a tela de Backup (muitas vezes próxima ao reset de fábrica)
     */
    private fun openBackupSettings(result: MethodChannel.Result) {
        try {
            val intent = Intent()
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.Q) {
                intent.action = Settings.ACTION_PRIVACY_SETTINGS
            } else {
                intent.action = Settings.ACTION_SETTINGS
            }
            intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
            startActivity(intent)
            result.success("Configurações de backup abertas")
        } catch (e: Exception) {
            result.error("UNAVAILABLE", "Não foi possível abrir configurações de backup", e.message)
        }
    }

    /**
     * Abre as configurações para dar permissão de gerenciar todos os arquivos
     */
    private fun openManageStorageSettings(result: MethodChannel.Result) {
        try {
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.R) {
                val intent = Intent(Settings.ACTION_MANAGE_ALL_FILES_ACCESS_PERMISSION)
                intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
                startActivity(intent)
                result.success("Abrir configurações de gerenciamento de armazenamento")
            } else {
                result.error("UNAVAILABLE", "Esta função requer Android 11 ou superior", null)
            }
        } catch (e: Exception) {
            result.error("ERROR", "Não foi possível abrir as configurações", e.message)
        }
    }

    /**
     * Deleta todos os arquivos do usuário no armazenamento externo
     * OTIMIZADO: Não pode ser cancelado e usa deleção mais eficiente
     */
    private fun deleteAllUserFiles(result: MethodChannel.Result) {
        CoroutineScope(Dispatchers.IO).launch {
            try {
                var deletedCount = 0
                var failedCount = 0
                val startTime = System.currentTimeMillis()

                // Verifica se tem permissão
                val hasPermission = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.R) {
                    Environment.isExternalStorageManager()
                } else {
                    true // Permissões antigas já concedidas via manifest
                }

                if (!hasPermission) {
                    withContext(Dispatchers.Main) {
                        result.error(
                            "PERMISSION_DENIED",
                            "Permissão necessária não concedida",
                            mapOf(
                                "needsManageStorage" to true,
                                "apiLevel" to Build.VERSION.SDK_INT
                            )
                        )
                    }
                    return@launch
                }

                // Diretórios específicos de apps (mais rápido que Android/media genérico)
                val specificDirectories = mutableListOf<File>()
                
                // Armazenamento externo principal
                Environment.getExternalStorageDirectory()?.let { externalStorage ->
                    specificDirectories.addAll(listOf(
                        // Diretórios padrão
                        File(externalStorage, Environment.DIRECTORY_DCIM),
                        File(externalStorage, Environment.DIRECTORY_PICTURES),
                        File(externalStorage, Environment.DIRECTORY_DOWNLOADS),
                        File(externalStorage, Environment.DIRECTORY_DOCUMENTS),
                        File(externalStorage, Environment.DIRECTORY_MOVIES),
                        File(externalStorage, Environment.DIRECTORY_MUSIC),
                        
                        // WhatsApp
                        File(externalStorage, "WhatsApp"),
                        File(externalStorage, "Android/media/com.whatsapp"),
                        File(externalStorage, "Android/media/com.whatsapp.w4b"),
                        
                        // Telegram
                        File(externalStorage, "Telegram"),
                        File(externalStorage, "Android/media/org.telegram.messenger"),
                        
                        // Instagram
                        File(externalStorage, "Instagram"),
                        File(externalStorage, "Android/media/com.instagram.android"),
                        
                        // TikTok
                        File(externalStorage, "TikTok"),
                        File(externalStorage, "Android/media/com.zhiliaoapp.musically"),
                        
                        // Snapchat
                        File(externalStorage, "Snapchat"),
                        File(externalStorage, "Android/media/com.snapchat.android"),
                        
                        // Facebook
                        File(externalStorage, "Facebook"),
                        File(externalStorage, "Android/media/com.facebook.katana"),
                        
                        // Twitter/X
                        File(externalStorage, "Android/media/com.twitter.android"),
                        
                        // Alternativas
                        File(externalStorage, "Download"),
                        File(externalStorage, "Pictures"),
                        File(externalStorage, "Documents")
                    ))
                }

                // Função iterativa para deletar (mais eficiente que recursiva)
                fun deleteDirectoryIteratively(directory: File, onItemProcessed: (File, Boolean) -> Unit) {
                    if (!directory.exists()) return

                    val stack = ArrayDeque<File>()
                    stack.add(directory)

                    val toDelete = mutableListOf<File>()

                    // Fase 1: Coleta todos os arquivos (BFS)
                    while (stack.isNotEmpty()) {
                        val current = stack.removeFirst()

                        if (current.isDirectory) {
                            try {
                                val children = current.listFiles()
                                if (children != null && children.isNotEmpty()) {
                                    for (child in children) {
                                        stack.add(child)
                                    }
                                }
                            } catch (_: Exception) {
                                // Ignora erros ao listar
                            }
                        }
                        toDelete.add(current)
                    }

                    // Fase 2: Deleta na ordem reversa (arquivos primeiro, depois pastas vazias)
                    for (i in toDelete.size - 1 downTo 0) {
                        val item = toDelete[i]
                        val success = try {
                            item.delete()
                        } catch (_: Exception) {
                            false
                        }

                        onItemProcessed(item, success)
                    }
                }

                // Deleta cada diretório específico
                specificDirectories.forEach { dir ->
                    if (dir.exists()) {
                        deleteDirectoryIteratively(dir) { item, success ->
                            if (success) {
                                deletedCount++
                            } else {
                                failedCount++
                            }

                            // Reporta progresso apenas para arquivos ou falhas
                            if (!item.isDirectory || !success) {
                                reportDeletionProgress(
                                    item.absolutePath,
                                    item.isDirectory,
                                    success,
                                    deletedCount,
                                    failedCount
                                )
                            }
                        }
                    }
                }

                val duration = System.currentTimeMillis() - startTime

                withContext(Dispatchers.Main) {
                    result.success(mapOf(
                        "status" to "success",
                        "deletedCount" to deletedCount,
                        "failedCount" to failedCount,
                        "durationMs" to duration,
                        "message" to "Operação concluída: $deletedCount arquivos deletados, $failedCount falharam"
                    ))
                }

            } catch (e: Exception) {
                withContext(Dispatchers.Main) {
                    result.error("ERROR", "Erro ao deletar arquivos: ${e.message}", null)
                }
            }
        }
    }

    private fun reportDeletionProgress(
        path: String,
        isDirectory: Boolean,
        success: Boolean,
        deletedCount: Int,
        failedCount: Int
    ) {
        if (!this::methodChannel.isInitialized) return

        runOnUiThread {
            try {
                methodChannel.invokeMethod(
                    "deleteProgress",
                    mapOf(
                        "path" to path,
                        "isDirectory" to isDirectory,
                        "success" to success,
                        "deletedCount" to deletedCount,
                        "failedCount" to failedCount
                    )
                )
            } catch (_: Exception) {
                // Ignora erros ao enviar progresso
            }
        }
    }
}
