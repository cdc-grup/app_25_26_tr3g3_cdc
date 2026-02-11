# App State Machine

## 1. High-Level Flow (Global States)

This diagram defines the macro lifecycle of the application.

```mermaid
stateDiagram-v2
    [*] --> Splash: App Launch
    Splash --> AuthCheck: Check Token & Ticket

    state AuthCheck {
        [*] --> Validating
        Validating --> Onboarding: No Token / No Ticket
        Validating --> PreRaceMode: Ticket Valid & Date < Event
        Validating --> LiveMode: Ticket Valid & Date = Event
    }

    Onboarding --> PreRaceMode: Ticket Synced
    
    state LiveMode {
        [*] --> Map2D_Idle
        Map2D_Idle --> Navigation_Active: User selects Destination
        Navigation_Active --> Map2D_Idle: Arrival / Cancel
    }

    LiveMode --> PostRaceMode: Event Finished
    PostRaceMode --> CarFinder: "Find my Car"

```

## 2. The Navigation Engine (Complex Logic)

This is where the magic (and complexity) happens. We define how the user enters and exits AR mode and how we handle connection loss.

### AR/2D Transition Logic

* **Main Trigger:** Gyroscope (Phone Tilt).
* If `pitch > 60°` (mobile vertical) -> **Activate AR**.
* If `pitch < 30°` (mobile flat) -> **Return to 2D**.

* **Secondary Trigger:** Manual "View in AR" button.

```mermaid
stateDiagram-v2
    state "Navigation Active" as Nav {
        [*] --> ComputingRoute: API / Local Graph Request
        
        ComputingRoute --> Route_2D: Success
        ComputingRoute --> Error_Toast: Fail (No path found)

        state Route_2D {
            [*] --> FollowingPath
            FollowingPath --> OffRoute: GPS Deviation > 20m
            OffRoute --> ComputingRoute: Auto-Recalculate
        }

        state Route_AR {
            [*] --> Calibrating: Scan Ground / Compass
            Calibrating --> ShowingArrows: Good Accuracy
            ShowingArrows --> LowLightWarning: Camera Dark
            ShowingArrows --> Route_2D: Lower Phone
        }

        Route_2D --> Route_AR: Lift Phone (Pitch > 60°)
        Route_AR --> Route_2D: Lower Phone (Pitch < 30°)
        
        -- External Events --
        Route_2D --> CongestionAlert: Socket: "Crowd Ahead"
        CongestionAlert --> ComputingRoute: Auto-Reroute
    }

    state "Connectivity" as Conn {
        Online --> Offline: Signal Lost
        Offline --> Online: Signal Restored
    }
    
    note right of Offline
        In Offline Mode:
        - Mapbox switches to Vector Tiles Pack
        - Routing uses local Graph (No congestion data)
        - AR is disabled (Optional, but recommended)
    end note

```

## 3. Key States Description

### A. `PreRaceMode` (US3)

* **Objective:** Planning and hype.
* **Restrictions:** Does not consume battery searching for high-precision GPS.
* **UI:** Shows the schedule (`events_schedule`), recommended access points, and offline map downloads.
* **Exit:** Automatically switches to `LiveMode` on race day at 06:00 AM.

### B. `Navigation_Active` (US4, US7, US8)

It is the most critical state. Consumes a lot of battery and data.

* **Sub-state `ComputingRoute`:**

1. Query the server (API) for congestion.
2. If server fails/takes > 3s, calculate local route (Plan B).

* **Sub-state `Route_AR`:**
* **Calibration:** When lifting the phone, ViroReact needs 1-2 seconds to anchor the ground. You must show a loader "Detecting ground...".
* **Safety Lock:** If the user walks too fast (>10km/h), the AR is blocked and shows "For your safety, look ahead".

### C. `Offline_Mode` (US33)

This is an "Overlaid State" (can occur at any time).

* **Behavior:**
* The route API (`POST /navigation/route`) is blocked.
* The local route engine (`Mapbox.DirectionsFactory`) is activated.
* "Friends" markers are hidden (since they cannot be updated).
* A yellow banner is shown: "Offline Mode - Basic routes active".

## 4. Edge Cases (Boundary cases to program)

1. **"The ghost user":**

* *Situation:* The GPS says the user is 500km from the circuit (start error).
* *Action:* The state diagram must prevent entering `Navigation_Active`. Show modal: "It seems you are not at the circuit".

2. **"The congestion loop":**

* *Situation:* The server says route A is full. The app calculates route B. 10 seconds later, route B also becomes full.
* *Action:* Define a `debounce` in the `ReRouting` state. Do not recalculate more than once per minute to avoid confusing the user.

3. **"Critical Battery":**

* *Situation:* Battery < 15%.
* *Action:* Force transition from `Route_AR` to `Route_2D` and disable the gyroscope sensor to save energy.
