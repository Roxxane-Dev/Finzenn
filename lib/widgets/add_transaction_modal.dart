import 'package:flutter/material.dart';
import '../../theme/finzenn_theme.dart';
import '../../services/transaction_service.dart';

class AddTransactionModal extends StatefulWidget {
  const AddTransactionModal({super.key});

  @override
  State<AddTransactionModal> createState() => _AddTransactionModalState();
}

class _AddTransactionModalState extends State<AddTransactionModal> {
  final _amountController = TextEditingController();
  final _descController = TextEditingController();
  
  bool _isExpense = true;
  String _selectedCategory = 'Comida';
  bool _isSaving = false;

  final List<String> _expenseCategories = ['Comida', 'Transporte', 'Suscripciones', 'Ocio', 'Salud'];
  final List<String> _incomeCategories = ['Salario', 'Inversiones', 'Regalo', 'Otros Ingresos'];

  @override
  void dispose() {
    _amountController.dispose();
    _descController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final amountText = _amountController.text.trim();
    if (amountText.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Ingresa el monto.'), backgroundColor: FinzennTheme.error));
      return;
    }
    final amount = double.tryParse(amountText);
    if (amount == null || amount <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Monto no válido.'), backgroundColor: FinzennTheme.error));
      return;
    }

    setState(() => _isSaving = true);

    try {
      await TransactionService().addTransaction(
        amount: amount,
        type: _isExpense ? 'expense' : 'income',
        source: 'manual', // En el futuro será 'voice' o 'ocr' también
        category: _selectedCategory,
        description: _descController.text.trim(),
      );
      if (mounted) {
        Navigator.pop(context); // Cierra el modal, el StreamBuilder del Dashboard detectará la BD
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(_isExpense ? '¡Gasto registrado (- \$${amount.toStringAsFixed(2)})!' : '¡Ingreso guardado (+ \$${amount.toStringAsFixed(2)})!'),
            backgroundColor: _isExpense ? FinzennTheme.error : FinzennTheme.success,
            behavior: SnackBarBehavior.floating,
          )
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error guardando: $e'), backgroundColor: FinzennTheme.error));
        setState(() => _isSaving = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentCats = _isExpense ? _expenseCategories : _incomeCategories;
    if (!currentCats.contains(_selectedCategory)) {
      _selectedCategory = currentCats.first;
    }

    return Container(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      decoration: const BoxDecoration(
        color: FinzennTheme.bgColor,
        borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min, // El Modal ocupa sólo lo necesario
            children: [
              // Pill top
              Container(width: 40, height: 4, decoration: BoxDecoration(color: FinzennTheme.textMuted.withOpacity(0.5), borderRadius: BorderRadius.circular(4))),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Nuevo Registro', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: FinzennTheme.textDark)),
                  GestureDetector(onTap: () => Navigator.pop(context), child: Container(padding: const EdgeInsets.all(8), decoration: BoxDecoration(color: FinzennTheme.softPurple.withOpacity(0.3), shape: BoxShape.circle), child: const Icon(Icons.close, color: FinzennTheme.primaryBlue, size: 20))),
                ],
              ),
              const SizedBox(height: 24),
              // Segmented (Gasto vs Ingreso)
              Container(
                height: 40,
                decoration: BoxDecoration(color: FinzennTheme.white, borderRadius: BorderRadius.circular(20), border: Border.all(color: Colors.white, width: 2), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 10)]),
                child: Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () => setState(() => _isExpense = true),
                        child: Container(
                          decoration: BoxDecoration(color: _isExpense ? const Color(0xFFFFECEC) : Colors.transparent, borderRadius: BorderRadius.circular(20)),
                          alignment: Alignment.center,
                          child: Text('Gasto (-)', style: TextStyle(color: _isExpense ? FinzennTheme.error : FinzennTheme.textSecondary, fontWeight: FontWeight.w800, fontSize: 13)),
                        ),
                      ),
                    ),
                    Expanded(
                      child: GestureDetector(
                        onTap: () => setState(() => _isExpense = false),
                        child: Container(
                          decoration: BoxDecoration(color: !_isExpense ? const Color(0xFFE8FFF5) : Colors.transparent, borderRadius: BorderRadius.circular(20)),
                          alignment: Alignment.center,
                          child: Text('Ingreso (+)', style: TextStyle(color: !_isExpense ? FinzennTheme.success : FinzennTheme.textSecondary, fontWeight: FontWeight.w800, fontSize: 13)),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Rueda de Dinero (Amount)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(padding: const EdgeInsets.only(top: 8, right: 4), child: Text('\$', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w900, color: _isExpense ? FinzennTheme.error : FinzennTheme.success))),
                  IntrinsicWidth(
                    child: TextField(
                      controller: _amountController,
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      autofocus: true,
                      style: const TextStyle(fontSize: 48, fontWeight: FontWeight.w900, color: FinzennTheme.textDark),
                      decoration: const InputDecoration(border: InputBorder.none, hintText: '0.00', hintStyle: TextStyle(color: FinzennTheme.textMuted)),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Categoría Picker
              SizedBox(
                height: 40,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: currentCats.length,
                  itemBuilder: (context, i) {
                    final cat = currentCats[i];
                    final isSel = cat == _selectedCategory;
                    return GestureDetector(
                      onTap: () => setState(() => _selectedCategory = cat),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        margin: const EdgeInsets.only(right: 8),
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: isSel ? FinzennTheme.primaryBlue : FinzennTheme.white,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: isSel ? FinzennTheme.primaryBlue : FinzennTheme.softPurple.withOpacity(0.3)),
                        ),
                        child: Text(cat, style: TextStyle(color: isSel ? FinzennTheme.white : FinzennTheme.textDark, fontWeight: FontWeight.w700, fontSize: 12)),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 24),

              // Nota Corta
              Container(
                decoration: BoxDecoration(color: FinzennTheme.white, borderRadius: BorderRadius.circular(16)),
                child: TextField(
                  controller: _descController,
                  decoration: const InputDecoration(
                    hintText: 'Añade una nota rápida... (Opcional)',
                    hintStyle: TextStyle(color: FinzennTheme.textMuted, fontSize: 13),
                    prefixIcon: Icon(Icons.mode_edit_outline, color: FinzennTheme.textMuted, size: 18),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Botón Save
              ElevatedButton(
                style: FinzennTheme.lightTheme.elevatedButtonTheme.style,
                onPressed: _isSaving ? null : _submit,
                child: _isSaving
                    ? const SizedBox(width: 24, height: 24, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                    : const Text('Registrar'),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
