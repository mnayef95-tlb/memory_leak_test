import 'dart:developer';

import 'package:vm_service/utils.dart';
import 'package:vm_service/vm_service.dart';
import 'package:vm_service/vm_service_io.dart';

class VmServer {
  VmService? _vmService;
  VM? _vm;

  Future<Uri?> getObservatoryUri() async {
    ServiceProtocolInfo serviceProtocolInfo = await Service.getInfo();
    return serviceProtocolInfo.serverWebSocketUri;
  }

  Future<VmService> getVmService() async {
    if (_vmService == null) {
      final uri = await getObservatoryUri();
      if (uri != null) {
        Uri url = convertToWebSocketUrl(serviceProtocolUrl: uri);
        _vmService = await vmServiceConnectUri(url.toString());
      } else {
        throw Exception('observatoryUri is null');
      }
    }
    return _vmService!;
  }

  Future<VM?> getVM() async {
    _vm ??= await (await getVmService()).getVM();
    return _vm;
  }

  Future<Isolate?> findMainIsolate() async {
    IsolateRef? ref;
    final vm = await getVM();
    if (vm == null) return null;
    vm.isolates?.forEach((isolate) {
      if (isolate.name == 'main') {
        ref = isolate;
      }
    });
    final vms = await getVmService();
    if (ref?.id != null) {
      return vms.getIsolate(ref!.id!);
    }
    return null;
  }

  Future<String?> invokeMethod(String targetId, String method, List<String> argumentIds) async {
    final vms = await getVmService();
    final mainIsolate = await findMainIsolate();
    if (mainIsolate != null && mainIsolate.id != null) {
      Response valueResponse = await vms.invoke(mainIsolate.id!, targetId, method, argumentIds);
      final valueRef = InstanceRef.parse(valueResponse.json);
      return valueRef?.valueAsString;
    }
    return null;
  }

  Future startGCAsync() async {
    final vms = await getVmService();
    final isolate = await findMainIsolate();
    if (isolate != null && isolate.id != null) {
      await vms.getAllocationProfile(isolate.id!, gc: true);
    }
  }

  Future<List<ClassHeapStats>?> takeMemorySnapshot() async {
    await startGCAsync();
    final isolate = await findMainIsolate();
    final service = await getVmService();
    final allocationProfile = await service.getAllocationProfile(isolate!.id!, gc: true);

    final members = allocationProfile.members;
    return members;
  }

  void dispose() {
    _vmService?.dispose();
    _vmService = null;
    _vm = null;
  }
}
