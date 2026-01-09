Proiect ASM - Prelucrarea și Manipularea Șirurilor de Octeți (8086)
📝 Descriere Proiect
Acest proiect constă în dezvoltarea unui program interactiv scris în limbaj de asamblare pentru arhitectura 8086 (16-biți)2. 
Programul permite utilizatorului să introducă un șir de date, realizează calcule complexe pe biți, sortează datele și efectuează rotații circulare, 
afișând rezultatele într-un format clar (binar și hexazecimal)3333333333333333.
Proiectul a fost realizat utilizând instrumentele TASM și TLINK4.

👥 Echipa și Responsabilități
Conform organizării interne a echipei noastre5:
    • Student 1: Responsabil cu citirea datelor de la tastatură, conversia acestora din format ASCII în valori binare și gestionarea șirului în segmentul de date6.
    • Student 2: Responsabil cu implementarea operațiilor pe biți, calculul componentelor cuvântului C și logica pentru rotațiile circulare7.
    • Student 3: Responsabil cu scrierea codului pentru sortarea descrescătoare a șirului și logica de afișare a rezultatelor finale8.
    • Student 4: Responsabil cu managementul depozitului GitHub, realizarea diagramei bloc și redactarea documentației tehnice a proiectului9.

🛠️ Funcționalități Principale
1. Citirea și Validarea Datelor
    • Programul acceptă între 8 și 16 octeți introduși în format hexazecimal (ex: 3F 7A 12...)10.
    • Citirea se realizează prin întreruperea DOS INT 21h, funcția AH=0Ah11.
2. Calculul Cuvântului C (16 biți) 12
Cuvântul C este generat astfel:
    • Biții 0-3: Rezultatul operației XOR între primii 4 biți ai primului octet și ultimii 4 biți ai ultimului octet13.
    • Biții 4-7: Rezultatul operației OR între biții 2-5 ai fiecărui octet din șir14.
    • Biții 8-15: Suma tuturor octeților din șir, calculată modulo 25615.
3. Manipularea Șirului
    • Sortare: Șirul este ordonat descrescător folosind un algoritm de sortare eficient16.
    • Analiza biților: Se determină octetul cu cel mai mare număr de biți de 1 (minim 3 biți) și se afișează poziția acestuia în șir17.
4. Rotații și Afișare 18
    • Pentru fiecare octet, se calculează suma primilor 2 biți ($N$)19.
    • Octetul este rotit circular spre stânga cu $N$ poziții20.
    • Rezultatele sunt afișate interactiv în formatele binar și hexazecimal21212121.

🚀 Instrucțiuni de Utilizare
Pentru a rula proiectul, aveți nevoie de un emulator (precum DOSBox) și utilitarele TASM:
    1. Asamblare: tasm/zi nume_fisier.asm
    2. Link-editare: tlink/v nume_fisier.obj
    3. Execuție: nume_fisier.exe
