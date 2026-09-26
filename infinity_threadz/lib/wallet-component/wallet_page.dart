import 'package:animated_theme_switcher/animated_theme_switcher.dart';
import 'package:flutter/material.dart';
import 'package:infinity_threadz/common/constants.dart';
import 'package:infinity_threadz/common/widgets/appbar.dart';
import 'package:infinity_threadz/common/widgets/circular_progress_indicator.dart';
import 'package:infinity_threadz/common/widgets/navigation_drawer.dart';
import 'package:infinity_threadz/wallet-component/models/account_card_model.dart';
import 'package:infinity_threadz/wallet-component/models/statement_model.dart';
import 'package:infinity_threadz/wallet-component/models/transaction_model.dart';
import 'package:infinity_threadz/wallet-component/widgets/account_card.dart';
import 'package:infinity_threadz/wallet-component/widgets/account_transaction.dart';
import 'package:infinity_threadz/wallet-component/widgets/wallet_button.dart';
import 'package:infinity_threadz/wallet-component/widgets/wallet_details_header.dart';
import 'package:intl/intl.dart';
import 'package:infinity_threadz/common/data/demo_data.dart';
import 'package:infinity_threadz/common/widgets/demo_notice.dart';

class WalletPage extends StatefulWidget {
  const WalletPage({super.key});

  @override
  State<StatefulWidget> createState() => _WalletPage();
}

class _WalletPage extends State<WalletPage> {
  final String title = 'Wallet';

  late NumberFormat formatCurrency;

  late ScrollController _scrollController;
  final ValueNotifier _canScrollToTop = ValueNotifier(false);

  late Map<String, ValueNotifier<bool?>> walletSections;
  late List<Statement> lsStatements;
  late List<AccountTransaction> lsTransactions;
  late List<AccountCard> lsAccountCards;
  late Map<int, ValueNotifier<bool?>> accountCardStates;

  final ValueNotifier _selectedAccount = ValueNotifier(0);

  @override
  void initState() {
    super.initState();

    formatCurrency = NumberFormat.simpleCurrency(locale: 'af');
    _scrollController = ScrollController()
      ..addListener(() => onWalletPageScroll());

    walletSections = {
      'Cards': ValueNotifier<bool>(true),
      'Transactions': ValueNotifier<bool>(true),
      'Statements': ValueNotifier<bool>(true),
    };

    lsStatements = DemoData.statements;

    lsTransactions = DemoData.transactions;

    lsAccountCards = DemoData.cards;

    accountCardStates = {};
    for (AccountCard card in lsAccountCards) {
      if (lsAccountCards.first.id == card.id) {
        accountCardStates.addAll({card.id: ValueNotifier<bool>(true)});
      } else {
        accountCardStates.addAll({card.id: ValueNotifier<bool>(false)});
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    double horizontalMargin =
        MediaQuery.of(context).size.width <= DeviceSize.tabletScreenWidth
            ? 10
            : 100;

    return ThemeSwitchingArea(
      child: Builder(
        builder: (context) => Scaffold(
          appBar: AppBarWidget(title: title),
          drawer: const CustomNavigationDrawer(),
          body: Container(
            margin: EdgeInsets.symmetric(
              horizontal: horizontalMargin,
              vertical: 10,
            ),
            child: buildWalletScaffold(),
          ),
          floatingActionButton: ValueListenableBuilder(
            valueListenable: _canScrollToTop,
            builder: (context, canScroll, child) {
              return canScroll
                  ? Container(
                      margin: const EdgeInsets.only(top: 70),
                      child: FloatingActionButton(
                        child: const Icon(Icons.arrow_upward),
                        onPressed: () => scrollToTop(),
                      ),
                    )
                  : const SizedBox.shrink();
            },
          ),
          floatingActionButtonLocation: FloatingActionButtonLocation.centerTop,
        ),
      ),
    );
  }

  Widget buildWalletScaffold() {
    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            controller: _scrollController,
            physics: const BouncingScrollPhysics(),
            child: Column(
              children: [
                buildCardsHeader(),
                buildTransactionsHeader(),
                buildStatementsHeader(),
              ],
            ),
          ),
        ),
        buildBottomButtonBar(),
      ],
    );
  }

  Widget buildCardsHeader() {
    return Column(
      children: [
        WalletDetailsHeaderWidget(
          title: 'Cards',
          onSectionExpanded: (title, isExpanded) =>
              onSectionExpanded(title, isExpanded),
        ),
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 200),
          child: ValueListenableBuilder(
            valueListenable: walletSections['Cards']!,
            builder: (context, isExpanded, child) {
              return isExpanded! ? buildCardDetails() : const SizedBox.shrink();
            },
          ),
        ),
      ],
    );
  }

  Widget buildCardDetails() {
    return ValueListenableBuilder(
      valueListenable: _selectedAccount,
      builder: (context, value, child) => ConstrainedBox(
        constraints: const BoxConstraints(maxHeight: 230),
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 10),
          child: ListView.separated(
            physics: const BouncingScrollPhysics(),
            shrinkWrap: true,
            scrollDirection: Axis.horizontal,
            itemCount: lsAccountCards.length,
            separatorBuilder: (context, index) => const SizedBox(width: 16),
            itemBuilder: (context, index) {
              AccountCard card = lsAccountCards.elementAt(index);
              bool state = accountCardStates[card.id]?.value ?? false;

              return AccountCardWidget(
                card: card,
                isSelected: state,
                onCardSelected: (card) => onCardSelected(card),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget buildTransactionsHeader() {
    return Column(
      children: [
        WalletDetailsHeaderWidget(
          title: 'Transactions',
          onSectionExpanded: (title, isExpanded) =>
              onSectionExpanded(title, isExpanded),
        ),
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 200),
          child: ValueListenableBuilder(
            valueListenable: walletSections['Transactions']!,
            builder: (context, isExpanded, child) {
              return isExpanded!
                  ? buildTransactionDetails()
                  : const SizedBox.shrink();
            },
          ),
        ),
      ],
    );
  }

  Widget buildTransactionDetails() {
    return ValueListenableBuilder(
      valueListenable: _selectedAccount,
      builder: (context, value, child) => FutureBuilder(
        future: Future.delayed(const Duration(seconds: 2)),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return ListView.separated(
              physics: const BouncingScrollPhysics(),
              shrinkWrap: true,
              scrollDirection: Axis.vertical,
              itemCount: lsTransactions.length,
              separatorBuilder: (context, index) => const Divider(
                thickness: 1,
                indent: 16,
              ),
              itemBuilder: (context, index) {
                AccountTransaction transaction =
                    lsTransactions.elementAt(index);

                return AccountTransactionWidget(
                  transaction: transaction,
                  formatCurrency: formatCurrency,
                );
              },
            );
          } else {
            return Container(
              margin: const EdgeInsets.symmetric(vertical: 10),
              child: const CircularProgressIndicatorWidget(),
            );
          }
        },
      ),
    );
  }

  Widget buildStatementsHeader() {
    return Column(
      children: [
        WalletDetailsHeaderWidget(
          title: 'Statements',
          onSectionExpanded: (title, isExpanded) =>
              onSectionExpanded(title, isExpanded),
        ),
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 200),
          child: ValueListenableBuilder(
            valueListenable: walletSections['Statements']!,
            builder: (context, isExpanded, child) {
              return isExpanded!
                  ? buildStatementsDetails()
                  : const SizedBox.shrink();
            },
          ),
        ),
      ],
    );
  }

  Widget buildStatementsDetails() {
    return ListView.builder(
      physics: const BouncingScrollPhysics(),
      shrinkWrap: true,
      scrollDirection: Axis.vertical,
      itemCount: lsStatements.length,
      itemBuilder: (context, index) {
        Statement statement = lsStatements.elementAt(index);

        return ListTile(
          leading: const ImageIcon(
            ResizeImage(
              AssetImage('assets/images/doc-verify.png'),
              width: 70,
              height: 70,
              allowUpscaling: false,
            ),
            size: 28,
          ),
          title: Text(
            statement.month,
            style: Theme.of(context).textTheme.titleLarge?.merge(
                  const TextStyle(fontWeight: FontWeight.bold),
                ),
          ),
          subtitle: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.calendar_today_rounded,
                    size: 16,
                  ),
                  const SizedBox(
                    width: 6,
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 5.5),
                    child: Text(
                      statement.date,
                      style: Theme.of(context).textTheme.bodyLarge?.merge(
                            const TextStyle(color: Colors.grey),
                          ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          trailing: const Icon(
            Icons.file_download_outlined,
            size: 25,
          ),
        );
      },
    );
  }

  Widget buildBottomButtonBar() {
    return Align(
      alignment: Alignment.bottomCenter,
      child: OverflowBar(
        alignment: MainAxisAlignment.spaceBetween,
        spacing: 8,
        children: [
          WalletButtonWidget(
            icon: Container(
              margin: const EdgeInsets.symmetric(horizontal: 4),
              child: const ImageIcon(
                ResizeImage(
                  AssetImage('assets/images/voucher.png'),
                  width: 70,
                  height: 70,
                  allowUpscaling: false,
                ),
                size: 22,
              ),
            ),
            text: 'Add Voucher',
            color: Theme.of(context).brightness == Brightness.dark
                ? Colors.white
                : Colors.black,
            isPrimary: false,
            onClicked: () => showDemoNotice(context, 'Vouchers'),
          ),
          WalletButtonWidget(
            icon: Container(
              margin: const EdgeInsets.symmetric(horizontal: 4),
              child: const ImageIcon(
                ResizeImage(
                  AssetImage('assets/images/card.png'),
                  width: 70,
                  height: 70,
                  allowUpscaling: false,
                ),
                size: 22,
              ),
            ),
            text: 'Add Card',
            isPrimary: false,
            onClicked: () => showDemoNotice(context, 'Adding cards'),
          ),
        ],
      ),
    );
  }

  void onSectionExpanded(String title, bool isExpanded) {
    walletSections.update(title, (value) {
      value.value = isExpanded;
      return value;
    }, ifAbsent: () => ValueNotifier(isExpanded));
  }

  void onCardSelected(AccountCard card) {
    accountCardStates.updateAll(
      (key, value) {
        if (key == card.id) {
          value.value = true;
          if (_selectedAccount.value != card.id) {
            _selectedAccount.value = card.id;
          }
        } else {
          value.value = false;
        }

        return value;
      },
    );
  }

  void scrollToTop() {
    _scrollController.animateTo(
      _scrollController.position.minScrollExtent,
      curve: Curves.easeOut,
      duration: const Duration(milliseconds: 400),
    );
  }

  void onWalletPageScroll() {
    _canScrollToTop.value = _scrollController.position.extentBefore > 150;
  }
}
