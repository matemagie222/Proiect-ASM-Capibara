Proiect ASM - Prelucrarea și Manipularea Șirurilor de Octeți (8086)

📝 Descriere Proiect

Acest proiect constă în dezvoltarea unui program interactiv scris în limbaj de asamblare pentru arhitectura 8086 (16-biți). 
Programul permite utilizatorului să introducă un șir de date, realizează calcule pe biți, sortează datele și efectuează rotații circulare, 
afișând rezultatele într-un format clar (binar și hexazecimal).
Proiectul a fost realizat utilizând instrumentele TASM și TLINK.

👥 Echipa și Responsabilități

Conform organizării interne a echipei noastre:

• Student 1: Responsabil cu citirea datelor de la tastatură, conversia acestora din format ASCII în valori binare și gestionarea șirului în segmentul de date.

• Student 2: Responsabil cu implementarea operațiilor pe biți, calculul componentelor cuvântului C și logica pentru rotațiile circulare.

• Student 3: Responsabil cu scrierea codului pentru sortarea descrescătoare a șirului și logica de afișare a rezultatelor finale.

• Student 4: Responsabil cu managementul depozitului GitHub, realizarea diagramei bloc și redactarea documentației tehnice a proiectului.

🛠️ Funcționalități Principale
1. Citirea și Validarea Datelor
• Programul acceptă între 8 și 16 octeți introduși în format hexazecimal (ex: 3F 7A 12...).
• Citirea se realizează prin întreruperea DOS INT 21h, funcția AH=0Ah.
2. Calculul Cuvântului C (16 biți)
Cuvântul C este generat astfel:
    • Biții 0-3: Rezultatul operației XOR între primii 4 biți ai primului octet și ultimii 4 biți ai ultimului octet.
    • Biții 4-7: Rezultatul operației OR între biții 2-5 ai fiecărui octet din șir.
    • Biții 8-15: Suma tuturor octeților din șir, calculată modulo 256.
3. Manipularea Șirului
    • Sortare: Șirul este ordonat descrescător folosind un algoritm de sortare eficient.
    • Analiza biților: Se determină octetul cu cel mai mare număr de biți de 1 (minim 3 biți) și se afișează poziția acestuia în șir.
4. Rotații și Afișare 
    • Pentru fiecare octet, se calculează suma primilor 2 biți ($N$).
    • Octetul este rotit circular spre stânga cu $N$ poziții.
    • Rezultatele sunt afișate interactiv în formatele binar și hexazecimal.

🚀 Instrucțiuni de Utilizare

Pentru a rula proiectul, aveți nevoie de un emulator (precum DOSBox) și utilitarele TASM:
    1. Asamblare: tasm/zi nume_fisier.asm
    2. Link-editare: tlink/v nume_fisier.obj
    3. Execuție: nume_fisier.exe
