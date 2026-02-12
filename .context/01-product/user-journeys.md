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