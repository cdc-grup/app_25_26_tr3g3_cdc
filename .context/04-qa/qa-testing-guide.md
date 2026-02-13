# Protocol de Control de Qualitat (QA) i Proves Físiques: Circuit Copilot

## 1. El repte de l'entorn

Aquesta aplicació no es pot validar només amb simuladors. El Circuit de Barcelona-Catalunya presenta condicions hostils per al maquinari mòbil:

1. **Llum Solar Directa:** Afecta la visibilitat de la pantalla i els sensors de la càmera (AR).
2. **Interferència Magnètica:** Les tribunes són d'acer i formigó, cosa que descalibra la brúixola digital.
3. **Ombra GPS (Multicamí):** Les estructures altes fan rebotar el senyal GPS.
4. **Saturació de la Xarxa:** 100.000 persones competint per l'amplada de banda 4G/5G.

## 2. Piràmide de Proves: Estratègia Automàtitzada

_Abans de sortir de l'oficina, el codi ha de passar aquests filtres:_

### A. Proves Unitàries i de Lògica (Shared & API)

- **Framework:** [Vitest](https://vitest.dev/).
- **Objectiu:** Validar algorismes crítics sense dependències externes.
- **Exemples:**
  - Càlcul de distàncies entre coordenades (lògica de proximitat a PDI).
  - Validació de formats de telemetria GPS.
  - Transformació de dades per al Socket.io (MessagePack).

### B. Proves d'Endpoint (API Integration)

- **Framework:** Vitest + [Supertest](https://github.com/ladjs/supertest).
- **Objectiu:** Assegurar que les rutes de l'API responen correctament amb els codis HTTP i esquemes de dades esperats.

### C. Proves de Components (Mobile)

- **Framework:** [Jest](https://jestjs.io/) + [React Native Testing Library](https://testing-library.com/docs/react-native-testing-library/intro/).
- **Objectiu:** Comprovar que les pantalles i components de la UI reaccionen correctamente a diferents estats (sense necessitat d'un dispositiu real).
- **Exemple:** Verificar que el botó d'AR es desactiva si el `compass_accuracy` és nul.

## 3. Fase 1: Simulacions de Laboratori (Oficina)

_Abans d'anar al circuit, comprova això:_

| Cas de Prova              | Acció                                                                    | Resultat Esperat                                                                                  |
| ------------------------- | ------------------------------------------------------------------------ | ------------------------------------------------------------------------------------------------- |
| **Simulació GPX**         | Carrega un fitxer `.gpx` amb una volta completa al circuit a l'emulador. | El punt blau es mou suaument per la pista sense salts.                                            |
| **Limitació de Xarxa**    | Configura el mòbil a "2G / Edge" (Ajustos de desenvolupador).            | El mapa base es carrega (perquè està a la memòria cau fora de línia) i la ruta es calcula en <3s. |
| **Soroll de la Brúixola** | Sacseja el mòbil violentament mentre utilitzes l'AR.                     | Les fletxes han d'intentar mantenir-se estables, no girar com lloques.                            |

## 3. Fase 2: Proves de Camp (In Situ)

_Proves obligatòries sobre el terreny real._

### A. Prova de la "Tribuna Metàl·lica" (Interferència Magnètica)

**Context:** Les brúixoles dels mòbils fallen a prop de grans masses de metall.

- **Ubicació:** Sota la Tribuna Principal o davant de la tanca de la recta.
- **Acció:** Obre el Mode AR.
- **Observació:** Cap a on apunta la fletxa?
- **Error Crític:** La fletxa apunta a la paret en comptes del camí.
- **Solució:** Si falla, l'app ha de detectar `compass_accuracy_low` i suggerir: _"Allunya't 2 metres de l'estructura metàl·lica"_ o canviar automàticament al Mapa 2D.

### B. Prova del "Multicamí" (Rebot del senyal GPS)

**Context:** El senyal GPS rebota a les grades i el mòbil es pensa que ets a la pista.

- **Ubicació:** Passadís estret entre la Tribuna G i la Tribuna H.
- **Acció:** Camina en línia recta.
- **Observació:** Comprova si l'avatar al mapa fa salts d'un costat a l'altre (Zig-Zag).
- **Validació:** L'algoritme de "Map Matching" (ajust al camí) ha de mantenir l'usuari al camí de vianants, ignorant salts de coordenades impossibles.

### C. Prova de "Llum Solar Extrema" (Visibilitat AR)

**Context:** El sol directe "encega" la càmera i sobreescalfa el mòbil.

- **Hora:** 12:00 PM - 02:00 PM (Sol Zenital).
- **Acció:** Utilitza l'AR durant 5 minuts continus apuntant a l'asfalt.
- **Riscos a mesurar:**

1. **Pèrdua de Contrast:** Són visibles les fletxes virtuals sobre l'asfalt gris clar? (Haurien de tenir un vora negra o una ombra forta).
2. **Pèrdua de Seguiment:** Si el terreny no té textura (és molt llis i brillant), ViroReact perdrà el seu ancoratje.
3. **Sobreestat:** El mòbil emet un avís de temperatura?

## 4. Fase 3: Proves d'Estrès (La simulació de la cursa)

### El Recorregut d'1 km

Un provador ha de completar tot aquest recorregut sense tancar l'app:

1. **Inici:** Pàrquing F.
2. **Destí:** Seient a la Tribuna N.
3. **Condicions:**

- Brillantor de la pantalla al 100%.
- Dades mòbils desactivades (Simulant el col·lapse de la xarxa).
- Bluetooth activat (Auriculars).

4. **Criteris d'Acceptació:**

- **Bateria:** No hauria d'abaixar més d'un 8% durant aquest trajecte (~15 minuts).
- **Navegació:** No hauria de requerir reiniciar l'app.
- **Àudio:** Les instruccions de veu ("Gira a la dreta") han de ser audibles per sobre del soroll ambiental (simula soroll de motors o multituds).

## 5. Informe d'Errors (Format Estàndard)

Quan els provadors informin de fallades des del circuit, han d'incloure:

- **Coordenades Exactes:** (Copia i enganxa des del mode de depuració).
- **Condicions del Cel:** (Sol / Núvols / Pluja). _La pluja afecta la pantalla tàctil._
- **Orientació del Dispositiu:** (Vertical / Horizontal).
- **Captura de pantalla del món de depuració d'AR:** (Per veure els punts d'ancoratje virtuals detectats pel sistema).
