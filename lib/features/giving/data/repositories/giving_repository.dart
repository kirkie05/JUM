import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import '../../../../core/services/supabase_service.dart';
import '../models/giving_model.dart';

class GivingRepository {
  final SupabaseClient _supabase;
  GivingRepository(this._supabase);

  Future<void> recordTransaction(GivingTransaction tx) async {
    await _supabase.from('donations').insert({
      'id': tx.id,
      'user_id': tx.userId,
      'amount': tx.amount,
      'currency': tx.currency,
      'category': tx.category,
      'gateway': tx.gateway,
      'reference': tx.reference,
      'status': tx.status,
      'receipt_url': tx.receiptUrl,
      'created_at': tx.createdAt.toIso8601String(),
    });
  }

  Future<List<GivingTransaction>> fetchHistory(String userId) async {
    final response = await _supabase
        .from('donations')
        .select()
        .eq('user_id', userId)
        .order('created_at', ascending: false);
    return (response as List).map((row) => GivingTransaction.fromJson(row)).toList();
  }

  Future<String> generateReceiptUrl(GivingTransaction tx) async {
    final pdf = pw.Document();
    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return pw.Container(
            padding: const pw.EdgeInsets.all(30),
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Center(
                  child: pw.Text(
                    'JESUS UNHINDERED MINISTRY',
                    style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold),
                  ),
                ),
                pw.Center(
                  child: pw.Text(
                    'Official Giving Receipt',
                    style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold),
                  ),
                ),
                pw.SizedBox(height: 40),
                pw.Divider(),
                pw.SizedBox(height: 20),
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Text('Receipt ID: ${tx.id}'),
                    pw.Text('Date: ${tx.createdAt.toLocal().toString().split('.')[0]}'),
                  ],
                ),
                pw.SizedBox(height: 10),
                pw.Text('User ID: ${tx.userId}'),
                pw.Text('Gateway: ${tx.gateway.toUpperCase()}'),
                pw.Text('Reference: ${tx.reference}'),
                pw.SizedBox(height: 30),
                pw.Table(
                  border: pw.TableBorder.all(color: PdfColors.grey),
                  children: [
                    pw.TableRow(
                      children: [
                        pw.Padding(
                          padding: const pw.EdgeInsets.all(8),
                          child: pw.Text('Category', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                        ),
                        pw.Padding(
                          padding: const pw.EdgeInsets.all(8),
                          child: pw.Text('Amount', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                        ),
                      ],
                    ),
                    pw.TableRow(
                      children: [
                        pw.Padding(
                          padding: const pw.EdgeInsets.all(8),
                          child: pw.Text(tx.category.toUpperCase()),
                        ),
                        pw.Padding(
                          padding: const pw.EdgeInsets.all(8),
                          child: pw.Text('${tx.currency} ${tx.amount.toStringAsFixed(2)}'),
                        ),
                      ],
                    ),
                  ],
                ),
                pw.SizedBox(height: 40),
                pw.Divider(),
                pw.SizedBox(height: 20),
                pw.Center(
                  child: pw.Text(
                    'Thank you for your faithful giving!',
                    style: pw.TextStyle(fontStyle: pw.FontStyle.italic, fontSize: 14),
                  ),
                ),
                pw.Center(
                  child: pw.Text(
                    'God bless you richly.',
                    style: pw.TextStyle(fontStyle: pw.FontStyle.italic, fontSize: 14),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );

    final pdfBytes = await pdf.save();
    final fileName = '${tx.userId}/${tx.id}.pdf';

    await _supabase.storage.from('documents').uploadBinary(fileName, pdfBytes);
    final publicUrl = _supabase.storage.from('documents').getPublicUrl(fileName);
    return publicUrl;
  }
}

final givingRepositoryProvider = Provider<GivingRepository>((ref) =>
    GivingRepository(ref.watch(supabaseClientProvider)));
