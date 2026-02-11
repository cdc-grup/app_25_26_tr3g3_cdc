# User Journeys

## Journey: The Efficient Exit (Traffic Management)

- **Context:** The race has just finished. 100,000 people are leaving.
- **Action:** User opens app to find their car (saved in US34).
- **System:**
    1. Checks user's saved parking coordinates.
    2. Checks server for "Gate Congestion Levels".
    3. Directs user to a secondary exit gate that is 5 minutes longer to walk but has 20 minutes less queue.
    4. Uses AR arrows to guide them through the crowd.

## Journey: The Group Reunion

- **Context:** User A is at Tribuna G, User B is at Food Truck Zone.
- **Action:** User A taps "Find B".
- **System:**
    1. Server pushes User B's last throttled location (via Socket.io).
    2. App draws a dynamic line on the map.
    3. As they get closer (<50m), App suggests: "Switch to AR to spot your friend in the crowd."