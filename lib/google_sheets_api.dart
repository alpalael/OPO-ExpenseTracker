import 'package:gsheets/gsheets.dart';

class GoogleSheetsApi {
  // create credentials
  static const _credentials = r'''
  {
  "type": "service_account",
  "project_id": "flutter-g-sheet-369916",
  "private_key_id": "702d11fb136c70084d9b97bbf9373694c52aa40d",
  "private_key": "-----BEGIN PRIVATE KEY-----\nMIIEvAIBADANBgkqhkiG9w0BAQEFAASCBKYwggSiAgEAAoIBAQCs34JtInjB58GY\nFVh7nP1d9eXaSH/ivOtmpOLL+/WIsMpDlAZFSkhHgYfQ9cqFSIc3mQ9BKt2ntVjw\n0oDWkKgHHHBQBOQ2LG1I73K3NMbMsElMRDwZH5iFneB6jnwbdEceRSJ5ejTDCd71\nXIpAXL3pB3Q5V5vXNydzp4mVrAao/eOsroBdb1oYfODEaPHm3MVN+ichMGOXltAH\nUteciSNPLI3G2DRKCteyy969EABKVF1ZPZavY8rT28jHvg02kSj8cxw2PMvFcKzt\nm78SzoRty8eejfjNQfBxr6d39lNleN2Q9e15gIWRJcyRgc0l/Mdmo2onjgIP2ZRs\nz/CbktvVAgMBAAECggEABqSuN/BvsI/t7iC/3jw5tl8pPpqzo2x8JV0nxAwCMwcM\nNs2c8hO5NFpDdGHFrxqK67WLkwcJLpU2/kYwok47zs4meMS/Wl+ZsYhWIbk6/Im3\nv2EN6C9BJr1a74rDNTDiPMUOXpm2JlqeQVKVk4Sc3bQmIL//oqUhdH3XOTO7q8nJ\nux62uW2VBHTgJbAdEitLTafZxUVNpT9j6rQ7ec/IPjmrZT3THrYEjcIC1I50VQhd\nm2Pa4BR7I59ISuejYvHfhiQEflFqYtRI1/+Nufpv0IptNrNKZ2Zsksa/gq0J3ye2\n6C0V4skX6WMhNxDaGlKFQaQOl9KdIB/S0wdVviMTIQKBgQDjLf3BP1pMJ2FMhznj\nU2juLgkvLjBrxyZiTE4IDax22NivrmQJ4SHpZWPOIsHf2tCMQTrtizMZg22fYQKy\n7/tu5aDUBTEJuXVzi5S4Rz67H8JF7b1iPn2GQnwLK/VQ6vU1RjJCggyQaRVA88Hi\nc40VE93Ro3AONdGSEKGGG9A20QKBgQDCzdQvx5mB0P92gCSpnGlFkfl2sRLiDnDR\nigJnXVVS9eeMr0bYRlXr1bWp+4CbLThuRCEgyZX2X5V1Dx5T9xHkk5cB+DvrFm8I\nxDrLEubeZidqgIgaRhtGiVSd7lScM4EpJEqZWAU+PkU9RtV/8vhaoryggfYco5qk\nMstiKrMdxQKBgFL/L3DVe2DNFlAGK1Dw3Sn/KZ3SCyClDlHlPLDWhgaZbHiqhqPR\nWzlQsGjT6+6jm4NSJXw5Wb7ddERBBeJnqH04aUxsZSD/X3iKKxgz9ygYDzrLA2CM\nIgHV8kmGksYwQMtozN3dc0ejDH/BTjk0K/viWSzIwByA7wKlDs3XBXexAoGANH13\nrkQvNc6V911CA73Uk91ohbXi66yOc7enPCjnA8qk0MCt6zrQjhJwt9O/7JA7w2Jy\nNr56vP82a2tedat+U8P9DZfQtWC/HHKbkPqP4N9PwZ/OjJ3VXaVFeqSsgcZTCD3y\nJ+2SxBnNWFyMzMQwbWOqReme4kqnMZVKPjJZPy0CgYBVKHtgDvh3cm94jVfk4Qbq\nDoU8X9zhjgYCqFF3EwXqP46RmmDFr/2rFF8/RCHFC7V879aum0N7e/kQiqZkfGe+\nN61dVjOfAc+nSvDJo/08iIeUAacvOk81X7C8YQmHI5WkV9QJ+XvBUtmcNd7Y2YDv\nylwOD8v04mHiN1+sHEzVRQ==\n-----END PRIVATE KEY-----\n",
  "client_email": "flutter-gsheet@flutter-g-sheet-369916.iam.gserviceaccount.com",
  "client_id": "107453732903579952489",
  "auth_uri": "https://accounts.google.com/o/oauth2/auth",
  "token_uri": "https://oauth2.googleapis.com/token",
  "auth_provider_x509_cert_url": "https://www.googleapis.com/oauth2/v1/certs",
  "client_x509_cert_url": "https://www.googleapis.com/robot/v1/metadata/x509/flutter-gsheet%40flutter-g-sheet-369916.iam.gserviceaccount.com"
}

  ''';

  // set up & connect to the spreadsheet
  static final _spreadsheetId = '1knCGyzVJtpQj8JCetGZyl02L-XcHhoqby-_sekG4GVQ';
  static final _gsheets = GSheets(_credentials);
  static Worksheet? _worksheet;

  // some variables to keep track of..
  static int numberOfTransactions = 0;
  static List<List<dynamic>> currentTransactions = [];
  static bool loading = true;

  // initialise the spreadsheet!
  Future init() async {
    final ss = await _gsheets.spreadsheet(_spreadsheetId);
    _worksheet = ss.worksheetByTitle('Worksheet1');
    countRows();
  }

  // count the number of notes
  static Future countRows() async {
    while ((await _worksheet!.values
            .value(column: 1, row: numberOfTransactions + 1)) !=
        '') {
      numberOfTransactions++;
    }
    // now we know how many notes to load, now let's load them!
    loadTransactions();
  }

  // load existing notes from the spreadsheet
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
    print(currentTransactions);
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

  // CALCULATE THE TOTAL INCOME!
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
