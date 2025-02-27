import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter/services.dart'
    show rootBundle; // Import para carregar o JSON local

void main() {
  runApp(const MeuApp());
}

class MeuApp extends StatelessWidget {
  const MeuApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Busca de Passagens',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const PesquisaPage(),
    );
  }
}

// Tela de Pesquisa
class PesquisaPage extends StatefulWidget {
  const PesquisaPage({Key? key}) : super(key: key);

  @override
  _PesquisaPageState createState() => _PesquisaPageState();
}

class _PesquisaPageState extends State<PesquisaPage> {
  final TextEditingController dataIdaController = TextEditingController();
  final TextEditingController dataVoltaController = TextEditingController();

  List<String> aeroportos = [];
  String? aeroportoOrigem;
  String? aeroportoDestino;

  final List<String> companhiasAereas = [
    "LATAM",
    "GOL",
    "AZUL",
    "AMERICAN AIRLINES",
    "TAP",
  ];
  List<String> companhiasSelecionadas = [];

  int adultos = 1;
  int criancas = 0;
  int bebes = 0;

  Future<void> carregarAeroportosLocalmente() async {
    try {
      final String jsonString = await rootBundle.loadString(
        'assets/aeroportos.json',
      );
      List<dynamic> dados = json.decode(jsonString);

      setState(() {
        aeroportos = List<String>.from(
          dados.map((e) => "${e["Iata"]} - ${e["Nome"]}"),
        );
      });

      print("Aeroportos carregados: $aeroportos");
    } catch (e) {
      print("Erro ao carregar o JSON: $e");
    }
  }

  void selecionarData(
    BuildContext context,
    TextEditingController controller,
  ) async {
    DateTime? dataSelecionada = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );

    if (dataSelecionada != null) {
      setState(() {
        controller.text =
            "${dataSelecionada.day}/${dataSelecionada.month}/${dataSelecionada.year}";
      });
    }
  }

  void buscarVoos() {
    if (aeroportoOrigem == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Selecione um aeroporto de origem!")),
      );
      return;
    }
    if (aeroportoDestino == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Selecione um aeroporto de destino!")),
      );
      return;
    }
    if (dataIdaController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Selecione uma data de ida!")),
      );
      return;
    }
    if (dataVoltaController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Selecione uma data de volta!")),
      );
      return;
    }
    if (companhiasSelecionadas.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Selecione pelo menos uma companhia aérea!"),
        ),
      );
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder:
            (context) => ResultadosPage(
              origem: aeroportoOrigem!,
              destino: aeroportoDestino!,
              dataIda: dataIdaController.text,
              dataVolta: dataVoltaController.text,
              companhias: companhiasSelecionadas,
              adultos: adultos,
              criancas: criancas,
              bebes: bebes,
            ),
      ),
    );
  }

  Widget buildPassageiroSelector(
    String titulo,
    int valor,
    Function(int) atualizarValor, {
    int min = 0,
    int? max,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(titulo),
        Row(
          children: [
            IconButton(
              onPressed:
                  valor > min
                      ? () {
                        setState(() {
                          atualizarValor(valor - 1);
                        });
                      }
                      : null,
              icon: const Icon(Icons.remove),
            ),
            Text(valor.toString(), style: const TextStyle(fontSize: 16)),
            IconButton(
              onPressed:
                  (max == null || valor < max)
                      ? () {
                        setState(() {
                          atualizarValor(valor + 1);
                        });
                      }
                      : null,
              icon: const Icon(Icons.add),
            ),
          ],
        ),
      ],
    );
  }

  @override
  void initState() {
    super.initState();
    carregarAeroportosLocalmente();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Buscar Passagens")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Aeroporto de Origem"),
            DropdownButton<String>(
              value: aeroportoOrigem,
              isExpanded: true,
              hint: const Text("Selecione um aeroporto"),
              items:
                  aeroportos.map((String aeroporto) {
                    return DropdownMenuItem<String>(
                      value: aeroporto,
                      child: Text(aeroporto),
                    );
                  }).toList(),
              onChanged: (String? novoValor) {
                setState(() {
                  aeroportoOrigem = novoValor;
                });
              },
            ),

            const SizedBox(height: 16),

            const Text("Aeroporto de Destino"),
            DropdownButton<String>(
              value: aeroportoDestino,
              isExpanded: true,
              hint: const Text("Selecione um aeroporto"),
              items:
                  aeroportos.map((String aeroporto) {
                    return DropdownMenuItem<String>(
                      value: aeroporto,
                      child: Text(aeroporto),
                    );
                  }).toList(),
              onChanged: (String? novoValor) {
                setState(() {
                  aeroportoDestino = novoValor;
                });
              },
            ),

            const SizedBox(height: 16),

            TextField(
              controller: dataIdaController,
              decoration: const InputDecoration(labelText: "Data de Ida"),
              onTap: () => selecionarData(context, dataIdaController),
              readOnly: true,
            ),

            TextField(
              controller: dataVoltaController,
              decoration: const InputDecoration(labelText: "Data de Volta"),
              onTap: () => selecionarData(context, dataVoltaController),
              readOnly: true,
            ),

            const SizedBox(height: 16),

            buildPassageiroSelector(
              "Adultos",
              adultos,
              (v) => adultos = v,
              min: 1,
              max: 9,
            ),
            buildPassageiroSelector(
              "Crianças",
              criancas,
              (v) => criancas = v,
              min: 0,
              max: 9,
            ),
            buildPassageiroSelector(
              "Bebês",
              bebes,
              (v) => bebes = v,
              min: 0,
              max: adultos,
            ),

            const SizedBox(height: 20),

            ElevatedButton(onPressed: buscarVoos, child: const Text("Buscar")),
          ],
        ),
      ),
    );
  }
}

// Tela de Resultados
class ResultadosPage extends StatelessWidget {
  final String origem;
  final String destino;
  final String dataIda;
  final String dataVolta;
  final List<String> companhias;
  final int adultos;
  final int criancas;
  final int bebes;

  const ResultadosPage({
    Key? key,
    required this.origem,
    required this.destino,
    required this.dataIda,
    required this.dataVolta,
    required this.companhias,
    required this.adultos,
    required this.criancas,
    required this.bebes,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Resultados")),
      body: Center(
        child: Text(
          "Viagem de $origem para $destino em $dataIda - Volta: $dataVolta",
        ),
      ),
    );
  }
}
