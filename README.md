# README

## Auteurs
- **Nom : Hugo Martin**

## Installation

### Prérequis
Pour exécuter ce projet, assurez-vous d'avoir les éléments suivants installés :
- [Flutter](https://docs.flutter.dev/get-started/install)
- [Python 3.x](https://www.python.org/downloads/) (pour le script d'analyse des couleurs)
- Les bibliothèques suivantes pour Python :
  ```bash
  pip install argparse
  ```

### Étapes d'installation
1. Clonez ce dépôt sur votre machine locale :
   ```bash
   git clone git@github.com:HugoM38/colorz.git
   ```
2. **Pour l'application Flutter** :
   - Accédez au répertoire du projet Flutter
   - Installez les dépendances :
     ```bash
     flutter pub get
     ```

## Utilisation

### Application Flutter (ColorZ)
L'application mobile permet de simuler et de visualiser les mélanges de couleurs selon les règles de votre algorithme.

1. **Lancer l'application** :
   - Lancez l'application avec la commande :
     ```bash
     flutter run
     ```
2. **Interface principale** :
   - Choisissez une couleur publique (base).
   - Sélectionnez les couleurs privées d'Alice et de Bob.
   - Cliquez sur "Calculer le résultat" pour obtenir les mélanges intermédiaires et le résultat final.
   
### Script Python (Récupération des couleurs privées)
Le script Python peut être utilisé pour retrouver les couleurs privées d'Alice et de Bob à partir de leurs mélanges publics respectifs.

#### Exemple d'utilisation :
Exécutez le script en ligne de commande avec les arguments suivants :
```bash
python find_colors.py <base_color> <mixed_alice> <mixed_bob>
```
- `<base_color>` : Couleur de base en format hexadécimal (ex. : `#FF0000`)
- `<mixed_alice>` : Mélange intermédiaire d'Alice en format hexadécimal (ex. : `#AA5500`)
- `<mixed_bob>` : Mélange intermédiaire de Bob en format hexadécimal (ex. : `#55AA00`)

#### Exemple complet :
```bash
python find_colors.py #FF0000 #AA5500 #55AA00
```

Le script effectuera une recherche exhaustive pour trouver les couleurs privées d'Alice et de Bob, puis affichera les résultats sous la forme :
- Couleur privée d'Alice : `#XXYYZZ`
- Couleur privée de Bob : `#ZZYYXX`
- Vérification des mélanges intermédiaires.

### Preuve de concept
La preuve de concept (PoC) montre que :
- L'application Flutter fournit un moyen interactif et visuel de simuler le mélange de couleurs et les résultats attendus.
- Le script Python démontre que, même en disposant uniquement des mélanges intermédiaires, il est possible de retrouver les couleurs privées initiales en explorant toutes les combinaisons possibles.

