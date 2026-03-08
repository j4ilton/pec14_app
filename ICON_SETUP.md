# Configuração do Ícone PEC 14

## Passos para Configurar o Ícone

1. **Salvar a Imagem do Ícone**
   - Salve a imagem do ícone fornecida na pasta `assets/` com o nome `icon.png`
   - A imagem deve ter no mínimo 1024x1024 pixels para melhor qualidade
   - Formatos suportados: PNG, JPG

2. **Instalar Dependências e Gerar Ícones**
   Execute os seguintes comandos no terminal:
   ```bash
   flutter pub get
   dart run flutter_launcher_icons
   ```

3. **Resultado**
   - Os ícones serão gerados automaticamente para todas as plataformas
   - Android: ícones em várias resoluções + ícone adaptativo
   - iOS: ícones em todas as resoluções necessárias
   - Web: ícones 192x192 e 512x512
   - Windows, macOS, Linux: ícones nativos

## Alterações Realizadas

✅ Nome da aplicação alterado para "PEC 14" em:
- Android (AndroidManifest.xml)
- iOS (Info.plist)
- macOS (Info.plist)
- Web (manifest.json e index.html)
- Windows (main.cpp e Runner.rc)
- Linux (my_application.cc)

✅ Configuração do flutter_launcher_icons adicionada ao pubspec.yaml

✅ Pasta assets/ criada para armazenar o ícone

## Observações

- O nome "PEC 14" aparecerá na tela inicial do dispositivo
- O ícone substituirá o ícone padrão do Flutter
- Após gerar os ícones, teste em um dispositivo/emulador para verificar
