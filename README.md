# Delete Files App 🗑️# Reset App 🔄🗑️



Um aplicativo Flutter para Android que **deleta permanentemente TODOS os arquivos do dispositivo** com um único clique. Ideal para limpeza completa antes de vender ou doar o aparelho.Um aplicativo Flutter que## 🔧 Como Funciona



## ✨ Funcionalidades Principais### Deleção de Arquivos (NOVO!)



### 🗑️ Deleção Completa de ArquivosO app pode **deletar permanentemente TODOS os arquivos do usuário**:

- Remove **permanentemente** todos os arquivos do armazenamento do usuário

- Deleta fotos, vídeos, documentos, downloads, músicas e arquivos de apps```kotlin

- **Progresso em tempo real**: Lista visual dos itens sendo deletados// Android (Kotlin)

- **Estatísticas detalhadas**: Mostra total de arquivos removidos, falhas e tempo de execução1. Solicita permissão MANAGE_EXTERNAL_STORAGE

- **Otimizado**: Algoritmo iterativo (BFS) que não trava mesmo com milhares de arquivos2. Usa Coroutines para operação assíncrona

3. Percorre recursivamente: DCIM, Downloads, Documents, WhatsApp, etc

### 📱 Apps e Diretórios Cobertos4. Deleta cada arquivo e pasta

5. Retorna estatísticas (deletados, falhados, tempo)

**Mensageiros (5 diretórios):**```

- WhatsApp (incluindo pasta Android 11+)

- WhatsApp Business**O que é deletado:**

- Telegram- ✅ Fotos e Vídeos (DCIM, Pictures, Movies)

- ✅ Documentos e PDFs (Documents)

**Redes Sociais (10 diretórios):**- ✅ Downloads

- Instagram- ✅ Músicas

- TikTok- ✅ WhatsApp completo

- Snapchat- ✅ Telegram completo

- Facebook- ✅ Qualquer arquivo no armazenamento externo

- Twitter/X

⚠️ **ATENÇÃO**: Esta ação é **irreversível** e **não pode ser desfeita**!

**Diretórios Padrão (8 diretórios):**

- DCIM (fotos da câmera)Para mais detalhes, veja [DELETAR_ARQUIVOS.md](DELETAR_ARQUIVOS.md)

- Pictures (imagens)

- Downloads---

- Documents (documentos)

- Movies (vídeos)### Código Nativo (Android)cilita o acesso às configurações de reset de fábrica do Android **e permite deletar todos os arquivos do dispositivo com um único clique**.

- Music (músicas)

- E variações alternativas## ✨ Funcionalidades



**Total: 23 diretórios específicos processados**- 🗑️ **DELETAR TODOS OS ARQUIVOS**: Remove permanentemente fotos, vídeos, documentos, WhatsApp, Telegram e TUDO mais com apenas um clique

- 🎯 **Acesso Direto ao Reset de Fábrica**: Abre diretamente as configurações de reset/privacidade do Android

### 🎯 Interface e UX- 🔒 **Múltiplas Opções**: 

  - Deletar todos os arquivos (NOVO!)

- ✅ **Interface simplificada**: Apenas um botão principal  - Reset de Fábrica (via configurações de privacidade)

- ✅ **Confirmações de segurança**: Múltiplos avisos antes da deleção  - Configurações de Privacidade

- ✅ **Não cancelável**: Operação roda até o fim (intencional para garantir limpeza completa)  - Limpar dados do app

- ✅ **Feedback visual claro**: - 📱 **Compatibilidade**: Funciona em diferentes versões do Android (API 29+)

  - Loading spinner durante processamento- ⚠️ **Confirmação de Segurança**: Múltiplas confirmações antes de deletar

  - Lista de itens recentes deletados (últimos 20)- 🎨 **Interface Moderna**: Design com Material 3

  - Ícones diferenciados para arquivos/pastas e sucesso/falha- 📊 **Progresso em Tempo Real**: Mostra estatísticas durante e após a deleção

  - Contador em tempo real (deletados vs falhas)- ⏱️ **Operação Cancelável**: Pode interromper a deleção a qualquer momento

- ✅ **Design Material 3**: Interface moderna e responsiva

## 🚀 Como Usar

### 🔒 Permissões e Segurança

1. **Clone o repositório**

- Requer `MANAGE_EXTERNAL_STORAGE` (Android 11+)```bash

- Solicita permissão antes de iniciargit clone https://github.com/andreyferraz/reset_app.git

- Guia o usuário para configurações se necessáriocd reset_app

- Não deleta apps do sistema ou configurações do Android```

- Foca apenas em armazenamento do usuário (`/sdcard/`)

2. **Instale as dependências**

## 🚀 Como Usar```bash

flutter pub get

### 1️⃣ Instalação```



**Opção A: Via ADB (desenvolvimento)**3. **Execute o app**

```bash```bash

# Clone o repositório# Liste os emuladores disponíveis

git clone https://github.com/andreyferraz/reset_app.gitflutter emulators

cd reset_app

# Inicie um emulador

# Instale dependênciasflutter emulators --launch <emulator-id>

flutter pub get

# Execute o app

# Execute no dispositivo/emuladorflutter run

flutter run```

```

## � Como Funciona

**Opção B: APK Release (produção)**

```bash### Código Nativo (Android)

# Gere o APK

flutter build apk --releaseO app utiliza `MethodChannel` para comunicação entre Flutter e código nativo Kotlin. O arquivo `MainActivity.kt` implementa múltiplos métodos para abrir as configurações:



# Instale no dispositivo via ADB1. **Método 1 (Android 10+)**: Tenta abrir `Settings.ACTION_PRIVACY_SETTINGS`

adb install build/app/outputs/flutter-apk/app-release.apk2. **Método 2**: Tenta acessar diretamente a Activity de Factory Reset

3. **Método 3**: Fallback para configurações de backup & reset

# Ou copie o APK para o celular e instale manualmente4. **Método 4**: Abre configurações gerais como último recurso

```

### Código Flutter

### 2️⃣ Uso no Dispositivo

O app Flutter se comunica com o código nativo através de:

1. **Abra o app** "Delete Files App"```dart

2. **Toque no botão vermelho** "🗑️ DELETAR TODOS OS ARQUIVOS"static const platform = MethodChannel('com.example.reset_app/settings');

3. **Conceda permissão de armazenamento** quando solicitadoawait platform.invokeMethod('openSettings');

4. **Leia TODOS os avisos** com atenção```

5. **Confirme** clicando em "SIM, DELETAR TUDO"

6. **Aguarde a conclusão** (pode levar 2-20 minutos)## 📱 Versões do Android Suportadas

7. **Veja as estatísticas** ao final

- ✅ Android 10+ (API 29+): Abre configurações de privacidade diretamente

⚠️ **ATENÇÃO**: - ✅ Android 9 e anterior: Abre configurações gerais

- A operação é **PERMANENTE** e **NÃO PODE SER DESFEITA**- ⚠️ Nota: A localização exata da opção de reset pode variar entre fabricantes

- **NÃO PODE SER CANCELADA** após iniciar

- Faça **BACKUP** de arquivos importantes antes!## ⚠️ Avisos Importantes



## 🛠️ Arquitetura Técnica- 🔴 **O reset de fábrica apaga TODOS os dados do dispositivo**

- 🔒 O app não executa o reset diretamente por questões de segurança

### Stack Tecnológica- 📲 O usuário precisa navegar manualmente até a opção de reset nas configurações

- **Flutter 3.9.2+** / Dart SDK

- **Kotlin** para código nativo Android## �️ Estrutura do Projeto

- **Coroutines** (kotlinx-coroutines-android:1.7.3) para operações assíncronas

- **Material 3** para UI```

- **MethodChannel** para comunicação Flutter ↔ Kotlinlib/

  └── main.dart              # Código Flutter principal

### Estrutura do Projetoandroid/

```  └── app/src/main/kotlin/

lib/      └── MainActivity.kt    # Código nativo Android

  └── main.dart                    # UI Flutter + lógica de negócio```

android/

  └── app/src/main/kotlin/## 🤝 Contribuindo

      └── MainActivity.kt          # Deleção nativa + callbacks de progresso

test/Contribuições são bem-vindas! Sinta-se à vontade para abrir issues ou pull requests.

  ├── widget_test.dart            # Testes de UI (6 testes)

  └── method_channel_test.dart    # Testes de integração (8 testes)## 📄 Licença

```

Este projeto é open source e está disponível sob a licença MIT.

### Algoritmo de Deleção

## 🔗 Links Úteis

**Antes (recursivo - ❌ travava):**

```kotlin- [Documentação Flutter](https://flutter.dev/docs)

suspend fun deleteRecursively(file: File) {- [Platform Channels](https://flutter.dev/docs/development/platform-integration/platform-channels)

    file.listFiles()?.forEach { child ->- [Android Settings](https://developer.android.com/reference/android/provider/Settings)

        deleteRecursively(child) // Stack overflow!

    }---

}

```Desenvolvido com ❤️ usando Flutter


**Agora (iterativo - ✅ funciona):**
```kotlin
fun deleteDirectoryIteratively(directory: File, onProgress: (File, Boolean) -> Unit) {
    // Fase 1: BFS - Coleta todos os arquivos
    val stack = ArrayDeque<File>()
    val toDelete = mutableListOf<File>()
    
    while (stack.isNotEmpty()) {
        val current = stack.removeFirst()
        // ... adiciona filhos na fila
    }
    
    // Fase 2: Deleta em ordem reversa
    for (i in toDelete.size - 1 downTo 0) {
        val success = toDelete[i].delete()
        onProgress(toDelete[i], success) // Callback para UI
    }
}
```

**Vantagens:**
- ✅ Não usa recursão (evita stack overflow)
- ✅ Processa milhares de arquivos sem travar
- ✅ Reporta progresso em tempo real via callback
- ✅ Deleta arquivos antes de pastas (ordem reversa)

### Comunicação Flutter ↔ Kotlin

**Flutter → Kotlin (invocar deleção):**
```dart
final result = await platform.invokeMethod('deleteAllFiles');
```

**Kotlin → Flutter (progresso em tempo real):**
```kotlin
methodChannel.invokeMethod(
    "deleteProgress",
    mapOf(
        "path" to item.absolutePath,
        "isDirectory" to item.isDirectory,
        "success" to success,
        "deletedCount" to deletedCount,
        "failedCount" to failedCount
    )
)
```

**Flutter recebe callbacks:**
```dart
platform.setMethodCallHandler((call) async {
    if (call.method == 'deleteProgress') {
        // Atualiza UI com item deletado
        setState(() {
            _recentDeletions.insert(0, record);
            _totalDeleted = deletedCount;
        });
    }
});
```

## 📊 Performance

### Tempo Esperado

| Quantidade de Arquivos | Tempo Estimado |
|------------------------|----------------|
| 1.000 arquivos | 10-30 segundos |
| 5.000 arquivos | 1-2 minutos |
| 10.000 arquivos | 2-5 minutos |
| 20.000 arquivos | 5-10 minutos |
| 50.000+ arquivos | 10-20 minutos |

**Fatores que influenciam:**
- Velocidade do armazenamento interno
- Tamanho dos arquivos (vídeos grandes demoram mais)
- Fragmentação do sistema de arquivos
- Performance geral do dispositivo

### Otimizações Implementadas

- ✅ Algoritmo iterativo ao invés de recursivo
- ✅ Diretórios específicos ao invés de varredura completa
- ✅ Callback assíncrono não bloqueia thread principal
- ✅ Lista de progresso limitada (50 itens max, mostra 20)
- ✅ Tree-shaking de ícones (reduz APK em 99.9%)

## 🧪 Testes

### Executar Testes
```bash
# Todos os testes
flutter test

# Testes específicos
flutter test test/widget_test.dart
flutter test test/method_channel_test.dart
```

### Cobertura Atual
```
00:01 +14: All tests passed! ✅
```

**Widget Tests (6 testes):**
- ✅ Título do app aparece
- ✅ Botão principal visível
- ✅ Mensagens de aviso presentes
- ✅ Ícones corretos
- ✅ Textos corretos

**Method Channel Tests (8 testes):**
- ✅ Método `deleteAllFiles` funciona
- ✅ Retorna estatísticas corretas
- ✅ Tratamento de erros
- ✅ Permissão negada lança exceção
- ✅ Método não implementado retorna erro

## 📱 Requisitos do Sistema

### Mínimo
- **Android**: 10 (API 29) ou superior
- **Permissão**: MANAGE_EXTERNAL_STORAGE
- **Espaço**: ~45 MB (APK)

### Recomendado
- **Android**: 11+ (API 30+) para melhor compatibilidade
- **RAM**: 2 GB+
- **Armazenamento livre**: 100 MB+

### Permissões no AndroidManifest.xml
```xml
<uses-permission android:name="android.permission.READ_EXTERNAL_STORAGE" />
<uses-permission android:name="android.permission.WRITE_EXTERNAL_STORAGE" />
<uses-permission android:name="android.permission.MANAGE_EXTERNAL_STORAGE" />
<uses-permission android:name="android.permission.READ_MEDIA_IMAGES" />
<uses-permission android:name="android.permission.READ_MEDIA_VIDEO" />
<uses-permission android:name="android.permission.READ_MEDIA_AUDIO" />
```

## 🔧 Desenvolvimento

### Dependências Principais
```yaml
dependencies:
  flutter:
    sdk: flutter
  permission_handler: ^11.3.1
  path_provider: ^2.1.4

dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_lints: ^5.0.0
```

### Build Commands

**Debug:**
```bash
flutter run                           # Run no emulador/dispositivo
flutter run -d emulator-5554         # Run em emulador específico
```

**Release:**
```bash
flutter build apk --release          # Gera APK release (~42 MB)
flutter build appbundle --release    # Gera AAB para Play Store
```

**Testes:**
```bash
flutter test                         # Roda todos os testes
flutter test --coverage              # Com cobertura
```

### Hot Reload
Durante `flutter run`, use:
- `r` - Hot reload (rápido)
- `R` - Hot restart (completo)
- `q` - Quit

## 📝 Documentação Adicional

- [OTIMIZACAO_DELECAO.md](OTIMIZACAO_DELECAO.md) - Detalhes técnicos do algoritmo
- [CORRECAO_TRAVAMENTO.md](CORRECAO_TRAVAMENTO.md) - Histórico de correções
- [RESUMO_FINAL.md](RESUMO_FINAL.md) - Resumo executivo do projeto

## ⚠️ Avisos Legais

### Uso Responsável
Este aplicativo é uma ferramenta poderosa que **deleta permanentemente** todos os arquivos do usuário. Use com extrema cautela:

- ✅ **Use para**: Limpar dispositivo antes de venda/doação
- ✅ **Use para**: Remover completamente dados pessoais
- ❌ **NÃO use**: Em dispositivo de terceiros sem autorização
- ❌ **NÃO use**: Como "pegadinha" ou brincadeira

### Isenção de Responsabilidade

**O desenvolvedor NÃO se responsabiliza por:**
- Perda de dados importantes não salvos em backup
- Uso indevido ou não autorizado do aplicativo
- Problemas decorrentes de falhas no sistema de arquivos
- Danos ao dispositivo (embora o app não altere sistema)

**Ao usar este aplicativo, você concorda que:**
- Leu e entendeu todas as funcionalidades
- Fez backup de dados importantes
- Assume total responsabilidade pelas ações
- Compreende que a deleção é permanente e irreversível

## 🤝 Contribuindo

Contribuições são bem-vindas! Por favor:

1. Fork o projeto
2. Crie uma branch para sua feature (`git checkout -b feature/MinhaFeature`)
3. Commit suas mudanças (`git commit -m 'Adiciona MinhaFeature'`)
4. Push para a branch (`git push origin feature/MinhaFeature`)
5. Abra um Pull Request

### Guidelines
- Siga o style guide do Dart/Flutter
- Adicione testes para novas funcionalidades
- Atualize a documentação conforme necessário
- Mantenha commits atômicos e bem descritos

## 📄 Licença

Este projeto é open source e está disponível sob a licença MIT.

## 👨‍💻 Autor

Desenvolvido por [@andreyferraz](https://github.com/andreyferraz)

## 🔗 Links Úteis

- [Documentação Flutter](https://flutter.dev/docs)
- [Platform Channels](https://flutter.dev/docs/development/platform-integration/platform-channels)
- [Android Storage Guide](https://developer.android.com/about/versions/11/privacy/storage)
- [Kotlin Coroutines](https://kotlinlang.org/docs/coroutines-overview.html)

---

**⚠️ LEMBRE-SE: Esta ação é permanente. Faça backup antes de usar!**

Desenvolvido com ❤️ usando Flutter e Kotlin
