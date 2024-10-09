# Flutter Memory Leak Integration Test POC

## Overview

This project presents a **Proof of Concept (POC)** for detecting memory leaks in a Flutter application using integration tests. The integration tests simulate user interactions by navigating through multiple screens multiple times and then analyze the app's memory usage to identify potential memory leaks. By leveraging the Dart VM service, the tests capture memory snapshots and verify that no unintended instances of screen states remain in memory after navigation.

## Table of Contents

- [Overview](#overview)
- [Running the Tests](#running-the-tests)
- [How It Works](#how-it-works)
    - [VmServer](#vmserver)
    - [Screens](#screens)
- [Troubleshooting](#troubleshooting)

## Running the Tests

To execute the integration tests and check for memory leaks, follow these steps:

1. **Start the App with VM Service Enabled**

   The Dart VM service is required for memory profiling and is only available in debug mode. Additionally, you need to disable the Dart Development Service (DDS) to ensure proper communication with the VM service. Launch the app on your device or emulator with the following command:

   ```bash
   flutter run --observe --disable-dds
   ```

    - `--observe`: Enables observatory (VM service) for debugging and profiling.
    - `--disable-dds`: Disables the Dart Development Service to prevent interference with VM service connections.

2. **Run the Integration Tests**

   In a separate terminal window, execute the integration tests:

   ```bash
   flutter test --observe --disable-dds integration_test/memory_leak_test.dart
   ```

## How It Works

### VmServer

The `VmServer` class interfaces with the Dart VM service to perform memory profiling:

- **Connection Establishment**: Connects to the Dart VM service using the service protocol URI.
- **Memory Snapshot**: Captures memory allocation profiles after forcing garbage collection.
- **Instance Counting**: Analyzes the snapshot to count current instances of specified classes (e.g., `_SecondPageState`).

### Screens

The app consists of three screens, each navigable via buttons:

1. **FirstPage**

    - **Description**: The initial screen with a button to navigate to the **Second Page**.
    - **Key Elements**:
        - Leak Indicator: "FirstPage has no memory leak"

2. **SecondPage**

    - **Description**: Accessible from the **First Page**, it contains buttons to navigate back or forward.
    - **Key Elements**:
        - Leak Indicator: "SecondPage has no memory leak"

3. **ThirdPage**

    - **Description**: Accessible from the **Second Page**, it contains a button to navigate back.
    - **Key Elements**:
        - Leak Indicator: "ThirdPage has a memory leak"

## Troubleshooting

If you encounter issues while running the tests, consider the following solutions:

1. **VM Service Connection Issues**

    - **Symptom**: Tests fail to connect to the VM service.
    - **Solution**: Ensure the app is running in **debug mode** with the `--observe` and `--disable-dds` flags. The VM service is unavailable in release builds.
