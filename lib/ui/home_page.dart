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

  Color mixColors(Color color1, Color color2, double ratio) {
    return Color.fromARGB(
      255,
      (color1.red * ratio + color2.red * (1 - ratio)).toInt(),
      (color1.green * ratio + color2.green * (1 - ratio)).toInt(),
      (color1.blue * ratio + color2.blue * (1 - ratio)).toInt(),
    );
  }

  Color mixColorsExactThird(Color color1, Color color2) {
    return Color.fromARGB(
      255,
      ((color1.red / 3) + (2 * color2.red / 3)).toInt(),
      ((color1.green / 3) + (2 * color2.green / 3)).toInt(),
      ((color1.blue / 3) + (2 * color2.blue / 3)).toInt(),
    );
  }

  void calculateResult() {
    final mixedAlice = mixColors(baseColor, privateColorAlice, 0.5);
    final mixedBob = mixColors(baseColor, privateColorBob, 0.5);

    setState(() {
      result = mixColorsExactThird(privateColorAlice, mixedBob);
    });

    assert(
      result == mixColorsExactThird(privateColorBob, mixedAlice),
      "Les résultats ne sont pas identiques !",
    );
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
                'Selectionner',
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
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Card(
                  elevation: 4,
                  margin: const EdgeInsets.symmetric(vertical: 8.0),
                  color: Colors.red.shade900,
                  child: ListTile(
                    title: const Text(
                      'Couleur de base',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    subtitle: GestureDetector(
                      onTap: () =>
                          copyToClipboard(colorToHex(baseColor), context),
                      child: Text(
                        colorToHex(baseColor),
                        style: const TextStyle(
                            fontSize: 14,
                            decoration: TextDecoration.underline,
                            color: Colors.white,
                            decorationColor: Colors.white),
                      ),
                    ),
                    trailing: GestureDetector(
                      onTap: () => showColorPicker(
                          context, 'Selectionner la couleur de base', baseColor,
                          (color) {
                        setState(() => baseColor = color);
                      }),
                      child: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: baseColor,
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.black26, width: 2),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: Card(
                        elevation: 4,
                        margin: const EdgeInsets.all(8.0),
                        color: Colors.red.shade900,
                        child: ListTile(
                          title: const Text(
                            "Couleur d'Alice",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          subtitle: GestureDetector(
                            onTap: () => copyToClipboard(
                                colorToHex(privateColorAlice), context),
                            child: Text(
                              colorToHex(privateColorAlice),
                              style: const TextStyle(
                                  fontSize: 14,
                                  decoration: TextDecoration.underline,
                                  color: Colors.white,
                                  decorationColor: Colors.white),
                            ),
                          ),
                          trailing: GestureDetector(
                            onTap: () => showColorPicker(
                                context,
                                "Selectionner la couleur d'Alice",
                                privateColorAlice, (color) {
                              setState(() => privateColorAlice = color);
                            }),
                            child: Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                color: privateColorAlice,
                                shape: BoxShape.circle,
                                border:
                                    Border.all(color: Colors.black26, width: 2),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Card(
                        elevation: 4,
                        margin: const EdgeInsets.all(8.0),
                        color: Colors.red.shade900,
                        child: ListTile(
                          title: const Text(
                            "Couleur de Bob",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          subtitle: GestureDetector(
                            onTap: () => copyToClipboard(
                                colorToHex(privateColorBob), context),
                            child: Text(
                              colorToHex(privateColorBob),
                              style: const TextStyle(
                                  fontSize: 14,
                                  decoration: TextDecoration.underline,
                                  color: Colors.white,
                                  decorationColor: Colors.white),
                            ),
                          ),
                          trailing: GestureDetector(
                            onTap: () => showColorPicker(
                                context,
                                "Selectionner la couleur de Bob",
                                privateColorBob, (color) {
                              setState(() => privateColorBob = color);
                            }),
                            child: Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                color: privateColorBob,
                                shape: BoxShape.circle,
                                border:
                                    Border.all(color: Colors.black26, width: 2),
                              ),
                            ),
                          ),
                        ),
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
                      textStyle: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    child: const Text(
                      'Calculer le résultat',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                if (result != null)
                  Card(
                    elevation: 4,
                    margin: const EdgeInsets.symmetric(vertical: 8.0),
                    color: Colors.red.shade900,
                    child: ListTile(
                      title: const Text(
                        'Resultat du mélange',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          decorationColor: Colors.white
                        ),
                      ),
                      subtitle: GestureDetector(
                        onTap: () =>
                            copyToClipboard(colorToHex(result!), context),
                        child: Text(
                          colorToHex(result!),
                          style: const TextStyle(
                            fontSize: 14,
                            decoration: TextDecoration.underline,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      trailing: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: result,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Colors.black26,
                            width: 2,
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
