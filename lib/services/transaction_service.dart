import 'package:supabase_flutter/supabase_flutter.dart';
import 'auth_service.dart';

class TransactionService {
  final SupabaseClient _supabase = Supabase.instance.client;

  // Escucha cambios en tiempo real en la tabla de Transacciones (del usuario activo)
  Stream<List<Map<String, dynamic>>> get myTransactionsStream {
    final user = AuthService().currentUser;
    if (user == null) return const Stream.empty();

    return _supabase.from('transactions')
      .stream(primaryKey: ['id'])
      .eq('user_id', user.id)
      .order('date', ascending: false);
  }

  // Agrega una transacción real
  Future<void> addTransaction({
    required double amount,
    required String type, // 'income' o 'expense'
    required String source, // 'manual', 'voice', 'ocr'
    required String category,
    String description = '',
  }) async {
    final user = AuthService().currentUser;
    if (user == null) throw Exception('No session found');

    await _supabase.from('transactions').insert({
      'user_id': user.id,
      'amount': amount,
      'type': type,
      'source': source,
      'category': category,
      'description': description,
    });
  }

  // Borra una transacción (Haptic y fácil)
  Future<void> deleteTransaction(String id) async {
    await _supabase.from('transactions').delete().eq('id', id);
  }
}
