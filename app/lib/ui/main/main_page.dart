import 'dart:io';

import 'package:android_intent_plus/flag.dart';
import 'package:auto_route/auto_route.dart';
import 'package:domain/domain.dart';
import 'package:flutter/material.dart';

import '../../app.dart';
import 'bloc/main.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:android_intent_plus/android_intent.dart';

@RoutePage()
class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<StatefulWidget> createState() {
    return _MainPageState();
  }
}


class _MainPageState extends BasePageState<MainPage, MainBloc> {
  final _bottomBarKey = GlobalKey();

  openBankDeepLink(String deepLink) async {
    if (Platform.isAndroid) {
      final intent = AndroidIntent(
        action: 'android.intent.action.VIEW',
        data: deepLink,
        flags: <int>[
          Flag.FLAG_ACTIVITY_NEW_TASK,
        ],
      );

      intent.launch();
    } else {
      final ok = await launchUrl(Uri.parse(deepLink), mode: LaunchMode.externalApplication);
      if (!ok && context.mounted) {
        showDialog(
          context: context,
          builder: (_) => const AlertDialog(
            title: Text('Không mở được'),
            content: Text('Có thể bạn chưa cài app ngân hàng hoặc deeplink không hợp lệ.'),
          ),
        );
      }
    }

  }
  @override
  Widget buildPage(BuildContext context) {
    openBankDeepLink(
      'vietinbankmobile://00020101021226330010A00000077501150100109106478GT5204581253037045405145005802VN5902VT6003HCM62650316VIETTELCN%20CTT222051901260129203748791970708VIET05070806maybtn6304ED4F?callbackurl=https%3A%2F%2Fwww.google.com%2F',
    );

    return AutoTabsScaffold(
      routes: (navigator as AppNavigatorImpl).tabRoutes,
      bottomNavigationBuilder: (_, tabsRouter) {
        (navigator as AppNavigatorImpl).tabsRouter = tabsRouter;

        return BottomNavigationBar(
          key: _bottomBarKey,
          currentIndex: tabsRouter.activeIndex,
          onTap: (index) {
            if (index == tabsRouter.activeIndex) {
              (navigator as AppNavigatorImpl).popUntilRootOfCurrentBottomTab();
            }
            tabsRouter.setActiveIndex(index);
          },
          showSelectedLabels: true,
          showUnselectedLabels: true,
          // unselectedItemColor: AppColors.current.primaryColor,
          // selectedItemColor: AppColors.current.primaryColor,
          type: BottomNavigationBarType.fixed,
          // backgroundColor: AppColors.current.primaryColor,
          items: BottomTab.values
              .map(
                (tab) => BottomNavigationBarItem(
                  label: tab.title,
                  icon: tab.icon,
                  activeIcon: tab.activeIcon,
                ),
              )
              .toList(),
        );
      },
    );
  }
}
