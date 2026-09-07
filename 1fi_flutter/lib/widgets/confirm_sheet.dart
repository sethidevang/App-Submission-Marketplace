import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../theme/context_ext.dart';
import '../theme/tokens.dart';
import '../util/format.dart';

Future<void> showEmiConfirmSheet(
  BuildContext context, {
  required String productName,
  required String variantSummary,
  required int tenure,
  required int monthly,
  required int total,
}) {
  final c = context.colors;
  return showModalBottomSheet(
    context: context,
    backgroundColor: c.surface,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
    ),
    builder: (sheetContext) {
      return SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(22, 10, 22, 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 36,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 18),
                  decoration: BoxDecoration(
                    color: c.border,
                    borderRadius: BorderRadius.circular(3),
                  ),
                ),
              ),
              Container(
                width: 52,
                height: 52,
                decoration:
                    BoxDecoration(color: c.accent50, shape: BoxShape.circle),
                child: Icon(Icons.check_rounded, color: c.accent500, size: 28),
              ),
              const SizedBox(height: 14),
              Text(
                'EMI plan confirmed',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: c.text,
                ),
              ),
              const SizedBox(height: 14),
              _row(c, 'Product', productName),
              if (variantSummary.isNotEmpty) ...[
                const SizedBox(height: 9),
                _row(c, 'Variant', variantSummary),
              ],
              const SizedBox(height: 9),
              _row(c, 'Tenure', '$tenure months'),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 9),
                child: Divider(height: 1, color: c.border),
              ),
              _row(c, 'Monthly EMI', '${rupees(monthly)}/mo'),
              const SizedBox(height: 9),
              _row(c, 'Total payable', rupees(total)),
              const SizedBox(height: 14),
              Container(
                padding: const EdgeInsets.all(13),
                decoration: BoxDecoration(
                  color: c.surfaceTint,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(Icons.info_outline_rounded,
                        size: 16, color: c.accent500),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        'No credit score required. No interest. Backed by your investments.',
                        style: TextStyle(
                            fontSize: 12, height: 1.55, color: c.text2),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 18),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(sheetContext).pop();
                    Navigator.of(context).popUntil((r) => r.isFirst);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: c.accent500,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(999)),
                  ),
                  child: Text(
                    'Done',
                    style: GoogleFonts.plusJakartaSans(
                      fontWeight: FontWeight.w700,
                      fontSize: 14.5,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}

Widget _row(AppColors c, String label, String value) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Text(label, style: TextStyle(fontSize: 13, color: c.text2)),
      Text(value,
          style: TextStyle(
              fontSize: 13, fontWeight: FontWeight.w700, color: c.text)),
    ],
  );
}
