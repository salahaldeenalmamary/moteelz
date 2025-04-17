import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:moteelz/core/extensions/context_extensions.dart';
import 'package:moteelz/core/extensions/widget_extensions.dart';

class DiscountCodeSection extends StatefulWidget {
  final Function(String) onApplyDiscount;

  const DiscountCodeSection({super.key, required this.onApplyDiscount});

  @override
  State<DiscountCodeSection> createState() => _DiscountCodeSectionState();
}

class _DiscountCodeSectionState extends State<DiscountCodeSection> {
  final _discountController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return
    
     Column( 
      crossAxisAlignment: CrossAxisAlignment.start,
      
      children: [
        Text('هل لديك كود خصم', style: theme.textTheme.titleMedium?.copyWith(
          
        ),).paddingAll(10),
        
        Form(
          key: _formKey,
          child: Row(
            children: [
              Expanded(
                  flex: 3,
                  child: TextFormField(
                    controller: _discountController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'الرجاء إدخال كود الخصم';
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      filled: true,
                      hintText: 'أدخل كود الخصم',
                      fillColor: theme.cardColor,
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(
                              color: theme.dividerColor, width: 0.3)),
                    ),
                  )),
              const SizedBox(width: 8),
              Expanded(
                  child: CupertinoButton.filled(
                padding: EdgeInsets.all(5),
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    widget.onApplyDiscount(_discountController.text);
                  }
                },
                child: const Text('تطبيق'),
              )),
            ],
          ),
        ),
      ],
    ).paddingAll(10).decorated(color: context.theme.cardColor);
  }

  @override
  void dispose() {
    _discountController.dispose();
    super.dispose();
  }
}

