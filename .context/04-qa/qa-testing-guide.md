# QA & Physical Testing Protocol: Circuit Copilot

## 1. El desafío del entorno

Esta aplicación no se puede validar solo con simuladores. El Circuit de Barcelona-Catalunya presenta condiciones hostiles para el hardware móvil:

1. **Luz Solar Directa:** Afecta a la visión de pantalla y a los sensores de la cámara (AR).
2. **Interferencia Magnética:** Las tribunas son de acero y hormigón, lo que descalibra la brújula digital.
3. **Sombra de GPS (Multipath):** Las estructuras altas rebotan la señal GPS.
4. **Saturación de Red:** 100.000 personas compitiendo por el ancho de banda 4G/5G.

## 2. Fase 1: Simulaciones de Laboratorio (Office)

*Antes de ir al circuito, verifica esto:*

| Test Case | Acción | Resultado Esperado |
| --- | --- | --- |
| **GPX Mocking** | Cargar un archivo `.gpx` con una vuelta completa al circuito en el emulador. | El punto azul se mueve suavemente por el trazado sin saltos. |
| **Network Throttling** | Configurar el móvil en "2G / Edge" (Developer settings). | El mapa base carga (porque está en caché offline) y la ruta se calcula en <3s. |
| **Compass Noise** | Agitar el móvil violentamente mientras se usa AR. | Las flechas deben intentar mantenerse estables, no girar como locas. |

## 3. Fase 2: Field Testing (On-Site)

*Pruebas obligatorias en el terreno real.*

### A. Test de "La Tribuna Metálica" (Interferencia Magnética)

**Contexto:** Las brújulas de los móviles fallan cerca de grandes masas de metal.

* **Lugar:** Debajo de la Tribuna Principal o frente a la reja de la recta.
* **Acción:** Abrir el Modo AR.
* **Observación:** ¿Hacia dónde apunta la flecha?
* **Fallo Crítico:** La flecha apunta a la pared en lugar del camino.
* **Solución:** Si falla, la app debe detectar `compass_accuracy_low` y sugerir: *"Aléjate 2 metros de la estructura metálica"* o cambiar a Mapa 2D automáticamente.

### B. Test de "Multipath" (Rebote de señal GPS)

**Contexto:** La señal GPS rebota en las gradas y el móvil cree que estás en la pista.

Opción visual recomendada:

* **Lugar:** Pasillo estrecho entre Tribuna G y Tribuna H.
* **Acción:** Caminar en línea recta.
* **Observación:** Mirar si el avatar en el mapa salta de un lado a otro (Zig-Zag).
* **Validación:** El algoritmo de "Map Matching" (Snap-to-road) debe mantener al usuario en el camino peatonal, ignorando los saltos de coordenadas imposibles.

### C. Test de "Luz Solar Extrema" (AR Visibility)

**Contexto:** El sol directo "ciega" la cámara y sobrecalienta el móvil.

* **Hora:** 12:00 PM - 14:00 PM (Sol cenital).
* **Acción:** Usar AR durante 5 minutos continuos apuntando al asfalto.
* **Riesgos a medir:**

1. **Contrast Loss:** ¿Se ven las flechas virtuales sobre el asfalto gris claro? (Deben tener borde negro o sombra fuerte).
2. **Tracking Lost:** Si el suelo no tiene textura (es muy liso y brillante), ViroReact perderá el anclaje.
3. **Overheat:** ¿El móvil lanza aviso de temperatura?

## 4. Fase 3: Stress Testing (La simulación de carrera)

### El "Walkthrough" de 1km

Un tester debe realizar este recorrido completo sin cerrar la app:

1. **Inicio:** Parking F.
2. **Destino:** Asiento en Tribuna N.
3. **Condiciones:**

* Brillo de pantalla al 100%.
* Datos móviles desactivados (Simulando colapso de red).
* Bluetooth activado (Auriculares).

4. **Criterios de Aceptación:**

* **Batería:** No debe bajar más del 8% en este trayecto (~15 mins).
* **Navegación:** No debe requerir reiniciar la app.
* **Audio:** Las instrucciones de voz ("Gira a la derecha") deben oírse sobre el ruido ambiental (simular ruido de motores o gentío).

## 5. Reporte de Bugs (Formato Estandarizado)

Cuando los testers reporten fallos desde el circuito, deben incluir:

* **Coordenadas Exactas:** (Copia y pega del modo debug).
* **Estado del Cielo:** (Soleado / Nublado / Lluvia). *La lluvia afecta a la pantalla táctil.*
* **Orientación del Dispositivo:** (Vertical / Horizontal).
* **Captura de Pantalla del "AR Debug World":** (Ver los puntos de anclaje virtuales que detecta el sistema).