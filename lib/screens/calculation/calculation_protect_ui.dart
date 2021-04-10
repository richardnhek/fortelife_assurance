import 'package:excel/excel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:forte_life/providers/app_provider.dart';
import 'package:forte_life/providers/parameters_provider.dart';
import 'package:forte_life/utils/device_utils.dart';
import 'package:forte_life/widgets/calculate_button.dart';
import 'package:forte_life/widgets/custom_datepicker.dart';
import 'package:forte_life/widgets/custom_dialogtext.dart';
import 'package:forte_life/widgets/custom_dropdown.dart';
import 'package:forte_life/widgets/custom_switch.dart';
import 'package:forte_life/widgets/custom_text_field.dart';
import 'package:forte_life/widgets/dropdown_text.dart';
import 'package:forte_life/widgets/field_title.dart';
import 'package:forte_life/widgets/reset_button.dart';

import 'package:intl/intl.dart';
import 'package:forte_life/widgets/disabled_field.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CalculationProtectUI extends StatefulWidget {
  CalculationProtectUI({this.scaffoldKey});
  final GlobalKey<ScaffoldState> scaffoldKey;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  _CalculationProtectUIState createState() => _CalculationProtectUIState();
}

class _CalculationProtectUIState extends State<CalculationProtectUI> {
  @override
  void initState() {
    super.initState();
    initializeCalculator();
  }

  Future<void> initializeCalculator() async {
    await getValues();
    premium.addListener(getAmountValues);
    sumAssured.addListener(getAmountValues);
    firstName.addListener(getAmountValues);
    lastName.addListener(getAmountValues);
    lOccupation.addListener(getAmountValues);
    pFirstName.addListener(getAmountValues);
    pLastName.addListener(getAmountValues);
    pOccupation.addListener(getAmountValues);
    riderAdded.addListener(getAmountValues);
    await checkNullValues();
  }

  Future<void> checkNullValues() async {
    if (sumAssuredNum == null || sumAssured.text == null) {
      sumAssured.clear();
    }
    if (premiumNum == null || premium.text == null) {
      premium.clear();
    }
    if (riderAdded.text == null) {
      riderAdded.clear();
    }
  }

  Future<void> getValues() async {
    final prefs = await SharedPreferences.getInstance();
    print(sumAssuredNum);
    String fName = prefs.getString("fName");
    String lName = prefs.getString("lName");
    String lOcc = prefs.getString("lOcc");
    String premVal = prefs.getString("premVal");
    String sumVal = prefs.getString("sumVal");
    String riderVal = prefs.getString("riderVal");
    String pName = prefs.getString("pName");
    String pLName = prefs.getString("pLName");
    String pOcc = prefs.getString("pOcc");
    String dobProtect = prefs.getString("lpDobProtect");
    String pDobProtect = prefs.getString("pDobProtect");
    String pAgeProtect = prefs.getString("pAgeProtect");
    String dobProtectDate = prefs.getString("lpDobProtectDate");
    String ageProtect = prefs.getString("ageProtect");
    String lpGenderProtect = prefs.getString("lpGenderProtect");
    String pGenderProtect = prefs.getString("pGenderProtect");
    String selectedModeProtect = prefs.getString("selectedModeProtect");
    int selYear = prefs.getInt("selYearInt");
    firstName.text = fName == null ? '' : fName;
    lastName.text = lName == null ? '' : lName;
    lOccupation.text = lOcc == null ? '' : lOcc;
    lSelectedGender = lpGenderProtect == null ? null : lpGenderProtect;
    pSelectedGender = pGenderProtect == null ? null : pGenderProtect;
    dob.text = dobProtect == null ? '' : dobProtect;
    pDob.text = pDobProtect == null ? '' : pDobProtect;
    pAge.text = pAgeProtect == null ? '' : pAgeProtect;
    lpBirthDate = dobProtectDate == null
        ? DateTime.tryParse('')
        : DateTime.tryParse(dobProtectDate);

    age.text = ageProtect == null ? '' : ageProtect;
    setState(() {
      selectedYear = (selYear == null) == false ? selYear : 10;
    });
    setState(() {
      selectedMode = (selectedModeProtect == null) == false
          ? selectedModeProtect
          : "Yearly";
    });
    premium.text = premVal != null ? double.tryParse(premVal).toString() : null;
    premiumNum = (premVal == null) ? null : double.tryParse(premVal);
    sumAssured.text =
        sumVal != null ? double.tryParse(sumVal).toString() : null;
    sumAssuredNum =
        (sumAssured.text == null) ? null : double.tryParse(sumAssured.text);
    if (sumAssuredNum == null) {
      sumAssured.clear();
    }
    riderAdded.text =
        riderVal != null ? double.tryParse(riderVal).toString() : null;
    pFirstName.text = pName == null ? '' : pName;
    pLastName.text = pLName == null ? '' : pLName;
    pOccupation.text = pOcc == null ? '' : pOcc;
  }

  Future<void> getAmountValues() async {
    final prefs = await SharedPreferences.getInstance();
    if (premiumNum != null)
      prefs.setString("premVal", premiumNum.toString());
    else
      prefs.setString("premVal", '');
    if (sumAssuredNum != null)
      prefs.setString("sumVal", sumAssuredNum.toString());
    else
      prefs.setString("sumVal", '');
    prefs.setInt("selYearInt", selectedYear);
    prefs.setString("riderVal", riderAdded.text);
    prefs.setString("pGenderProtect", pSelectedGender);
    prefs.setString("lpGenderProtect", lSelectedGender);
    prefs.setString("fName", firstName.text);
    prefs.setString("lName", lastName.text);
    prefs.setString("lOcc", lOccupation.text);
    prefs.setString("pName", pFirstName.text);
    prefs.setString("pLName", pLastName.text);
    prefs.setString("pOcc", pOccupation.text);
  }

  FocusNode premiumFocusNode;
  //Proposer
  final pFirstName = TextEditingController();
  final pLastName = TextEditingController();
  final pAge = TextEditingController();
  final pDob = TextEditingController();
  final pGender = TextEditingController();
  final pOccupation = TextEditingController();
  //

  //Life Proposed
  final firstName = TextEditingController();
  final lastName = TextEditingController();
  final age = TextEditingController();
  final dob = TextEditingController();
  final sumAssured = TextEditingController();
  final premium = TextEditingController();
  final gender = TextEditingController();
  final lOccupation = TextEditingController();
  final riderAdded = TextEditingController();
  //

  String lSelectedGender;
  String pSelectedGender;
  String selectedMode = "Yearly";

  //Necessary error texts
  bool emptyAgeField = false;
  bool emptyAgeFieldP = false;
  bool emptyGenderField = false;
  bool emptyGenderFieldP = false;
  bool emptyPremiumField = false;
  bool emptySumField = false;
  //
  //Necessary error variables
  int counter = 0;
  //
  //

  //Regular Expressions
  RegExp regExpNum = RegExp("[+]?\\d*\\.?\\d+");
  //

  int selectedYear = 10;
  int parameterCounter = 0;

  double premiumNum;
  double sumAssuredNum;
  double premiumRider;
  DateTime lpBirthDate;
  bool isOnPolicy = false;
  bool isKhmer = false;

  List<Widget> customDialogChildren = List();

  List<DropdownMenuItem> genderTypes = [
    DropdownMenuItem(
        child: DropDownText(
          title: "Male",
        ),
        value: "Male"),
    DropdownMenuItem(
        child: DropDownText(
          title: "Female",
        ),
        value: "Female")
  ];

  List<DropdownMenuItem> paymentMode = [
    DropdownMenuItem(
        child: DropDownText(
          title: "Yearly",
        ),
        value: "Yearly"),
    DropdownMenuItem(
        child: DropDownText(
          title: "Half-yearly",
        ),
        value: "Half-yearly"),
    DropdownMenuItem(
        child: DropDownText(
          title: "Quarterly",
        ),
        value: "Quarterly"),
    DropdownMenuItem(
        child: DropDownText(
          title: "Monthly",
        ),
        value: "Monthly")
  ];

  List<DropdownMenuItem> policyYears = [
    DropdownMenuItem(child: DropDownText(title: "10"), value: 10),
    DropdownMenuItem(child: DropDownText(title: "15"), value: 15),
    DropdownMenuItem(child: DropDownText(title: "20"), value: 20),
    DropdownMenuItem(child: DropDownText(title: "25"), value: 25),
    DropdownMenuItem(child: DropDownText(title: "30"), value: 30),
    DropdownMenuItem(child: DropDownText(title: "35"), value: 35)
  ];

  DateTime _selectedDate;
  DateTime _currentDate = DateTime.now();
  //

  @override
  Widget build(BuildContext context) {
    ParametersProvider parametersProvider =
        Provider.of<ParametersProvider>(context);
    AppProvider appProvider =
        Provider.of<AppProvider>(widget.scaffoldKey.currentContext);
    Map<String, dynamic> lang = appProvider.lang;
    final mq = MediaQuery.of(context);
    List<DropdownMenuItem> languageSI = [
      DropdownMenuItem(
          child: Image(
            image: AssetImage("assets/icons/english.png"),
            width: DeviceUtils.getResponsive(
                mq: mq,
                appProvider: appProvider,
                onPhone: 45.0,
                onTablet: 90.0),
            height: DeviceUtils.getResponsive(
                mq: mq,
                appProvider: appProvider,
                onPhone: 30.0,
                onTablet: 60.0),
          ),
          value: false),
      DropdownMenuItem(
          child: Image(
            image: AssetImage("assets/icons/khmer.png"),
            width: DeviceUtils.getResponsive(
                mq: mq,
                appProvider: appProvider,
                onPhone: 45.0,
                onTablet: 90.0),
            height: DeviceUtils.getResponsive(
                mq: mq,
                appProvider: appProvider,
                onPhone: 30.0,
                onTablet: 60.0),
          ),
          value: true)
    ];
    showAlertDialog(BuildContext context) {
      showDialog(
          context: context,
          builder: (context) => Center(
                  child: Material(
                type: MaterialType.transparency,
                child: Center(
                  child: Container(
                      width: DeviceUtils.getResponsive(
                          mq: mq,
                          appProvider: appProvider,
                          onPhone: 300.0,
                          onTablet: 600.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(3),
                        color: Colors.white,
                      ),
                      padding: EdgeInsets.all(10),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Align(
                            child: Image.asset("assets/icons/wrong.png",
                                width: DeviceUtils.getResponsive(
                                    mq: mq,
                                    appProvider: appProvider,
                                    onPhone: 60.0,
                                    onTablet: 120.0),
                                height: DeviceUtils.getResponsive(
                                    mq: mq,
                                    appProvider: appProvider,
                                    onPhone: 60.0,
                                    onTablet: 120.0)),
                            alignment: Alignment.center,
                          ),
                          SizedBox(
                              height: DeviceUtils.getResponsive(
                                  mq: mq,
                                  appProvider: appProvider,
                                  onPhone: 20.0,
                                  onTablet: 40.0)),
                          Align(
                            alignment: Alignment.center,
                            child: Container(
                              width: DeviceUtils.getResponsive(
                                  mq: mq,
                                  appProvider: appProvider,
                                  onPhone: 150.0,
                                  onTablet: 300.0),
                              child: Text(
                                "Error Inputs",
                                style: TextStyle(
                                    color: Color(0xFFD31145),
                                    fontSize: DeviceUtils.getResponsive(
                                        mq: mq,
                                        appProvider: appProvider,
                                        onPhone: 22.0,
                                        onTablet: 44.0),
                                    fontFamily: "Kano",
                                    fontWeight: FontWeight.w600),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                          SizedBox(
                              height: DeviceUtils.getResponsive(
                                  mq: mq,
                                  appProvider: appProvider,
                                  onPhone: 10.0,
                                  onTablet: 20.0)),
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: customDialogChildren,
                          ),
                          SizedBox(
                              height: DeviceUtils.getResponsive(
                                  mq: mq,
                                  appProvider: appProvider,
                                  onPhone: 20.0,
                                  onTablet: 40.0)),
                          Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                FlatButton(
                                  onPressed: () {
                                    setState(() {
                                      Navigator.of(context).pop();
                                      appProvider.calculationPage = 1;
                                    });
                                  },
                                  child: Text(
                                    "INFO",
                                    style: TextStyle(
                                        fontSize: DeviceUtils.getResponsive(
                                            mq: mq,
                                            appProvider: appProvider,
                                            onPhone: 16.0,
                                            onTablet: 32.0),
                                        fontFamily: "Kano",
                                        color: Colors.blueAccent),
                                  ),
                                ),
                                SizedBox(
                                    width: DeviceUtils.getResponsive(
                                        mq: mq,
                                        appProvider: appProvider,
                                        onPhone: 10.0,
                                        onTablet: 20.0)),
                                FlatButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: Text(
                                    "OK",
                                    style: TextStyle(
                                        fontSize: DeviceUtils.getResponsive(
                                            mq: mq,
                                            appProvider: appProvider,
                                            onPhone: 16.0,
                                            onTablet: 32.0),
                                        fontFamily: "Kano",
                                        color: Colors.blueAccent),
                                  ),
                                ),
                              ]),
                        ],
                      )),
                ),
              )));
    }

    //Derive rate
    Future<void> getRate(bool isMale, int ageParam, int termParam) async {
      ByteData data = await rootBundle.load("assets/rate/rate.xlsx");
      var bytes =
          data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
      var excel = Excel.decodeBytes(bytes);
      int row = 1;
      String column = "B";
      switch (termParam) {
        case 15:
          {
            column = "C";
            break;
          }
        case 20:
          {
            column = "D";
            break;
          }
        case 25:
          {
            column = "E";
            break;
          }
        case 30:
          {
            column = "F";
            break;
          }
        case 35:
          {
            column = "G";
            break;
          }
        default:
          {
            column = "B";
            break;
          }
      }
      if (isMale == true) {
        Sheet sheetObj = excel['Male'];
        row = ageParam - 17;
        var cellResult = sheetObj.cell(CellIndex.indexByString("$column$row"));
        premiumRider =
            (cellResult.value * double.parse(riderAdded.text)) / 1000;
      } else {
        Sheet sheetObj = excel['Female'];
        row = ageParam - 17;
        var cellResult = sheetObj.cell(CellIndex.indexByString("$column$row"));
        premiumRider =
            (cellResult.value * double.parse(riderAdded.text)) / 1000;
      }
      counter++;
    }
    //

    //Calculate and Generate PDF
    void calculateAndPDF() {
      if (appProvider.differentPerson == false) {
        parametersProvider.pName = parametersProvider.lpName =
            firstName.text.toString() + " " + lastName.text.toString();
        parametersProvider.pAge =
            parametersProvider.lpAge = age.text.toString();
        parametersProvider.pGender =
            parametersProvider.lpGender = lSelectedGender.toString();
        parametersProvider.pOccupation =
            parametersProvider.lpOccupation = lOccupation.text.toString();
      } else {
        //Proposer
        parametersProvider.pName =
            pFirstName.text.toString() + " " + pLastName.text.toString();
        parametersProvider.pAge = pAge.text.toString();
        parametersProvider.pGender = pSelectedGender.toString();
        parametersProvider.pOccupation = pOccupation.text.toString();
        //

        //Life Proposed
        parametersProvider.lpName =
            firstName.text.toString() + " " + lastName.text.toString();
        parametersProvider.lpAge = age.text.toString();
        parametersProvider.lpGender = lSelectedGender.toString();
        parametersProvider.lpOccupation = lOccupation.text.toString();
        //

      }

      if (appProvider.addRider == true) {
        parametersProvider.riderSA = double.parse(riderAdded.text).toString();
        parametersProvider.premiumRider = premiumRider.toString();
        parametersProvider.totalPremium =
            (premiumNum + premiumRider).toString();
      } else {
        parametersProvider.riderSA = "0";
        parametersProvider.premiumRider = "0";
        parametersProvider.totalPremium = premiumNum.toString();
      }

      parametersProvider.policyTerm = selectedYear.toString();
      parametersProvider.annualP = premiumNum.toString();
      parametersProvider.basicSA = sumAssuredNum.toString();
      parametersProvider.paymentMode = selectedMode;
      parametersProvider.isOnPolicy = isOnPolicy;
      setState(() {
        appProvider.activeTabIndex = 1;
        appProvider.pdfScreenIndex = 0;
        appProvider.calculationPage = 0;
        parametersProvider.isKhmerSI = isKhmer;
      });
      Navigator.pushNamedAndRemoveUntil(context, '/main_flow', (_) => false);
    }
    //

    return SafeArea(
      child: SingleChildScrollView(
        controller: ScrollController(),
        child: Container(
          padding: EdgeInsets.symmetric(
              horizontal: DeviceUtils.getResponsive(
                  mq: mq,
                  appProvider: appProvider,
                  onPhone: 20.0,
                  onTablet: mq.size.width / 10),
              vertical: DeviceUtils.getResponsive(
                  mq: mq,
                  appProvider: appProvider,
                  onPhone: mq.size.height / 8,
                  onTablet: mq.size.height / 7)),
          child: Form(
            key: widget._formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomSwitch(
                  appProvider: appProvider,
                  mq: mq,
                  value: appProvider.differentPerson,
                  title: lang['buy_for_someone'],
                  onChanged: (bool) {
                    setState(() {
                      appProvider.differentPerson = bool;
                    });
                  },
                ),
                SizedBox(
                    height: DeviceUtils.getResponsive(
                        mq: mq,
                        appProvider: appProvider,
                        onPhone: 0.0,
                        onTablet: 25.0)),
                Visibility(
                  child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 5),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            FieldTitle(
                              fontSize: DeviceUtils.getResponsive(
                                  mq: mq,
                                  appProvider: appProvider,
                                  onPhone: 21.0,
                                  onTablet: 42.0),
                              fieldTitle: lang['proposer'],
                            ),
                            SizedBox(
                                height: DeviceUtils.getResponsive(
                                    mq: mq,
                                    appProvider: appProvider,
                                    onPhone: 10.0,
                                    onTablet: 20.0)),
                            Container(
                              width: mq.size.width,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: CustomTextField(
                                      appProvider: appProvider,
                                      mq: mq,
                                      formLabel: lang['first_name'],
                                      formInputType: TextInputType.name,
                                      formController: pFirstName,
                                      isRequired: false,
                                      maxLength: 10,
                                      errorVisible: false,
                                    ),
                                  ),
                                  SizedBox(
                                      width: DeviceUtils.getResponsive(
                                          mq: mq,
                                          appProvider: appProvider,
                                          onPhone: 5.0,
                                          onTablet: 10.0)),
                                  Expanded(
                                    child: CustomTextField(
                                      appProvider: appProvider,
                                      mq: mq,
                                      formLabel: lang['last_name'],
                                      maxLength: 10,
                                      isRequired: false,
                                      formInputType: TextInputType.name,
                                      formController: pLastName,
                                      errorVisible: false,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                                height: DeviceUtils.getResponsive(
                                    mq: mq,
                                    appProvider: appProvider,
                                    onPhone: 5.0,
                                    onTablet: 10.0)),
                            Container(
                              width: mq.size.width,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                      flex: 1,
                                      child: DisabledField(
                                          appProvider: appProvider,
                                          mq: mq,
                                          formController: pAge,
                                          title: lang['age'])),
                                  SizedBox(
                                      width: DeviceUtils.getResponsive(
                                          mq: mq,
                                          appProvider: appProvider,
                                          onPhone: 5.0,
                                          onTablet: 10.0)),
                                  Expanded(
                                      flex: 2,
                                      child: CustomDatePicker(
                                        appProvider: appProvider,
                                        mq: mq,
                                        title: lang['dob'],
                                        focusNode: AlwaysDisabledFocusNode(),
                                        dob: pDob,
                                        onTap: () {
                                          _selectDate(
                                              context, pDob, pAge, false);
                                        },
                                      )),
                                ],
                              ),
                            ),
                            SizedBox(
                                height: DeviceUtils.getResponsive(
                                    mq: mq,
                                    appProvider: appProvider,
                                    onPhone: 5.0,
                                    onTablet: 10.0)),
                            Container(
                              child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                        child: CustomDropDown(
                                      appProvider: appProvider,
                                      title: lang['gender'],
                                      value: pSelectedGender,
                                      isRequired: true,
                                      errorVisible: emptyGenderFieldP,
                                      items: genderTypes,
                                      onChange: (value) async {
                                        final prefs = await SharedPreferences
                                            .getInstance();
                                        setState(() {
                                          pSelectedGender = value;
                                          prefs.setString(
                                              "pGenderProtect", value);
                                        });
                                      },
                                    )),
                                    SizedBox(
                                        width: DeviceUtils.getResponsive(
                                            mq: mq,
                                            appProvider: appProvider,
                                            onPhone: 5.0,
                                            onTablet: 10.0)),
                                    Expanded(
                                      flex: 2,
                                      child: CustomTextField(
                                        appProvider: appProvider,
                                        mq: mq,
                                        formInputType: TextInputType.text,
                                        formLabel: lang['occupation'],
                                        maxLength: 22,
                                        isRequired: false,
                                        formController: pOccupation,
                                        errorVisible: false,
                                      ),
                                    )
                                  ]),
                            )
                          ])),
                  visible: appProvider.differentPerson,
                ),
                SizedBox(
                    height: DeviceUtils.getResponsive(
                        mq: mq,
                        appProvider: appProvider,
                        onPhone: 15.0,
                        onTablet: 30.0)),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 5),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      FieldTitle(
                        fontSize: DeviceUtils.getResponsive(
                            mq: mq,
                            appProvider: appProvider,
                            onPhone: 21.0,
                            onTablet: 42.0),
                        fieldTitle: lang['life_proposed'],
                      ),
                      SizedBox(
                          height: DeviceUtils.getResponsive(
                              mq: mq,
                              appProvider: appProvider,
                              onPhone: 10.0,
                              onTablet: 20.0)),
                      Container(
                        width: mq.size.width,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: CustomTextField(
                                appProvider: appProvider,
                                mq: mq,
                                formLabel: lang['first_name'],
                                formInputType: TextInputType.name,
                                isRequired: false,
                                formController: firstName,
                                maxLength: 10,
                                errorVisible: false,
                              ),
                            ),
                            SizedBox(
                                width: DeviceUtils.getResponsive(
                                    mq: mq,
                                    appProvider: appProvider,
                                    onPhone: 5.0,
                                    onTablet: 10.0)),
                            Expanded(
                              child: CustomTextField(
                                appProvider: appProvider,
                                mq: mq,
                                formLabel: lang['last_name'],
                                formInputType: TextInputType.name,
                                formController: lastName,
                                isRequired: false,
                                maxLength: 10,
                                errorVisible: false,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                          height: DeviceUtils.getResponsive(
                              mq: mq,
                              appProvider: appProvider,
                              onPhone: 5.0,
                              onTablet: 10.0)),
                      Container(
                        width: mq.size.width,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                                flex: 1,
                                child: DisabledField(
                                    appProvider: appProvider,
                                    mq: mq,
                                    formController: age,
                                    title: lang['age'])),
                            SizedBox(
                                width: DeviceUtils.getResponsive(
                                    mq: mq,
                                    appProvider: appProvider,
                                    onPhone: 5.0,
                                    onTablet: 10.0)),
                            Expanded(
                                flex: 2,
                                child: CustomDatePicker(
                                  appProvider: appProvider,
                                  mq: mq,
                                  title: lang['dob'],
                                  focusNode: AlwaysDisabledFocusNode(),
                                  dob: dob,
                                  onTap: () {
                                    _selectDate(context, dob, age, true);
                                  },
                                )),
                          ],
                        ),
                      ),
                      SizedBox(
                          height: DeviceUtils.getResponsive(
                              mq: mq,
                              appProvider: appProvider,
                              onPhone: 5.0,
                              onTablet: 10.0)),
                      Container(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                                child: CustomDropDown(
                              appProvider: appProvider,
                              title: lang['gender'],
                              value: lSelectedGender,
                              items: genderTypes,
                              isRequired: true,
                              errorVisible: emptyGenderField,
                              onChange: (value) async {
                                final prefs =
                                    await SharedPreferences.getInstance();
                                setState(() {
                                  lSelectedGender = value;
                                  prefs.setString("lpGenderProtect", value);
                                });
                              },
                            )),
                            SizedBox(
                                width: DeviceUtils.getResponsive(
                                    mq: mq,
                                    appProvider: appProvider,
                                    onPhone: 5.0,
                                    onTablet: 10.0)),
                            Expanded(
                              flex: 2,
                              child: CustomTextField(
                                appProvider: appProvider,
                                mq: mq,
                                formInputType: TextInputType.text,
                                formLabel: lang['occupation'],
                                maxLength: 22,
                                isRequired: false,
                                formController: lOccupation,
                                errorVisible: false,
                              ),
                            )
                          ],
                        ),
                      ),
                      SizedBox(
                          height: DeviceUtils.getResponsive(
                              mq: mq,
                              appProvider: appProvider,
                              onPhone: 5.0,
                              onTablet: 10.0)),
                      Container(
                        width: mq.size.width,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              flex: 1,
                              child: CustomDropDown(
                                appProvider: appProvider,
                                title: "Payment Mode",
                                value: selectedMode,
                                isRequired: true,
                                errorVisible: false,
                                items: paymentMode,
                                onChange: (value) async {
                                  final prefs =
                                      await SharedPreferences.getInstance();
                                  setState(() {
                                    selectedMode = value;
                                    prefs.setString(
                                        "selectedModeProtect", value);
                                  });
                                },
                              ),
                            ),
                            SizedBox(
                                width: DeviceUtils.getResponsive(
                                    mq: mq,
                                    appProvider: appProvider,
                                    onPhone: 5.0,
                                    onTablet: 10.0)),
                            Expanded(
                              flex: 1,
                              child: CustomDropDown(
                                appProvider: appProvider,
                                title: "Policy Year",
                                value: selectedYear,
                                isRequired: true,
                                items: policyYears,
                                errorVisible: false,
                                onChange: (value) {
                                  setState(() {
                                    selectedYear = value;
                                    if ((premium.text.isNotEmpty ||
                                            sumAssured.text.isNotEmpty) &&
                                        selectedMode.isNotEmpty) {
                                      if (premium.text.isNotEmpty) {
                                        premiumNum = double.parse(premium.text);
                                        sumAssuredNum = value * premiumNum;
                                        sumAssured.text =
                                            sumAssuredNum.toStringAsFixed(2);
                                      } else if (sumAssured.text.isNotEmpty) {
                                        sumAssuredNum =
                                            double.parse(sumAssured.text);
                                        premiumNum = sumAssuredNum / value;
                                        premium.text =
                                            premiumNum.toStringAsFixed(2);
                                      }
                                    }
                                  });
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                          height: DeviceUtils.getResponsive(
                              mq: mq,
                              appProvider: appProvider,
                              onPhone: 5.0,
                              onTablet: 10.0)),
                      CustomTextField(
                        appProvider: appProvider,
                        mq: mq,
                        formLabel: lang['premium'],
                        formInputType: TextInputType.numberWithOptions(
                            signed: true, decimal: true),
                        formController: premium,
                        maxLength: 9,
                        isRequired: true,
                        errorVisible: emptyPremiumField,
                        onChange: (text) {
                          if (selectedYear != null) {
                            if (text == "") {
                              sumAssured.text = "";
                            } else
                              premiumNum = double.parse(text);
                            sumAssuredNum = premiumNum * selectedYear;
                            sumAssured.text = sumAssuredNum.toStringAsFixed(2);
                          } else {
                            sumAssured.text = null;
                          }
                        },
                      ),
                      SizedBox(
                          height: DeviceUtils.getResponsive(
                              mq: mq,
                              appProvider: appProvider,
                              onPhone: 5.0,
                              onTablet: 10.0)),
                      CustomTextField(
                        appProvider: appProvider,
                        mq: mq,
                        formLabel: lang['sum_assured'],
                        formInputType: TextInputType.numberWithOptions(
                            signed: true, decimal: true),
                        formController: sumAssured,
                        isRequired: true,
                        maxLength: 10,
                        errorVisible: emptySumField,
                        onChange: (text) {
                          if (selectedYear != null) {
                            if (text.toString().isEmpty) {
                              premium.clear();
                            } else
                              sumAssuredNum = double.parse(text);
                            premiumNum = sumAssuredNum / selectedYear;
                            premium.text = premiumNum.toStringAsFixed(2);
                          } else {
                            premium.clear();
                          }
                        },
                      ),
                    ],
                  ),
                ),
                SizedBox(
                    height: DeviceUtils.getResponsive(
                        mq: mq,
                        appProvider: appProvider,
                        onPhone: 0.0,
                        onTablet: 10.0)),
                CustomSwitch(
                  appProvider: appProvider,
                  mq: mq,
                  value: appProvider.addRider,
                  title: lang['add_rider'],
                  onChanged: (bool) {
                    setState(() {
                      appProvider.addRider = bool;
                    });
                  },
                ),
                Visibility(
                    visible: appProvider.addRider,
                    child: Padding(
                      padding: EdgeInsets.only(left: 5, right: 5, bottom: 5),
                      child: CustomTextField(
                        appProvider: appProvider,
                        mq: mq,
                        formInputType: TextInputType.numberWithOptions(
                            signed: true, decimal: true),
                        formLabel: lang['add_rider'],
                        isRequired: true,
                        maxLength: 10,
                        formController: riderAdded,
                        errorVisible: false,
                      ),
                    )),
                SizedBox(
                    height: DeviceUtils.getResponsive(
                        mq: mq,
                        appProvider: appProvider,
                        onPhone: 0.0,
                        onTablet: 10.0)),
                Padding(
                  padding: EdgeInsets.all(5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                          flex: 3,
                          child: Text(lang['language'],
                              style: TextStyle(
                                  fontFamily: "Kano",
                                  fontSize: DeviceUtils.getResponsive(
                                      mq: mq,
                                      appProvider: appProvider,
                                      onPhone: 15.0,
                                      onTablet: 30.0),
                                  fontWeight: FontWeight.w700,
                                  color: Colors.black.withOpacity(0.5)))),
                      Expanded(
                        flex: 1,
                        child: CustomDropDown(
                          appProvider: appProvider,
                          title: "Language",
                          errorVisible: false,
                          isRequired: false,
                          value: isKhmer,
                          items: languageSI,
                          onChange: (value) async {
                            setState(() {
                              isKhmer = value;
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                    height: DeviceUtils.getResponsive(
                        mq: mq,
                        appProvider: appProvider,
                        onPhone: 0.0,
                        onTablet: 10.0)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 5),
                      child: CalculateButton(
                          calcTitle: lang['calculate_button'],
                          fontSize: DeviceUtils.getResponsive(
                              mq: mq,
                              appProvider: appProvider,
                              onPhone: 15.0,
                              onTablet: 21.0),
                          btnWidth: DeviceUtils.getResponsive(
                              mq: mq,
                              appProvider: appProvider,
                              onPhone: 100.0,
                              onTablet: 140.0),
                          btnHeight: DeviceUtils.getResponsive(
                              mq: mq,
                              appProvider: appProvider,
                              onPhone: 50.0,
                              onTablet: 70.0),
                          onPressed: () async {
                            if (widget._formKey.currentState.validate()) {
                              counter = 0;
                              customDialogChildren.clear();
                              widget._formKey.currentState.save();
                              await saveTextValues();
                              if (appProvider.differentPerson == true) {
                                if (appProvider.addRider) {
                                  sumAssuredValidation(
                                      sumAssured.text, selectedYear);
                                  premiumValidation(premium.text);
                                  ageValidation(age.text, pAge.text,
                                      selectedYear, true, true);
                                  addedRiderValidation(
                                      riderAdded.text, sumAssured.text);
                                  genderValidation(
                                      lSelectedGender, pSelectedGender, true);
                                  if (counter == 6) {
                                    await getRate(isMale(lSelectedGender),
                                        int.parse(age.text), selectedYear);
                                    calculateAndPDF();
                                  } else
                                    showAlertDialog(context);
                                } else {
                                  sumAssuredValidation(
                                      sumAssured.text, selectedYear);
                                  premiumValidation(premium.text);
                                  ageValidation(age.text, pAge.text,
                                      selectedYear, true, false);
                                  genderValidation(
                                      lSelectedGender, pSelectedGender, true);
                                  if (counter == 5) {
                                    calculateAndPDF();
                                  } else
                                    showAlertDialog(context);
                                }
                              } else {
                                if (appProvider.addRider) {
                                  sumAssuredValidation(
                                      sumAssured.text, selectedYear);
                                  premiumValidation(premium.text);
                                  ageValidation(age.text, pAge.text,
                                      selectedYear, false, true);
                                  addedRiderValidation(
                                      riderAdded.text, sumAssured.text);
                                  genderValidation(
                                      lSelectedGender, pSelectedGender, false);
                                  if (counter == 5) {
                                    await getRate(isMale(lSelectedGender),
                                        int.parse(age.text), selectedYear);
                                    calculateAndPDF();
                                  } else
                                    showAlertDialog(context);
                                } else {
                                  sumAssuredValidation(
                                      sumAssured.text, selectedYear);
                                  premiumValidation(premium.text);
                                  ageValidation(age.text, pAge.text,
                                      selectedYear, false, false);
                                  genderValidation(
                                      lSelectedGender, pSelectedGender, false);
                                  if (counter == 4) {
                                    calculateAndPDF();
                                  } else
                                    showAlertDialog(context);
                                }
                              }
                            } else {
                              customDialogChildren.add(CustomDialogText(
                                description: "No Inputs",
                              ));
                              showAlertDialog(context);
                            }
                          }),
                    ),
                    Padding(
                        padding: EdgeInsets.all(5),
                        child: ResetButton(
                          calcTitle: lang['reset_button'],
                          fontSize: DeviceUtils.getResponsive(
                              mq: mq,
                              appProvider: appProvider,
                              onPhone: 15.0,
                              onTablet: 21.0),
                          btnWidth: DeviceUtils.getResponsive(
                              mq: mq,
                              appProvider: appProvider,
                              onPhone: 100.0,
                              onTablet: 140.0),
                          btnHeight: DeviceUtils.getResponsive(
                              mq: mq,
                              appProvider: appProvider,
                              onPhone: 50.0,
                              onTablet: 70.0),
                          onPressed: () async {
                            final prefs = await SharedPreferences.getInstance();
                            //Proposer
                            pFirstName.clear();
                            pLastName.clear();
                            pAge.clear();
                            pDob.clear();
                            prefs.remove("pDobProtect");
                            prefs.remove("pAgeProtect");
                            pGender.clear();
                            pOccupation.clear();
                            //

                            //Life Proposed
                            firstName.clear();
                            lastName.clear();
                            age.clear();
                            dob.clear();
                            if (age.text.isNotEmpty) {
                              prefs.remove("ageProtect");
                            }
                            if (dob.text.isNotEmpty) {
                              prefs.remove("lpDobProtect");
                            }
                            sumAssured.clear();
                            sumAssuredNum = 0;
                            premium.clear();
                            premiumNum = 0;
                            gender.clear();
                            lOccupation.clear();

                            riderAdded.clear();

                            lSelectedGender = "Male";
                            pSelectedGender = "Male";
                            selectedYear = 10;
                          },
                        ))
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Date Picker Function
  _selectDate(BuildContext context, TextEditingController tec,
      TextEditingController tecAge, bool isLpAge) async {
    final prefs = await SharedPreferences.getInstance();
    String premVal = prefs.getString("premVal");
    String sumVal = prefs.getString("sumVal");
    if (premiumNum != null) {
      prefs.setString("premVal", premiumNum.toString());
      premVal = prefs.getString("premVal");
    }
    if (sumAssuredNum != null) {
      prefs.setString("sumVal", sumAssuredNum.toString());
      sumVal = prefs.getString("sumVal");
    }
    DateTime newSelectedDate = await showDatePicker(
        context: context,
        initialDate: _selectedDate != null ? _selectedDate : DateTime.now(),
        firstDate: DateTime(1940),
        lastDate: DateTime.now(),
        builder: (BuildContext context, Widget child) {
          return Theme(
            data: ThemeData.dark().copyWith(
              colorScheme: ColorScheme.light(
                primary: Color(0xFF8AB84B),
                onPrimary: Colors.white,
                surface: Color(0xFF8AB84B),
                onSurface: Colors.black,
              ),
              dialogBackgroundColor: Colors.white,
            ),
            child: child,
          );
        });

    if (newSelectedDate != null) {
      _selectedDate = newSelectedDate;
      String dateTime = _selectedDate.toString();
      tec.text = convertDateTimeDisplay(dateTime);
      tec.selection = TextSelection.fromPosition(TextPosition(
          offset: dob.text.length, affinity: TextAffinity.upstream));
      tecAge.text = calculateAge(_selectedDate, isLpAge);
      if (isLpAge) {
        prefs.setString("lpDobProtectDate", dateTime);
        prefs.setString("lpDobProtect", dob.text);
        prefs.setString("ageProtect", age.text);
      } else {
        prefs.setString("pDobProtectDate", dateTime);
        prefs.setString("pDobProtect", pDob.text);
        prefs.setString("pAgeProtect", pAge.text);
      }
    }

    premium.text = (premVal.isEmpty || premVal == null)
        ? ''
        : double.tryParse(premVal).toString();
    if (premVal == null) {
      premium.clear();
    }
    sumAssured.text = (sumVal.isEmpty || sumVal == null)
        ? ''
        : double.tryParse(sumVal).toString();
    if (sumVal == null) {
      sumAssured.clear();
    }
  }

//

  //Save Text Values
  Future<void> saveTextValues() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString("fName", firstName.text);
    prefs.setString("lName", lastName.text);
    prefs.setString("lOcc", lOccupation.text);
    prefs.setString("lpDobProtect", dob.text);
    prefs.setString("premVal", premiumNum.toString());
    prefs.setString("sumVal", sumAssuredNum.toString());
    prefs.setString("pName", pFirstName.text);
    prefs.setString("pLName", pLastName.text);
    prefs.setString("pOcc", pOccupation.text);
  }
  //

// Calculate age from datepicker
  calculateAge(DateTime birthDate, bool isLpAge) {
    int age = _currentDate.year - birthDate.year;
    int month1 = _currentDate.month;
    int month2 = birthDate.month;
    if (month2 > month1) {
      age--;
    } else if (month1 == month2) {
      int day1 = _currentDate.day;
      int day2 = birthDate.day;
      if (day2 > day1) {
        age--;
      }
    }
    if (isLpAge) {
      lpBirthDate = birthDate;
      sumAssured.clear();
      premium.clear();
    }
    return age.toString();
  }
  //

  //Convert DateTime format to Date form
  String convertDateTimeDisplay(String date) {
    final DateFormat displayFormatter = DateFormat('yyyy-MM-dd HH:mm:ss.SSS');
    final DateFormat serverFormatter = DateFormat('dd-MM-yyyy');
    final DateTime displayDate = displayFormatter.parse(date);
    final String formatted = serverFormatter.format(displayDate);
    return formatted;
  }
  //

  //Check whether the birthdate is before or after the date the plan is bought
  bool isOnPolicyStatus(DateTime birthDate) {
    if (birthDate.month == _currentDate.month &&
        birthDate.day == _currentDate.day)
      return true;
    else
      return false;
  }
  //

  //Validate Age
  void ageValidation(String ageText, String pAgeText, int policyTerm,
      bool isDifferentPerson, bool isAddRider) {
    if (isDifferentPerson == false) {
      if (ageText.isEmpty) {
        customDialogChildren.add(CustomDialogText(
          description: "Age field can't be empty",
        ));
      } else {
        if ((int.parse(ageText) + policyTerm) > 69) {
          customDialogChildren.add(CustomDialogText(
            description: "Age limit exceeded, please check information page.",
          ));
        } else if (int.parse(ageText) < 18) {
          customDialogChildren.add(CustomDialogText(
            description: "Age under 18, please check information page",
          ));
        } else {
          counter++;
        }
      }
    } else {
      if (ageText.isEmpty || pAgeText.isEmpty) {
        customDialogChildren.add(CustomDialogText(
          description: "Age field can't be empty",
        ));
      } else {
        if (((int.parse(ageText) + policyTerm) > 69) ||
            (int.parse(pAgeText) < 18) ||
            (isAddRider == false && int.parse(ageText) < 1) ||
            int.parse(ageText) > 59 ||
            (isAddRider == true && (int.parse(ageText) < 18))) {
          if ((int.parse(ageText) + policyTerm) > 69) {
            customDialogChildren.add(CustomDialogText(
              description: "Age limit exceeded, please check information page.",
            ));
          }
          if (int.parse(pAgeText) < 18) {
            customDialogChildren.add(CustomDialogText(
              description: "Age under 18, please check information page",
            ));
          }
          if (isAddRider == false && (int.parse(ageText) < 1)) {
            customDialogChildren.add(CustomDialogText(
              description: "Life Proposed's age must be at least 1 year old",
            ));
          }
          if (isAddRider == true && (int.parse(ageText) < 18)) {
            customDialogChildren.add(CustomDialogText(
              description:
                  "Life Proposed's age must be at least 18 years old to add rider",
            ));
          }
          if (int.parse(ageText) > 59) {
            customDialogChildren.add(CustomDialogText(
              description:
                  "Life Proposed's age is limited to at most 59 years old",
            ));
          }
        } else {
          isOnPolicy = isOnPolicyStatus(lpBirthDate);
          counter += 2;
        }
      }
    }
  }
  //

  //Validate Added Rider
  void addedRiderValidation(String riderAmount, String sumAssuredAmount) {
    if (riderAmount.isEmpty) {
      customDialogChildren.add(CustomDialogText(
        description: "Rider can't be empty",
      ));
    } else {
      if (regExpNum.hasMatch(riderAmount) == false) {
        customDialogChildren.add(CustomDialogText(
          description: "Rider entered is not a number",
        ));
      } else if (double.parse(riderAmount) < 0) {
        customDialogChildren.add(CustomDialogText(
          description: "Rider can't be 0 or a negative amount",
        ));
      } else {
        if (double.parse(riderAmount) < 3600) {
          customDialogChildren.add(CustomDialogText(
            description: "Rider must be at least 3600 USD",
          ));
        } else if (double.parse(riderAmount) >
            (double.parse(sumAssuredAmount) * 5)) {
          customDialogChildren.add(CustomDialogText(
            description:
                "Rider is currently limited, please check information page",
          ));
        } else
          counter++;
      }
    }
  }
  //

  //Validate Sum Assured
  void sumAssuredValidation(String sumAssuredAmount, int policyTerm) {
    if (sumAssuredAmount.isEmpty) {
      customDialogChildren.add(CustomDialogText(
        description: "Sum Assured can't be empty",
      ));
    } else {
      if (regExpNum.hasMatch(sumAssuredAmount) == false) {
        customDialogChildren.add(CustomDialogText(
          description: "Sum Assured entered is not a number",
        ));
      } else if (double.parse(sumAssuredAmount) < 0) {
        customDialogChildren.add(CustomDialogText(
          description: "Sum Assured can't be 0 or a negative amount",
        ));
      } else {
        switch (policyTerm) {
          case 10:
            {
              if (double.parse(sumAssuredAmount) < 2400) {
                customDialogChildren.add(CustomDialogText(
                  description:
                      "For Policy Term (10): Sum Assured must be at least 2400 USD",
                ));
              } else
                counter++;
              break;
            }
          case 15:
            {
              if (double.parse(sumAssuredAmount) < 3600) {
                customDialogChildren.add(CustomDialogText(
                  description:
                      "For Policy Term (15): Sum Assured must be at least 3600 USD",
                ));
              } else
                counter++;

              break;
            }
          case 20:
            {
              if (double.parse(sumAssuredAmount) < 4800) {
                customDialogChildren.add(CustomDialogText(
                  description:
                      "For Policy Term (20): Sum Assured must be at least 4800 USD",
                ));
              } else
                counter++;
              break;
            }
          case 25:
            {
              if (double.parse(sumAssuredAmount) < 6000) {
                customDialogChildren.add(CustomDialogText(
                  description:
                      "For Policy Term (25): Sum Assured must be at least 6000 USD",
                ));
              } else
                counter++;

              break;
            }
          case 30:
            {
              if (double.parse(sumAssuredAmount) < 7200) {
                customDialogChildren.add(CustomDialogText(
                  description:
                      "For Policy Term (30): Sum Assured must be at least 7200 USD",
                ));
              } else
                counter++;

              break;
            }
          case 35:
            {
              if (double.parse(sumAssuredAmount) < 8400) {
                customDialogChildren.add(CustomDialogText(
                  description:
                      "For Policy Term (35): Sum Assured must be at least 8400 USD",
                ));
              } else
                counter++;

              break;
            }
        }
      }
    }
  }
  //

  //Validate Sum Assured
  void premiumValidation(String premiumAmount) {
    if (premiumAmount.isEmpty || premiumAmount == null) {
      if (premiumAmount.isEmpty) {
        customDialogChildren.add(CustomDialogText(
          description: "Premium can't be empty",
        ));
      } else
        customDialogChildren.add(CustomDialogText(
          description: "Premium can't be null",
        ));
    } else {
      if (regExpNum.hasMatch(premiumAmount) == false) {
        customDialogChildren.add(CustomDialogText(
          description: "Premium entered is not a number",
        ));
      } else if (double.parse(premiumAmount) <= 0) {
        customDialogChildren.add(CustomDialogText(
          description: "Premium can't be 0 or a negative amount",
        ));
      } else if (((double.parse(premiumAmount) > 0) &&
          (double.parse(premiumAmount) < 240))) {
        customDialogChildren.add(CustomDialogText(
          description: "Premium must be at least 240 USD",
        ));
      } else
        counter++;
    }
  }
  //

  //Gender Emptiness Validation
  void genderValidation(
      String lGenderText, String pGenderText, bool isDifferentPerson) {
    if (isDifferentPerson) {
      if (lGenderText == null || pGenderText == null) {
        customDialogChildren.add(CustomDialogText(
          description: "Gender field can't be empty",
        ));
      } else
        counter++;
    } else {
      if (lGenderText == null) {
        customDialogChildren.add(CustomDialogText(
          description: "Gender field can't be empty",
        ));
      } else
        counter++;
    }
  }
  //

  //Validate Gender
  bool isMale(String selectedGender) {
    if (selectedGender == "Male") {
      return true;
    } else {
      return false;
    }
  }
  //

  @override
  void dispose() {
    super.dispose();
  }
}

class AlwaysDisabledFocusNode extends FocusNode {
  @override
  bool get hasFocus => false;
}
