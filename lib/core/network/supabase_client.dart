import 'package:supabase_flutter/supabase_flutter.dart';

final supabase = Supabase.instance.client;

class SupabaseClientProvider {
  static SupabaseClient get client => supabase;
}
