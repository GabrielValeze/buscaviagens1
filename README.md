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

⚙ Configuração da API

Este projeto consome a API https://buscamilhas.mock.gralmeidan.dev. Certifique-se de que ela está acessível antes de executar o aplicativo.

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

🛠 Contribuição

Contribuições são bem-vindas! Para contribuir:

Faça um fork do repositório

Crie uma branch (git checkout -b minha-feature)

Commit suas mudanças (git commit -m 'Adiciona nova feature')

Faça um push para a branch (git push origin minha-feature)

Abra um Pull Request 🚀

📜 Licença

Este projeto está sob a licença MIT.

