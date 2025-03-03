📌 Projeto Buscar Viagens

Este é um aplicativo Flutter para busca de passagens aéreas.

🚀 Executando o Projeto

📦 Dependências Necessárias

Antes de rodar o projeto, certifique-se de ter instalado:

Flutter SDK (Instruções de instalação)

Dart SDK (incluído no Flutter)

Visual Studio Code ou Android Studio (para desenvolvimento e emulação)

Dispositivo físico ou emulador configurado

Instale as dependências do projeto executando:

flutter pub get

▶ Rodando o App

Para rodar o aplicativo no emulador ou dispositivo físico, use o comando:

flutter run

Se estiver usando um emulador específico, liste os dispositivos disponíveis com:

flutter devices

e selecione um dispositivo com:

flutter run -d <DEVICE_ID>

📌 Funcionalidades

Busca de passagens aéreas por companhia

Exibição de preço total, taxa de embarque, IATA de origem/destino

Seleção de tipo de viagem (Ida ou Ida e Volta)

Exibição de duração do voo e número de conexões

🛠 Tecnologias Utilizadas

Flutter (Framework)

Dart (Linguagem de Programação)

TableCalendar (Para exibição de datas)

Material Design (Interface UI)

📂 Estrutura do Projeto

/ buscarviagens
  ├── lib/
  
  │   ├── main.dart          # Arquivo principal
  
  ├── assets/
  
  │   ├── aeroportos.json  # Dados locais
  
  ├── pubspec.yaml  # Configuração de dependências
