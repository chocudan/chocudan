import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:drift/drift.dart' show Value;
import '../db/database.dart';
import '../db/id_helper.dart';
import '../providers/app_providers.dart';
import '../services/ai_parse_service.dart';
import '../widgets/cupertino_form_row.dart' show AppFormRow;
import '../widgets/tag_input.dart';
import '../widgets/multi_image_picker.dart';

class AddEditPlaceScreen extends ConsumerStatefulWidget {
  final String type; // "food" | "destination"
  final Place? existingPlace; // null = thêm mới, có giá trị = sửa

  const AddEditPlaceScreen({
    super.key,
    required this.type,
    this.existingPlace,
  });

  @override
  ConsumerState<AddEditPlaceScreen> createState() =>
      _AddEditPlaceScreenState();
}

class _AddEditPlaceScreenState extends ConsumerState<AddEditPlaceScreen> {
  int _segment = 0; // 0 = AI paste, 1 = nhập tay

  final _rawTextController = TextEditingController();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();
  final _openHoursController = TextEditingController();
  final _avgPriceController = TextEditingController();
  final _freeshipNoteController = TextEditingController();
  final _noteController = TextEditingController();

  List<String> _categoryTags = [];
  List<DraftImage> _draftImages = [];
  bool _freeship = false;
  bool _aiLoading = false;
  String? _error;

  final List<_MenuItemDraft> _menuDrafts = [];

  bool get _isEditMode => widget.existingPlace != null;

  @override
  void initState() {
    super.initState();
    if (_isEditMode) {
      _segment = 1; // sửa thì luôn vào form nhập tay trực tiếp
      final p = widget.existingPlace!;
      _nameController.text = p.name;
      _phoneController.text = p.phone ?? '';
      _addressController.text = p.address ?? '';
      _openHoursController.text = p.openHours ?? '';
      _avgPriceController.text = p.avgPriceRange ?? '';
      _categoryTags = (p.category ?? '')
          .split(',')
          .map((t) => t.trim())
          .where((t) => t.isNotEmpty)
          .toList();
      _freeshipNoteController.text = p.freeshipNote ?? '';
      _noteController.text = p.note ?? '';
      _freeship = p.freeship;
      _loadExistingData();
    }
  }

  Future<void> _loadExistingData() async {
    final db = ref.read(databaseProvider);
    final items = await db.getMenuItemsForPlace(widget.existingPlace!.id);
    final images = await db.getImagesForPlace(widget.existingPlace!.id);
    setState(() {
      _menuDrafts.addAll(
        items.map(
          (i) => _MenuItemDraft(
            id: i.id,
            name: i.name,
            price: i.priceText,
            categoryGroup: i.categoryGroup ?? '',
            isBestSeller: i.isBestSeller,
          ),
        ),
      );
      _draftImages = images
          .map((img) => DraftImage(
                localPath: img.localPath,
                isPrimary: img.isPrimary,
              ))
          .toList();
    });
  }

  @override
  void dispose() {
    _rawTextController.dispose();
    _nameController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _openHoursController.dispose();
    _avgPriceController.dispose();
    _freeshipNoteController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  Future<void> _runAiExtract() async {
    final text = _rawTextController.text.trim();
    if (text.isEmpty) {
      setState(() => _error = 'Vui lòng dán nội dung bài post trước');
      return;
    }

    setState(() {
      _aiLoading = true;
      _error = null;
    });

    try {
      final result = await AiParseService.parsePost(text);
      setState(() {
        _nameController.text = result.name ?? '';
        _phoneController.text = result.phone ?? '';
        _addressController.text = result.address ?? '';
        _openHoursController.text = result.openHours ?? '';
        _categoryTags = result.category == null
            ? []
            : result.category!
                .split(',')
                .map((t) => t.trim())
                .where((t) => t.isNotEmpty)
                .toList();
        _freeshipNoteController.text = result.freeshipNote ?? '';
        _freeship = result.freeship;
        _menuDrafts
          ..clear()
          ..addAll(
            result.menuItems.map(
              (m) => _MenuItemDraft(
                id: newId(),
                name: m.name,
                price: m.priceText,
                categoryGroup: m.categoryGroup ?? '',
                isBestSeller: m.isBestSeller,
              ),
            ),
          );
        _segment = 1; // chuyển sang xem/sửa form sau khi parse xong
        _aiLoading = false;
      });
    } catch (e) {
      setState(() {
        _aiLoading = false;
        _error = 'Không thể trích xuất. Vui lòng thử lại hoặc nhập tay.';
      });
    }
  }

  void _addMenuDraft() {
    setState(() {
      _menuDrafts.add(_MenuItemDraft(id: newId(), name: '', price: ''));
    });
  }

  void _removeMenuDraft(String id) {
    setState(() {
      _menuDrafts.removeWhere((d) => d.id == id);
    });
  }

  Future<void> _save() async {
    final name = _nameController.text.trim();
    if (name.isEmpty) {
      setState(() => _error = 'Vui lòng nhập tên quán');
      return;
    }

    final db = ref.read(databaseProvider);
    final user = ref.read(currentUserProvider);

    final placeId = widget.existingPlace?.id ?? newId();

    final companion = PlacesCompanion.insert(
      id: placeId,
      type: Value(widget.type),
      name: name,
      phone: Value(_phoneController.text.trim().isEmpty
          ? null
          : _phoneController.text.trim()),
      address: Value(_addressController.text.trim().isEmpty
          ? null
          : _addressController.text.trim()),
      rawText: Value(_rawTextController.text.trim()),
      freeship: Value(_freeship),
      freeshipNote: Value(_freeshipNoteController.text.trim().isEmpty
          ? null
          : _freeshipNoteController.text.trim()),
      openHours: Value(_openHoursController.text.trim().isEmpty
          ? null
          : _openHoursController.text.trim()),
      category: Value(_categoryTags.isEmpty ? null : _categoryTags.join(',')),
      avgPriceRange: Value(_avgPriceController.text.trim().isEmpty
          ? null
          : _avgPriceController.text.trim()),
      note: Value(_noteController.text.trim().isEmpty
          ? null
          : _noteController.text.trim()),
      createdBy: Value(user?.id),
    );

    if (_isEditMode) {
      await db.updatePlace(companion.copyWith(
        updatedAt: Value(DateTime.now()),
      ));
      await db.deleteMenuItemsForPlace(placeId);
    } else {
      await db.insertPlace(companion);
    }

    for (final draft in _menuDrafts) {
      if (draft.name.trim().isEmpty) continue;
      await db.insertMenuItem(
        MenuItemsCompanion.insert(
          id: draft.id,
          placeId: placeId,
          name: draft.name.trim(),
          priceText: draft.price.trim(),
          categoryGroup: Value(
            draft.categoryGroup.trim().isEmpty ? null : draft.categoryGroup,
          ),
          isBestSeller: Value(draft.isBestSeller),
        ),
      );
    }

    // Đồng bộ ảnh: xoá hết ảnh cũ trong DB rồi ghi lại theo draft hiện tại
    // (đơn giản hơn so với diff từng ảnh, chấp nhận được vì số ảnh/quán
    // thường không quá nhiều).
    if (_isEditMode) {
      final oldImages = await db.getImagesForPlace(placeId);
      for (final img in oldImages) {
        await db.deletePlaceImage(img.id);
      }
    }
    for (final draft in _draftImages) {
      await db.insertPlaceImage(
        PlaceImagesCompanion.insert(
          id: newId(),
          placeId: placeId,
          localPath: draft.localPath,
          isPrimary: Value(draft.isPrimary),
        ),
      );
    }

    if (!mounted) return;
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        leading: CupertinoButton(
          padding: EdgeInsets.zero,
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Huỷ'),
        ),
        middle: Text(_isEditMode ? 'Sửa quán' : 'Thêm quán'),
        trailing: CupertinoButton(
          padding: EdgeInsets.zero,
          onPressed: _save,
          child: const Text(
            'Lưu',
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
        ),
      ),
      child: SafeArea(
        child: Column(
          children: [
            if (!_isEditMode)
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 10, 16, 4),
                child: CupertinoSlidingSegmentedControl<int>(
                  groupValue: _segment,
                  children: const {
                    0: Padding(
                      padding: EdgeInsets.symmetric(vertical: 6),
                      child:
                          Text('✨ Dán từ FB', style: TextStyle(fontSize: 13)),
                    ),
                    1: Padding(
                      padding: EdgeInsets.symmetric(vertical: 6),
                      child:
                          Text('⌨ Nhập tay', style: TextStyle(fontSize: 13)),
                    ),
                  },
                  onValueChanged: (v) {
                    if (v != null) setState(() => _segment = v);
                  },
                ),
              ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                children: [
                  if (_segment == 0) ...[
                    Container(
                      decoration: BoxDecoration(
                        color: CupertinoColors.white,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: const EdgeInsets.all(10),
                      child: CupertinoTextField(
                        controller: _rawTextController,
                        placeholder:
                            'Dán nội dung bài post Facebook vào đây...',
                        maxLines: 6,
                        decoration: const BoxDecoration(),
                        padding: EdgeInsets.zero,
                      ),
                    ),
                    const SizedBox(height: 10),
                    CupertinoButton(
                      color: CupertinoColors.systemIndigo,
                      onPressed: _aiLoading ? null : _runAiExtract,
                      child: _aiLoading
                          ? const CupertinoActivityIndicator(
                              color: CupertinoColors.white,
                            )
                          : const Text('✨ Trích xuất thông tin bằng AI'),
                    ),
                  ],
                  if (_error != null) ...[
                    const SizedBox(height: 8),
                    Text(
                      _error!,
                      style: const TextStyle(
                        color: CupertinoColors.destructiveRed,
                        fontSize: 13,
                      ),
                    ),
                  ],
                  if (_segment == 1 || _nameController.text.isNotEmpty) ...[
                    const SizedBox(height: 14),
                    const _SectionHeader('Hình ảnh'),
                    Container(
                      decoration: BoxDecoration(
                        color: CupertinoColors.white,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: const EdgeInsets.all(8),
                      child: MultiImagePicker(
                        initialImages: _draftImages,
                        onChanged: (imgs) => _draftImages = imgs,
                      ),
                    ),
                    const SizedBox(height: 14),
                    const _SectionHeader('Thông tin quán'),
                    CupertinoListSection.insetGrouped(
                      margin: EdgeInsets.zero,
                      children: [
                        AppFormRow(
                          label: 'Tên',
                          controller: _nameController,
                          placeholder: 'Tên quán',
                        ),
                        AppFormRow(
                          label: 'SĐT',
                          controller: _phoneController,
                          placeholder: 'Số điện thoại',
                          keyboardType: TextInputType.phone,
                        ),
                        AppFormRow(
                          label: 'Địa chỉ',
                          controller: _addressController,
                          placeholder: 'Nhập địa chỉ...',
                        ),
                        AppFormRow(
                          label: 'Giờ mở',
                          controller: _openHoursController,
                          placeholder: 'Vd: 8:00 - 22:00',
                        ),
                        AppFormRow(
                          label: 'Giá trung bình',
                          controller: _avgPriceController,
                          placeholder: 'Vd: 20k - 50k',
                        ),
                        AppFormRow(
                          label: 'Freeship',
                          trailing: CupertinoSwitch(
                            value: _freeship,
                            onChanged: (v) => setState(() => _freeship = v),
                          ),
                        ),
                        if (_freeship)
                          AppFormRow(
                            label: 'Ghi chú freeship',
                            controller: _freeshipNoteController,
                            placeholder: 'Vd: Đơn từ 50k',
                          ),
                        AppFormRow(
                          label: 'Ghi chú',
                          controller: _noteController,
                          placeholder: 'Tuỳ chọn',
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    const _SectionHeader('Danh mục'),
                    Container(
                      decoration: BoxDecoration(
                        color: CupertinoColors.white,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: const EdgeInsets.all(10),
                      child: TagInput(
                        initialTags: _categoryTags,
                        onChanged: (tags) => _categoryTags = tags,
                        placeholder: 'Vd: Ăn uống, Bánh, Đồ uống...',
                      ),
                    ),
                    const SizedBox(height: 14),
                    const _SectionHeader('Món ăn'),
                    Container(
                      decoration: BoxDecoration(
                        color: CupertinoColors.white,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                        children: [
                          ..._menuDrafts.map(
                            (draft) => _MenuDraftRow(
                              draft: draft,
                              onRemove: () => _removeMenuDraft(draft.id),
                              onChanged: () => setState(() {}),
                            ),
                          ),
                          CupertinoButton(
                            onPressed: _addMenuDraft,
                            child: const Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Icon(
                                  CupertinoIcons.add_circled_solid,
                                  color: CupertinoColors.activeGreen,
                                  size: 20,
                                ),
                                SizedBox(width: 8),
                                Text('Thêm món'),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  const _SectionHeader(this.title);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6, left: 4),
      child: Text(
        title.toUpperCase(),
        style: const TextStyle(
          fontSize: 12,
          color: CupertinoColors.secondaryLabel,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}

class _MenuItemDraft {
  String id;
  String name;
  String price;
  String categoryGroup;
  bool isBestSeller;

  _MenuItemDraft({
    required this.id,
    required this.name,
    required this.price,
    this.categoryGroup = '',
    this.isBestSeller = false,
  });
}

class _MenuDraftRow extends StatefulWidget {
  final _MenuItemDraft draft;
  final VoidCallback onRemove;
  final VoidCallback onChanged;

  const _MenuDraftRow({
    required this.draft,
    required this.onRemove,
    required this.onChanged,
  });

  @override
  State<_MenuDraftRow> createState() => _MenuDraftRowState();
}

class _MenuDraftRowState extends State<_MenuDraftRow> {
  late TextEditingController _nameCtrl;
  late TextEditingController _priceCtrl;

  @override
  void initState() {
    super.initState();
    _nameCtrl = TextEditingController(text: widget.draft.name);
    _priceCtrl = TextEditingController(text: widget.draft.price);
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _priceCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(color: CupertinoColors.systemGrey5, width: 0.5),
        ),
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: widget.onRemove,
            child: const Icon(
              CupertinoIcons.minus_circle_fill,
              color: CupertinoColors.destructiveRed,
              size: 20,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            flex: 3,
            child: CupertinoTextField(
              controller: _nameCtrl,
              placeholder: 'Tên món',
              padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
              decoration: const BoxDecoration(),
              style: const TextStyle(fontSize: 14),
              onChanged: (v) {
                widget.draft.name = v;
                widget.onChanged();
              },
            ),
          ),
          Expanded(
            flex: 2,
            child: CupertinoTextField(
              controller: _priceCtrl,
              placeholder: 'Giá',
              padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
              decoration: const BoxDecoration(),
              style: const TextStyle(fontSize: 14),
              textAlign: TextAlign.right,
              onChanged: (v) {
                widget.draft.price = v;
                widget.onChanged();
              },
            ),
          ),
        ],
      ),
    );
  }
}
