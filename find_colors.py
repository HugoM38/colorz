import argparse
import sys
from itertools import product

def hex_to_rgb(hex_color):
    hex_color = hex_color.lstrip('#')
    return tuple(int(hex_color[i:i+2], 16) for i in (0, 2, 4))

def rgb_to_hex(rgb_color):
    return '#{:02x}{:02x}{:02x}'.format(rgb_color[0], rgb_color[1], rgb_color[2])

def mix_colors(color1, color2, ratio=0.5):
    return (
        int(color1[0] * ratio + color2[0] * (1 - ratio)),
        int(color1[1] * ratio + color2[1] * (1 - ratio)),
        int(color1[2] * ratio + color2[2] * (1 - ratio))
    )

def calculate_final_color(base_color, alice_color, bob_color):
    private_mix = mix_colors(alice_color, bob_color, 0.5)
    return mix_colors(private_mix, base_color, 0.66)

def verify_solution(base_color, alice_color, bob_color, mixed_alice, mixed_bob):
    test_mix_alice = mix_colors(base_color, alice_color, 0.5)
    test_mix_bob = mix_colors(base_color, bob_color, 0.5)
    
    return (test_mix_alice == mixed_alice and test_mix_bob == mixed_bob)

def find_private_colors(base_color, mixed_alice, mixed_bob):
    print("Recherche en cours... (cela peut prendre quelques minutes)")
    
    total = 256 * 256 * 256
    count = 0
    
    for r, g, b in product(range(256), repeat=3):
        count += 1
        if count % 1000000 == 0:
            print(f"Progression : {count/total*100:.1f}%")
            
        alice_color = (r, g, b)
        test_mix_alice = mix_colors(base_color, alice_color, 0.5)
        
        if test_mix_alice == mixed_alice:
            for r2, g2, b2 in product(range(256), repeat=3):
                bob_color = (r2, g2, b2)
                if verify_solution(base_color, alice_color, bob_color, mixed_alice, mixed_bob):
                    return alice_color, bob_color
    
    return None, None

def main():
    parser = argparse.ArgumentParser(description='Retrouve les couleurs privées à partir des mélanges.')
    parser.add_argument('base_color', help='Couleur de base (format hexadécimal)')
    parser.add_argument('mixed_alice', help='Mélange intermédiaire d\'Alice (format hexadécimal)')
    parser.add_argument('mixed_bob', help='Mélange intermédiaire de Bob (format hexadécimal)')
    
    args = parser.parse_args()

    try:
        base_color = hex_to_rgb(args.base_color)
        mixed_alice = hex_to_rgb(args.mixed_alice)
        mixed_bob = hex_to_rgb(args.mixed_bob)

        print("\nRecherche des couleurs privées...")
        print(f"Couleur de base: {args.base_color}")
        print(f"Mélange d'Alice: {args.mixed_alice}")
        print(f"Mélange de Bob: {args.mixed_bob}\n")

        alice_color, bob_color = find_private_colors(base_color, mixed_alice, mixed_bob)

        if alice_color and bob_color:
            alice_hex = rgb_to_hex(alice_color)
            bob_hex = rgb_to_hex(bob_color)
            
            print("\nCouleurs trouvées !")
            print(f"Couleur privée d'Alice: {alice_hex}")
            print(f"Couleur privée de Bob: {bob_hex}")
            
            test_mix_alice = mix_colors(base_color, alice_color, 0.5)
            test_mix_bob = mix_colors(base_color, bob_color, 0.5)
            final_result = calculate_final_color(base_color, alice_color, bob_color)
            
            print("\nVérification des mélanges :")
            print(f"Mélange Alice attendu: {args.mixed_alice}")
            print(f"Mélange Alice obtenu: {rgb_to_hex(test_mix_alice)}")
            print(f"Mélange Bob attendu: {args.mixed_bob}")
            print(f"Mélange Bob obtenu: {rgb_to_hex(test_mix_bob)}")
            print(f"Résultat final: {rgb_to_hex(final_result)}")
        else:
            print("Aucune solution trouvée !")
            sys.exit(1)

    except ValueError as e:
        print(f"Erreur : Format de couleur invalide - {str(e)}")
        sys.exit(1)

if __name__ == "__main__":
    main()