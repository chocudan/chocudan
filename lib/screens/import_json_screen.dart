import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:file_picker/file_picker.dart';
import '../providers/app_providers.dart';
import '../services/json_import_service.dart';

class ImportJsonScreen extends ConsumerStatefulWidget {
  const ImportJsonScreen({super.key});

  @override
  ConsumerState<ImportJsonScreen> createState() => _ImportJsonScreenState();
}

class _ImportJsonScreenState extends ConsumerState<ImportJsonScreen> {
  bool _importing = false;
  ImportResult? _result;
  String? _error;
  String? _pickedFileName;

  Future<void> _pickAndImport() async {
    setState(() {
      _error = null;
      _result = null;
    });

    final picked = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['json'],
      withData: true,
    );
    if (picked == null || picked.files.isEmpty) return;

    final file = picked.files.first;
    final bytes = file.bytes;
    if (bytes == null) {
      setState(() => _error = 'Không đọc được nội dung file');
      return;
    }

    setState(() {
      _importing = true;
      _pickedFileName = file.name;
    });

    try {
      final jsonString = utf8.decode(bytes);
      final db = ref.read(databaseProvider);
      final user = ref.read(currentUserProvider);
      final result = await JsonImportService.importFromJson(
        jsonString,
        db,
        user?.id,
      );
      if (!mounted) return;
      setState(() {
        _result = result;
        _importing = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _error = '$e';
        _importing = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        previousPageTitle: 'Cài đặt',
        middle: Text('Import dữ liệu'),
      ),
      child: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: CupertinoColors.systemBlue.withOpacity(0.08),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Cách dùng',
                    style:
                        TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                  ),
                  SizedBox(height: 6),
                  Text(
                    '1. Chuẩn bị file JSON theo đúng format mẫu (xem '
                    'assets/sample_import.json trong project).\n'
                    '2. Mỗi quán có thể kèm "id" — nếu id đã tồn tại '
                    'trong app, dữ liệu cũ sẽ bị ĐÈ. Nếu để trống/null, '
                    'app tự tạo quán mới.\n'
                    '3. Menu items đi kèm mỗi quán sẽ được ghi đè hoàn '
                    'toàn theo file JSON.',
                    style: TextStyle(fontSize: 12, height: 1.5),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            CupertinoButton.filled(
              onPressed: _importing ? null : _pickAndImport,
              child: _importing
                  ? const CupertinoActivityIndicator(
                      color: CupertinoColors.white,
                    )
                  : const Text('Chọn file JSON để import'),
            ),
            if (_pickedFileName != null) ...[
              const SizedBox(height: 8),
              Text(
                'File: $_pickedFileName',
                style: const TextStyle(
                  fontSize: 12,
                  color: CupertinoColors.secondaryLabel,
                ),
                textAlign: TextAlign.center,
              ),
            ],
            if (_error != null) ...[
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: CupertinoColors.destructiveRed.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  _error!,
                  style: const TextStyle(
                    fontSize: 13,
                    color: CupertinoColors.destructiveRed,
                  ),
                ),
              ),
            ],
            if (_result != null) ...[
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: CupertinoColors.systemGreen.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      children: [
                        Icon(
                          CupertinoIcons.checkmark_circle_fill,
                          color: CupertinoColors.activeGreen,
                          size: 18,
                        ),
                        SizedBox(width: 6),
                        Text(
                          'Import hoàn tất',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text('✅ Thêm mới: ${_result!.inserted} quán'),
                    Text('🔁 Cập nhật: ${_result!.updated} quán'),
                    if (_result!.failed > 0)
                      Text(
                        '⚠️ Lỗi: ${_result!.failed} quán',
                        style: const TextStyle(
                          color: CupertinoColors.destructiveRed,
                        ),
                      ),
                    if (_result!.errors.isNotEmpty) ...[
                      const SizedBox(height: 8),
                      ..._result!.errors.map(
                        (e) => Text(
                          '• $e',
                          style: const TextStyle(
                            fontSize: 11,
                            color: CupertinoColors.secondaryLabel,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
