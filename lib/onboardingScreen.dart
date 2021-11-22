import 'package:chantix/informationFilling.dart';
import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:lottie/lottie.dart';


class OnBoardingPage extends StatefulWidget {
  @override
  _OnBoardingPageState createState() => _OnBoardingPageState();
}

class _OnBoardingPageState extends State<OnBoardingPage> {
  final introKey = GlobalKey<IntroductionScreenState>();


  // called when onboarding is completed
  void _onIntroEnd(context) {
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
            builder: (context) =>UserInfo()),
            (Route<dynamic> route) => false);
  }


  @override
  Widget build(BuildContext context) {
    const pageDecoration = const PageDecoration(
      titleTextStyle: TextStyle(fontSize: 20.0,color: Colors.black54,fontWeight: FontWeight.w500),
      bodyTextStyle: TextStyle(color:Colors.black54,fontSize: 16,fontWeight: FontWeight.w300),
      descriptionPadding: EdgeInsets.fromLTRB(20.0, 20.0, 20, 0),
      pageColor: Colors.white,
      imagePadding: EdgeInsets.zero,
    );

    return IntroductionScreen(
      key: introKey,
      pages: [
        PageViewModel(
          title: "Just add cigarettes?!",
          body:
          "Add cigarettes you smoke daily and the app will automatically calculate the life you lost on the basis of machine learning.",
          image: Lottie.asset("assets/ecgAni.json"),
          decoration: pageDecoration,
        ),
        PageViewModel(
          title: "Analyze yourself",
          body:
          "Chantix provides you with graphs for both, the life you are losing and the money you are spending. And yes it does alert you if you are overspending on smoking.",
          image:  Lottie.asset("assets/graphAni.json"),
          decoration: pageDecoration,
        ),
        PageViewModel(
          title: "What\'s in your body?",
          body:
          "Chantix computes the amount of nicotine, tar, COHb in your body.It cares for you thus informs the best doctors in your city about your health condition. Smart! isn\'t it?",
          image:  Lottie.asset("assets/flaskAni.json"),
          decoration: pageDecoration,
        ),
        PageViewModel(
          title: "Doctor as a friend!",
          body:
          "Spots best cardiologists, oncologists, rehabilitation in your city. Just remember , contact them or else it will be too late",
          image:  Lottie.asset("assets/injectAni.json"),
          decoration: pageDecoration,
        ),
      ],
      onDone: () => _onIntroEnd(context),
      showSkipButton: true,
      skipFlex: 0,
      nextFlex: 0,
      skip: const Text('Skip'),
      next: const Icon(Icons.arrow_forward),
      done: const Text('Done', style: TextStyle(fontWeight: FontWeight.w600)),
      dotsDecorator: const DotsDecorator(
        size: Size(10.0, 10.0),
        color: Color(0xD2D20808),
        activeColor: Color(0xD2A50505),
        activeSize: Size(22.0, 10.0),
        activeShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(25.0)),
        ),
      ),
    );
  }
}
