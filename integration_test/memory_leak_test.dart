import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:memory_leak_test/main.dart';
import 'package:vm_service/src/vm_service.dart';

import 'vm/vm_service.dart';

void main() {
  final vmServer = VmServer();

  setUpAll(() {
    IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  });

  testWidgets('Test second screen memory leak', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());
    await tester.pumpAndSettle();
    await tester.tap(find.text("Go to next page"));
    await tester.pumpAndSettle();
    await tester.tap(find.text("Go back"));
    await tester.pumpAndSettle();
    await tester.tap(find.text("Go to next page"));
    await tester.pumpAndSettle();
    await tester.tap(find.text("Go back"));
    await tester.pumpAndSettle();
    await tester.tap(find.text("Go to next page"));
    await tester.pumpAndSettle();
    await tester.tap(find.text("Go back"));
    await tester.pumpAndSettle();
    await tester.tap(find.text("Go to next page"));
    await tester.pumpAndSettle();
    await tester.tap(find.text("Go back"));
    await tester.pumpAndSettle();
    await tester.tap(find.text("Go to next page"));
    await tester.pumpAndSettle();
    await tester.tap(find.text("Go back"));
    await tester.pumpAndSettle();

    final snapshot = await vmServer.takeMemorySnapshot();
    final instanceCount = _getInstancesCountByName(snapshot, "_SecondPageState");
    expect("Number of instances: $instanceCount", "Number of instances: 0", reason: "SecondPage has a memory leak");
  });

  testWidgets('Test third screen memory leak', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());
    await tester.pumpAndSettle();
    await tester.tap(find.text("Go to next page"));
    await tester.pumpAndSettle();
    await tester.tap(find.text("Go to next page"));
    await tester.pumpAndSettle();
    await tester.tap(find.text("Go back"));
    await tester.pumpAndSettle();
    await tester.tap(find.text("Go to next page"));
    await tester.pumpAndSettle();
    await tester.tap(find.text("Go back"));
    await tester.pumpAndSettle();
    await tester.tap(find.text("Go to next page"));
    await tester.pumpAndSettle();
    await tester.tap(find.text("Go back"));
    await tester.pumpAndSettle();
    await tester.tap(find.text("Go to next page"));
    await tester.pumpAndSettle();
    await tester.tap(find.text("Go back"));
    await tester.pumpAndSettle();
    await tester.tap(find.text("Go to next page"));
    await tester.pumpAndSettle();
    await tester.tap(find.text("Go back"));
    await tester.pumpAndSettle();

    final snapshot = await vmServer.takeMemorySnapshot();
    final instanceCount = _getInstancesCountByName(snapshot, "_ThirdPageState");
    expect("Number of instances: $instanceCount", "Number of instances: 0", reason: "ThirdPage has a memory leak");
  });

  tearDown(() {
    vmServer.dispose();
  });
}

int _getInstancesCountByName(List<ClassHeapStats>? snapshot, String name) {
  final member = snapshot?.cast().firstWhere((e) => e.classRef?.name == name, orElse: () => null);
  return member?.instancesCurrent;
}
