import 'package:flutter/material.dart';

void main() => runApp(const GasolinaAlcoolApp());

class GasolinaAlcoolApp extends StatelessWidget {
  const GasolinaAlcoolApp({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Gasolina x Álcool',
        theme: ThemeData(colorScheme: ColorScheme.fromSeed(seedColor: Colors.green), useMaterial3: true),
        home: const ComparadorPage(),
      );
}

class ComparadorPage extends StatefulWidget {
  const ComparadorPage({super.key});
  @override
  State<ComparadorPage> createState() => _ComparadorPageState();
}

class _ComparadorPageState extends State<ComparadorPage> {
  final gasolinaController = TextEditingController();
  final alcoolController = TextEditingController();
  String? resultado;

  void calcular() {
    final gasolina = double.tryParse(gasolinaController.text.replaceAll(',', '.'));
    final alcool = double.tryParse(alcoolController.text.replaceAll(',', '.'));
    if (gasolina == null || alcool == null || gasolina <= 0 || alcool <= 0) {
      setState(() => resultado = 'Informe valores válidos maiores que zero.');
      return;
    }
    final porcentagem = alcool / gasolina * 100;
    final recomendacao = porcentagem <= 75 ? 'álcool' : 'gasolina';
    setState(() => resultado = 'Relação: ' + porcentagem.toStringAsFixed(1) + '%\nÉ mais vantajoso abastecer com ' + recomendacao + '.');
  }

  @override
  void dispose() { gasolinaController.dispose(); alcoolController.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Gasolina x Álcool'), centerTitle: true),
    body: Center(child: SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: ConstrainedBox(constraints: const BoxConstraints(maxWidth: 420), child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Icon(Icons.local_gas_station, color: Colors.green, size: 96),
          const SizedBox(height: 24),
          CampoPreco(rotulo: 'Preço da gasolina', controller: gasolinaController),
          const SizedBox(height: 16),
          CampoPreco(rotulo: 'Preço do álcool', controller: alcoolController),
          const SizedBox(height: 20),
          FilledButton(onPressed: calcular, child: const Text('Calcular')),
          if (resultado != null) ...[const SizedBox(height: 24), Card(child: Padding(padding: const EdgeInsets.all(16), child: Text(resultado!, textAlign: TextAlign.center)))],
        ],
      )),
    )),
  );
}

class CampoPreco extends StatelessWidget {
  const CampoPreco({super.key, required this.rotulo, required this.controller});
  final String rotulo;
  final TextEditingController controller;
  @override
  Widget build(BuildContext context) => TextField(
    controller: controller,
    keyboardType: const TextInputType.numberWithOptions(decimal: true),
    decoration: InputDecoration(labelText: rotulo, prefixText: 'R\$ ', border: const OutlineInputBorder()),
  );
}
