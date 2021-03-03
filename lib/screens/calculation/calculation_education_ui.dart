import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:forte_life/providers/app_provider.dart';
import 'package:forte_life/providers/parameters_provider.dart';
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

class CalculationEducationUI extends StatefulWidget {
  @override
  _CalculationEducationUIState createState() => _CalculationEducationUIState();
}

class _CalculationEducationUIState extends State<CalculationEducationUI> {
  FocusNode premiumFocusNode;

  @override
  void initState() {
    super.initState();
  }

  //Payor
  TextEditingController pFirstName = TextEditingController();
  TextEditingController pLastName = TextEditingController();
  TextEditingController pAge = TextEditingController();
  TextEditingController pDob = TextEditingController();
  TextEditingController pGender = TextEditingController();
  TextEditingController pOccupation = TextEditingController();
  //

  //Child
  TextEditingController firstName = TextEditingController();
  TextEditingController lastName = TextEditingController();
  TextEditingController age = TextEditingController();
  TextEditingController dob = TextEditingController();
  TextEditingController sumAssured = TextEditingController();
  TextEditingController premium = TextEditingController();
  TextEditingController gender = TextEditingController();
  TextEditingController lOccupation = TextEditingController();
  TextEditingController policyYear = TextEditingController();
  TextEditingController riderAdded = TextEditingController();
  //

  String lSelectedGender;
  String pSelectedGender;
  String selectedMode = "Yearly";
  double premiumNum;
  double sumAssuredNum;
  DateTime lpBirthDate;
  bool isOnPolicy = false;

  //Necessary error variables
  int counter;
  //

  //Regular Expressions
  RegExp regExpNum = RegExp("[+]?\\d*\\.?\\d+");
  //

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
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

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
    final mq = MediaQuery.of(context);
    showAlertDialog(BuildContext context) {
      AlertDialog alert = AlertDialog(
        contentPadding: EdgeInsets.only(top: 25, left: 10, right: 10),
        title: Center(
            child: Container(
                child: Text(
          "Error Inputs",
          style: TextStyle(
              color: Colors.red,
              fontFamily: "Kano",
              fontSize: 16,
              fontWeight: FontWeight.bold),
        ))),
        content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: customDialogChildren),
        actions: [
          FlatButton(
            child: Text(
              "OK",
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF8AB84B)),
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
          )
        ],
      );

      // show the dialog
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return alert;
        },
      );
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
          lastName.text.toString() + " " + firstName.text.toString();
      parametersProvider.lpAge = age.text.toString();
      parametersProvider.lpGender = lSelectedGender.toString();
      parametersProvider.lpOccupation = lOccupation.text.toString();
      //

      parametersProvider.policyTerm = policyYear.text;
      parametersProvider.paymentMode = selectedMode;
      parametersProvider.annualP = premiumNum.toString();
      parametersProvider.basicSA = sumAssuredNum.toString();
      parametersProvider.isOnPolicy = isOnPolicy;
      appProvider.pdfScreenIndex = 1;
      appProvider.activeTabIndex = 1;
      Navigator.of(context).pushNamed("/main_flow");
    }
    //

    return SafeArea(
      child: SingleChildScrollView(
        controller: ScrollController(),
        child: Container(
          padding: EdgeInsets.symmetric(
              horizontal: 20, vertical: mq.size.height / 8),
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
                            fieldTitle: "Payor",
                          ),
                          SizedBox(height: 10),
                          Container(
                            width: mq.size.width,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: CustomTextField(
                                    formLabel: "First Name",
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
                                    formLabel: "Last Name",
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
                          Container(
                            width: mq.size.width,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                    flex: 1,
                                    child: DisabledField(
                                      formController: pAge,
                                      title: "Age",
                                    )),
                                SizedBox(width: 5),
                                Expanded(
                                    flex: 2,
                                    child: CustomDatePicker(
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
                                    title: "Gender",
                                    value: pSelectedGender,
                                    errorVisible: false,
                                    isRequired: true,
                                    items: genderTypes,
                                    onChange: (value) {
                                      setState(() {
                                        pSelectedGender = value;
                                      });
                                    },
                                  )),
                                  SizedBox(width: 5),
                                  Expanded(
                                    flex: 2,
                                    child: CustomTextField(
                                      formInputType: TextInputType.text,
                                      formLabel: "Occupation",
                                      maxLength: 10,
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
                        fieldTitle: "Life Proposed",
                      ),
                      SizedBox(height: 10),
                      Container(
                        width: mq.size.width,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: CustomTextField(
                                formLabel: "First Name",
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
                                formLabel: "Last Name",
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
                                  title: "Age",
                                )),
                            SizedBox(width: 5),
                            Expanded(
                                flex: 2,
                                child: CustomDatePicker(
                                  focusNode: AlwaysDisabledFocusNode(),
                                  dob: dob,
                                  onTap: () async {
                                    await _selectDate(context, dob, age, true);
                                    checkPolicyYear(int.parse(policyYear.text),
                                        int.parse(age.text));
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
                              title: "Gender",
                              value: lSelectedGender,
                              isRequired: true,
                              items: genderTypes,
                              errorVisible: false,
                              onChange: (value) {
                                setState(() {
                                  lSelectedGender = value;
                                });
                              },
                            )),
                            SizedBox(width: 5),
                            Expanded(
                              flex: 2,
                              child: CustomTextField(
                                formInputType: TextInputType.text,
                                formLabel: "Occupation",
                                maxLength: 10,
                                isRequired: false,
                                formController: lOccupation,
                                errorVisible: false,
                              ),
                            )
                          ],
                        ),
                      ),
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
                                onChange: (value) {
                                  setState(() {
                                    selectedMode = value;
                                  });
                                },
                              ),
                            ),
                            SizedBox(width: 5),
                            Expanded(
                                flex: 1,
                                child: DisabledField(
                                  title: "Policy Year",
                                  formController: policyYear,
                                )),
                          ],
                        ),
                      ),
                      CustomTextField(
                        formLabel: "Premium Payable",
                        formInputType: TextInputType.number,
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
                      CustomTextField(
                        formLabel: "Sum Assured",
                        formInputType: TextInputType.number,
                        formController: sumAssured,
                        isRequired: true,
                        maxLength: 10,
                        errorVisible: false,
                        onChange: (text) {
                          print(policyYear.text);
                          if (int.parse(policyYear.text) != null) {
                            if (text == "") {
                              premium.text = "";
                            } else
                              premiumNum = (double.parse(text) /
                                  double.parse(policyYear.text));
                            premium.text = premiumNum.toStringAsFixed(2);
                            sumAssuredNum = double.parse(text);
                            premiumNum = double.parse(premium.text);
                            print(sumAssuredNum);
                          } else {
                            premium.text = null;
                          }
                        },
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 5),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 5),
                      child: CalculateButton(onPressed: () async {
                        if (_formKey.currentState.validate()) {
                          counter = 0;
                          customDialogChildren.clear();
                          _formKey.currentState.save();
                          policyYearValidation(policyYear.text);
                          sumAssuredValidation(
                              sumAssured.text, premium.text, policyYear.text);
                          premiumValidation(premium.text);
                          ageValidation(age.text, pAge.text, policyYear.text);
                          genderValidation(lSelectedGender, pSelectedGender);
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
        tec.text = convertDateTimeDisplay(dateTime);
        tec.selection = TextSelection.fromPosition(TextPosition(
            offset: dob.text.length, affinity: TextAffinity.upstream));
        tecAge.text = calculateAge(_selectedDate, isLpAge);
      });
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
