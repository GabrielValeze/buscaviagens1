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
  final TextEditingController dataController = TextEditingController();

  List<String> aeroportos = [];
  String? aeroportoOrigem;
  String? aeroportoDestino;

  // Lista de companhias aéreas disponíveis
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

      print(
        "Aeroportos carregados: $aeroportos",
      ); // Debug para garantir que os dados foram lidos corretamente
    } catch (e) {
      print("Erro ao carregar o JSON: $e");
    }
  }

  void selecionarData(BuildContext context) async {
    DateTime? dataSelecionada = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );

    if (dataSelecionada != null) {
      setState(() {
        dataController.text =
            "${dataSelecionada.day}/${dataSelecionada.month}/${dataSelecionada.year}";
      });
    }
  }

  void buscarVoos() {
    if (aeroportoOrigem != null &&
        aeroportoDestino != null &&
        dataController.text.isNotEmpty &&
        companhiasSelecionadas.isNotEmpty) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder:
              (context) => ResultadosPage(
                origem: aeroportoOrigem!,
                destino: aeroportoDestino!,
                data: dataController.text,
                companhias: companhiasSelecionadas,
                adultos: adultos,
                criancas: criancas,
                bebes: bebes,
              ),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Preencha todos os campos corretamente!")),
      );
    }
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
            aeroportos.isEmpty
                ? const CircularProgressIndicator()
                : DropdownButton<String>(
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
            aeroportos.isEmpty
                ? const CircularProgressIndicator()
                : DropdownButton<String>(
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
              controller: dataController,
              decoration: const InputDecoration(labelText: "Data da Viagem"),
              onTap: () => selecionarData(context),
              readOnly: true,
            ),

            const SizedBox(height: 16),

            const Text("Companhias Aéreas"),
            Column(
              children:
                  companhiasAereas.map((companhia) {
                    return CheckboxListTile(
                      title: Text(companhia),
                      value: companhiasSelecionadas.contains(companhia),
                      onChanged: (bool? selecionado) {
                        setState(() {
                          if (selecionado == true) {
                            companhiasSelecionadas.add(companhia);
                          } else {
                            companhiasSelecionadas.remove(companhia);
                          }
                        });
                      },
                    );
                  }).toList(),
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
  final String data;
  final List<String> companhias;
  final int adultos;
  final int criancas;
  final int bebes;

  const ResultadosPage({
    Key? key,
    required this.origem,
    required this.destino,
    required this.data,
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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Voos de $origem para $destino"),
            Text("Data: $data"),
            Text("Adultos: $adultos | Crianças: $criancas | Bebês: $bebes"),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Voltar"),
            ),
          ],
        ),
      ),
    );
  }
}
