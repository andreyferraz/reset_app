# Reset App 🔄🗑️

Um aplicativo Flutter que## 🔧 Como Funciona

### Deleção de Arquivos (NOVO!)

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

Para mais detalhes, veja [DELETAR_ARQUIVOS.md](DELETAR_ARQUIVOS.md)

---

### Código Nativo (Android)cilita o acesso às configurações de reset de fábrica do Android **e permite deletar todos os arquivos do dispositivo com um único clique**.

## ✨ Funcionalidades

- 🗑️ **DELETAR TODOS OS ARQUIVOS**: Remove permanentemente fotos, vídeos, documentos, WhatsApp, Telegram e TUDO mais com apenas um clique
- 🎯 **Acesso Direto ao Reset de Fábrica**: Abre diretamente as configurações de reset/privacidade do Android
- 🔒 **Múltiplas Opções**: 
  - Deletar todos os arquivos (NOVO!)
  - Reset de Fábrica (via configurações de privacidade)
  - Configurações de Privacidade
  - Limpar dados do app
- 📱 **Compatibilidade**: Funciona em diferentes versões do Android (API 29+)
- ⚠️ **Confirmação de Segurança**: Múltiplas confirmações antes de deletar
- 🎨 **Interface Moderna**: Design com Material 3
- 📊 **Progresso em Tempo Real**: Mostra estatísticas durante e após a deleção
- ⏱️ **Operação Cancelável**: Pode interromper a deleção a qualquer momento

## 🚀 Como Usar

1. **Clone o repositório**
```bash
git clone https://github.com/andreyferraz/reset_app.git
cd reset_app
```

2. **Instale as dependências**
```bash
flutter pub get
```

3. **Execute o app**
```bash
# Liste os emuladores disponíveis
flutter emulators

# Inicie um emulador
flutter emulators --launch <emulator-id>

# Execute o app
flutter run
```

## � Como Funciona

### Código Nativo (Android)

O app utiliza `MethodChannel` para comunicação entre Flutter e código nativo Kotlin. O arquivo `MainActivity.kt` implementa múltiplos métodos para abrir as configurações:

1. **Método 1 (Android 10+)**: Tenta abrir `Settings.ACTION_PRIVACY_SETTINGS`
2. **Método 2**: Tenta acessar diretamente a Activity de Factory Reset
3. **Método 3**: Fallback para configurações de backup & reset
4. **Método 4**: Abre configurações gerais como último recurso

### Código Flutter

O app Flutter se comunica com o código nativo através de:
```dart
static const platform = MethodChannel('com.example.reset_app/settings');
await platform.invokeMethod('openSettings');
```

## 📱 Versões do Android Suportadas

- ✅ Android 10+ (API 29+): Abre configurações de privacidade diretamente
- ✅ Android 9 e anterior: Abre configurações gerais
- ⚠️ Nota: A localização exata da opção de reset pode variar entre fabricantes

## ⚠️ Avisos Importantes

- 🔴 **O reset de fábrica apaga TODOS os dados do dispositivo**
- 🔒 O app não executa o reset diretamente por questões de segurança
- 📲 O usuário precisa navegar manualmente até a opção de reset nas configurações

## �️ Estrutura do Projeto

```
lib/
  └── main.dart              # Código Flutter principal
android/
  └── app/src/main/kotlin/
      └── MainActivity.kt    # Código nativo Android
```

## 🤝 Contribuindo

Contribuições são bem-vindas! Sinta-se à vontade para abrir issues ou pull requests.

## 📄 Licença

Este projeto é open source e está disponível sob a licença MIT.

## 🔗 Links Úteis

- [Documentação Flutter](https://flutter.dev/docs)
- [Platform Channels](https://flutter.dev/docs/development/platform-integration/platform-channels)
- [Android Settings](https://developer.android.com/reference/android/provider/Settings)

---

Desenvolvido com ❤️ usando Flutter
