
<h2 align="center">StayFocused</h2>

<div align="center">
  <img src="https://github.com/user-attachments/assets/c073aa1b-f8ef-418c-82a9-7e98a431b4a3" alt="iOS – App Icon" width="30%">
</div>


**StayFocused** is an iOS feature-project that lets users define timers to restrict app usage and help them stay focused by leveraging Apple’s Screen Time and Device Activity frameworks. It uses the DeviceActivityMonitor API to schedule start/end events for focus sessions and the Screen Time API to enforce usage limits. The codebase is organized into Swift targets including the main app, a Device Activity extension, and a Widget for quick glance controls.

## Features

-   **Custom Timer Schedules**: Define focus windows with start/end times and app-specific thresholds.
    
-   **Device Activity Monitoring**: Automatically trigger extensions at the beginning and end of each timer session using DeviceActivityMonitor.
    
-   **Screen Time Enforcement**: Apply ManagedSettings rules to block or limit app usage once the timer expires.
    
-   **Home Screen Widget**: Control and view focus sessions directly from the live activity or the dynamic island powered by the TimerActivityWidget target.
    

## Screenshots

### Live Activity

![LiveActivity](https://github.com/user-attachments/assets/2aa7c2e6-8a6f-43ff-a822-b9c10b2027c7)

### Timer

![Timer](https://github.com/user-attachments/assets/cecc1e06-ac05-414b-bff8-1f5a58e4acf4)

### Shield

![Shield](https://github.com/user-attachments/assets/ee954548-302c-4d40-a0f4-9374979ee669)

### Screen Time Authentication

![ScreenTimeAPI](https://github.com/user-attachments/assets/50366c49-6ee2-4b18-889f-ee02477b40eb)

## Project Structure

-   **StayFocused/**  – SwiftUI app entry point and views.
    
-   **TimerMonitor/**  – Implements DeviceActivityMonitor schedules and thresholds.
    
-   **TimerActivityContent/**  – Defines the DeviceActivityReport extension UI.
    
-   **TimerActivityWidget/**  – SwiftUI Widget for quick session info.
    
-   **TimerActivityUI/**  – Shared UI components for the timer extension.
    

## Installation

1.  Clone the repository:
    
    ```bash
    git clone https://github.com/killlilwinters/StayFocused-ScreenTimeAPI.git
    
    ```
    
2.  Open  `StayFocused.xcodeproj`  in Xcode.
    
3.  In your target's  **Signing & Capabilities**, add the  **FamilyControls**  entitlement to your  `.entitlements`  file and enable the  **DeviceActivity**  capability **if needed**.
    
4.  Build and run on either a physical device or the Simulator (fully supported on Simulator).
