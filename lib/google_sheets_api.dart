import 'package:gsheets/gsheets.dart';

class GoogleSheetsApi {
  //create Credentials
  static const _credentials = r'''
  {
     "type": "service_account",
  "project_id": "budget-planner-336706",
  "private_key_id": "c5392f849ff597c4a218e4edfa043b0c3826be3a",
  "private_key": "-----BEGIN PRIVATE KEY-----\nMIIEvQIBADANBgkqhkiG9w0BAQEFAASCBKcwggSjAgEAAoIBAQC1J1Wh8/ySEUNn\n3NSGAXhJ1SYCe2arXUEQnM4oq36ekecS6E0X/hagjR5NLPVjdonCh8Qkg/0WTL/v\ngPQIn6007XtK1f9SwSBWmTMVQYz2axTI8X8qvlYZF1WKMNZH2cV3CwxVB4ga5D5X\nKIY4oMjI1vRker+gubEIoO+HTz/8wjx4sqwFoQs2GW8ykGhwm6VqccZ12ZFhucId\nV0BreG7SHR2cVKiFgtSh70k5J1S/G6UTCEKD+hruQB0FIKrFo7bKWCmVfpNzyNFN\nw9+Vv2/0ElAFuypDffgFrw32oMww1CMgPA9za3Nnhhe2wH7z4DbjwLgTZwlTRI1D\nNprBoxBxAgMBAAECggEAA9/3WcioGTsWTS/w5Hw+kEcSEjvaf9rgS+nWvRGiBTlL\nZIukg9ldrt8l4Ue6E1UTRZ51fcR2/ZWfBhFPkamnYPpIHgXYJB3ZF7vHgce5AK0H\nW579dd1uu7L/Pj6k2WeZQjPHIUB70vtuhpsUIpJJ3oXpN1xVd1Ym08TsKrbxavIh\nc5EE2Su4CUVbGosvzW9pCX7egNVklZ3+xgLzdNBESqQEESa336i9IpgFvI6m0TpY\nT0f3UvYRjZ/frOz98bG/tmnvLbP+MjCmc3oJkA4m+quCMIbd8icB9whXXafsyKEk\nXTmHftKb3mzCLX7ZmmLadqRgsheouLElRaVTyF5+iwKBgQDhx2rfxA+heqAJDIWc\nw+ilz0HfFmXjUYYMID/jRdnnaXgv1I9353fTHFQ+olVbMiZ7Ymw651e0z/zRXtbf\n2hyYt4qLLFORTELfD0hzkXSAQUUnGfI02J+iphOv1DH41fyPk4MpeYSOeqD8Tfy/\nLni4aeNYq5dHq4/ZznSYn4qhqwKBgQDNZscZIlP8MZ4JbWxXehM+QuiPrd/0+mUh\nCDChw1R9E8rgHUZTpDtBMeB/Y6WPiE09HZzNR1dHhl5UPSFtaoDdVgpp6doYvDPN\nouyTuCHXSmBn8r6dg4fIFKWsembU9UJZIuJXxjO2BE7DZt9eBwCljp7yayANEra/\nLoXo3ZfyUwKBgATuDMhcCJdXDR2Fd3ln0bGlJ+QOIiVnh0zGe36j7NEfvW8V7hgJ\nJtWmPbSsaL64Bp0VFhXnLUQWcofD0V9L7OnswAqv6hc3GhKyy7syRt/yDOeAqog6\n3ql3hOCG+pxbV8tuxiNmst1FkjRQI5+tDRfBwCQUgxYeieKQnn0ipq1HAoGAeU9E\nM3H0zDO5tLOtkxSEHPeDRqhYZuUjqRifMEqesaho32gqyudqH50Hi/UcKONFSt0c\naJjD0XhoabQY8/g813wjdl4o8wbkSYT52Fydj/tbaMkTDxBJtz+KgY1hAlE/uElE\nCLcEf3GX2wv8zBmyphTPhzkBmvb8e3lMmTWWsgUCgYEAyv6l2FyTYhCx/xgmIur7\nrnQDNF17gwj2UFhPfvDYGqsXRh95cFDRY9ckX0tiPXenHTcigBsebUItf9RPQIIw\nSLTRs4BlQTwKuAfEGrXGkCpbuc6jcC05MJFE06OWVequNwl7QrVrMQf5GdykqhUA\nHVXcj9vjggncqMSo8XoueQA=\n-----END PRIVATE KEY-----\n",
  "client_email": "budget-planner@budget-planner-336706.iam.gserviceaccount.com",
  "client_id": "111355652373260658881",
  "auth_uri": "https://accounts.google.com/o/oauth2/auth",
  "token_uri": "https://oauth2.googleapis.com/token",
  "auth_provider_x509_cert_url": "https://www.googleapis.com/oauth2/v1/certs",
  "client_x509_cert_url": "https://www.googleapis.com/robot/v1/metadata/x509/budget-planner%40budget-planner-336706.iam.gserviceaccount.com"

  }''';

  //set up & connect to the spreadsheet
  static const _spreadsheetId = '1Zvk4W26iqTTnAOxNvSLpr1TfQi0E9xMuJ9qwCBN8EZI';
  static final _gsheets = GSheets(_credentials);
  static Worksheet? _worksheet;

  static int numberOfTransactions = 0;
  static List<List<dynamic>> currentTransactions = [];
  static bool loading = true;

  //Initialize the spread sheet
  Future init() async {
    final ss = await _gsheets.spreadsheet(_spreadsheetId);
    _worksheet = ss.worksheetByTitle('Sheet1');

    countRows();
  }

  // count the number of notes
  static Future countRows() async {
    while ((await _worksheet?.values
            .value(column: 1, row: numberOfTransactions + 1)) !=
        '') {
      numberOfTransactions++;
    }
    loadTransactions();
  }

  static Future loadTransactions() async {
    if (_worksheet == null) return;

    for (int i = 1; i < numberOfTransactions; i++) {
      final String transactionName =
          await _worksheet!.values.value(column: 1, row: i + 1);
      final String transactionAmount =
          await _worksheet!.values.value(column: 2, row: i + 1);
      final String transactionType =
          await _worksheet!.values.value(column: 3, row: i + 1);

      if (currentTransactions.length < numberOfTransactions) {
        currentTransactions.add([
          transactionName,
          transactionAmount,
          transactionType,
        ]);
      }
    }
    // this will stop the circular loading indicator
    loading = false;
  }

  // insert a new transaction
  static Future insert(String name, String amount, bool _isIncome) async {
    if (_worksheet == null) return;
    numberOfTransactions++;
    currentTransactions.add([
      name,
      amount,
      _isIncome == true ? 'income' : 'expense',
    ]);
    await _worksheet!.values.appendRow([
      name,
      amount,
      _isIncome == true ? 'income' : 'expense',
    ]);
  }

  //delete row
  Future<bool> deleteById(int id) async {
    final index = await _worksheet!.values.rowIndexOf(id);
    if (index > 0) {
      return _worksheet!.deleteRow(index);
    }
    return false;
  }

  // CALCULATE THE TOTAL INCOME
  static double calculateIncome() {
    double totalIncome = 0;
    for (int i = 0; i < currentTransactions.length; i++) {
      if (currentTransactions[i][2] == 'income') {
        totalIncome += double.parse(currentTransactions[i][1]);
      }
    }
    return totalIncome;
  }

  // CALCULATE THE TOTAL EXPENSE!
  static double calculateExpense() {
    double totalExpense = 0;
    for (int i = 0; i < currentTransactions.length; i++) {
      if (currentTransactions[i][2] == 'expense') {
        totalExpense += double.parse(currentTransactions[i][1]);
      }
    }
    return totalExpense;
  }
}
