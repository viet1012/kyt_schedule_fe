import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'app_panel.dart';

class KytInputPanel extends StatelessWidget {
  final TextEditingController msnvCtrl;
  final TextEditingController nameCtrl;
  final TextEditingController groupCtrl;
  final TextEditingController positionCtrl;
  final DateTime startDate;
  final VoidCallback onAddEmployee;
  final VoidCallback onPickDate;
  final VoidCallback onGenerate;

  KytInputPanel({
    super.key,
    required this.msnvCtrl,
    required this.nameCtrl,
    required this.groupCtrl,
    required this.positionCtrl,
    required this.startDate,
    required this.onAddEmployee,
    required this.onPickDate,
    required this.onGenerate,
  });

  final _fmt = DateFormat('d-MMM-yy', 'en_US');

  Widget _inputField({
    required TextEditingController controller,
    required String label,
    double width = 160,
  }) {
    return SizedBox(
      width: width,
      height: 44,
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          isDense: true,
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AppPanel(
      title: 'Thiết lập lịch KYT',
      icon: Icons.tune,
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          children: [
            Wrap(
              spacing: 10,
              runSpacing: 10,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                _inputField(controller: msnvCtrl, label: 'MSNV', width: 110),
                _inputField(controller: nameCtrl, label: 'Họ và tên', width: 230),
                _inputField(controller: groupCtrl, label: 'Group', width: 140),
                _inputField(controller: positionCtrl, label: 'Chức vụ', width: 160),
                SizedBox(
                  height: 44,
                  child: FilledButton.icon(
                    onPressed: onAddEmployee,
                    icon: const Icon(Icons.person_add_alt_1),
                    label: const Text('Thêm nhân viên'),
                  ),
                ),
                SizedBox(
                  height: 44,
                  child: OutlinedButton.icon(
                    onPressed: onPickDate,
                    icon: const Icon(Icons.calendar_month),
                    label: Text(_fmt.format(startDate)),
                  ),
                ),
                SizedBox(
                  height: 44,
                  child: FilledButton.icon(
                    onPressed: onGenerate,
                    icon: const Icon(Icons.auto_awesome),
                    label: const Text('Tạo lịch'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Icon(Icons.info_outline, size: 18, color: Colors.grey.shade600),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    'Lịch chỉ chạy từ Thứ 3 đến Thứ 6. Xóa nhân viên xong bấm Tạo lịch để tự dồn lại.',
                    style: TextStyle(color: Colors.grey.shade700),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}