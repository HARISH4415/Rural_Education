import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  await Supabase.initialize(
    url: 'https://kbnzsoxdngsnbxfypoko.supabase.co',
    anonKey: 'sb_publishable_iuK2OH3EM-iHis0keHlYwQ_HUdVj7l8',
  );

  final data = {
    'name': 'Test User',
    'school': 'Test School',
    'age': 10,
    'parent_mobile': '1234567890',
    'email': 'test@test.com',
    'password': 'password',
    'standard': 'Class 1',
    'board': 'CBSE',
    'caste': 'N/A',
  };

  try {
    var response =
        await Supabase.instance.client.from('students').upsert(data).select();
    print("Upsert response: $response");
  } catch (e) {
    print("Upsert error: $e");
  }

  try {
    var response2 =
        await Supabase.instance.client.from('students').insert(data).select();
    print("Insert response: $response2");
  } catch (e) {
    print("Insert error: $e");
  }
}
