# 🚀 Guia Rápido de Início

## ✅ Pré-requisitos Verificados

- [x] Flutter SDK instalado
- [x] Dependências instaladas (`flutter pub get`)
- [x] Estrutura do projeto criada
- [x] Código implementado

## 📱 Como Executar

### Opção 1: Usar o Android Studio

1. Abra o projeto no Android Studio
2. Aguarde a indexação terminar
3. Conecte um dispositivo ou inicie um emulador
4. Clique no botão **Run** (▶️) ou pressione `Shift+F10`

### Opção 2: Linha de Comando

```bash
# No diretório do projeto
flutter run
```

### Opção 3: Modo Debug no VS Code

1. Abra o projeto no VS Code
2. Pressione `F5` ou vá em Run > Start Debugging
3. Selecione o dispositivo/emulador

## 🔐 Testando a Aplicação

### 1. Teste como Utilizador Comum

1. **Login:**
   - Email: `user@sos.com`
   - Senha: `user123`

2. **Funcionalidades Disponíveis:**
   - ✅ Ver lista de objetos aprovados
   - ✅ Filtrar por categoria
   - ✅ Ver detalhes dos itens
   - ✅ Reportar novo objeto
   - ✅ Ver mapa com localizações
   - ✅ Fazer logout

3. **Testar Reporte:**
   - Clique no botão flutuante "Reportar"
   - Selecione uma categoria
   - Digite uma descrição (mínimo 10 caracteres)
   - Adicione uma foto (opcional)
   - Clique em "Reportar Item"
   - O item ficará pendente até aprovação do admin

### 2. Teste como Administrador

1. **Logout** (se estiver logado como user)

2. **Login como Admin:**
   - Email: `admin@sos.com`
   - Senha: `admin123`

3. **Funcionalidades Disponíveis:**
   - ✅ Ver itens pendentes (aba "Pendentes")
   - ✅ Ver todos os itens (aba "Todos os Itens")
   - ✅ Validar itens pendentes
   - ✅ Remover itens
   - ✅ Fazer logout

4. **Testar Validação:**
   - Vá para a aba "Pendentes"
   - Clique em "Validar" em um item
   - O item aparecerá na homepage para todos os usuários

5. **Testar Remoção:**
   - Clique em "Remover" em qualquer item
   - Confirme a ação
   - O item será deletado permanentemente

### 3. Criar Nova Conta

1. Na tela de login, clique em "Registre-se"
2. Preencha:
   - Email válido
   - Senha (mínimo 6 caracteres)
   - Confirme a senha
3. Clique em "Cadastrar"
4. Você será redirecionado para a homepage

## 🗺️ Configurar Google Maps (Opcional)

Se quiser testar o mapa completo:

1. Siga o guia em `GOOGLE_MAPS_SETUP.md`
2. Obtenha uma API Key do Google Cloud
3. Configure no AndroidManifest.xml
4. Reinicie a aplicação

**Nota:** A aplicação funciona normalmente sem o Google Maps configurado, exceto a tela de mapa que pode mostrar erro.

## 🔍 Testando Filtros

1. Na homepage, use os chips no topo para filtrar por categoria:
   - Todos
   - Acessórios
   - Chaves
   - Documentos
   - Eletrônicos
   - Outros

## 📊 Fluxo Completo de Teste

```
1. Login como USER
   ↓
2. Ver itens aprovados na homepage
   ↓
3. Reportar um novo objeto
   ↓
4. Logout
   ↓
5. Login como ADMIN
   ↓
6. Ver item pendente no painel
   ↓
7. Validar o item
   ↓
8. Logout
   ↓
9. Login como USER novamente
   ↓
10. Ver o item aprovado na homepage
```

## 🐛 Solução de Problemas

### Erro: "flutter: command not found"
```bash
# Adicione o Flutter ao PATH ou use o caminho completo
/caminho/para/flutter/bin/flutter run
```

### Erro: "No devices found"
- Inicie um emulador Android/iOS
- Ou conecte um dispositivo físico com USB Debug ativado
- Verifique: `flutter devices`

### Erro: "Gradle build failed"
```bash
# Limpe e reconstrua
flutter clean
flutter pub get
flutter run
```

### Erro: "Plugin not found"
```bash
# Reinstale as dependências
flutter pub get
# Se persistir, delete pasta build
rm -rf build/
flutter run
```

### Imagens não aparecem
- As URLs de placeholder podem não carregar sem internet
- Conecte o dispositivo/emulador à internet

### Mapa não funciona
- Configure a API Key do Google Maps (ver GOOGLE_MAPS_SETUP.md)
- Ou ignore - as outras funcionalidades funcionam normalmente

## 📝 Notas Importantes

1. **Dados Mock:** A aplicação usa dados simulados em memória
   - Os dados resetam quando você reinicia o app
   - Para persistência real, integre com Firebase/API

2. **Permissões:** 
   - Conceda permissões de câmera e galeria quando solicitado
   - Permissões de localização são necessárias para o mapa

3. **Performance:**
   - Primeira execução pode demorar mais (compilação)
   - Hot reload (r) é rápido para mudanças rápidas
   - Hot restart (R) recarrega toda a aplicação

## 🎯 Próximos Passos

Após testar a aplicação base:

1. [ ] Configure Firebase Authentication
2. [ ] Adicione Firestore para persistência
3. [ ] Configure Firebase Storage para imagens
4. [ ] Adicione geolocalização real
5. [ ] Implemente notificações push
6. [ ] Publique na Play Store/App Store

## 💡 Dicas de Desenvolvimento

### Hot Reload
```bash
# Na linha de comando com flutter run ativo
r  # Hot reload
R  # Hot restart
q  # Quit
```

### Debug
```bash
# Executar em modo debug com logs
flutter run -v

# Executar em modo release (mais rápido)
flutter run --release
```

### Ver logs
```bash
# Android
flutter logs

# Ou use o Android Studio Logcat
```

## 📞 Suporte

Se encontrar problemas:
1. Verifique a documentação do Flutter: https://flutter.dev/docs
2. Consulte o Stack Overflow: https://stackoverflow.com/questions/tagged/flutter
3. Revise os erros no console/logcat

---

**Boa sorte com o desenvolvimento! 🚀**

