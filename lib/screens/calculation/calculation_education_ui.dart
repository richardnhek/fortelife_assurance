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
    await getValues();
    policyYear.addListener(getAmountValues);
    premium.addListener(getAmountValues);
    sumAssured.addListener(getAmountValues);
  }

  Future<void> getValues() async {
    final prefs = await SharedPreferences.getInstance();
    String fName = prefs.getString("fNameEdu");
    String lName = prefs.getString("lNameEdu");
    String premVal = prefs.getString("premValEdu");
    String sumVal = prefs.getString("sumValEdu");
    String pName = prefs.getString("pNameEdu");
    String pLName = prefs.getString("pLNameEdu");
    String pOcc = prefs.getString("pOccEdu");
    String pDobEdu = prefs.getString("pDobEdu");
    String pDobDateEdu = prefs.getString("pDobDateEdu");
    String pAgeEdu = prefs.getString("pAgeEdu");
    String dobEdu = prefs.getString("dobEdu");
    String dobDateEdu = prefs.getString("lpDobEduDate");
    String ageEdu = prefs.getString("ageEdu");
    String selYear = prefs.getString("selYearIntEdu");
    String selectedModeEdu = prefs.get("selectedModeEdu");
    String lpGenderEdu = prefs.getString("lpGenderEdu");
    String pGenderEdu = prefs.getString("pGenderEdu");
    print(pDobEdu);
    print(pDobDateEdu);
    firstName.text = fName == null ? '' : fName;
    lastName.text = lName == null ? '' : lName;
    dob.text = dobEdu == null ? '' : dobEdu;
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
    sumAssured.text = sumVal != null ? double.tryParse(sumVal).toString() : '';
    sumAssuredNum =
        (sumAssured.text == null) ? '' : double.tryParse(sumAssured.text);
    pDob.text = pDobEdu == null ? '' : pDobEdu;
    pAge.text = pAgeEdu == null ? '' : pAgeEdu;
    pFirstName.text = pName == null ? '' : pName;
    pLastName.text = pLName == null ? '' : pLName;
    pOccupation.text = pOcc == null ? '' : pOcc;
  }

  Future<void> getAmountValues() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString("dobEdu", dob.text);
    prefs.setString("ageEdu", age.text);
    prefs.setString("selYearIntEdu", policyYear.text);
    prefs.setString("premValEdu", premium.text);
    prefs.setString("sumValEdu", sumAssured.text);
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
  final lOccupation = TextEditingController(text: "Child");
  final policyYear = TextEditingController();
  final riderAdded = TextEditingController();
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
  List<DropdownMenuItem> languageSI = [
    DropdownMenuItem(
        child: Image(
          image: AssetImage("assets/icons/english.png"),
          width: 45,
          height: 30,
        ),
        value: false),
    DropdownMenuItem(
        child: Image(
          image: AssetImage("assets/icons/khmer.png"),
          width: 45,
          height: 30,
        ),
        value: true)
  ];

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
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

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
    showAlertDialog(BuildContext context) {
      showDialog(
          context: context,
          builder: (context) => Center(
                  child: Material(
                type: MaterialType.transparency,
                child: Center(
                  child: Container(
                      width: 300,
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
                                width: 60, height: 60),
                            alignment: Alignment.center,
                          ),
                          SizedBox(height: 20),
                          Align(
                            alignment: Alignment.center,
                            child: Container(
                              width: 150,
                              child: Text(
                                "Error Inputs",
                                style: TextStyle(
                                    color: Color(0xFFD31145),
                                    fontSize: 22,
                                    fontFamily: "Kano",
                                    fontWeight: FontWeight.w600),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                          SizedBox(height: 10),
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: customDialogChildren,
                          ),
                          SizedBox(height: 20),
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
                                    "INFO",
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontFamily: "Kano",
                                        color: Colors.blueAccent),
                                  ),
                                ),
                                SizedBox(width: 10),
                                FlatButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: Text(
                                    "OK",
                                    style: TextStyle(
                                        fontSize: 16,
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
      customDialogChildren.clear();
      if (policy < 10) {
        customDialogChildren.addAll([
          CustomDialogText(
            description:
                "Policy Year ($policy) invalid: must be at least 10 years",
          ),
          CustomDialogText(
            description:
                "Life Proposed's Age ($childAge) invalid: Child's age is limited to 8 years old",
          ),
        ]);
        showAlertDialog(context);
        policyYear.clear();
        age.clear();
        dob.clear();
      } else if (policy > 17) {
        customDialogChildren.addAll([
          CustomDialogText(
            description:
                "Policy Year ($policy) invalid: Policy Year is limited to at most 17 years",
          ),
          CustomDialogText(
            description:
                "Life Proposed's Age ($childAge) invalid: Child's age must be at least 1 year old",
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
      parametersProvider.pName =
          pFirstName.text.toString() + " " + pLastName.text.toString();
      parametersProvider.pAge = pAge.text.toString();
      parametersProvider.pGender = pSelectedGender.toString();
      parametersProvider.pOccupation = pOccupation.text.toString();
      //

      //Child
      parametersProvider.lpName =
          firstName.text.toString() + " " + lastName.text.toString();
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
        parametersProvider.isKhmerSI = isKhmer;
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
                          SizedBox(height: 10),
                          Container(
                            width: mq.size.width,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: CustomTextField(
                                    formLabel: lang['first_name'],
                                    formInputType: TextInputType.name,
                                    formController: pFirstName,
                                    maxLength: 10,
                                    isRequired: false,
                                    errorVisible: false,
                                  ),
                                ),
                                SizedBox(width: 5),
                                Expanded(
                                  child: CustomTextField(
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
                          SizedBox(height: 5),
                          Container(
                            width: mq.size.width,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                    flex: 1,
                                    child: DisabledField(
                                      formController: pAge,
                                      title: lang['age'],
                                    )),
                                SizedBox(width: 5),
                                Expanded(
                                    flex: 2,
                                    child: CustomDatePicker(
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
                          SizedBox(height: 5),
                          Container(
                            child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                      child: CustomDropDown(
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
                                      });
                                    },
                                  )),
                                  SizedBox(width: 5),
                                  Expanded(
                                    flex: 2,
                                    child: CustomTextField(
                                      formInputType: TextInputType.text,
                                      formLabel: lang['occupation'],
                                      maxLength: 9,
                                      isRequired: false,
                                      formController: pOccupation,
                                      errorVisible: false,
                                    ),
                                  )
                                ]),
                          )
                        ])),
                SizedBox(height: 15),
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
                      SizedBox(height: 10),
                      Container(
                        width: mq.size.width,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: CustomTextField(
                                formLabel: lang['first_name'],
                                formInputType: TextInputType.name,
                                maxLength: 10,
                                isRequired: false,
                                formController: firstName,
                                errorVisible: false,
                              ),
                            ),
                            SizedBox(width: 5),
                            Expanded(
                              child: CustomTextField(
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
                      SizedBox(height: 5),
                      Container(
                        width: mq.size.width,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                                flex: 1,
                                child: DisabledField(
                                  formController: age,
                                  title: lang['age'],
                                )),
                            SizedBox(width: 5),
                            Expanded(
                                flex: 2,
                                child: CustomDatePicker(
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
                      SizedBox(height: 5),
                      Container(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                                child: CustomDropDown(
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
                                });
                              },
                            )),
                            SizedBox(width: 5),
                            Expanded(
                              flex: 2,
                              child: DisabledField(
                                formController: lOccupation,
                                title: lang['occupation'],
                              ),
                            )
                          ],
                        ),
                      ),
                      SizedBox(height: 5),
                      Container(
                        width: mq.size.width,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              flex: 1,
                              child: CustomDropDown(
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
                            SizedBox(width: 5),
                            Expanded(
                                flex: 1,
                                child: DisabledField(
                                  title: lang['policy_year'],
                                  formController: policyYear,
                                )),
                          ],
                        ),
                      ),
                      SizedBox(height: 5),
                      CustomTextField(
                        formLabel: lang['premium'],
                        formInputType: TextInputType.numberWithOptions(
                            signed: true, decimal: true),
                        formController: premium,
                        maxLength: 9,
                        isRequired: true,
                        errorVisible: false,
                        onChange: (text) {
                          if (int.parse(policyYear.text) != null) {
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
                      SizedBox(height: 5),
                      CustomTextField(
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
                    ],
                  ),
                ),
                SizedBox(height: 5),
                Padding(
                  padding: EdgeInsets.all(5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                          flex: 3,
                          child: Text("Language",
                              style: TextStyle(
                                  fontFamily: "Kano",
                                  fontSize: 15,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.black.withOpacity(0.5)))),
                      Expanded(
                        flex: 1,
                        child: CustomDropDown(
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
                            if (_formKey.currentState.validate()) {
                              counter = 0;
                              customDialogChildren.clear();
                              _formKey.currentState.save();
                              await saveTextValues();
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
                          onPressed: () {
                            //Proposer
                            pFirstName.clear();
                            pLastName.clear();
                            pAge.clear();
                            pDob.clear();
                            pGender.clear();
                            pOccupation.clear();
                            //

                            //Life Proposed
                            firstName.clear();
                            lastName.clear();
                            age.clear();
                            dob.clear();
                            sumAssured.clear();
                            premium.clear();
                            gender.clear();
                            lOccupation.clear();
                            policyYear.clear();

                            riderAdded.clear();

                            lSelectedGender = "Male";
                            pSelectedGender = "Male";
                            policyYear.text = "10";
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
    String sumVal = sumAssured.text;
    String premVal = premium.text;
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
          prefs.setString("pAgeEdu", tecAge.text);
          prefs.setString("pDobEdu", tec.text);
        }
      });

      if (int.tryParse(policyYear.text) > 0) {
        prefs.setString("dobEdu", dob.text);
        prefs.setString("ageEdu", age.text);
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
    if (ageText.isEmpty || pAgeText.isEmpty) {
      customDialogChildren.add(CustomDialogText(
        description: "Age field can't be empty",
      ));
    } else {
      if ((int.parse(pAgeText) + int.parse(policyTerm)) > 69 ||
          (int.parse(pAgeText) > 59)) {
        customDialogChildren.add(CustomDialogText(
          description:
              "Payor's age limit exceeded, please check information page.",
        ));
      } else if (int.parse(pAgeText) < 18) {
        customDialogChildren.add(CustomDialogText(
          description: "Payor's age under 18, please check information page",
        ));
      } else {
        isOnPolicy = isOnPolicyStatus(lpBirthDate);
        counter++;
      }
    }
  }
  //

  void policyYearValidation(String policyYearText) {
    if (policyYearText.isEmpty) {
      customDialogChildren.add(CustomDialogText(
        description: "Policy Year can't be empty",
      ));
    } else {
      counter++;
    }
  }

  //Validate Sum Assured
  void sumAssuredValidation(
      String sumAssuredAmount, String premiumAmount, String policyTerm) {
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
          description: "Sum Assured can't be a negative number",
        ));
      } else {
        switch (policyTerm) {
          case "10":
            {
              if (double.parse(sumAssuredAmount) < 2400) {
                customDialogChildren.add(CustomDialogText(
                  description:
                      "For Policy Term (10): Sum Assured must be at least 2,400 USD",
                ));
              } else
                counter++;
              break;
            }
          case "11":
            {
              if (double.parse(sumAssuredAmount) < 2640) {
                customDialogChildren.add(CustomDialogText(
                  description:
                      "For Policy Term (11): Sum Assured must be at least 2,640 USD",
                ));
              } else
                counter++;

              break;
            }
          case "12":
            {
              if (double.parse(sumAssuredAmount) < 2880) {
                customDialogChildren.add(CustomDialogText(
                  description:
                      "For Policy Term (12): Sum Assured must be at least 2,880 USD",
                ));
              } else
                counter++;
              break;
            }
          case "13":
            {
              if (double.parse(sumAssuredAmount) < 3120) {
                customDialogChildren.add(CustomDialogText(
                  description:
                      "For Policy Term (13): Sum Assured must be at least 3,120 USD",
                ));
              } else
                counter++;
              break;
            }
          case "14":
            {
              if (double.parse(sumAssuredAmount) < 3360) {
                customDialogChildren.add(CustomDialogText(
                  description:
                      "For Policy Term (14): Sum Assured must be at least 3,360 USD",
                ));
              } else
                counter++;
              break;
            }
          case "15":
            {
              if (double.parse(sumAssuredAmount) < 3600) {
                customDialogChildren.add(CustomDialogText(
                  description:
                      "For Policy Term (15): Sum Assured must be at least 3,600 USD",
                ));
              } else
                counter++;
              break;
            }
          case "16":
            {
              if (double.parse(sumAssuredAmount) < 3840) {
                customDialogChildren.add(CustomDialogText(
                  description:
                      "For Policy Term (16): Sum Assured must be at least 3,840 USD",
                ));
              } else
                counter++;
              break;
            }
          case "17":
            {
              if (double.parse(sumAssuredAmount) < 4080) {
                customDialogChildren.add(CustomDialogText(
                  description:
                      "For Policy Term (17): Sum Assured must be at least 4,080 USD",
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

  //Save Text Values
  Future<void> saveTextValues() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString("fNameEdu", firstName.text);
    prefs.setString("lNameEdu", lastName.text);
    prefs.setString("lpDobEduDate", lpBirthDate.toString());
    prefs.setString("premValEdu", premium.text);
    prefs.setString("sumValEdu", sumAssured.text);
    prefs.setString("pNameEdu", pFirstName.text);
    prefs.setString("pLNameEdu", pLastName.text);
    prefs.setString("pOccEdu", pOccupation.text);
  }
  //

  //Gender Emptiness Validation
  void genderValidation(String lGenderText, String pGenderText) {
    if (lGenderText == null || pGenderText == null) {
      customDialogChildren.add(CustomDialogText(
        description: "Gender field can't be empty",
      ));
    } else
      counter++;
  }
  //

  //Validate Premium
  void premiumValidation(String premiumAmount) {
    if (premiumAmount.isEmpty) {
      customDialogChildren.add(CustomDialogText(
        description: "Premium can't be empty",
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
  @override
  void dispose() {
    super.dispose();
  }
}

class AlwaysDisabledFocusNode extends FocusNode {
  @override
  bool get hasFocus => false;
}
