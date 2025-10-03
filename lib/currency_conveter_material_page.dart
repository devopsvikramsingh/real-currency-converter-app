import 'package:flutter/material.dart';

class CurrencyConverterMaterialPage extends StatefulWidget {
  const CurrencyConverterMaterialPage({super.key});

  @override
  State<CurrencyConverterMaterialPage> createState() =>
      _CurrencyConverterMaterialPageState();
}

class _CurrencyConverterMaterialPageState
    extends State<CurrencyConverterMaterialPage> {
  double result = 0;
  final TextEditingController textEditingController = TextEditingController();

  // Currency conversion rates (From USD to others)
  final Map<String, double> conversionRates = {
    'USD': 1.0,
    'INR': 88.75,
    'EUR': 0.94,
    'JPY': 149.50,
    'GBP': 0.82,
  };

  String fromCurrency = 'USD';
  String toCurrency = 'INR';

  void convertCurrency() {
    final inputText = textEditingController.text;
    if (inputText.isEmpty) {
      _showError("Please enter an amount.");
      return;
    }

    double? inputAmount = double.tryParse(inputText);
    if (inputAmount == null) {
      _showError("Invalid number format.");
      return;
    }

    // Convert from selected currency to USD, then to target currency
    double usdAmount = inputAmount / conversionRates[fromCurrency]!;
    double converted = usdAmount * conversionRates[toCurrency]!;

    setState(() {
      result = converted;
    });
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey,
      appBar: AppBar(
        backgroundColor: Colors.deepOrange,
        elevation: 0,
        title: const Text(
          'Currency Converter',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '$toCurrency ${result.toStringAsFixed(2)}',
              style: const TextStyle(
                fontSize: 40,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: textEditingController,
              style: const TextStyle(fontSize: 18, color: Colors.black),
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                labelText: 'Enter amount',
                prefixIcon: const Icon(Icons.attach_money),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(child: _buildCurrencyDropdown(true)),
                const SizedBox(width: 10),
                const Icon(Icons.arrow_forward, color: Colors.white),
                const SizedBox(width: 10),
                Expanded(child: _buildCurrencyDropdown(false)),
              ],
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: convertCurrency,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                foregroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 50),
              ),
              child: const Text('Convert'),
            ),
          ],
        ),
      ),
    );
  }

  // Build Dropdown for currency selection
  Widget _buildCurrencyDropdown(bool isFromCurrency) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: DropdownButton<String>(
        value: isFromCurrency ? fromCurrency : toCurrency,
        isExpanded: true,
        icon: const Icon(Icons.arrow_drop_down),
        underline: const SizedBox(), // Remove underline
        onChanged: (String? newValue) {
          if (newValue != null) {
            setState(() {
              if (isFromCurrency) {
                fromCurrency = newValue;
              } else {
                toCurrency = newValue;
              }
            });
          }
        },
        items: conversionRates.keys.map((String currency) {
          return DropdownMenuItem<String>(
            value: currency,
            child: Text(
              currency,
              style: const TextStyle(fontSize: 16),
            ),
          );
        }).toList(),
      ),
    );
  }
}
