import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:moteelz/futures/wallet_details/widget/wallet_card.dart';

class DescriptionWalletDetailsCardFeatures extends StatefulWidget {
  final String description;

  const DescriptionWalletDetailsCardFeatures({
    super.key,
    required this.description,
  });

  @override
  State<DescriptionWalletDetailsCardFeatures> createState() =>
      _DescriptionWalletDetailsCardFeaturesState();
}


class _DescriptionWalletDetailsCardFeaturesState
    extends State<DescriptionWalletDetailsCardFeatures> {
  bool _isExpanded = false;
  bool _showReadMore = false;

  void _checkTextOverflow(double maxWidth) {
    final textPainter = TextPainter(
      text: TextSpan(
        text: widget.description,
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
      ),
      maxLines: 4,
      textDirection: TextDirection.rtl,
    );
    textPainter.layout(maxWidth: maxWidth);
    if (textPainter.didExceedMaxLines) {
      _showReadMore = true;
    } else {
      _showReadMore = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return CupertinoListSection.insetGrouped(
      backgroundColor: theme.scaffoldBackgroundColor,
      margin: EdgeInsets.zero,
      header: 
        Text(
          "وصف البطاقة",
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        
        children: [
            LayoutBuilder(
          builder: (context, constraints) {
            _checkTextOverflow(constraints.maxWidth);
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.description,
                  style: theme.textTheme.bodySmall?.copyWith(
                      fontWeight: FontWeight.bold, color: Colors.grey),
                  maxLines: _isExpanded ? null : 4,
                  overflow: _isExpanded ? null : TextOverflow.ellipsis,
                ),
                if (_showReadMore)
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _isExpanded = !_isExpanded;
                      });
                    },
                    child: Text(
                      _isExpanded ? 'قراءة أقل' : 'قراءة المزيد',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
              ],
            );
          },
        ),
    
        ],
    );
  }
}
