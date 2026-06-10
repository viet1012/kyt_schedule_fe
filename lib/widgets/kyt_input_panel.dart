import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'app_panel.dart';

class KytInputPanel extends StatelessWidget {
  final TextEditingController msnvCtrl;
  final TextEditingController nameCtrl;
  final TextEditingController groupCtrl;
  final TextEditingController positionCtrl;

  final String selectedFac;
  final ValueChanged<String> onFacChanged;

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
    required this.selectedFac,
    required this.onFacChanged,
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
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
    );
  }

  Widget _facDropdown() {
    return SizedBox(
      width: 130,
      height: 44,
      child: DropdownButtonFormField<String>(
        value: selectedFac,
        decoration: InputDecoration(
          labelText: 'FAC',
          isDense: true,
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        ),
        items: const [
          DropdownMenuItem(value: 'Fac_1', child: Text('Fac_1')),
          DropdownMenuItem(value: 'Fac_2', child: Text('Fac_2')),
          DropdownMenuItem(value: 'Fac_3', child: Text('Fac_3')),
          DropdownMenuItem(value: 'Fac_4', child: Text('Fac_4')),
        ],
        onChanged: (value) {
          if (value == null) return;
          onFacChanged(value);
        },
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
                _facDropdown(),
                _inputField(controller: msnvCtrl, label: 'MSNV', width: 110),
                _inputField(
                  controller: nameCtrl,
                  label: 'Họ và tên',
                  width: 230,
                ),
                _inputField(controller: groupCtrl, label: 'Group', width: 140),
                _inputField(
                  controller: positionCtrl,
                  label: 'Chức vụ',
                  width: 160,
                ),
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
                    'Lịch chạy riêng theo từng FAC. Nhân viên mới sẽ tham gia từ round tiếp theo.',
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
