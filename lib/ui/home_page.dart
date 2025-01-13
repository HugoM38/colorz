import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter/services.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Color baseColor = Colors.blue;
  Color privateColorAlice = Colors.green;
  Color privateColorBob = Colors.red;
  Color? result;
  Color? mixedAlice;
  Color? mixedBob;
  Color? aliceFinalMix;
  Color? bobFinalMix;

  Color mixColors(Color color1, Color color2, double ratio) {
    return Color.fromARGB(
      255,
      (color1.red * ratio + color2.red * (1 - ratio)).toInt(),
      (color1.green * ratio + color2.green * (1 - ratio)).toInt(),
      (color1.blue * ratio + color2.blue * (1 - ratio)).toInt(),
    );
  }

  void calculateResult() {
    final aliceMix = mixColors(baseColor, privateColorAlice, 0.5);
    final bobMix = mixColors(baseColor, privateColorBob, 0.5);

    final privateMix = mixColors(privateColorAlice, privateColorBob, 0.5);

    final finalResult = mixColors(privateMix, baseColor, 0.66);

    setState(() {
      mixedAlice = aliceMix;
      mixedBob = bobMix;
      aliceFinalMix = finalResult;
      bobFinalMix = finalResult;
      result = finalResult;
    });
  }

  String colorToHex(Color color) {
    return '#${color.value.toRadixString(16).toUpperCase().substring(2)}';
  }

  void showColorPicker(BuildContext context, String title, Color currentColor,
      Function(Color) onColorChanged) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.red.shade900,
          title: Text(
            title,
            style: const TextStyle(color: Colors.white),
          ),
          content: SingleChildScrollView(
            child: ColorPicker(
              pickerColor: currentColor,
              onColorChanged: onColorChanged,
              enableAlpha: false,
              labelTypes: const [],
              pickerAreaHeightPercent: 0.6,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text(
                'Sélectionner',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        );
      },
    );
  }

  void copyToClipboard(String text, BuildContext context) {
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('$text copié dans le presse-papiers')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ColorZ'),
        backgroundColor: Colors.red.shade900,
        titleTextStyle: const TextStyle(
            fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
      ),
      backgroundColor: Colors.grey.shade900,
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(16.0),
            constraints: const BoxConstraints(maxWidth: 600),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                buildColorCard(
                    'Couleur de base (publique)',
                    baseColor,
                    context,
                    () => showColorPicker(
                        context,
                        'Sélectionner la couleur de base',
                        baseColor,
                        (color) => setState(() => baseColor = color))),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: buildColorCard(
                        "Couleur privée d'Alice",
                        privateColorAlice,
                        context,
                        () => showColorPicker(
                            context,
                            "Sélectionner la couleur d'Alice",
                            privateColorAlice,
                            (color) =>
                                setState(() => privateColorAlice = color)),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: buildColorCard(
                        "Couleur privée de Bob",
                        privateColorBob,
                        context,
                        () => showColorPicker(
                            context,
                            "Sélectionner la couleur de Bob",
                            privateColorBob,
                            (color) => setState(() => privateColorBob = color)),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Center(
                  child: ElevatedButton(
                    onPressed: calculateResult,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red.shade900,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 24, vertical: 12),
                    ),
                    child: const Text(
                      'Calculer le résultat',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                if (mixedAlice != null)
                  buildColorCard("Mélange public d'Alice (50/50)", mixedAlice!,
                      context, null),
                if (mixedBob != null)
                  buildColorCard("Mélange public de Bob (50/50)", mixedBob!,
                      context, null),
                const SizedBox(height: 24),
                if (aliceFinalMix != null)
                  buildColorCard("Résultat final d'Alice (66/33)",
                      aliceFinalMix!, context, null),
                if (bobFinalMix != null)
                  buildColorCard("Résultat final de Bob (66/33)", bobFinalMix!,
                      context, null),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildColorCard(
      String title, Color color, BuildContext context, VoidCallback? onTap) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      color: Colors.red.shade900,
      child: ListTile(
        title: Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        subtitle: Row(
          children: [
            Text(
              colorToHex(color),
              style: const TextStyle(
                fontSize: 14,
                color: Colors.white,
              ),
            ),
            const SizedBox(width: 8),
            IconButton(
              icon: const Icon(Icons.copy, color: Colors.white, size: 18),
              onPressed: () => copyToClipboard(colorToHex(color), context),
              tooltip: 'Copier le code couleur',
            ),
          ],
        ),
        trailing: onTap != null
            ? GestureDetector(
                onTap: onTap,
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: color,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.black26, width: 2),
                  ),
                ),
              )
            : Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: color,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.black26, width: 2),
                ),
              ),
      ),
    );
  }
}
