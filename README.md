# Bizerba Digital Card — HTML/PWA

Aplicació de targeta digital que funciona localment. No utilitza cap servidor ni CDN per generar el QR.

## Funcions
- Dades editables des del mateix iPhone.
- Dades guardades en localStorage.
- QR de vCard generat dins del navegador.
- Compartició de la vCard `.vcf` amb el menú natiu de l'iPhone.
- Mode Fira amb QR gran.
- Funciona sense Internet després d'obrir-la.

## Ús més senzill
1. Descarrega/descomprimeix la carpeta.
2. Obre `index.html` amb Safari des de l'app Fitxers.
3. Entra a **Editar dades**, modifica la informació i prem **Guardar canvis**.
4. Per una fira, prem **Mode Fira — QR gran**.

## Instal·lació com a icona
Perquè Safari permeti una PWA completa amb "Afegir a pantalla d'inici", la pàgina s'ha de servir per HTTPS. El projecte inclou `manifest.webmanifest` i `sw.js` per si més endavant vols allotjar-lo en un servei estàtic. El contingut de l'app no depèn de cap API externa.


Logo update (v5): the BIZERBA wordmark is no longer compressed with excessive negative letter spacing or artificial font weight. Its proportions are kept natural for responsive display.
