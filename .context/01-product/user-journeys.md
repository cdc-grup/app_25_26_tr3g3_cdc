# Recorreguts d'Usuari (User Journeys)

## Recorregut: La Sortida Eficient (Gestió del Trànsit)

- **Context:** La cursa acaba de finalitzar. 100.000 persones estan sortint.
- **Acció:** L'usuari obre l'app per trobar el seu cotxe (guardat a l'US34).
- **Sistema:**
    1. Comprova les coordenades d'aparcament guardades de l'usuari.
    2. Consulta al servidor els "Nivells de Congestió de les Portes".
    3. Dirigeix l'usuari a una porta de sortida secundària que triga 5 minuts més a peu però té 20 minuts menys de cua.
    4. Utilitza fletxes d'AR per guiar-los a través de la multitud.

## Recorregut: El retrobament del Grup

- **Context:** L'Usuari A està a la Tribuna G, l'Usuari B està a la Zona de Food Trucks.
- **Acció:** L'Usuari A prem "Troba el B".
- **Sistema:**
    1. El servidor envia l'última ubicació limitada de l'Usuari B (via Socket.io).
    2. L'app dibuixa una línia dinàmica al mapa.
    3. A mesura que s'apropen (<50m), l'App suggereix: "Passa a l'AR per localitzar el teu amic entre la multitud."
## Recorregut: Trobar Menjar i Beguda (Restaurants)

- **Context:** L'usuari vol menjar alguna cosa durant el transcurs de la cursa.
- **Acció:** L'usuari busca la categoria "Restaurants" a l'app.
- **Sistema:**
    1. Mostra les opcions de menjar disponibles a prop.
    2. Indica el temps d'espera a la cua en temps real.
    3. Permet fer la comanda i el pagament des del mòbil per recollir.
    4. Envia una notificació quan la comanda està llesta.

## Recorregut: Localitzar Serveis (Banys)

- **Context:** L'usuari necessita utilitzar els lavabos.
- **Acció:** L'usuari selecciona "Banys" al menú de serveis o mapa.
- **Sistema:**
    1. Localitza la posició actual de l'usuari.
    2. Mostra els banys més propers i el seu estat d'ocupació (lliure/ocupat/cues).
    3. Guia l'usuari fins al bany escollit amb fletxes al mapa.

## Recorregut: Arribada a la Localitat (Butaca / Graderia / Gespa)

- **Context:** L'usuari acaba d'entrar i vol trobar el seu lloc assignat.
- **Acció:** L'usuari selecciona "La meva entrada" o escaneja el codi QR.
- **Sistema:**
    1. Identifica la zona, porta, fila i seient de l'entrada.
    2. Genera una ruta pas a pas des de la posició actual fins al lloc exacte.
    3. Utilitza realitat augmentada (AR) per senyalitzar el camí i la ubicació precisa.
