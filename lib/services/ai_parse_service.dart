import 'dart:convert';
import 'package:http/http.dart' as http;

/// Kết quả parse 1 món ăn từ post
class ParsedMenuItem {
  final String name;
  final String priceText;
  final String? categoryGroup;
  final bool isBestSeller;

  ParsedMenuItem({
    required this.name,
    required this.priceText,
    this.categoryGroup,
    this.isBestSeller = false,
  });

  factory ParsedMenuItem.fromJson(Map<String, dynamic> json) {
    return ParsedMenuItem(
      name: json['name'] ?? '',
      priceText: json['priceText'] ?? '',
      categoryGroup: json['categoryGroup'],
      isBestSeller: json['isBestSeller'] ?? false,
    );
  }
}

/// Kết quả parse toàn bộ post
class ParsedPlace {
  final String? name;
  final String? phone;
  final String? address;
  final bool freeship;
  final String? freeshipNote;
  final String? openHours;
  final String? category;
  final List<ParsedMenuItem> menuItems;

  ParsedPlace({
    this.name,
    this.phone,
    this.address,
    this.freeship = false,
    this.freeshipNote,
    this.openHours,
    this.category,
    this.menuItems = const [],
  });

  factory ParsedPlace.fromJson(Map<String, dynamic> json) {
    return ParsedPlace(
      name: json['name'],
      phone: json['phone'],
      address: json['address'],
      freeship: json['freeship'] ?? false,
      freeshipNote: json['freeshipNote'],
      openHours: json['openHours'],
      category: json['category'],
      menuItems: (json['menuItems'] as List<dynamic>? ?? [])
          .map((e) => ParsedMenuItem.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}

/// Service gọi Claude API để trích xuất thông tin quán từ text bài post
/// Facebook (Chợ Cư Dân Vinhomes Q9 và tương tự).
///
/// LƯU Ý QUAN TRỌNG: cần điền API key của bạn vào [_apiKey] bên dưới,
/// hoặc đọc từ biến môi trường / file config riêng (khuyến nghị hơn,
/// không nên hardcode key trong source code khi đẩy lên Git).
class AiParseService {
  static const _apiKey = String.fromEnvironment(
    'ANTHROPIC_API_KEY',
    defaultValue: '',
  );
  static const _endpoint = 'https://api.anthropic.com/v1/messages';
  static const _model = 'claude-sonnet-4-6';

  static const _systemPrompt = '''
Bạn là công cụ trích xuất dữ liệu có cấu trúc từ bài đăng bán hàng trên
Facebook (nhóm "Chợ Cư Dân Vinhomes" hoặc tương tự — bán đồ ăn, thức uống,
trái cây...).

Trả lời CHỈ bằng JSON hợp lệ, không có markdown, không có lời giải thích,
không có ```json. Đúng theo schema sau:

{
  "name": string | null,            // tên người bán / shop (ưu tiên tên shop nếu có)
  "phone": string | null,           // số điện thoại liên hệ chính (chỉ chữ số)
  "address": string | null,         // địa chỉ nếu có, null nếu chỉ bán ship không có địa chỉ cố định
  "freeship": boolean,              // true nếu post có đề cập freeship
  "freeshipNote": string | null,    // mô tả điều kiện freeship nguyên văn, vd "đơn từ 50k, dưới phụ thu 5k"
  "openHours": string | null,       // giờ mở cửa nếu có, vd "8:30 - 22:30"
  "category": string | null,        // 1 hoặc nhiều danh mục, cách nhau bởi dấu phẩy, vd "Ăn uống,Đồ uống" hoặc "Bánh". Không thêm khoảng trắng thừa quanh dấu phẩy.
  "menuItems": [
    {
      "name": string,               // tên món
      "priceText": string,          // giữ NGUYÊN văn cách viết giá gốc, vd "45k/10 cái", "12k-15k"
      "categoryGroup": string | null, // nhóm món nếu post có chia, vd "Đồ uống", "Ăn no"
      "isBestSeller": boolean        // true nếu post có nhấn mạnh đây là best seller/món chính
    }
  ]
}

QUY TẮC QUAN TRỌNG:
- Không suy đoán quá đà — nếu thông tin không có trong post, để null.
- Giữ nguyên cách viết giá gốc trong priceText, không tự quy đổi/chuẩn hoá.
- Nếu 1 dòng có nhiều biến thể giá (vd "Cà phê 12k-15k") thì giữ nguyên 1 món,
  không tách thành nhiều món trừ khi post liệt kê rõ ràng từng món riêng.
- Số điện thoại: loại bỏ ký tự đặc biệt/font lạ, chỉ giữ lại chữ số.
- Nếu post không phải bài bán hàng (không có món/giá nào), trả về
  tất cả field null và menuItems là mảng rỗng.
''';

  static Future<ParsedPlace> parsePost(String rawText) async {
    if (_apiKey.isEmpty) {
      throw Exception(
        'Chưa cấu hình ANTHROPIC_API_KEY. Chạy app với '
        '--dart-define=ANTHROPIC_API_KEY=your_key_here',
      );
    }

    final response = await http.post(
      Uri.parse(_endpoint),
      headers: {
        'Content-Type': 'application/json',
        'x-api-key': _apiKey,
        'anthropic-version': '2023-06-01',
      },
      body: jsonEncode({
        'model': _model,
        'max_tokens': 1500,
        'system': _systemPrompt,
        'messages': [
          {'role': 'user', 'content': rawText},
        ],
      }),
    );

    if (response.statusCode != 200) {
      throw Exception(
        'AI parse thất bại (${response.statusCode}): ${response.body}',
      );
    }

    final data = jsonDecode(utf8.decode(response.bodyBytes));
    final content = data['content'] as List<dynamic>;
    final textBlock = content.firstWhere(
      (block) => block['type'] == 'text',
      orElse: () => null,
    );

    if (textBlock == null) {
      throw Exception('Không nhận được phản hồi text từ AI');
    }

    String jsonText = (textBlock['text'] as String).trim();
    // Phòng trường hợp model vẫn bọc markdown dù đã dặn không làm vậy
    jsonText = jsonText
        .replaceAll(RegExp(r'^```json\s*'), '')
        .replaceAll(RegExp(r'^```\s*'), '')
        .replaceAll(RegExp(r'```\s*$'), '')
        .trim();

    final parsed = jsonDecode(jsonText) as Map<String, dynamic>;
    return ParsedPlace.fromJson(parsed);
  }
}
