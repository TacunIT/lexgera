# Deviazioni dalle indicazioni della grafica

Riferimento: risposte della grafica del 27/11/2026. Il tag `grafica-2026-11-27` contiene le indicazioni applicate alla lettera; le correzioni sono nei commit successivi.

## Correzioni (indicazioni della grafica modificate)

1. Titolo hero su mobile
   - Indicazione: 60px, interlinea 60px.
   - Problema: misurato con il font caricato, "COMPETENZA," a 60px occupa 284px; a 320px di schermo lo spazio è circa 272px, quindi la parola sfora.
   - Soluzione: `font-size: min(3.75rem, 17.5vw)`: 60px da circa 343px di larghezza in su, 56px a 320px.

2. Titolo di #contatti ("Parla con un nostro consulente")
   - Indicazione: titoli di sezione #8383E5.
   - Problema: la sezione ha fondo viola; #8383E5 sarebbe illeggibile.
   - Soluzione: resta bianco.

3. Valori desktop fra 861 e 1200px
   - Indicazione: valori solo per il mobile.
   - Problema: con i clamp esistenti a 861px i testi erano più piccoli che a 860px, es. titoli 43px contro 48px, didascalie 18px contro 24px.
   - Soluzione: minimi dei clamp alzati ai valori mobile, didascalie e sottotitoli 24px fissi.

## Integrazioni (punti su cui la grafica non ha dato indicazioni)

1. Card "Altro" del form senza mascotte: testo spostato in basso di 36px (28px icona + 8px gap) per allinearlo alle altre card.
2. Icone del form "Di cosa hai bisogno?": sostituite con le stesse icone delle card dei servizi; le vecchie `contatti-1..4.png` rimosse.
3. Icona telefono "piena": fill e stroke dello stesso colore, per mantenere dimensioni e angoli arrotondati dell'icona Lucide originale.
4. Voce di menu "whatsapp" in minuscolo come le altre voci; "WhatsApp" con la grafia corretta nei testi.
5. Riquadro del titolare nella privacy: spazio fra etichette e valori.
6. Testi da 16px delle card dei servizi lasciati a #827A94 (la grafica ha indicato #5B5970 solo per il body base).
