import 'package:womentaxi/untils/export_file.dart';

class EarningsData extends StatefulWidget {
  const EarningsData({super.key});

  @override
  State<EarningsData> createState() => _EarningsDataState();
}

class _EarningsDataState extends State<EarningsData> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Kpink.withOpacity(0.2),
      padding: EdgeInsets.all(15.r),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "Todays Earnings",
            style: TextStyle(
                fontSize: kEighteenFont,
                fontWeight: kFW400,
                height: 1.2,
                color: kcarden),
          ),
          Row(
            children: [
              Text(
                "₹ 100",
                style: TextStyle(
                    fontSize: kEighteenFont,
                    fontWeight: kFW400,
                    color: kcarden),
              ),
              SizedBox(
                width: 10.w,
              ),
              Icon(
                Icons.keyboard_arrow_down,
                color: kcarden,
              ),
            ],
          )
        ],
      ),
    );
  }
}
