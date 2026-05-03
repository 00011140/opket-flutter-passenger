import 'package:flutter/material.dart';
import 'package:opket/core/widgets/app_container.dart';

const terms = '''
Foydalanuvchi Shartlari (Terms and Conditions)

Diqqat: Ushbu hujjat sizning taxi va ovqat yetkazib berish ilovangiz uchun mo‘ljallangan.

1. Umumiy ma’lumot

Ushbu ilova (“Ilova”) orqali siz transport xizmatlari va ovqat yetkazib berish xizmatlaridan foydalanishingiz mumkin. Ilovadan foydalanish orqali siz ushbu Foydalanuvchi Shartlariga rozilik bildirgan hisoblanasiz.

2. Hisob yaratish

Ilovadan foydalanish uchun siz hisob yaratishingiz kerak bo‘ladi.

Sizning hisob ma’lumotlaringiz to‘g‘ri va yangilangan bo‘lishi kerak.

Hisobingizni boshqa shaxs bilan baham ko‘rish taqiqlanadi.

3. Xizmatlar

Ilova orqali transport buyurtmalari va ovqat yetkazib berish buyurtmalarini amalga oshirishingiz mumkin.

Xizmatlar hududingizdagi mavjud transport va restoranlar bilan cheklangan bo‘lishi mumkin.

4. To‘lovlar

Ilovada to‘lovlar real yoki test usullar orqali amalga oshiriladi.

Transport va ovqat yetkazib berish xizmatlari uchun to‘lovlar aniq belgilangan narxlarga muvofiq amalga oshiriladi.

Apple Pay yoki boshqa ilova ichidagi to‘lov tizimlari orqali amalga oshiriladigan xizmatlar faqat haqiqiy mahsulot va xizmatlarga tegishli bo‘lishi kerak.

5. Foydalanuvchi majburiyatlari

Ilovadan qonuniy maqsadlarda foydalaning.

Noqonuniy yoki zararli harakatlar taqiqlanadi.

Ilovaga zarar yetkazadigan xatti-harakatlar qilinmasligi kerak.

6. Maxfiylik va ma’lumotlar

Ilova sizning joylashuvingizni, telefon raqamingizni va boshqa shaxsiy ma’lumotlarni yig‘ishi mumkin.

Ushbu ma’lumotlar faqat xizmat ko‘rsatish va mijozlarni qo‘llab-quvvatlash uchun ishlatiladi.

Batafsil ma’lumot uchun Maxfiylik Siyosatini o‘qing.

7. Mas’uliyat cheklovi

Ilova xizmatlari vaqtincha ishlamasligi yoki kechikishi mumkin.

Ilova egasi transport yoki ovqat yetkazib berish jarayonidagi kechikish, zarar yoki yo‘qotishlar uchun javobgar emas.

8. Shartlarni o‘zgartirish

Biz ushbu shartlarni istalgan vaqtda yangilash huquqini saqlab qolamiz.

Yangilangan shartlar ilovada e’lon qilinadi va foydalanuvchi undan xabardor bo‘lishi majburiy.

9. Aloqa

Savol yoki muammolar bo‘lsa, ilovaning Aloqa / Support bo‘limiga murojaat qiling.
 ''';

class TermsAndConditions extends StatelessWidget {
  const TermsAndConditions({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.white),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(child: AppContainer(child: Text(terms))),
      ),
    );
  }
}
