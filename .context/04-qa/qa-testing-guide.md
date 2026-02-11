# QA & Physical Testing Protocol: Circuit Copilot

## 1. The challenge of the environment

This application cannot be validated with simulators alone. The Circuit de Barcelona-Catalunya presents hostile conditions for mobile hardware:

1. **Direct Sunlight:** Affects screen visibility and camera sensors (AR).
2. **Magnetic Interference:** The grandstands are made of steel and concrete, which decalibrates the digital compass.
3. **GPS Shadow (Multipath):** High structures bounce the GPS signal.
4. **Network Saturation:** 100,000 people competing for 4G/5G bandwidth.

## 2. Phase 1: Laboratory Simulations (Office)

*Before going to the circuit, check this:*

| Test Case | Action | Expected Result |
| --- | --- | --- |
| **GPX Mocking** | Load a `.gpx` file with a complete lap of the circuit in the emulator. | The blue dot moves smoothly along the track without jumps. |
| **Network Throttling** | Configure the mobile to "2G / Edge" (Developer settings). | The base map loads (because it is in offline cache) and the route is calculated in <3s. |
| **Compass Noise** | Shake the mobile violently while using AR. | Arrows should try to stay stable, not spin like crazy. |

## 3. Phase 2: Field Testing (On-Site)

*Mandatory tests on real terrain.*

### A. "The Metal Grandstand" Test (Magnetic Interference)

**Context:** Mobile compasses fail near large masses of metal.

* **Location:** Under the Main Grandstand or in front of the straight's fence.
* **Action:** Open AR Mode.
* **Observation:** Where is the arrow pointing?
* **Critical Failure:** The arrow points to the wall instead of the path.
* **Solution:** If it fails, the app must detect `compass_accuracy_low` and suggest: *"Move 2 meters away from the metal structure"* or switch to 2D Map automatically.

### B. "Multipath" Test (GPS signal bounce)

**Context:** The GPS signal bounces off the stands and the mobile thinks you are on the track.

Recommended visual option:

* **Location:** Narrow corridor between Grandstand G and Grandstand H.
* **Action:** Walk in a straight line.
* **Observation:** See if the avatar on the map jumps from side to side (Zig-Zag).
* **Validation:** The "Map Matching" (Snap-to-road) algorithm must keep the user on the pedestrian path, ignoring impossible coordinate jumps.

### C. "Extreme Sunlight" Test (AR Visibility)

**Context:** Direct sun "blinds" the camera and overheats the mobile.

* **Time:** 12:00 PM - 02:00 PM (Zenith Sun).
* **Action:** Use AR for 5 continuous minutes pointing at the asphalt.
* **Risks to measure:**

1. **Contrast Loss:** Are the virtual arrows visible on the light gray asphalt? (They should have a black border or strong shadow).
2. **Tracking Lost:** If the ground has no texture (it is very smooth and shiny), ViroReact will lose its anchor.
3. **Overheat:** Does the mobile issue a temperature warning?

## 4. Phase 3: Stress Testing (The race simulation)

### The 1km Walkthrough

A tester must complete this entire route without closing the app:

1. **Start:** Parking F.
2. **Destination:** Seat in Grandstand N.
3. **Conditions:**

* Screen brightness at 100%.
* Mobile data disabled (Simulating network collapse).
* Bluetooth enabled (Headphones).

4. **Acceptance Criteria:**

* **Battery:** Should not drop more than 8% during this journey (~15 mins).
* **Navigation:** Should not require restarting the app.
* **Audio:** Voice instructions ("Turn right") must be audible over ambient noise (simulate engine noise or crowds).

## 5. Bug Reporting (Standardized Format)

When testers report failures from the circuit, they must include:

* **Exact Coordinates:** (Copy and paste from debug mode).
* **Sky Conditions:** (Sunny / Cloudy / Rain). *Rain affects the touchscreen.*
* **Device Orientation:** (Vertical / Horizontal).
* **AR Debug World Screenshot:** (See the virtual anchor points detected by the system).