import 'package:excel/excel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:forte_life/constants/constants.dart';
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
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey("valueP") && !prefs.containsKey("valueLP")) {
      await getAmountValues();
      await getValues();
    }
    pFirstName.addListener(getAmountValues);
    pLastName.addListener(getAmountValues);
    pAge.addListener(getAmountValues);
    pOccupation.addListener(getAmountValues);

    firstName.addListener(getAmountValues);
    lastName.addListener(getAmountValues);
    lOccupation.addListener(getAmountValues);
    age.addListener(getAmountValues);
    premium.addListener(getAmountValues);
    sumAssured.addListener(getAmountValues);
    riderAdded.addListener(getAmountValues);
    if (prefs.containsKey("valueP") && prefs.containsKey("valueLP")) {
      await getValues();
    }
  }

  Future<void> getValues() async {
    final prefs = await SharedPreferences.getInstance();
    List<String> valueLP = prefs.getStringList("valueLP");
    List<String> valueP = prefs.getStringList("valueP");
    //
    String fName = valueLP[0];
    String lName = valueLP[1];
    String ageProtect = valueLP[2];
    String lOcc = valueLP[3];
    String premVal = valueLP[4];
    String sumVal = valueLP[5];
    String riderVal = valueLP[6];
    String pName = valueP[0];
    String pLName = valueP[1];
    String pAgeProtect = valueP[2];
    String pOcc = valueP[3];
    //
    //
    String dobProtect = prefs.getString("lpDobProtect");
    String pDobProtect = prefs.getString("pDobProtect");
    String dobProtectDate = prefs.getString("lpDobProtectDate");
    String lpGenderProtect = prefs.getString("lpGenderProtect");
    String pGenderProtect = prefs.getString("pGenderProtect");
    String selectedModeProtect = prefs.getString("selectedModeProtect");
    int selYear = prefs.getInt("selYearInt");
    //
    //Rider Limit
    riderLimit = prefs.getInt(RIDER_AMOUNT);
    //
    firstName.text = fName == null ? '' : fName;
    lastName.text = lName == null ? '' : lName;
    lOccupation.text = lOcc == null ? '' : lOcc;
    setState(() {
      lSelectedGender = lpGenderProtect == null ? null : lpGenderProtect;
    });
    setState(() {
      pSelectedGender = pGenderProtect == null ? null : pGenderProtect;
    });
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
    premium.text = premVal == null ? '' : premVal;

    premiumNum = (premium.text == null) ? '' : double.tryParse(premium.text);
    sumAssured.text = sumVal == null ? '' : sumVal;
    sumAssuredNum =
        (sumAssured.text == null) ? '' : double.tryParse(sumAssured.text);
    if (sumAssuredNum == null) {
      sumAssured.clear();
    }

    riderAdded.text = riderVal == null ? '' : riderVal;
    pFirstName.text = pName == null ? '' : pName;
    pLastName.text = pLName == null ? '' : pLName;
    pOccupation.text = pOcc == null ? '' : pOcc;
  }

  Future<void> getAmountValues() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setStringList("valueLP", [
      firstName.text,
      lastName.text,
      age.text,
      lOccupation.text,
      premium.text,
      sumAssured.text,
      riderAdded.text
    ]);
    prefs.setStringList("valueP",
        [pFirstName.text, pLastName.text, pAge.text, pOccupation.text]);
    prefs.setInt("selYearInt", selectedYear);
    prefs.setString("lpGenderProtect", lSelectedGender);
    prefs.setString("pGenderProtect", pSelectedGender);
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
  int riderLimit;
  DateTime lpBirthDate;
  bool isOnPolicy = false;
  bool isKhmer = false;

  List<Widget> customDialogChildren = List();

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
    List<DropdownMenuItem> paymentMode = [
      DropdownMenuItem(
          child: DropDownText(
            title: lang['yearly'],
          ),
          value: "Yearly"),
      DropdownMenuItem(
          child: DropDownText(
            title: lang['half_yearly'],
          ),
          value: "Half-yearly"),
      DropdownMenuItem(
          child: DropDownText(
            title: lang['quarterly'],
          ),
          value: "Quarterly"),
      DropdownMenuItem(
          child: DropDownText(
            title: lang['monthly'],
          ),
          value: "Monthly")
    ];
    List<DropdownMenuItem> genderTypes = [
      DropdownMenuItem(
          child: DropDownText(
            title: lang['male'],
          ),
          value: "Male"),
      DropdownMenuItem(
          child: DropDownText(
            title: lang['female'],
          ),
          value: "Female")
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
                                lang['error_inputs'],
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
                                    lang['info'],
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
                                    lang['ok'],
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
            appProvider.language != 'kh'
                ? firstName.text.toString() + " " + lastName.text.toString()
                : lastName.text.toString() + " " + firstName.text.toString();
        parametersProvider.pAge =
            parametersProvider.lpAge = age.text.toString();
        parametersProvider.pGender =
            parametersProvider.lpGender = lSelectedGender.toString();
        parametersProvider.pOccupation =
            parametersProvider.lpOccupation = lOccupation.text.toString();
      } else {
        //Proposer
        parametersProvider.pName = appProvider.language != 'kh'
            ? pFirstName.text.toString() + " " + pLastName.text.toString()
            : pLastName.text.toString() + " " + pFirstName.text.toString();
        parametersProvider.pAge = pAge.text.toString();
        parametersProvider.pGender = pSelectedGender.toString();
        parametersProvider.pOccupation = pOccupation.text.toString();
        //

        //Life Proposed
        parametersProvider.lpName = appProvider.language != 'kh'
            ? firstName.text.toString() + " " + lastName.text.toString()
            : lastName.text.toString() + " " + firstName.text.toString();
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
                              fieldTitle: lang['proposer_protect'],
                            ),
                            SizedBox(
                                height: DeviceUtils.getResponsive(
                                    mq: mq,
                                    appProvider: appProvider,
                                    onPhone: 10.0,
                                    onTablet: 20.0)),
                            Container(
                              width: mq.size.width,
                              height: DeviceUtils.getResponsive(
                                  mq: mq,
                                  appProvider: appProvider,
                                  onPhone: 65.0,
                                  onTablet: 130.0),
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
                              height: DeviceUtils.getResponsive(
                                  mq: mq,
                                  appProvider: appProvider,
                                  onPhone: 65.0,
                                  onTablet: 130.0),
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
                              height: DeviceUtils.getResponsive(
                                  mq: mq,
                                  appProvider: appProvider,
                                  onPhone: 65.0,
                                  onTablet: 130.0),
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
                                        if (!prefs.containsKey("valueP") &&
                                            !prefs.containsKey("valueLP")) {
                                          await getAmountValues();
                                          await getValues();
                                        }
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
                        height: DeviceUtils.getResponsive(
                            mq: mq,
                            appProvider: appProvider,
                            onPhone: 65.0,
                            onTablet: 130.0),
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
                        height: DeviceUtils.getResponsive(
                            mq: mq,
                            appProvider: appProvider,
                            onPhone: 65.0,
                            onTablet: 130.0),
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
                        height: DeviceUtils.getResponsive(
                            mq: mq,
                            appProvider: appProvider,
                            onPhone: 65.0,
                            onTablet: 130.0),
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
                                  getAmountValues();
                                  getValues();
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
                        height: DeviceUtils.getResponsive(
                            mq: mq,
                            appProvider: appProvider,
                            onPhone: 65.0,
                            onTablet: 130.0),
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
                                title: lang['policy'] + "",
                                value: selectedYear,
                                isRequired: true,
                                items: policyYears,
                                errorVisible: false,
                                onChange: (value) async {
                                  final prefs =
                                      await SharedPreferences.getInstance();
                                  setState(() {
                                    selectedYear = value;
                                    prefs.setInt("selYearInt", value);
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
                      Container(
                        height: DeviceUtils.getResponsive(
                            mq: mq,
                            appProvider: appProvider,
                            onPhone: 65.0,
                            onTablet: 130.0),
                        child: CustomTextField(
                          appProvider: appProvider,
                          mq: mq,
                          formLabel: lang['premium'],
                          formInputType: TextInputType.numberWithOptions(
                              signed: true, decimal: true),
                          formController: premium,
                          maxLength: 8,
                          isRequired: true,
                          errorVisible: emptyPremiumField,
                          onChange: (text) {
                            if (selectedYear != null) {
                              if (text == "") {
                                sumAssured.text = "";
                              } else
                                premiumNum =
                                    text != null ? double.parse(text) : 0;
                              sumAssuredNum = premiumNum * selectedYear;
                              sumAssured.text =
                                  sumAssuredNum.toStringAsFixed(2);
                            } else {
                              sumAssured.text = null;
                            }
                          },
                        ),
                      ),
                      SizedBox(
                          height: DeviceUtils.getResponsive(
                              mq: mq,
                              appProvider: appProvider,
                              onPhone: 5.0,
                              onTablet: 10.0)),
                      Container(
                        height: DeviceUtils.getResponsive(
                            mq: mq,
                            appProvider: appProvider,
                            onPhone: 65.0,
                            onTablet: 130.0),
                        child: CustomTextField(
                          appProvider: appProvider,
                          mq: mq,
                          formLabel: lang['sum_assured'],
                          formInputType: TextInputType.numberWithOptions(
                              signed: true, decimal: true),
                          formController: sumAssured,
                          isRequired: true,
                          maxLength: 9,
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
                      ),
                    ],
                  ),
                ),
                SizedBox(
                    height: DeviceUtils.getResponsive(
                        mq: mq,
                        appProvider: appProvider,
                        onPhone: 5.0,
                        onTablet: 20.0)),
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
                    child: Container(
                      height: DeviceUtils.getResponsive(
                          mq: mq,
                          appProvider: appProvider,
                          onPhone: 65.0,
                          onTablet: 75.0),
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
                              onTablet: 30.0),
                          btnWidth: DeviceUtils.getResponsive(
                              mq: mq,
                              appProvider: appProvider,
                              onPhone: 100.0,
                              onTablet: 200.0),
                          btnHeight: DeviceUtils.getResponsive(
                              mq: mq,
                              appProvider: appProvider,
                              onPhone: 50.0,
                              onTablet: 100.0),
                          onPressed: () async {
                            if (widget._formKey.currentState.validate()) {
                              counter = 0;
                              customDialogChildren.clear();
                              widget._formKey.currentState.save();
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
                                description: lang['no_input'],
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
                              onTablet: 30.0),
                          btnWidth: DeviceUtils.getResponsive(
                              mq: mq,
                              appProvider: appProvider,
                              onPhone: 100.0,
                              onTablet: 200.0),
                          btnHeight: DeviceUtils.getResponsive(
                              mq: mq,
                              appProvider: appProvider,
                              onPhone: 50.0,
                              onTablet: 100.0),
                          onPressed: () async {
                            final prefs = await SharedPreferences.getInstance();
                            //Proposer
                            pFirstName.clear();
                            pLastName.clear();
                            pAge.clear();
                            pDob.clear();
                            pGender.clear();
                            pOccupation.clear();
                            prefs.remove("valueP");
                            //

                            //Life Proposed
                            firstName.clear();
                            lastName.clear();
                            age.clear();
                            dob.clear();
                            sumAssured.clear();
                            sumAssuredNum = null;
                            premium.clear();
                            premiumNum = null;
                            gender.clear();
                            lOccupation.clear();
                            riderAdded.clear();
                            selectedYear = 10;
                            prefs.remove("valueLP");
                            //

                            //
                            setState(() {
                              lSelectedGender = null;
                              pSelectedGender = null;
                              selectedMode = "Yearly";
                            });
                            prefs.remove("lpDobProtect");
                            prefs.remove("pDobProtect");
                            prefs.remove("lpDobProtectDate");
                            prefs.remove("lpGenderProtect");
                            prefs.remove("pGenderProtect");
                            prefs.remove("selectedModeProtect");
                            //
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
    final appProvider = Provider.of<AppProvider>(context, listen: false);
    String sumVal = sumAssured.text;
    String premVal = premium.text;

    DateTime newSelectedDate = await showDatePicker(
        context: context,
        locale: appProvider.language != 'kh'
            ? const Locale("en", "EN")
            : const Locale("km", "KM"),
        initialDate: _selectedDate != null ? _selectedDate : DateTime.now(),
        firstDate: DateTime(1940),
        lastDate: DateTime.now(),
        initialDatePickerMode: DatePickerMode.year,
        builder: (BuildContext context, Widget child) {
          return Theme(
            data: ThemeData.light().copyWith(
              primaryColor: Color(0xFF8AB84B),
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
      setState(() {
        _selectedDate = newSelectedDate;
        String dateTime = _selectedDate.toString();
        tec.text = convertDateTimeDisplay(dateTime);
        tec.selection = TextSelection.fromPosition(TextPosition(
            offset: dob.text.length, affinity: TextAffinity.upstream));
        tecAge.text = calculateAge(_selectedDate, isLpAge);
        if (isLpAge) {
          prefs.setString("lpDobProtectDate", dateTime);
          prefs.setString("lpDobProtect", tec.text);
          getAmountValues();
        } else {
          prefs.setString("pDobProtectDate", dateTime);
          prefs.setString("pDobProtect", tec.text);
          getAmountValues();
        }
      });
    }
    getAmountValues();
    if (sumVal.isNotEmpty || premVal.isNotEmpty) {
      if (premVal.isNotEmpty) {
        sumVal = (double.parse(premVal) * selectedYear).toString();
      } else {
        premVal = (double.parse(sumVal) / selectedYear).toString();
      }
    } else if (sumVal.isNotEmpty && premVal.isNotEmpty) {
      sumVal = (double.parse(premVal) * selectedYear).toString();
    }
    premium.text = premVal.isNotEmpty ? premVal : '';
    sumAssured.text = sumVal.isNotEmpty ? sumVal : '';
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
    AppProvider appProvider = Provider.of<AppProvider>(context, listen: false);
    Map<String, dynamic> lang = appProvider.lang;
    if (isDifferentPerson == false) {
      if (ageText.isEmpty) {
        customDialogChildren.add(CustomDialogText(
          description: lang['age_empty'],
        ));
      } else {
        if ((int.parse(ageText) + policyTerm) > 69) {
          customDialogChildren.add(CustomDialogText(
            description: lang['pro_exceeded'],
          ));
        } else if (int.parse(ageText) < 18) {
          customDialogChildren.add(CustomDialogText(
            description: lang['pro_under18'],
          ));
        } else {
          counter++;
        }
      }
    } else {
      if (ageText.isEmpty || pAgeText.isEmpty) {
        customDialogChildren.add(CustomDialogText(
          description: lang['age_empty'],
        ));
      } else {
        if (((int.parse(ageText) + policyTerm) > 69) ||
            (int.parse(pAgeText) < 18) ||
            (isAddRider == false && int.parse(ageText) < 1) ||
            int.parse(ageText) > 59 ||
            (isAddRider == true && (int.parse(ageText) < 18))) {
          if ((int.parse(ageText) + policyTerm) > 69) {
            customDialogChildren.add(CustomDialogText(
              description: lang['pro_exceeded'],
            ));
          }
          if (int.parse(pAgeText) < 18) {
            customDialogChildren.add(CustomDialogText(
              description: lang['pro_under18'],
            ));
          }
          if (isAddRider == false && (int.parse(ageText) < 1)) {
            customDialogChildren.add(CustomDialogText(
              description: lang['pro_under18'],
            ));
          }
          if (isAddRider == true && (int.parse(ageText) < 18)) {
            customDialogChildren.add(CustomDialogText(
              description: lang['pro_under18'],
            ));
          }
          if (int.parse(ageText) > 59) {
            customDialogChildren.add(CustomDialogText(
              description: lang['pro_exceeded'],
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
    AppProvider appProvider = Provider.of<AppProvider>(context, listen: false);
    Map<String, dynamic> lang = appProvider.lang;
    if (riderAmount.isEmpty) {
      customDialogChildren.add(CustomDialogText(
        description: lang['rider_empty'],
      ));
    } else if (sumAssuredAmount.isEmpty) {
      customDialogChildren.add(CustomDialogText(
        description: lang['sumassured_empty'],
      ));
    } else {
      if (regExpNum.hasMatch(riderAmount) == false) {
        customDialogChildren.add(CustomDialogText(
          description: lang['rider_num'],
        ));
      } else if (double.parse(riderAmount) < 0) {
        customDialogChildren.add(CustomDialogText(
          description: lang['rider_0'],
        ));
      } else if (sumAssuredAmount.isNotEmpty) {
        if (double.parse(riderAmount) < 3600) {
          customDialogChildren.add(CustomDialogText(
            description: lang['rider_under3600'],
          ));
        } else if (double.tryParse(riderAmount) >
            (double.tryParse(sumAssuredAmount) *
                double.tryParse(riderLimit.toString()))) {
          customDialogChildren.add(CustomDialogText(
            description: lang['rider_exceeded'],
          ));
        } else
          counter++;
      }
    }
  }
  //

  //Validate Sum Assured
  void sumAssuredValidation(String sumAssuredAmount, int policyTerm) {
    AppProvider appProvider = Provider.of<AppProvider>(context, listen: false);
    Map<String, dynamic> lang = appProvider.lang;
    if (sumAssuredAmount.isEmpty) {
      customDialogChildren.add(CustomDialogText(
        description: lang['sumassured_empty'],
      ));
    } else if (premium.text.isEmpty) {
    } else if (double.parse(premium.text.toString()) < 240) {
    } else {
      if (regExpNum.hasMatch(sumAssuredAmount) == false) {
        customDialogChildren.add(CustomDialogText(
          description: lang['sumassured_num'],
        ));
      } else if (double.parse(sumAssuredAmount) < 0) {
        customDialogChildren.add(CustomDialogText(
          description: lang['sumassured_0'],
        ));
      } else {
        switch (policyTerm) {
          case 10:
            {
              if (double.parse(sumAssuredAmount) < 2400) {
                customDialogChildren.add(CustomDialogText(
                  description: lang['for_policy'] +
                      "(10):" +
                      lang['sumassured_least'] +
                      " 2400 USD",
                ));
              } else
                counter++;
              break;
            }
          case 15:
            {
              if (double.parse(sumAssuredAmount) < 3600) {
                customDialogChildren.add(CustomDialogText(
                  description: lang['for_policy'] +
                      "(15):" +
                      lang['sumassured_least'] +
                      " 3600 USD",
                ));
              } else
                counter++;

              break;
            }
          case 20:
            {
              if (double.parse(sumAssuredAmount) < 4800) {
                customDialogChildren.add(CustomDialogText(
                  description: lang['for_policy'] +
                      "(20):" +
                      lang['sumassured_least'] +
                      " 4800 USD",
                ));
              } else
                counter++;
              break;
            }
          case 25:
            {
              if (double.parse(sumAssuredAmount) < 6000) {
                customDialogChildren.add(CustomDialogText(
                  description: lang['for_policy'] +
                      "(25):" +
                      lang['sumassured_least'] +
                      " 6000 USD",
                ));
              } else
                counter++;

              break;
            }
          case 30:
            {
              if (double.parse(sumAssuredAmount) < 7200) {
                customDialogChildren.add(CustomDialogText(
                  description: lang['for_policy'] +
                      "(30):" +
                      lang['sumassured_least'] +
                      " 7200 USD",
                ));
              } else
                counter++;

              break;
            }
          case 35:
            {
              if (double.parse(sumAssuredAmount) < 8400) {
                customDialogChildren.add(CustomDialogText(
                  description: lang['for_policy'] +
                      "(35):" +
                      lang['sumassured_least'] +
                      " 8400 USD",
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
    AppProvider appProvider = Provider.of<AppProvider>(context, listen: false);
    Map<String, dynamic> lang = appProvider.lang;
    if (premiumAmount.isEmpty || premiumAmount == null) {
      if (premiumAmount.isEmpty) {
        customDialogChildren.add(CustomDialogText(
          description: lang['premium_empty'],
        ));
      } else
        customDialogChildren.add(CustomDialogText(
          description: lang['premium_empty'],
        ));
    } else {
      if (regExpNum.hasMatch(premiumAmount) == false) {
        customDialogChildren.add(CustomDialogText(
          description: lang['premium_num'],
        ));
      } else if (double.parse(premiumAmount) <= 0) {
        customDialogChildren.add(CustomDialogText(
          description: lang['premium_0'],
        ));
      } else if (((double.parse(premiumAmount) > 0) &&
          (double.parse(premiumAmount) < 240))) {
        customDialogChildren.add(CustomDialogText(
          description: lang['premium_240'],
        ));
      } else
        counter++;
    }
  }
  //

  //Gender Emptiness Validation
  void genderValidation(
      String lGenderText, String pGenderText, bool isDifferentPerson) {
    AppProvider appProvider = Provider.of<AppProvider>(context, listen: false);
    Map<String, dynamic> lang = appProvider.lang;
    if (isDifferentPerson) {
      if (lGenderText == null || pGenderText == null) {
        customDialogChildren.add(CustomDialogText(
          description: lang['gender_empty'],
        ));
      } else
        counter++;
    } else {
      if (lGenderText == null) {
        customDialogChildren.add(CustomDialogText(
          description: lang['gender_empty'],
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
