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
import 'package:forte_life/widgets/custom_text_field.dart';
import 'package:forte_life/widgets/dropdown_text.dart';
import 'package:forte_life/widgets/field_title.dart';
import 'package:forte_life/widgets/reset_button.dart';

import 'package:intl/intl.dart';
import 'package:forte_life/widgets/disabled_field.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CalculationEducationUI extends StatefulWidget {
  @override
  _CalculationEducationUIState createState() => _CalculationEducationUIState();
}

class _CalculationEducationUIState extends State<CalculationEducationUI> {
  FocusNode premiumFocusNode;

  @override
  void initState() {
    super.initState();
    initializeCalculator();
  }

  Future<void> initializeCalculator() async {
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey("valueEduP") && !prefs.containsKey("valueEduLP")) {
      await getAmountValues();
      await getValues();
    }
    policyYear.addListener(getAmountValues);
    pFirstName.addListener(getAmountValues);
    pLastName.addListener(getAmountValues);
    pAge.addListener(getAmountValues);
    pOccupation.addListener(getAmountValues);

    firstName.addListener(getAmountValues);
    lastName.addListener(getAmountValues);
    age.addListener(getAmountValues);
    policyYear.addListener(getAmountValues);
    premium.addListener(getAmountValues);
    sumAssured.addListener(getAmountValues);
    if (prefs.containsKey("valueEduP") && prefs.containsKey("valueEduLP")) {
      await getValues();
    }
  }

  Future<void> getValues() async {
    final prefs = await SharedPreferences.getInstance();
    List<String> valueEduLP = prefs.getStringList("valueEduLP");
    List<String> valueEduP = prefs.getStringList("valueEduP");
    //
    String fName = valueEduLP[0];
    String lName = valueEduLP[1];
    String premVal = valueEduLP[4];
    String sumVal = valueEduLP[5];
    String ageEdu = valueEduLP[2];
    String selYear = valueEduLP[3];
    String pName = valueEduP[0];
    String pLName = valueEduP[1];
    String pAgeEdu = valueEduP[2];
    String pOcc = valueEduP[3];
    //
    String pDobEdu = prefs.getString("pDobEdu");
    String pDobDateEdu = prefs.getString("pDobDateEdu");
    String dobEdu = prefs.getString("dobEdu");
    String dobDateEdu = prefs.getString("lpDobEduDate");
    String selectedModeEdu = prefs.get("selectedModeEdu");
    String lpGenderEdu = prefs.getString("lpGenderEdu");
    String pGenderEdu = prefs.getString("pGenderEdu");
    //
    firstName.text = fName == null ? '' : fName;
    lastName.text = lName == null ? '' : lName;
    dob.text = dobEdu == null ? '' : dobEdu;
    print(dob.text.toString());

    setState(() {
      lSelectedGender = (lpGenderEdu == null) == false ? lpGenderEdu : null;
    });
    setState(() {
      pSelectedGender = (pGenderEdu == null) == false ? pGenderEdu : null;
    });
    lpBirthDate = dobDateEdu == null
        ? DateTime.tryParse('')
        : DateTime.tryParse(dobDateEdu);

    age.text = ageEdu == null ? '' : ageEdu;
    policyYear.text = (selYear == null) == false ? selYear : "";
    selectedMode =
        (selectedModeEdu == null) == false ? selectedModeEdu : "Yearly";
    premium.text = premVal == null ? '' : premVal;
    premiumNum = (premium.text == null) ? '' : double.tryParse(premium.text);
    sumAssured.text = sumVal == null ? '' : sumVal;
    sumAssuredNum =
        (sumAssured.text == null) ? '' : double.tryParse(sumAssured.text);
    pDob.text = pDobEdu == null ? '' : pDobEdu;
    print(pDob.text.toString());
    pAge.text = pAgeEdu == null ? '' : pAgeEdu;
    pFirstName.text = pName == null ? '' : pName;
    pLastName.text = pLName == null ? '' : pLName;
    pOccupation.text = pOcc == null ? '' : pOcc;
  }

  Future<void> getAmountValues() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setStringList("valueEduLP", [
      firstName.text,
      lastName.text,
      age.text,
      policyYear.text,
      premium.text,
      sumAssured.text
    ]);
    prefs.setStringList("valueEduP",
        [pFirstName.text, pLastName.text, pAge.text, pOccupation.text]);
    prefs.setString("lpGenderEdu", lSelectedGender);
    prefs.setString("pGenderEdu", pSelectedGender);
  }

  //Payor
  final pFirstName = TextEditingController();
  final pLastName = TextEditingController();
  final pAge = TextEditingController();
  final pDob = TextEditingController();
  final pGender = TextEditingController();
  final pOccupation = TextEditingController();
  //

  //Child
  final firstName = TextEditingController();
  final lastName = TextEditingController();
  final age = TextEditingController();
  final dob = TextEditingController();
  final sumAssured = TextEditingController();
  final premium = TextEditingController();
  final gender = TextEditingController();
  final policyYear = TextEditingController();
  //

  String lSelectedGender;
  String pSelectedGender;
  String selectedMode = "Yearly";
  double premiumNum;
  double sumAssuredNum;
  DateTime lpBirthDate;
  bool isOnPolicy = false;
  bool isKhmer = false;

  //Necessary error variables
  int counter;
  //

  //Regular Expressions
  RegExp regExpNum = RegExp("[+]?\\d*\\.?\\d+");
  //

  List<Widget> customDialogChildren = List();

  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  DateTime _selectedDate;
  DateTime _currentDate = DateTime.now();
  //

  @override
  Widget build(BuildContext context) {
    ParametersProvider parametersProvider =
        Provider.of<ParametersProvider>(context, listen: false);
    AppProvider appProvider = Provider.of<AppProvider>(context);
    Map<String, dynamic> lang = appProvider.lang;
    final mq = MediaQuery.of(context);
    final lOccupation = TextEditingController(text: lang['child']);
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
                                      appProvider.calculationPageEdu = 1;
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

    //Validate Policy Year
    void checkPolicyYear(int policy, int childAge) {
      AppProvider appProvider =
          Provider.of<AppProvider>(context, listen: false);
      Map<String, dynamic> lang = appProvider.lang;
      customDialogChildren.clear();
      if (policy < 10) {
        customDialogChildren.addAll([
          CustomDialogText(
            description: lang['policy'] + "($policy) " + lang['invalid_10'],
          ),
          CustomDialogText(
            description: lang['lp_age'] + "($childAge) " + lang['invalid_8'],
          ),
        ]);
        showAlertDialog(context);
        policyYear.clear();
        age.clear();
        dob.clear();
      } else if (policy > 17) {
        customDialogChildren.addAll([
          CustomDialogText(
            description: lang['policy'] + "($policy) " + lang['policy_17'],
          ),
          CustomDialogText(
            description: lang['lp_age'] + "($childAge) " + lang['invalid_1'],
          ),
        ]);
        showAlertDialog(context);
        policyYear.clear();
        age.clear();
        dob.clear();
      } else {
        policyYear.text = policy.toString();
      }
    }
    //

    //Calculate and Generate PDF
    void calculateAndPDF() {
      //Payor
      parametersProvider.pName = appProvider.language != 'kh'
          ? pFirstName.text.toString() + " " + pLastName.text.toString()
          : pLastName.text.toString() + " " + pFirstName.text.toString();
      parametersProvider.pAge = pAge.text.toString();
      parametersProvider.pGender = pSelectedGender.toString();
      parametersProvider.pOccupation = pOccupation.text.toString();
      //

      //Child
      parametersProvider.lpName = appProvider.language != 'kh'
          ? firstName.text.toString() + " " + lastName.text.toString()
          : lastName.text.toString() + " " + firstName.text.toString();
      parametersProvider.lpAge = age.text.toString();
      parametersProvider.lpGender = lSelectedGender.toString();
      parametersProvider.lpOccupation = lOccupation.text.toString();
      //

      parametersProvider.policyTerm = policyYear.text;
      parametersProvider.paymentMode = selectedMode;
      parametersProvider.annualP = premiumNum.toString();
      parametersProvider.basicSA = sumAssuredNum.toString();
      parametersProvider.isOnPolicy = isOnPolicy;
      setState(() {
        appProvider.pdfScreenIndex = 1;
        appProvider.activeTabIndex = 1;
        appProvider.calculationPageEdu = 0;
      });
      Navigator.pushNamedAndRemoveUntil(context, '/main_flow', (_) => false);
    }
    //

    return SafeArea(
      key: _scaffoldKey,
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
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
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
                            fieldTitle: lang['payor'],
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
                                    formController: pFirstName,
                                    maxLength: 10,
                                    isRequired: false,
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
                                    formInputType: TextInputType.name,
                                    formController: pLastName,
                                    isRequired: false,
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
                              children: [
                                Expanded(
                                    flex: 1,
                                    child: DisabledField(
                                      appProvider: appProvider,
                                      mq: mq,
                                      formController: pAge,
                                      title: lang['age'],
                                    )),
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
                                        _selectDate(context, pDob, pAge, false);
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
                                    errorVisible: false,
                                    isRequired: true,
                                    items: genderTypes,
                                    onChange: (value) async {
                                      final prefs =
                                          await SharedPreferences.getInstance();
                                      setState(() {
                                        pSelectedGender = value;
                                        prefs.setString("pGenderEdu", value);
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
                                      formController: pOccupation,
                                      errorVisible: false,
                                    ),
                                  )
                                ]),
                          )
                        ])),
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
                        fieldTitle: lang['life_proposed_edu'],
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
                                maxLength: 10,
                                isRequired: false,
                                formController: firstName,
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
                                  title: lang['age'],
                                )),
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
                                  onTap: () async {
                                    await _selectDate(context, dob, age, true);
                                    checkPolicyYear(
                                        int.tryParse(policyYear.text),
                                        int.tryParse(age.text));
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
                              isRequired: true,
                              items: genderTypes,
                              errorVisible: false,
                              onChange: (value) async {
                                final prefs =
                                    await SharedPreferences.getInstance();
                                setState(() {
                                  lSelectedGender = value;
                                  prefs.setString("lpGenderEdu", value);
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
                              child: DisabledField(
                                appProvider: appProvider,
                                mq: mq,
                                formController: lOccupation,
                                title: lang['occupation'],
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
                                    prefs.setString("selectedModeEdu", value);
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
                                child: DisabledField(
                                  appProvider: appProvider,
                                  mq: mq,
                                  title: lang['policy_year'],
                                  formController: policyYear,
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
                        child: CustomTextField(
                          appProvider: appProvider,
                          mq: mq,
                          formLabel: lang['premium'],
                          formInputType: TextInputType.numberWithOptions(
                              signed: true, decimal: true),
                          formController: premium,
                          maxLength: 8,
                          isRequired: true,
                          errorVisible: false,
                          onChange: (text) {
                            if (int.tryParse(policyYear.text) != null) {
                              if (text == "") {
                                sumAssured.text = "";
                              } else
                                premiumNum = double.parse(text);
                              sumAssured.text =
                                  (double.parse(policyYear.text) * premiumNum)
                                      .toStringAsFixed(2);
                              sumAssuredNum = double.parse(sumAssured.text);
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
                          errorVisible: false,
                          onChange: (text) {
                            if (int.parse(policyYear.text) != null) {
                              if (text == "") {
                                premium.text = "";
                              } else
                                premiumNum = (double.parse(text) /
                                    double.parse(policyYear.text));
                              premium.text = premiumNum.toStringAsFixed(2);
                              sumAssuredNum = double.parse(text);
                              premiumNum = double.parse(premium.text);
                            } else {
                              premium.text = null;
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
                            if (_formKey.currentState.validate()) {
                              counter = 0;
                              customDialogChildren.clear();
                              _formKey.currentState.save();
                              policyYearValidation(policyYear.text);
                              sumAssuredValidation(sumAssured.text,
                                  premium.text, policyYear.text);
                              premiumValidation(premium.text);
                              ageValidation(
                                  age.text, pAge.text, policyYear.text);
                              genderValidation(
                                  lSelectedGender, pSelectedGender);
                              if (counter == 5) {
                                calculateAndPDF();
                              } else
                                showAlertDialog(context);
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
                            prefs.remove("valueEduLP");
                            //

                            //Life Proposed
                            firstName.clear();
                            lastName.clear();
                            age.clear();
                            dob.clear();
                            sumAssured.clear();
                            premium.clear();
                            gender.clear();
                            policyYear.clear();
                            setState(() {
                              lSelectedGender = null;
                              pSelectedGender = null;
                              selectedMode = "Yearly";
                            });
                            prefs.remove("valueEduP");
                            prefs.remove("pDobEdu");
                            prefs.remove("pDobDateEdu");
                            prefs.remove("dobEdu");
                            prefs.remove("lpDobEduDate");
                            prefs.remove("selectedModeEdu");
                            prefs.remove("lpGenderEdu");
                            prefs.remove("pGenderEdu");
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
        initialDate: _selectedDate != null
            ? isLpAge == true
                ? DateTime(DateTime.now().year - 8)
                : _selectedDate
            : isLpAge == true
                ? DateTime(DateTime.now().year - 1)
                : DateTime.now(),
        firstDate: isLpAge == true
            ? DateTime(DateTime.now().year - 8)
            : DateTime(1940),
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
              child: child);
        });

    if (newSelectedDate != null) {
      setState(() {
        _selectedDate = newSelectedDate;
        String dateTime = _selectedDate.toString();

        if (isLpAge) {
          prefs.setString("lpDobEduDate", dateTime);
        } else {
          prefs.setString("pDobEduDate", dateTime);
        }
        tec.text = convertDateTimeDisplay(dateTime);
        tec.selection = TextSelection.fromPosition(TextPosition(
            offset: dob.text.length, affinity: TextAffinity.upstream));
        tecAge.text = calculateAge(_selectedDate, isLpAge);
        if (!isLpAge) {
          getAmountValues();
          prefs.setString("pDobEdu", tec.text);
        }
      });

      if (int.tryParse(policyYear.text) > 0) {
        prefs.setString("dobEdu", dob.text);
        getAmountValues();
        prefs.setString("selYearIntEdu", policyYear.text);
        if (sumVal.isNotEmpty || premVal.isNotEmpty) {
          if (premVal.isNotEmpty) {
            sumVal = (double.parse(premVal) * double.parse(policyYear.text))
                .toString();
          } else {
            premVal = (double.parse(sumVal) / double.parse(policyYear.text))
                .toString();
          }
        } else if (sumVal.isNotEmpty && premVal.isNotEmpty) {
          sumVal = (double.parse(premVal) * double.parse(policyYear.text))
              .toString();
        }
        sumAssuredNum = double.tryParse(sumVal);
        premiumNum = double.tryParse(premVal);
        prefs.setString("sumValEdu", sumVal);
        prefs.setString("premValEdu", premVal);
        premium.text = premVal.isNotEmpty ? premVal : '';
        sumAssured.text = sumVal.isNotEmpty ? sumVal : '';
      } else {
        prefs.setString("sumValEdu", sumVal);
        prefs.setString("premValEdu", premVal);
        premium.text = premVal.isNotEmpty ? premVal : '';
        sumAssured.text = sumVal.isNotEmpty ? sumVal : '';
      }
    }
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
      policyYear.text = (18 - age).toString();
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
  void ageValidation(String ageText, String pAgeText, String policyTerm) {
    AppProvider appProvider = Provider.of<AppProvider>(context, listen: false);
    Map<String, dynamic> lang = appProvider.lang;
    if (ageText.isEmpty || pAgeText.isEmpty) {
      customDialogChildren.add(CustomDialogText(
        description: lang['age_empty'],
      ));
    } else {
      if ((int.parse(pAgeText) + int.parse(policyTerm)) > 69 ||
          (int.parse(pAgeText) > 59)) {
        customDialogChildren.add(CustomDialogText(
          description: lang['p_limit'],
        ));
      } else if (int.parse(pAgeText) < 18) {
        customDialogChildren.add(CustomDialogText(
          description: lang['p_under18'],
        ));
      } else {
        isOnPolicy = isOnPolicyStatus(lpBirthDate);
        counter++;
      }
    }
  }
  //

  void policyYearValidation(String policyYearText) {
    AppProvider appProvider = Provider.of<AppProvider>(context, listen: false);
    Map<String, dynamic> lang = appProvider.lang;
    if (policyYearText.isEmpty) {
      customDialogChildren.add(CustomDialogText(
        description: lang['policy'] + lang['empty'],
      ));
    } else {
      counter++;
    }
  }

  //Validate Sum Assured
  void sumAssuredValidation(
      String sumAssuredAmount, String premiumAmount, String policyTerm) {
    AppProvider appProvider = Provider.of<AppProvider>(context, listen: false);
    Map<String, dynamic> lang = appProvider.lang;
    if (sumAssuredAmount.isEmpty) {
      customDialogChildren.add(CustomDialogText(
        description: lang['sumassured_empty'],
      ));
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
          case "10":
            {
              if (double.parse(sumAssuredAmount) < 2400) {
                customDialogChildren.add(CustomDialogText(
                  description: lang['for_policy'] +
                              "(10): " +
                              lang['sumassured_least'] +
                              appProvider.language !=
                          'kh'
                      ? " 2,400 USD"
                      : " ២៤០០ ដុល្លារ",
                ));
              } else
                counter++;
              break;
            }
          case "11":
            {
              if (double.parse(sumAssuredAmount) < 2640) {
                customDialogChildren.add(CustomDialogText(
                  description: lang['for_policy'] +
                              "(11): " +
                              lang['sumassured_least'] +
                              appProvider.language !=
                          'kh'
                      ? " 2,640 USD"
                      : " ២៦៤០ ដុល្លារ",
                ));
              } else
                counter++;

              break;
            }
          case "12":
            {
              if (double.parse(sumAssuredAmount) < 2880) {
                customDialogChildren.add(CustomDialogText(
                  description: lang['for_policy'] +
                              "(12): " +
                              lang['sumassured_least'] +
                              appProvider.language !=
                          'kh'
                      ? " 2,880 USD"
                      : " ២៨៨០ ដុល្លារ",
                ));
              } else
                counter++;
              break;
            }
          case "13":
            {
              if (double.parse(sumAssuredAmount) < 3120) {
                customDialogChildren.add(CustomDialogText(
                  description: lang['for_policy'] +
                              "(13): " +
                              lang['sumassured_least'] +
                              appProvider.language !=
                          'kh'
                      ? " 3,120 USD"
                      : " ៣១២០ ដុល្លារ",
                ));
              } else
                counter++;
              break;
            }
          case "14":
            {
              if (double.parse(sumAssuredAmount) < 3360) {
                customDialogChildren.add(CustomDialogText(
                  description: lang['for_policy'] +
                              "(14): " +
                              lang['sumassured_least'] +
                              appProvider.language !=
                          'kh'
                      ? " 3,360 USD"
                      : " ៣៣៦០ ដុល្លារ",
                ));
              } else
                counter++;
              break;
            }
          case "15":
            {
              if (double.parse(sumAssuredAmount) < 3600) {
                customDialogChildren.add(CustomDialogText(
                  description: lang['for_policy'] +
                              "(15): " +
                              lang['sumassured_least'] +
                              appProvider.language !=
                          'kh'
                      ? " 3,600 USD"
                      : " ៣៦០០ ដុល្លារ",
                ));
              } else
                counter++;
              break;
            }
          case "16":
            {
              if (double.parse(sumAssuredAmount) < 3840) {
                customDialogChildren.add(CustomDialogText(
                  description: lang['for_policy'] +
                              "(16): " +
                              lang['sumassured_least'] +
                              appProvider.language !=
                          'kh'
                      ? " 3,840 USD"
                      : " ៣៨៤០ ដុល្លារ",
                ));
              } else
                counter++;
              break;
            }
          case "17":
            {
              if (double.parse(sumAssuredAmount) < 4080) {
                customDialogChildren.add(CustomDialogText(
                  description: lang['for_policy'] +
                              "(17): " +
                              lang['sumassured_least'] +
                              appProvider.language !=
                          'kh'
                      ? " 4,080 USD"
                      : " ៤០៨០ ដុល្លារ",
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

  //Gender Emptiness Validation
  void genderValidation(String lGenderText, String pGenderText) {
    AppProvider appProvider = Provider.of<AppProvider>(context, listen: false);
    Map<String, dynamic> lang = appProvider.lang;
    if (lGenderText == null || pGenderText == null) {
      customDialogChildren.add(CustomDialogText(
        description: lang['gender_empty'],
      ));
    } else
      counter++;
  }
  //

  //Validate Premium
  void premiumValidation(String premiumAmount) {
    AppProvider appProvider = Provider.of<AppProvider>(context, listen: false);
    Map<String, dynamic> lang = appProvider.lang;
    if (premiumAmount.isEmpty) {
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
  @override
  void dispose() {
    super.dispose();
  }
}

class AlwaysDisabledFocusNode extends FocusNode {
  @override
  bool get hasFocus => false;
}
