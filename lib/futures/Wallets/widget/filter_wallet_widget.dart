import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:moteelz/futures/Wallets/state/Wallets_state.dart';

import '../../../data/models/filter_country.dart';

class FilterWalletSheet extends StatefulWidget {
  final WalletFilter currentFilter;
  final Function(WalletFilter) onApply;

  final List<FilterCountry> countries;
  final double maxPriceRange;

  const FilterWalletSheet({
    super.key,
    required this.currentFilter,
    required this.onApply,
    required this.countries,
    this.maxPriceRange = 10000,
  });

  @override
  State<FilterWalletSheet> createState() => _FilterWalletSheetState();
}

class _FilterWalletSheetState extends State<FilterWalletSheet> {
  late TextEditingController _nameController;
  late double _minPrice;
  late double _maxPrice;
  FilterCountry? _selectedCountry;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.currentFilter.name);
    _minPrice = widget.currentFilter.minPrice?.toDouble() ?? 0;
    _maxPrice =
        widget.currentFilter.maxPrice?.toDouble() ?? widget.maxPriceRange;
    _selectedCountry = widget.countries.firstWhere(
      (c) => c.id == widget.currentFilter.countryId,
      orElse: () => FilterCountry(id: -1, name: ''),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: _buildActionButtons(),
      body: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius:
                const BorderRadius.vertical(top: Radius.circular(20))),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            _buildPriceRangeSlider(),
            Text('الدولة', style: Theme.of(context).textTheme.titleMedium,),
            SizedBox(height: 4,),
            _buildCountryButton(),

            SizedBox(height: 40,),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('التصفية', style: Theme.of(context).textTheme.titleLarge),
          InkWell(
            onTap: () {
              Navigator.of(context).pop();
              widget.onApply(WalletFilter.initial());
            },
            child: Text(
              'محو الكل',
              style: TextStyle(
                color: Colors.blue, // لون الرابط
                decoration: TextDecoration.underline, // إضافة خط تحت النص
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildChip(String price) {
    return Chip(
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      label: Text(
        price,
        style: TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildPriceRangeSlider() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Text('السعر', style: Theme.of(context).textTheme.titleMedium),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildChip('${_minPrice.round()} س.ر'),
            _buildChip('${_maxPrice.round()} س.ر'),
          ],
        ),
        RangeSlider(
          values: RangeValues(_minPrice, _maxPrice),
          min: 0,
          max: widget.maxPriceRange,
          divisions: 10,
          labels: RangeLabels(
            '${_minPrice.round()} س.ر',
            '${_maxPrice.round()} س.ر',
          ),
          onChanged: (values) {
            setState(() {
              _minPrice = values.start;
              _maxPrice = values.end;
            });
          },
        ),
      ],
    );
  }

Widget _buildCountryButton() {
  return TextButton(
    style: TextButton.styleFrom(
      padding: const EdgeInsets.all(16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: BorderSide(color: Colors.grey.shade300),
      ),
    ),
    onPressed: _showCountryBottomSheet,
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          _selectedCountry?.name ?? 'اختار الدولة',
          style: TextStyle(
            color: _selectedCountry != null 
                ? Colors.black 
                : Colors.grey.shade600,
          ),
        ),
        Icon(Icons.arrow_drop_down, color: Colors.grey.shade600)
      ],
    ),
  );
}



  Widget _buildActionButtons() {
    return CupertinoButton.filled(
      padding: EdgeInsets.zero,
      borderRadius: BorderRadius.zero,
      onPressed: () {
        final newFilter = WalletFilter(
          name: _nameController.text.isNotEmpty ? _nameController.text : null,
          minPrice: _minPrice.round(),
          maxPrice: _maxPrice.round(),
          countryId: _selectedCountry?.id,
        );
        widget.onApply(newFilter);
        Navigator.pop(context);
      },
      child: const Text('بحث'),
    );
  }

void _showCountryBottomSheet() {
  CountrySelectionBottomSheet.show(
    context: context,
    countries: widget.countries,
    selectedCountry: _selectedCountry,
    onCountrySelected: (country) => setState(() => _selectedCountry = country),
  );
}

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }
}


class CountrySelectionBottomSheet extends StatefulWidget {
  final List<FilterCountry> countries;
  final FilterCountry? selectedCountry;
  final ValueChanged<FilterCountry> onCountrySelected;

  const CountrySelectionBottomSheet({
    super.key,
    required this.countries,
    required this.selectedCountry,
    required this.onCountrySelected,
  });

  static void show({
    required BuildContext context,
    required List<FilterCountry> countries,
    required FilterCountry? selectedCountry,
    required ValueChanged<FilterCountry> onCountrySelected,
  }) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => CountrySelectionBottomSheet(
        countries: countries,
        selectedCountry: selectedCountry,
        onCountrySelected: onCountrySelected,
      ),
    );
  }

  @override
  State<CountrySelectionBottomSheet> createState() => _CountrySelectionBottomSheetState();
}

class _CountrySelectionBottomSheetState extends State<CountrySelectionBottomSheet> {
  late TextEditingController _searchController;
  late List<FilterCountry> _filteredCountries;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    _filteredCountries = List.from(widget.countries);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _handleSearch(String query) {
    setState(() {
      _filteredCountries = widget.countries
          .where((country) => country.name.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildHeader(),
            const SizedBox(height: 16),
            _buildSearchField(),
            const SizedBox(height: 16),
            _buildCountryList(),
            const SizedBox(height: 8),
            _buildCancelButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text('اختار الدولة', style: Theme.of(context).textTheme.titleLarge),
        IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.pop(context),
        ),
      ],
    );
  }

  Widget _buildSearchField() {
    return TextField(
      controller: _searchController,
      decoration: InputDecoration(
        hintText: 'ابحث عن الدولة...',
        prefixIcon: const Icon(Icons.search),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      onChanged: _handleSearch,
    );
  }

  Widget _buildCountryList() {
    return Expanded(
      child: ListView.separated(
        shrinkWrap: true,
        itemCount: _filteredCountries.length,
        separatorBuilder: (context, index) => Divider(
          height: 1, 
          color: Colors.grey.shade300
        ),
        itemBuilder: (context, index) {
          final country = _filteredCountries[index];
          return ListTile(
            title: Text(country.name),
            trailing: widget.selectedCountry?.id == country.id
                ? Icon(Icons.check, color: Theme.of(context).primaryColor)
                : null,
            onTap: () {
              widget.onCountrySelected(country);
              Navigator.pop(context);
            },
          );
        },
      ),
    );
  }

  Widget _buildCancelButton() {
    return SizedBox(
      width: double.infinity,
      child: TextButton(
        onPressed: () => Navigator.pop(context),
        child: const Text('إلغاء'),
      ),
    );
  }
}