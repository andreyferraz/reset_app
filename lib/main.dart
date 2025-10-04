import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';

class DeletionRecord {
  DeletionRecord({
    required this.path,
    required this.displayName,
    required this.success,
    required this.isDirectory,
    required this.timestamp,
  });

  final String path;
  final String displayName;
  final bool success;
  final bool isDirectory;
  final DateTime timestamp;
}

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
  final List<DeletionRecord> _recentDeletions = [];
  int _totalDeleted = 0;
  int _totalFailed = 0;

  @override
  void initState() {
    super.initState();
    platform.setMethodCallHandler(_handleNativeCalls);
  }

  @override
  void dispose() {
    platform.setMethodCallHandler(null);
    super.dispose();
  }

  Future<dynamic> _handleNativeCalls(MethodCall call) async {
    if (!mounted) return null;

    switch (call.method) {
      case 'deleteProgress':
        final arguments = Map<String, dynamic>.from(call.arguments as Map);
        final path = arguments['path'] as String? ?? '';
        final isDirectory = arguments['isDirectory'] as bool? ?? false;
        final success = arguments['success'] as bool? ?? true;
        final deletedCount = (arguments['deletedCount'] as num?)?.toInt() ?? _totalDeleted;
        final failedCount = (arguments['failedCount'] as num?)?.toInt() ?? _totalFailed;

        final displayName = _extractDisplayName(path, isDirectory: isDirectory);
        final record = DeletionRecord(
          path: path,
          displayName: displayName,
          success: success,
          isDirectory: isDirectory,
          timestamp: DateTime.now(),
        );

        setState(() {
          _totalDeleted = deletedCount;
          _totalFailed = failedCount;
          _recentDeletions.insert(0, record);
          if (_recentDeletions.length > 50) {
            _recentDeletions.removeRange(50, _recentDeletions.length);
          }

          final statusPrefix = success ? '🗑️ Removido' : '⚠️ Falha ao remover';
          _lastMessage = '$statusPrefix: $displayName\n'
              'Total removidos: $deletedCount | Falhas: $failedCount';
        });
        break;
      default:
        break;
    }

    return null;
  }

  String _extractDisplayName(String path, {required bool isDirectory}) {
    if (path.isEmpty) {
      return isDirectory ? 'Pasta desconhecida' : 'Arquivo desconhecido';
    }

    final segments = path.split(RegExp(r'[\\/]+')).where((segment) => segment.isNotEmpty).toList();
    if (segments.isEmpty) {
      return path;
    }

    return segments.last;
  }

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
      _totalDeleted = 0;
      _totalFailed = 0;
      _recentDeletions.clear();
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
          _totalDeleted = deletedCount;
          _totalFailed = failedCount;
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
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(
                  Icons.delete_forever,
                  size: 120,
                  color: Colors.red[700],
                ),
                const SizedBox(height: 24),
                Text(
                  'Deletar Todos os Arquivos',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12),
                Text(
                  'Remove permanentemente TODOS os arquivos do dispositivo',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: Colors.grey[600],
                      ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32),

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
                    width: double.infinity,
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

                if (_recentDeletions.isNotEmpty) ...[
                  const SizedBox(height: 24),
                  _buildRecentDeletionsCard(context),
                ],

                if (_lastMessage.isNotEmpty) ...[
                  const SizedBox(height: 24),
                  Container(
                    width: double.infinity,
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
                ],

                const SizedBox(height: 24),

                // Aviso importante
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.orange[50],
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.orange[300]!),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
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

  Widget _buildRecentDeletionsCard(BuildContext context) {
    final theme = Theme.of(context);
    final itemsToShow = _recentDeletions.take(20).toList();

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface.withOpacity(0.95),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: theme.colorScheme.outline.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.list_alt, color: theme.colorScheme.primary),
              const SizedBox(width: 8),
              Text(
                'Itens recentes deletados',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: itemsToShow.length,
            separatorBuilder: (_, __) => const Divider(height: 12, thickness: 0.6),
            itemBuilder: (context, index) {
              final record = itemsToShow[index];
              final icon = record.isDirectory ? Icons.folder : Icons.insert_drive_file;
              final iconColor = record.success ? Colors.green[700] : Colors.red[700];
              final subtitle = record.success ? 'Removido com sucesso' : 'Falha ao remover';

              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(icon, color: iconColor),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          record.displayName,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          subtitle,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: record.success ? Colors.green[700] : Colors.red[700],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}
