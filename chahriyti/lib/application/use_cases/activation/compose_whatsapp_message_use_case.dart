class ComposeWhatsAppMessageUseCase {
  const ComposeWhatsAppMessageUseCase();

  String call({
    required String name,
    required String phone,
    required String wilayaName,
    required String deviceId,
  }) {
    const adminPhone = '213675474946';
    final message = '''مرحباً، أريد تفعيل تطبيق شهريتي

الاسم: $name
رقم الهاتف: $phone
الولاية: $wilayaName
رقم الجهاز: $deviceId''';

    final encoded = Uri.encodeComponent(message);
    return 'https://wa.me/$adminPhone?text=$encoded';
  }
}
