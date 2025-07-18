import 'dart:io';
import 'dart:typed_data';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:share_plus/share_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:intl/intl.dart';
import '../models/quote_model.dart';
import 'pricing_service.dart';

class PdfService {
  static const double _margin = 40.0;
  static const double _spacing = 10.0;

  static Future<Uint8List> generateQuotePdf(Quote quote) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.letter,
        margin: const pw.EdgeInsets.all(_margin),
        build: (pw.Context context) {
          return [
            _buildHeader(),
            pw.SizedBox(height: _spacing * 2),
            _buildQuoteInfo(quote),
            pw.SizedBox(height: _spacing * 2),
            _buildCustomerInfo(quote),
            pw.SizedBox(height: _spacing * 2),
            _buildVehicleInfo(quote),
            pw.SizedBox(height: _spacing * 2),
            _buildPhotoshootInfo(quote),
            pw.SizedBox(height: _spacing * 2),
            _buildProductConfiguration(quote),
            pw.SizedBox(height: _spacing * 2),
            _buildStandInfo(quote),
            pw.SizedBox(height: _spacing * 2),
            _buildPricingBreakdown(quote),
            pw.SizedBox(height: _spacing * 2),
            _buildFooter(),
          ];
        },
      ),
    );

    return pdf.save();
  }

  static pw.Widget _buildHeader() {
    return pw.Container(
      width: double.infinity,
      padding: const pw.EdgeInsets.all(20),
      decoration: pw.BoxDecoration(
        color: PdfColors.grey900,
        borderRadius: const pw.BorderRadius.all(pw.Radius.circular(8)),
      ),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(
            'PHOTOMOTIVE GROUP',
            style: pw.TextStyle(
              fontSize: 28,
              fontWeight: pw.FontWeight.bold,
              color: PdfColors.white,
            ),
          ),
          pw.SizedBox(height: 4),
          pw.Text(
            'Car Event Photography Quote',
            style: pw.TextStyle(
              fontSize: 18,
              fontWeight: pw.FontWeight.bold,
              color: PdfColors.redAccent,
            ),
          ),
          pw.SizedBox(height: 8),
          pw.Text(
            'Professional Car Photography & Custom Products',
            style: pw.TextStyle(fontSize: 14, color: PdfColors.grey300),
          ),
          pw.SizedBox(height: 4),
          pw.Text(
            'Contact: 409-223-7567 | info@PhotomotiveGroup.com',
            style: pw.TextStyle(fontSize: 12, color: PdfColors.grey400),
          ),
        ],
      ),
    );
  }

  static pw.Widget _buildQuoteInfo(Quote quote) {
    return _buildSection('Order Information', [
      _buildInfoRow('Completed By', quote.completedBy),
      _buildInfoRow('Date', DateFormat('MMM dd, yyyy').format(quote.date)),
      _buildInfoRow('Time', DateFormat('hh:mm a').format(quote.time)),
      _buildInfoRow('Car Event Name', quote.carEventName),
    ]);
  }

  static pw.Widget _buildCustomerInfo(Quote quote) {
    return _buildSection('Customer Information', [
      _buildInfoRow('Name', quote.customerName),
      _buildInfoRow(
        'Veteran',
        quote.isVeteran
            ? 'Yes (${quote.effectiveVeteranDiscountPercentage.toStringAsFixed(0)}% discount)'
            : 'No',
      ),
      _buildInfoRow('Address', quote.address),
      _buildInfoRow(
        'City, State, Zip',
        '${quote.city}, ${quote.state} ${quote.zipCode}',
      ),
      _buildInfoRow('Phone Number', quote.phoneNumber),
      _buildInfoRow('Email Address', quote.emailAddress),
    ]);
  }

  static pw.Widget _buildVehicleInfo(Quote quote) {
    return _buildSection('Vehicle Information', [
      _buildInfoRow('Car Make', quote.carMake),
      _buildInfoRow('Car Model', quote.carModel),
      _buildInfoRow('Car Color', quote.carColor),
    ]);
  }

  static pw.Widget _buildPhotoshootInfo(Quote quote) {
    final needByText = quote.needByDate != null
        ? DateFormat('MMM dd, yyyy').format(quote.needByDate!)
        : 'Not specified';

    return _buildSection('Photoshoot Details', [
      _buildInfoRow('Photos taken by', quote.photoTakenBy.displayName),
      _buildInfoRow('Available Dates', quote.availableDates),
      _buildInfoRow('Priority Service', quote.isPriorityService ? 'Yes' : 'No'),
      _buildInfoRow('Need by date', needByText),
      _buildInfoRow(
        'Customer wants photos',
        quote.wantsPhotosFromShoot ? 'Yes' : 'No',
      ),
    ]);
  }

  static pw.Widget _buildProductConfiguration(Quote quote) {
    final sizeText = quote.productSize == ProductSize.custom
        ? quote.customSize.isNotEmpty
              ? quote.customSize
              : 'Custom Size'
        : quote.productSize.displayName;

    final printMaterialsText = quote.printMaterials.isNotEmpty
        ? quote.printMaterials.map((m) => m.displayName).join(', ')
        : 'None specified';

    final substratesText = quote.substrates.isNotEmpty
        ? quote.substrates.map((s) => s.displayName).join(', ')
        : 'None';

    return _buildSection('Product Configuration', [
      _buildInfoRow('Size', sizeText),
      _buildInfoRow('Showboard Type', quote.showboardType.displayName),
      if (quote.themeDescription.isNotEmpty)
        _buildInfoRow('Theme Description', quote.themeDescription),
      _buildInfoRow('Printed on', printMaterialsText),
      _buildInfoRow('Substrate', substratesText),
      _buildInfoRow('Framed', quote.isFramed ? 'Yes' : 'No'),
      if (quote.effectiveHasCombinationCase)
        _buildInfoRow('Combination Case', 'Yes')
      else ...[
        _buildInfoRow(
          'Protective Case',
          quote.hasProtectiveCase ? 'Yes' : 'No',
        ),
      ],
    ]);
  }

  static pw.Widget _buildStandInfo(Quote quote) {
    return _buildSection('Stand Information', [
      _buildInfoRow('Stand Type', quote.standType.displayName),
      if (quote.standType == StandType.premium ||
          quote.standType == StandType.premiumSilver ||
          quote.standType == StandType.premiumBlack)
        if (!quote.effectiveHasCombinationCase)
          _buildInfoRow(
            'Stand Carrying Case',
            quote.hasStandCarryingCase ? 'Yes' : 'No',
          ),
    ]);
  }

  static pw.Widget _buildPricingBreakdown(Quote quote) {
    final breakdown = PricingService.getItemizedPricing(quote);
    final total = PricingService.calculateTotalPrice(quote);

    List<pw.Widget> priceRows = [];

    // Add each line item
    breakdown.forEach((item, price) {
      priceRows.add(_buildPriceRow(item, price));
    });

    // Add total
    priceRows.add(pw.SizedBox(height: _spacing));
    priceRows.add(pw.Divider(color: PdfColors.grey600, thickness: 2));
    priceRows.add(pw.SizedBox(height: _spacing / 2));
    priceRows.add(
      pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          pw.Text(
            'Total Amount',
            style: pw.TextStyle(
              fontSize: 16,
              fontWeight: pw.FontWeight.bold,
              color: PdfColors.grey800,
            ),
          ),
          pw.Text(
            PricingService.formatPrice(total),
            style: pw.TextStyle(
              fontSize: 16,
              fontWeight: pw.FontWeight.bold,
              color: PdfColors.red700,
            ),
          ),
        ],
      ),
    );

    return _buildSection('Price Breakdown', priceRows);
  }

  static pw.Widget _buildPriceRow(String item, double price) {
    final isDiscount = price < 0;
    final isZeroPrice = price == 0.0;
    final color = isDiscount ? PdfColors.green600 : PdfColors.grey800;

    return pw.Padding(
      padding: const pw.EdgeInsets.only(bottom: 6),
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          pw.Expanded(
            child: pw.Text(
              item,
              style: pw.TextStyle(fontSize: 12, color: color),
            ),
          ),
          pw.Text(
            isZeroPrice ? 'Included' : PricingService.formatPrice(price.abs()),
            style: pw.TextStyle(
              fontSize: 12,
              color: isZeroPrice ? PdfColors.grey600 : color,
              fontWeight: isDiscount
                  ? pw.FontWeight.bold
                  : pw.FontWeight.normal,
              fontStyle: isZeroPrice
                  ? pw.FontStyle.italic
                  : pw.FontStyle.normal,
            ),
          ),
        ],
      ),
    );
  }

  static pw.Widget _buildSection(String title, List<pw.Widget> content) {
    return pw.Container(
      width: double.infinity,
      padding: const pw.EdgeInsets.all(16),
      decoration: pw.BoxDecoration(
        border: pw.Border.all(color: PdfColors.grey400),
        borderRadius: const pw.BorderRadius.all(pw.Radius.circular(8)),
      ),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(
            title,
            style: pw.TextStyle(
              fontSize: 18,
              fontWeight: pw.FontWeight.bold,
              color: PdfColors.grey800,
            ),
          ),
          pw.SizedBox(height: _spacing),
          pw.Divider(color: PdfColors.grey400),
          pw.SizedBox(height: _spacing),
          ...content,
        ],
      ),
    );
  }

  static pw.Widget _buildInfoRow(String label, String value) {
    if (value.isEmpty) return pw.SizedBox.shrink();

    return pw.Padding(
      padding: const pw.EdgeInsets.only(bottom: 8),
      child: pw.Row(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Expanded(
            flex: 2,
            child: pw.Text(
              '$label:',
              style: pw.TextStyle(
                fontSize: 12,
                fontWeight: pw.FontWeight.bold,
                color: PdfColors.grey700,
              ),
            ),
          ),
          pw.Expanded(
            flex: 3,
            child: pw.Text(
              value,
              style: const pw.TextStyle(fontSize: 12, color: PdfColors.black),
            ),
          ),
        ],
      ),
    );
  }

  static pw.Widget _buildFooter() {
    return pw.Container(
      width: double.infinity,
      padding: const pw.EdgeInsets.all(16),
      decoration: pw.BoxDecoration(
        color: PdfColors.grey100,
        borderRadius: const pw.BorderRadius.all(pw.Radius.circular(8)),
      ),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.center,
        children: [
          pw.Text(
            'PHOTOMOTIVE GROUP',
            style: pw.TextStyle(
              fontSize: 16,
              fontWeight: pw.FontWeight.bold,
              color: PdfColors.grey800,
            ),
          ),
          pw.SizedBox(height: 4),
          pw.Text(
            'Capturing High-Quality, Unique Car Images for Car Shows & Collections',
            style: pw.TextStyle(
              fontSize: 12,
              fontWeight: pw.FontWeight.bold,
              color: PdfColors.red700,
            ),
          ),
          pw.SizedBox(height: 8),
          pw.Text(
            'Thank you for choosing Photomotive Group for your car photography needs!',
            style: pw.TextStyle(fontSize: 12, color: PdfColors.grey700),
          ),
          pw.SizedBox(height: 8),
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.center,
            children: [
              pw.Text(
                'Contact: 409-223-7567 | info@PhotomotiveGroup.com',
                style: pw.TextStyle(
                  fontSize: 10,
                  fontWeight: pw.FontWeight.bold,
                  color: PdfColors.grey600,
                ),
              ),
            ],
          ),
          pw.SizedBox(height: 8),
          pw.Divider(color: PdfColors.grey400, thickness: 1),
          pw.SizedBox(height: 8),
          pw.Text(
            'This quote is valid for 30 days from the date of issue.',
            style: const pw.TextStyle(fontSize: 10, color: PdfColors.grey600),
          ),
          pw.SizedBox(height: 4),
          pw.Text(
            'Generated on ${DateFormat('MMM dd, yyyy \'at\' hh:mm a').format(DateTime.now())}',
            style: const pw.TextStyle(fontSize: 10, color: PdfColors.grey600),
          ),
        ],
      ),
    );
  }

  static Future<void> printQuote(Quote quote) async {
    final pdfData = await generateQuotePdf(quote);
    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => pdfData,
      name:
          'Quote_${quote.customerName}_${DateFormat('yyyyMMdd').format(quote.date)}',
    );
  }

  static Future<void> shareQuote(Quote quote) async {
    final pdfData = await generateQuotePdf(quote);
    final tempDir = await getTemporaryDirectory();
    final fileName =
        'Quote_${quote.customerName}_${DateFormat('yyyyMMdd').format(quote.date)}.pdf';
    final file = File('${tempDir.path}/$fileName');
    await file.writeAsBytes(pdfData);

    await Share.shareXFiles(
      [XFile(file.path)],
      text: 'Photomotive Group Quote for ${quote.customerName}',
      subject: 'Photomotive Group Car Photography Quote',
    );
  }

  static Future<String> saveQuotePdf(Quote quote) async {
    final pdfData = await generateQuotePdf(quote);
    final directory = await getApplicationDocumentsDirectory();
    final fileName =
        'Quote_${quote.customerName}_${DateFormat('yyyyMMdd').format(quote.date)}.pdf';
    final file = File('${directory.path}/$fileName');
    await file.writeAsBytes(pdfData);
    return file.path;
  }
}
