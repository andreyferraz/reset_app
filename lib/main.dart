import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';

void main() {
  runApp(const ResetApp());
}

class ResetApp extends StatelessWidget {
  const ResetApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Reset App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.red,
          brightness: Brightness.light,
        ),
        useMaterial3: true,
      ),
      home: const ResetHomePage(),
    );
  }
}

class ResetHomePage extends StatefulWidget {
  const ResetHomePage({super.key});

  @override
  State<ResetHomePage> createState() => _ResetHomePageState();
}

class _ResetHomePageState extends State<ResetHomePage> {
  static const platform = MethodChannel('com.example.reset_app/settings');
  bool _isDeleting = false;
  String _lastMessage = '';

  Future<void> _requestStoragePermission() async {
    // Android 11+ requer permissão especial
    if (await Permission.manageExternalStorage.isDenied) {
      final result = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('⚠️ Permissão Necessária'),
          content: const Text(
            'Para deletar todos os arquivos, o app precisa de permissão para '
            'gerenciar todos os arquivos do dispositivo.\n\n'
            'Você será levado às configurações para conceder esta permissão.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Cancelar'),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Abrir Configurações'),
            ),
          ],
        ),
      );

      if (result == true) {
        await platform.invokeMethod('openManageStorageSettings');
      }
      return;
    }
  }

  Future<void> _deleteAllFiles() async {
    // Solicita permissão primeiro
    await _requestStoragePermission();

    // Verifica se tem permissão
    if (await Permission.manageExternalStorage.isDenied) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Permissão não concedida. Operação cancelada.'),
            backgroundColor: Colors.orange,
          ),
        );
      }
      return;
    }

    // Confirmação final
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('🚨 ATENÇÃO - ÚLTIMA CONFIRMAÇÃO'),
        content: const Text(
          'Esta ação irá DELETAR PERMANENTEMENTE todos os arquivos:\n\n'
          '❌ Fotos e Vídeos\n'
          '❌ Documentos e PDFs\n'
          '❌ Downloads\n'
          '❌ Músicas\n'
          '❌ WhatsApp e Telegram\n'
          '❌ Instagram, TikTok, Snapchat\n'
          '❌ TUDO no armazenamento!\n\n'
          '⚠️ NÃO PODE SER CANCELADO!\n'
          '⚠️ NÃO PODE SER DESFEITO!\n\n'
          'Tem certeza ABSOLUTA?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('CANCELAR'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            style: FilledButton.styleFrom(backgroundColor: Colors.red[900]),
            child: const Text('SIM, DELETAR TUDO'),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    setState(() {
      _isDeleting = true;
      _lastMessage = '🔄 DELETANDO ARQUIVOS...\n\n'
          'Isso pode levar vários minutos.\n'
          'NÃO FECHE O APP!\n\n'
          'Aguarde...';
    });

    try {
      final result = await platform.invokeMethod('deleteAllFiles');
      
      if (mounted && result is Map) {
        final deletedCount = result['deletedCount'] ?? 0;
        final failedCount = result['failedCount'] ?? 0;
        final duration = result['durationMs'] ?? 0;

        setState(() {
          _lastMessage = '✅ OPERAÇÃO CONCLUÍDA!\n\n'
              '🗑️ $deletedCount arquivos deletados\n'
              '⚠️ $failedCount falharam\n'
              '⏱️ ${(duration / 1000).toStringAsFixed(1)} segundos';
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('✅ Concluído! $deletedCount arquivos deletados.'),
            backgroundColor: Colors.green,
            duration: const Duration(seconds: 10),
          ),
        );
      }
    } on PlatformException catch (e) {
      if (mounted) {
        String errorMsg = '❌ ERRO: ${e.message}';
        
        if (e.code == 'PERMISSION_DENIED') {
          errorMsg = '❌ Permissão negada.\n\nAbra as configurações e conceda a permissão.';
          await platform.invokeMethod('openManageStorageSettings');
        }

        setState(() => _lastMessage = errorMsg);
        
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(errorMsg),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 10),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isDeleting = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Delete Files App'),
        centerTitle: true,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Theme.of(context).colorScheme.surface,
              Theme.of(context).colorScheme.surfaceContainerHighest,
            ],
          ),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.delete_forever,
                  size: 120,
                  color: Colors.red[700],
                ),
                const SizedBox(height: 32),
                Text(
                  'Deletar Todos os Arquivos',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                Text(
                  'Remove permanentemente TODOS os arquivos do dispositivo',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: Colors.grey[600],
                      ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 48),
                
                // Botão PRINCIPAL - Deletar TODOS os arquivos
                SizedBox(
                  width: double.infinity,
                  height: 70,
                  child: FilledButton.icon(
                    onPressed: _isDeleting ? null : _deleteAllFiles,
                    icon: _isDeleting
                        ? const SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(
                              strokeWidth: 3,
                              color: Colors.white,
                            ),
                          )
                        : const Icon(Icons.delete_forever, size: 32),
                    label: Text(
                      _isDeleting ? 'DELETANDO... AGUARDE' : '🗑️ DELETAR TODOS OS ARQUIVOS',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                      textAlign: TextAlign.center,
                    ),
                    style: FilledButton.styleFrom(
                      backgroundColor: Colors.red[900],
                      foregroundColor: Colors.white,
                    ),
                  ),
                ),
                
                if (_isDeleting) ...[
                  const SizedBox(height: 24),
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.orange[50],
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.orange[300]!, width: 2),
                    ),
                    child: Column(
                      children: [
                        const SizedBox(
                          width: 48,
                          height: 48,
                          child: CircularProgressIndicator(
                            strokeWidth: 5,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          '⚠️ DELETANDO ARQUIVOS',
                          style: TextStyle(
                            color: Colors.orange[900],
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Isso pode levar vários minutos.\nNÃO FECHE O APP!',
                          style: TextStyle(
                            color: Colors.orange[800],
                            fontSize: 14,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ],
                
                const SizedBox(height: 32),
                
                // Mostra a última mensagem
                if (_lastMessage.isNotEmpty)
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.blue[50],
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.blue[300]!),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(Icons.info_outline, color: Colors.blue[700]),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            _lastMessage,
                            style: TextStyle(
                              color: Colors.blue[900],
                              fontSize: 13,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                
                const Spacer(),
                
                // Aviso importante
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.orange[50],
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.orange[300]!),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.warning_amber_rounded, color: Colors.orange[700], size: 28),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'ATENÇÃO: Esta ação é permanente e não pode ser desfeita. Certifique-se de fazer backup antes!',
                          style: TextStyle(
                            color: Colors.orange[900],
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
