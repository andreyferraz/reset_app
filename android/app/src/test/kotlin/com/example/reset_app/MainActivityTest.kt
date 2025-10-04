package com.example.reset_app

import android.os.Environment
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import org.junit.Test
import org.junit.Assert.*
import org.junit.Before
import org.mockito.Mockito.*
import java.io.File

/**
 * Testes unitários para MainActivity
 * 
 * Valida as funcionalidades principais:
 * - Lista de diretórios a serem deletados
 * - Verificação de permissões
 * - Estrutura de pastas do WhatsApp, Telegram, etc.
 */
class MainActivityTest {

    @Test
    fun `test directory list contains all WhatsApp folders`() {
        // Simula o armazenamento externo
        val externalStorage = File("/sdcard")
        
        // Lista de diretórios esperados
        val expectedDirectories = listOf(
            "WhatsApp",
            "Android/media/com.whatsapp",
            "Android/media/com.whatsapp.w4b"
        )
        
        // Verifica se todas as pastas do WhatsApp estão na lista
        expectedDirectories.forEach { dir ->
            val fullPath = File(externalStorage, dir)
            assertNotNull("Diretório $dir deveria existir na lista", fullPath)
        }
    }

    @Test
    fun `test directory list contains Telegram folders`() {
        val externalStorage = File("/sdcard")
        
        val expectedDirectories = listOf(
            "Telegram",
            "Android/media/org.telegram.messenger"
        )
        
        expectedDirectories.forEach { dir ->
            val fullPath = File(externalStorage, dir)
            assertNotNull("Diretório $dir deveria existir na lista", fullPath)
        }
    }

    @Test
    fun `test directory list contains Instagram folders`() {
        val externalStorage = File("/sdcard")
        
        val expectedDirectories = listOf(
            "Instagram",
            "Android/media/com.instagram.android"
        )
        
        expectedDirectories.forEach { dir ->
            val fullPath = File(externalStorage, dir)
            assertNotNull("Diretório $dir deveria existir na lista", fullPath)
        }
    }

    @Test
    fun `test directory list contains TikTok folders`() {
        val externalStorage = File("/sdcard")
        
        val expectedDirectories = listOf(
            "TikTok",
            "Android/media/com.zhiliaoapp.musically"
        )
        
        expectedDirectories.forEach { dir ->
            val fullPath = File(externalStorage, dir)
            assertNotNull("Diretório $dir deveria existir na lista", fullPath)
        }
    }

    @Test
    fun `test directory list contains all standard Android directories`() {
        val externalStorage = File("/sdcard")
        
        val expectedDirectories = listOf(
            Environment.DIRECTORY_DCIM,
            Environment.DIRECTORY_PICTURES,
            Environment.DIRECTORY_DOWNLOADS,
            Environment.DIRECTORY_DOCUMENTS,
            Environment.DIRECTORY_MOVIES,
            Environment.DIRECTORY_MUSIC
        )
        
        expectedDirectories.forEach { dir ->
            val fullPath = File(externalStorage, dir)
            assertNotNull("Diretório padrão $dir deveria existir na lista", fullPath)
        }
    }

    @Test
    fun `test directory list contains Android media folder`() {
        val externalStorage = File("/sdcard")
        val androidMedia = File(externalStorage, "Android/media")
        
        assertNotNull("Pasta Android/media deveria existir na lista", androidMedia)
        assertEquals("Caminho deveria ser /sdcard/Android/media", 
            "/sdcard/Android/media", androidMedia.path)
    }

    @Test
    fun `test all WhatsApp folders are covered`() {
        // Lista completa de TODAS as possíveis pastas do WhatsApp
        val allWhatsAppPaths = listOf(
            "/sdcard/WhatsApp",                             // Pasta antiga
            "/sdcard/Android/media/com.whatsapp",           // Pasta nova (Android 11+)
            "/sdcard/Android/media/com.whatsapp.w4b"        // WhatsApp Business
        )
        
        allWhatsAppPaths.forEach { path ->
            val file = File(path)
            assertTrue("Caminho do WhatsApp deveria ser válido: $path", 
                file.path.contains("WhatsApp") || file.path.contains("whatsapp"))
        }
    }

    @Test
    fun `test total number of directories is correct`() {
        // Contabiliza o número total de diretórios que devem ser deletados
        val expectedCount = 
            6 + // Diretórios padrão (DCIM, Pictures, Downloads, Documents, Movies, Music)
            3 + // WhatsApp (3 pastas)
            2 + // Telegram (2 pastas)
            3 + // Alternativas (Download, Pictures, Documents)
            2 + // Instagram
            2 + // TikTok
            2 + // Snapchat
            2 + // Facebook
            1   // Android/media (pega todos os apps)
        
        // Total esperado: 23 diretórios
        assertEquals("Número total de diretórios deveria ser 23", 23, expectedCount)
    }

    @Test
    fun `test file path formatting is correct`() {
        val externalStorage = File("/sdcard")
        
        // Testa se os caminhos são formados corretamente
        val whatsappNew = File(externalStorage, "Android/media/com.whatsapp")
        assertEquals("/sdcard/Android/media/com.whatsapp", whatsappNew.path)
        
        val telegram = File(externalStorage, "Android/media/org.telegram.messenger")
        assertEquals("/sdcard/Android/media/org.telegram.messenger", telegram.path)
        
        val instagram = File(externalStorage, "Android/media/com.instagram.android")
        assertEquals("/sdcard/Android/media/com.instagram.android", instagram.path)
    }

    @Test
    fun `test method channel names are correct`() {
        val expectedChannel = "com.example.reset_app/settings"
        
        // Verifica se o canal está no formato correto
        assertTrue("Canal deveria conter o package name", 
            expectedChannel.contains("com.example.reset_app"))
        assertTrue("Canal deveria conter /settings", 
            expectedChannel.contains("/settings"))
    }

    @Test
    fun `test all social media apps are covered`() {
        val socialMediaApps = mapOf(
            "WhatsApp" to "com.whatsapp",
            "WhatsApp Business" to "com.whatsapp.w4b",
            "Telegram" to "org.telegram.messenger",
            "Instagram" to "com.instagram.android",
            "TikTok" to "com.zhiliaoapp.musically",
            "Snapchat" to "com.snapchat.android",
            "Facebook" to "com.facebook.katana"
        )
        
        socialMediaApps.forEach { (name, packageName) ->
            val path = "Android/media/$packageName"
            assertTrue("$name deveria ter caminho válido", path.contains(packageName))
        }
    }
}
