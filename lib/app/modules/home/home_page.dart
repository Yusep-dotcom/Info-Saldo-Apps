import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:info_saldo_apps/app/data/local/database.dart';
import 'package:info_saldo_apps/app/data/models/transaction_with_category.dart';
import 'package:info_saldo_apps/app/modules/transaction/view/transaction_page.dart';

class HomePage extends StatefulWidget {
  final DateTime selectedDate;
  const HomePage({super.key, required this.selectedDate});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final AppDb database = Get.find<AppDb>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// ======================
              /// SUMMARY
              /// ======================
              Padding(
                padding: const EdgeInsets.all(16),
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 81, 81, 81),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: _summaryItem(
                          icon: Icons.download,
                          iconColor: Colors.blue,
                          title: 'Income',
                          value: 'Rp 0',
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: _summaryItem(
                          icon: Icons.upload,
                          iconColor: Colors.red,
                          title: 'Expense',
                          value: 'Rp 0',
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  'Transaksi',
                  style: GoogleFonts.montserrat(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              const SizedBox(height: 8),

              /// ======================
              /// LIST TRANSAKSI
              /// ======================
              StreamBuilder<List<TransactionWithCategory>>(
                stream: database.getTransactionByDateRepo(widget.selectedDate),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(
                      child: Padding(
                        padding: EdgeInsets.all(20),
                        child: Text('Data masih kosong'),
                      ),
                    );
                  }

                  final data = snapshot.data!;

                  return ListView.builder(
                    itemCount: data.length,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      final item = data[index];

                      return Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 6,
                        ),
                        child: Card(
                          elevation: 4,
                          child: ListTile(
                            leading: Icon(
                              item.category.type == 1
                                  ? Icons.arrow_upward
                                  : Icons.arrow_downward,
                              color: item.category.type == 1
                                  ? Colors.red
                                  : Colors.blue,
                            ),
                            title: Text(
                              'Rp ${item.transaction.amount}',
                              style: GoogleFonts.montserrat(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            subtitle: Text(
                              '${item.category.name} • ${item.transaction.title}',
                              style: GoogleFonts.montserrat(fontSize: 12),
                            ),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                /// DELETE
                                IconButton(
                                  icon: const Icon(
                                    Icons.delete,
                                    color: Colors.red,
                                  ),
                                  onPressed: () async {
                                    await database.deleteTransaction(
                                      item.transaction.id,
                                    );
                                  },
                                ),

                                /// EDIT
                                IconButton(
                                  icon: const Icon(Icons.edit),
                                  onPressed: () {
                                    Get.to(() => TransactionPage(transactionWithCategory:snapshot.data![index]));
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// ======================
  /// SUMMARY ITEM
  /// ======================
  Widget _summaryItem({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String value,
  }) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: iconColor, size: 20),
        ),
        const SizedBox(width: 8),
        Flexible(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: GoogleFonts.montserrat(
                  color: Colors.white,
                  fontSize: 12,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: GoogleFonts.montserrat(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                ),
              ),
            ],    
          ),
        ),
      ],
    );
  }
}
