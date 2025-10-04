# Delete Files App 🗑️

Um aplicativo Flutter simples e direto que **deleta permanentemente TODOS os arquivos do dispositivo Android com apenas um clique**.

## ✨ Funcionalidade Principal

- 🗑️ **DELETAR TODOS OS ARQUIVOS**: Remove permanentemente fotos, vídeos, documentos, WhatsApp, Telegram e TUDO mais com apenas um clique
- ⚠️ **Múltiplas Confirmações**: Sistema de segurança para evitar deleções acidentais
- 📊 **Progresso em Tempo Real**: Mostra estatísticas durante e após a deleção
- ⏱️ **Operação Cancelável**: Pode interromper a deleção a qualquer momento
- 📱 **Interface Simples**: Uma tela, um botão, uma função clara
- 🎨 **Design Moderno**: Interface limpa com Material 3
- 📱 **Compatibilidade**: Android 11+ (API 30+)

## 🚀 Como Usar

### 1. **Clone o repositório**
```bash
git clone https://github.com/andreyferraz/reset_app.git
cd reset_app
```

### 2. **Instale as dependências**
```bash
flutter pub get
```

### 3. **Execute o app**
```bash
# Liste os emuladores disponíveis
flutter emulators

# Inicie um emulador
flutter emulators --launch <emulator-id>

# Execute o app
flutter run
```

### 4. **Primeiro Uso**
1. Abra o app
2. Clique no botão "🗑️ DELETAR TODOS OS ARQUIVOS"
3. Conceda permissão "Gerenciar todos os arquivos" nas configurações
4. Volte ao app e clique novamente
5. Confirme a ação

## 🔧 Como Funciona

### Deleção de Arquivos

O app pode **deletar permanentemente TODOS os arquivos do usuário**:

```kotlin
// Android (Kotlin)
1. Solicita permissão MANAGE_EXTERNAL_STORAGE
2. Usa Coroutines para operação assíncrona
3. Percorre recursivamente: DCIM, Downloads, Documents, WhatsApp, etc
4. Deleta cada arquivo e pasta
5. Retorna estatísticas (deletados, falhados, tempo)
```

**O que é deletado:**
- ✅ Fotos e Vídeos (DCIM, Pictures, Movies)
- ✅ Documentos e PDFs (Documents)
- ✅ Downloads
- ✅ Músicas
- ✅ WhatsApp completo
- ✅ Telegram completo
- ✅ Qualquer arquivo no armazenamento externo

⚠️ **ATENÇÃO**: Esta ação é **irreversível** e **não pode ser desfeita**!

### Código Nativo (Android)

O app utiliza `MethodChannel` para comunicação entre Flutter e código nativo Kotlin:

```dart
// Flutter
static const platform = MethodChannel('com.example.reset_app/settings');
await platform.invokeMethod('deleteAllFiles');
```

```kotlin
// Kotlin (MainActivity.kt)
CoroutineScope(Dispatchers.IO).launch {
    // Percorre e deleta todos os arquivos
    directories.forEach { dir ->
        deleteRecursively(dir)
    }
}
```

## 📱 Interface do Usuário

### Tela Principal

```
┌─────────────────────────────────────┐
│                                     │
│         🗑️ (Ícone Grande)          │
│                                     │
│    "Deletar Todos os Arquivos"     │
│  Remove permanentemente TODOS...   │
│                                     │
│  ┌───────────────────────────────┐ │
│  │ 🗑️ DELETAR TODOS OS ARQUIVOS │ │
│  │    (Botão Vermelho Grande)    │ │
│  └───────────────────────────────┘ │
│                                     │
│  ⚠️ Aviso: Ação permanente!        │
│                                     │
└─────────────────────────────────────┘
```

### Durante Deleção

```
┌─────────────────────────────────────┐
│  ⭕ DELETANDO ARQUIVOS...          │
│  [████████████░░░░░░] 60%          │
│  [ Cancelar Operação ]             │
└─────────────────────────────────────┘
```

### Após Conclusão

```
┌─────────────────────────────────────┐
│  ℹ️  Resultado:                     │
│                                     │
│  ✅ Concluído!                     │
│  🗑️ 1.234 arquivos deletados      │
│  ⚠️ 5 falharam                     │
│  ⏱️ 45.2s                          │
└─────────────────────────────────────┘
```

## ⚠️ Avisos Importantes

### 🔴 Esta é uma ação DESTRUTIVA

- ❌ **NÃO pode ser desfeita**
- ❌ **NÃO cria backup automático**
- ❌ **NÃO envia para lixeira**
- ✅ **Deleta PERMANENTEMENTE**

### 🔒 Segurança

- ✅ Requer permissão especial do Android
- ✅ Múltiplas confirmações antes de executar
- ✅ Avisos claros sobre a ação
- ✅ Pode ser cancelado a qualquer momento
- ✅ Não deleta arquivos do sistema
- ✅ Não deleta apps instalados

### 📱 Compatibilidade

- ✅ **Android 11+** (API 30+): Requer MANAGE_EXTERNAL_STORAGE
- ⚠️ **Android 10** (API 29): Scoped Storage (acesso limitado)
- ⚠️ **Android 9 e anteriores**: Permissões antigas

### 🏢 Google Play Store

Se for publicar no Play Store:
- ⚠️ Permissão `MANAGE_EXTERNAL_STORAGE` é **restrita**
- 📝 Você precisa **justificar** o uso
- 🎯 Categorias permitidas: Gerenciadores de arquivo, backup, antivírus
- ❌ Pode ser **rejeitado** se não justificado adequadamente

## 🛠️ Estrutura do Projeto

```
lib/
  └── main.dart                    # Código Flutter principal
android/
  └── app/
      ├── src/main/
      │   ├── AndroidManifest.xml  # Permissões
      │   └── kotlin/
      │       └── MainActivity.kt  # Código nativo
      └── build.gradle.kts         # Dependências
```

## 📦 Dependências

```yaml
dependencies:
  flutter:
    sdk: flutter
  permission_handler: ^11.3.1    # Gerenciamento de permissões
  path_provider: ^2.1.4          # Acesso a diretórios

# Kotlin
dependencies {
  implementation("org.jetbrains.kotlinx:kotlinx-coroutines-android:1.7.3")
}
```

## 📚 Documentação Adicional

- [DELETAR_ARQUIVOS.md](DELETAR_ARQUIVOS.md) - Guia completo da funcionalidade
- [INTERFACE_SIMPLIFICADA.md](INTERFACE_SIMPLIFICADA.md) - Detalhes da interface
- [INSTRUCOES.md](INSTRUCOES.md) - Instruções detalhadas

## 🎯 Use Cases

### Quando usar:

✅ Vai vender/doar o celular  
✅ Celular cheio de arquivos desnecessários  
✅ Precisa limpar dados pessoais rapidamente  
✅ Recomeçar do zero com armazenamento limpo  

### Quando NÃO usar:

❌ Apenas para liberar um pouco de espaço  
❌ Se não tem backup dos arquivos importantes  
❌ Se não tem certeza absoluta  
❌ Para deletar apenas alguns arquivos específicos  

## 🧪 Testando

### Criar Arquivos de Teste no Emulador

```bash
# Via ADB
adb shell "echo 'teste' > /sdcard/Download/teste.txt"
adb shell "mkdir -p /sdcard/DCIM/Camera"
adb shell "echo 'foto' > /sdcard/DCIM/Camera/foto.jpg"
```

### Verificar Deleção

```bash
# Listar arquivos
adb shell "ls /sdcard/Download/"
adb shell "ls /sdcard/DCIM/"
```

## 🤝 Contribuindo

Contribuições são bem-vindas! Sinta-se à vontade para abrir issues ou pull requests.

## ⚠️ Disclaimer

Este aplicativo é fornecido "como está", sem garantias de qualquer tipo.  
**Use por sua própria conta e risco.**  
O desenvolvedor não se responsabiliza por perda de dados.  
**SEMPRE faça backup antes de usar!**

## 📄 Licença

Este projeto é open source e está disponível sob a licença MIT.

## 🔗 Links Úteis

- [Documentação Flutter](https://flutter.dev/docs)
- [Platform Channels](https://flutter.dev/docs/development/platform-integration/platform-channels)
- [Android Permissions](https://developer.android.com/training/permissions)
- [MANAGE_EXTERNAL_STORAGE](https://developer.android.com/reference/android/Manifest.permission#MANAGE_EXTERNAL_STORAGE)

---

**⚠️ ATENÇÃO: Este é um aplicativo poderoso e destrutivo. Use com responsabilidade!**

Desenvolvido com ❤️ usando Flutter
