# Reset App 🔄

Um aplicativo Flutter que facilita o acesso às configurações de reset de fábrica do dispositivo.

## ⚠️ Aviso Importante

**Este aplicativo NÃO executa o reset de fábrica diretamente.** Por questões de segurança do sistema operacional, nenhum aplicativo comum pode executar um reset de fábrica automaticamente.

### O que o app faz:

✅ Abre as configurações do sistema Android onde você pode fazer o reset manualmente  
✅ Exibe avisos e confirmações antes de abrir as configurações  
✅ Interface moderna e intuitiva  
✅ Tema vermelho para destacar a importância da ação  

### O que o app NÃO faz:

❌ Não executa reset de fábrica automaticamente  
❌ Não apaga dados sem permissão explícita do usuário  
❌ Não funciona no iOS (Apple não permite acesso a essas configurações)  

## 📱 Funcionalidades

1. **Botão "Reset de Fábrica"**
   - Exibe um diálogo de confirmação
   - Abre as configurações do sistema Android
   - Usuário navega manualmente até "Reset de Fábrica"

2. **Botão "Limpar Dados do App"**
   - Demonstração de como limpar apenas dados do próprio app
   - Não afeta o sistema

## 🚀 Como Executar

### Pré-requisitos

- Flutter SDK instalado (versão 3.0+)
- Android Studio ou VS Code com extensão Flutter
- Dispositivo Android ou emulador

### Passos

1. **Clone ou navegue até o diretório do projeto**
```bash
cd ~/reset_app
```

2. **Instale as dependências**
```bash
flutter pub get
```

3. **Execute o app**
```bash
flutter run
```

Ou em modo debug:
```bash
flutter run -d <device-id>
```

Para listar dispositivos disponíveis:
```bash
flutter devices
```

## 📦 Estrutura do Projeto

```
reset_app/
├── lib/
│   └── main.dart                 # Interface Flutter
├── android/
│   └── app/src/main/kotlin/
│       └── com/example/reset_app/
│           └── MainActivity.kt   # Código nativo Android
├── ios/                          # (iOS não suportado para esta funcionalidade)
└── README.md
```

## 🔧 Detalhes Técnicos

### Código Flutter (Dart)

O app usa `MethodChannel` para comunicação com código nativo:

```dart
static const platform = MethodChannel('com.example.reset_app/settings');
await platform.invokeMethod('openSettings');
```

### Código Nativo Android (Kotlin)

Abre as configurações do sistema usando Intent:

```kotlin
val intent = Intent(Settings.ACTION_SETTINGS)
startActivity(intent)
```

## 🎨 Interface

- Design Material 3
- Gradiente suave no fundo
- Botões grandes e fáceis de pressionar
- Ícones intuitivos
- Avisos visuais em laranja
- Confirmações em diálogo modal

## 📝 Limitações

### Android
- ✅ Funciona: Abre configurações do sistema
- ⚠️ Usuário precisa navegar manualmente até "Sistema > Reset de Fábrica"
- ❌ Não é possível executar reset automaticamente sem permissões de sistema

### iOS
- ❌ A Apple não permite que apps abram configurações específicas
- ❌ Não há API para acessar função de reset de fábrica

## 🛡️ Segurança

Este é um comportamento **intencional e correto** do sistema operacional:

1. **Proteção contra malware**: Apps maliciosos não podem apagar o dispositivo
2. **Confirmação do usuário**: Requer múltiplas confirmações nas configurações do sistema
3. **Transparência**: Usuário vê exatamente o que está fazendo

## 🔍 Como Fazer Reset Manual no Android

Após o app abrir as configurações:

1. Vá em **Sistema** ou **Configurações Gerais**
2. Encontre **Redefinir** ou **Reset**
3. Selecione **Redefinir dados de fábrica** ou **Factory Reset**
4. Confirme com sua senha/PIN
5. Confirme novamente a ação

⚠️ **ATENÇÃO**: Isso apagará TODOS os dados do dispositivo permanentemente!

## 📄 Licença

Este é um projeto de exemplo/demonstração.

## �� Contribuições

Sinta-se livre para melhorar o código, adicionar recursos ou corrigir bugs.

---

**Desenvolvido com Flutter 💙**
